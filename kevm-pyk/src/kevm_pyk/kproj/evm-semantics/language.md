```k
requires "inner-evm.md"
requires "lemmas/lemmas.k"

// Workaround not using hooks
module EVM2
    imports INNER-EVM
    rule ComputeValidJumpDests(... code:Code) => #computeValidJumpDests(Code)

    syntax Bytes ::= #computeValidJumpDests(Bytes)             [symbol(computeValidJumpDests),    function, memo, total]
                   | #computeValidJumpDests(Bytes, Int, Bytes) [symbol(computeValidJumpDestsAux), function             ]
 // --------------------------------------------------------------------------------------------------------------------
    rule #computeValidJumpDests(PGM) => #computeValidJumpDests(PGM, 0, padRightBytes(.Bytes, lengthBytes(PGM), 0))

    syntax Bytes ::= #computeValidJumpDestsWithinBound(Bytes, Int, Bytes) [symbol(computeValidJumpDestsWithinBound), function]
 // --------------------------------------------------------------------------------------------------------------------------
    rule #computeValidJumpDests(PGM, I, RESULT) => RESULT requires I >=Int lengthBytes(PGM)
    rule #computeValidJumpDests(PGM, I, RESULT) => #computeValidJumpDestsWithinBound(PGM, I, RESULT) requires I <Int lengthBytes(PGM)

    rule #computeValidJumpDestsWithinBound(PGM, I, RESULT) => #computeValidJumpDests(PGM, I +Int 1, RESULT[I <- 1]) requires PGM [ I ] ==Int 91
    rule #computeValidJumpDestsWithinBound(PGM, I, RESULT) => #computeValidJumpDests(PGM, I +Int #widthOpCode(PGM [ I ]), RESULT) requires notBool PGM [ I ] ==Int 91
endmodule

module CSE
    imports INNER-EVM
    imports LEMMAS
    imports GAS
    imports INFINITE-GAS
```

To facilitate choosing the next instruction based on structural matching rather
than a side-condition, we intruduce a new intermediate step to program execution.
This splits out looking up the OpCode in the program buffer from disassembling it.

```k
    syntax KItem ::= "#nextOpCode" "[" Int "]"      [symbol(nextOpCode)]

    rule [lookupOpCode]:
         <k> (.K => #nextOpCode[PGM[PCOUNT]]) ~> #execute ... </k>
         <program> PGM </program>
         <pc> PCOUNT </pc>
      requires 0 <=Int PCOUNT andBool PCOUNT <Int lengthBytes(PGM)
        [priority(20)]

    rule <k> #nextOpCode[ I ] => #next[#dasmOpCode(I, SCHED)] ... </k>
         <schedule> SCHED </schedule>
```

Simplifications
---------------

```k
  // ########################
  // Buffer Reasoning
  // From: tests/specs/benchmarks/verification.k
  // ########################

    rule #sizeWordStack(WS, N)  <Int SIZE => #sizeWordStack(WS, 0) +Int N  <Int SIZE  requires N =/=Int 0 [simplification]
    rule #sizeWordStack(WS, N) <=Int SIZE => #sizeWordStack(WS, 0) +Int N <=Int SIZE  requires N =/=Int 0 [simplification]

    rule SIZELIMIT <Int #sizeWordStack(WS, N) +Int DELTA  => SIZELIMIT <Int (#sizeWordStack(WS, 0) +Int N) +Int DELTA  requires N =/=Int 0 [simplification]
    rule SIZELIMIT <Int #sizeWordStack(WS, N)             => SIZELIMIT <Int  #sizeWordStack(WS, 0) +Int N              requires N =/=Int 0 [simplification]

    rule size(_:List) <Int 0  => false [simplification]
    rule 0 <=Int size(_:List) => true  [simplification]

    rule size(ListItem(_) List) => 1 +Int size(List) [simplification]

 // TODO: This is a bit of a hack, since I:Int may be out of bounds.
    rule #lookupOpCode(BA, I, SCHED) => #dasmOpCode(BA[I], SCHED)
    // requires 0 <=Int I andBool I <Int lengthBytes(BA)
        [simplification]

    rule #Ceil(L:List[N])      => { true #Equals size(L) >=Int N } [simplification]
    rule #Ceil(L:List[N <- _]) => { true #Equals size(L) >=Int N } [simplification]

    rule (ListItem(I)             _)[0]        => I                             [simplification]
    rule (ListItem(_) ListItem(I) _)[1]        => I                             [simplification]
    rule (ListItem(_)              L)[0 <- I0] => (ListItem(I0)              L) [simplification]
    rule (ListItem(I0) ListItem(_) L)[1 <- I1] => (ListItem(I0) ListItem(I1) L) [simplification]

    rule #Ceil(byte(_, _)) => { true #Equals true } [simplification]

    rule #Ceil(log2Int(X:Int)) => { true #Equals X >Int 0 } [simplification]

    // Defined even for 0
    rule #Ceil(_ /sWord _) => { true #Equals true } [simplification]
    rule #Ceil(_ %sWord _) => { true #Equals true } [simplification]


    // This "undoes" the simplification for #write, to the concrete syntax for it.
    rule WM [ IDX := #buf(1, VAL) ] => padRightBytes(WM, IDX +Int 1, 0) [ IDX <- VAL ] [simplification]
    rule #Ceil(padRightBytes(_:Bytes, N, 0) [ I <- _ ])
      => { true #Equals I <=Int N } [simplification]

    rule #Ceil(substrBytes(B:Bytes, N, M))
      => { true #Equals M >=Int N andBool lengthBytes(B) >=Int M }
         [simplification]
endmodule
```

CSE Prelude
-----------


```k
module EVM-CSE-PRELUDE
    imports STRING
    imports EVM-DATA
    imports NETWORK
    imports GAS
    imports ULM


    configuration
        <k> #precompiled? ($ACCTCODE, getSchedule($SCHEDULE:Int)) ~> #execute </k>
        <exit-code exit=""> 1 </exit-code>
        <schedule> getSchedule($SCHEDULE:Int) </schedule>
        <ethereum>
          <evm>

            // Mutable during a single transaction
            // -----------------------------------

            <output>          .Bytes      </output>           // H_RETURN
            <statusCode>      .StatusCode </statusCode>
            <callStack>       .List       </callStack>

            <callState>
              <program>   $PGM                         </program>
              <jumpDests> ComputeValidJumpDests($PGM) </jumpDests>

              // I_*
              <id>        $ID:Int    </id>                    // I_a
              <caller>    $CALLER:Account   </caller>         // I_s
              <callData>  $CALLDATA:Bytes  </callData>        // I_d
              <callValue> $CALLVALUE:Int </callValue>         // I_v

              // \mu_*
              <wordStack>   .List  </wordStack>           // \mu_s
              <localMem>    .Bytes </localMem>            // \mu_m
              <pc>          0      </pc>                  // \mu_pc
              <gas>         $GAS:Int </gas>               // \mau_g
              <memoryUsed>  0      </memoryUsed>          // \mu_i
              <callGas>     0:Gas  </callGas>

              <static>    $STATIC:Bool </static>
              <callDepth> 0     </callDepth>
            </callState>

            // Immutable during a single transaction
            // -------------------------------------
            <snapshotCount> 0 </snapshotCount>
            <snapshot> ListItem(0) </snapshot>
          </evm>
        </ethereum>
```

Load Program

```k
    syntax Bytes ::= #computeValidJumpDests(Bytes)             [symbol(computeValidJumpDests),    function, memo, total]
                   | #computeValidJumpDests(Bytes, Int, Bytes) [symbol(computeValidJumpDestsAux), function             ]
 // --------------------------------------------------------------------------------------------------------------------
    rule #computeValidJumpDests(PGM) => #computeValidJumpDests(PGM, 0, padRightBytes(.Bytes, lengthBytes(PGM), 0))

    syntax Bytes ::= #computeValidJumpDestsWithinBound(Bytes, Int, Bytes) [symbol(computeValidJumpDestsWithinBound), function]
 // --------------------------------------------------------------------------------------------------------------------------
    rule #computeValidJumpDests(PGM, I, RESULT) => RESULT requires I >=Int lengthBytes(PGM)
    rule #computeValidJumpDests(PGM, I, RESULT) => #computeValidJumpDestsWithinBound(PGM, I, RESULT) requires I <Int lengthBytes(PGM)

    rule #computeValidJumpDestsWithinBound(PGM, I, RESULT) => #computeValidJumpDests(PGM, I +Int 1, RESULT[I <- 1]) requires PGM [ I ] ==Int 91
    rule #computeValidJumpDestsWithinBound(PGM, I, RESULT) => #computeValidJumpDests(PGM, I +Int #widthOpCode(PGM [ I ]), RESULT) requires notBool PGM [ I ] ==Int 91

    syntax Int ::= #widthOpCode(Int) [symbol(#widthOpCode), function]
 // -----------------------------------------------------------------
    rule #widthOpCode(W) => W -Int 94 requires W >=Int 96 andBool W <=Int 127
    rule #widthOpCode(_) => 1 [owise]
```

Memory Consumption

```k
    syntax Int ::= #memoryUsageUpdate ( Int , Int , Int ) [symbol(#memoryUsageUpdate), function, total]
 // ---------------------------------------------------------------------------------------------------
    rule #memoryUsageUpdate(MU,     _, WIDTH) => MU                                       requires notBool 0 <Int WIDTH [concrete]
    rule #memoryUsageUpdate(MU, START, WIDTH) => maxInt(MU, (START +Int WIDTH) up/Int 32) requires         0 <Int WIDTH [concrete]
```

Execute

```k
    syntax KItem ::= "#execute"        [symbol(execute)]
                   | "#halt"           [symbol(halt)]
                   | "#end" StatusCode [symbol(end)]
                   | "#precompiled?" "(" Int "," Schedule ")"
```

To facilitate choosing the next instruction based on structural matching rather
than a side-condition, we intruduce a new intermediate step to program execution.
This splits out looking up the OpCode in the program buffer from disassembling it.

```k
    syntax KItem ::= "#nextOpCode" "[" Int "]"      [symbol(nextOpCode)]

    rule [halt]:
         <k> #halt ~> (#execute => .K) ... </k>

    rule [lookupOpCode]:
         <k> (.K => #nextOpCode[PGM[PCOUNT]]) ~> #execute ... </k>
         <program> PGM </program>
         <pc> PCOUNT </pc>
      requires 0 <=Int PCOUNT andBool PCOUNT <Int lengthBytes(PGM)
        [priority(20)]
```

Control Flow
------------

### Exception Based

```k
    rule [end]:
         <k> #end SC => #halt ... </k>
         <statusCode> _ => SC </statusCode>

    rule <k> #halt ~> (_:Int    => .K) ... </k>
    rule <k> #halt ~> (_:OpCode => .K) ... </k>
```

Helpers
-------

```k
syntax Bool ::= Bytes "==Bytes" Bytes   [symbol(_==Bytes_), function, total]
rule B1 ==Bytes B2 => B1 ==K B2
```

Precompiled
-----------

```k
    syntax KItem ::= "#precompiled?" "(" Int "," Schedule ")"
    rule <k> #precompiled?(_, _) => .K ... </k> [owise]
```

```k
    syntax Bytes ::= #point ( G1Point ) [symbol(#point), function]
 // --------------------------------------------------------------
    rule #point((X, Y)) => #padToWidth(32, #asByteStack(X)) +Bytes #padToWidth(32, #asByteStack(Y))
```

```k
    syntax Bytes ::= #ecrec ( Bytes , Bytes , Bytes , Bytes ) [symbol(#ecrec),    function, total, smtlib(ecrec)]
                   | #ecrec ( Account )                       [symbol(#ecrecAux), function, total               ]
 // -------------------------------------------------------------------------------------------------------------
    rule [ecrec]: #ecrec(HASH, SIGV, SIGR, SIGS) => #ecrec(#sender(HASH, #asWord(SIGV), SIGR, SIGS)) [concrete]

    rule #ecrec(.Account) => .Bytes
    rule #ecrec(N:Int)    => #padToWidth(32, #asByteStack(N))
```

```k
    syntax InternalOp ::= #ecpairing(List, List, Int, Bytes, Int) [symbol(#ecpairing)]
    syntax InternalOp ::= "#checkPoint"
 // ----------------------------------------------------------------------------------
    rule <k> (.K => #checkPoint)
          ~> #ecpairing((.List => ListItem((#asWord(#range(DATA, I, 32)), #asWord(#range(DATA, I +Int 32, 32))))) _, (.List => ListItem((#asWord(#range(DATA, I +Int 96, 32)) x #asWord(#range(DATA, I +Int 64, 32)) , #asWord(#range(DATA, I +Int 160, 32)) x #asWord(#range(DATA, I +Int 128, 32))))) _, I => I +Int 192, DATA, LEN) ... </k>
      requires I =/=Int LEN
    rule <k> #ecpairing(A, B, LEN, _, LEN) => #end EVMC_SUCCESS ... </k>
         <output> _ => #padToWidth(32, #asByteStack(bool2Word(BN128AtePairing(A, B)))) </output>
```

```k
    syntax Bytes ::= #kzg2vh ( Bytes ) [symbol(#kzg2vh), function, total]
 // ---------------------------------------------------------------------
    // VERSIONED_HASH_VERSION_KZG = 0x01
    rule #kzg2vh ( C ) => Sha256raw(C)[0 <- 1]
```

```k
    syntax Bytes ::= #modexp1 ( Int , Int , Int , Bytes ) [symbol(#modexp1), function]
                   | #modexp2 ( Int , Int , Int , Bytes ) [symbol(#modexp2), function]
                   | #modexp3 ( Int , Int , Int , Bytes ) [symbol(#modexp3), function]
                   | #modexp4 ( Int , Int , Int )         [symbol(#modexp4), function]
 // ----------------------------------------------------------------------------------
    rule #modexp1(BASELEN, EXPLEN,   MODLEN, DATA) => #modexp2(#asInteger(#range(DATA, 0, BASELEN)), EXPLEN, MODLEN, #range(DATA, BASELEN, maxInt(0, lengthBytes(DATA) -Int BASELEN))) requires MODLEN =/=Int 0
    rule #modexp1(_,       _,        0,      _)    => .Bytes
    rule #modexp2(BASE,    EXPLEN,   MODLEN, DATA) => #modexp3(BASE, #asInteger(#range(DATA, 0, EXPLEN)), MODLEN, #range(DATA, EXPLEN, maxInt(0, lengthBytes(DATA) -Int EXPLEN)))
    rule #modexp3(BASE,    EXPONENT, MODLEN, DATA) => #padToWidth(MODLEN, #modexp4(BASE, EXPONENT, #asInteger(#range(DATA, 0, MODLEN))))
    rule #modexp4(BASE,    EXPONENT, MODULUS)      => #asByteStack(powmod(BASE, EXPONENT, MODULUS))
```

Call / Create
=============

```k
    syntax InternalOp ::= "#push"
 // ------------------------------------------------
    rule <k> W0:Int ~> #push => .K ... </k> <wordStack> WS => pushList(W0, WS) </wordStack>
```

```k
    syntax InternalOp ::= "#pushCallStack"
 // --------------------------------------
    rule <k> #pushCallStack => .K ... </k>
         <callStack> STACK => ListItem(<callState> CALLSTATE </callState>) STACK </callStack>
         <callState> CALLSTATE </callState>
    syntax InternalOp ::= "#popCallStack"
 // -------------------------------------
    rule <k> #popCallStack => .K ... </k>
         <callStack> ListItem(<callState> CALLSTATE </callState>) REST => REST </callStack>
         <callState> _ => CALLSTATE </callState>

```

```k
    syntax InternalOp ::= "#pushWorldState"
 // ---------------------------------------
    rule <k> #pushWorldState => PushState() ... </k>

    syntax InternalOp ::= "#popWorldState"
 // --------------------------------------
    rule <k> #popWorldState => RollbackState() ... </k>

    syntax InternalOp ::= "#dropWorldState"
 // ---------------------------------------
    rule <k> #dropWorldState => CommitState() ... </k>
```

```k
    syntax KItem ::= "#initVM"
 // --------------------------
    rule <k> #initVM      => .K ... </k>
         <pc>           _ => 0      </pc>
         <memoryUsed>   _ => 0      </memoryUsed>
         <output>       _ => .Bytes </output>
         <wordStack>    _ => .List  </wordStack>
         <localMem>     _ => .Bytes </localMem>

    syntax KItem ::= "#loadProgram" Bytes [symbol(loadProgram)]
 // -----------------------------------------------------------
    rule [program.load]:
         <k> #loadProgram BYTES => .K ... </k>
         <program> _ => BYTES </program>
         <jumpDests> _ => ComputeValidJumpDests(BYTES) </jumpDests>
```

```k
    syntax OpCode ::= "ECPAIRING" | "CREATE" | "CREATE2" | "CALL" | "CALLCODE" | "DELEGATECALL" | "STATICCALL"
    syntax InternalOp ::= "#pc" "[" OpCode "]" [symbol(pc)]
 // -------------------------------------------------------
    rule [pc.inc]:
         <k> #pc [ OP ] => .K ... </k>
         <pc> PCOUNT => PCOUNT +Int 1 </pc>
```

### Account Creation/Deletion

-   `#create____` transfers the endowment to the new account and triggers the execution of the initialization code.
-   `#codeDeposit_` checks the result of initialization code and whether the code deposit can be paid, indicating an error if not.
-   `#isValidCode_` checks if the code returned by the execution of the initialization code begins with a reserved byte. [EIP-3541]
-   `#hasValidInitCode` checks the length of the transaction data in a create transaction. [EIP-3860]

```k
    syntax InternalOp ::= "#create"   Int Int Int Bytes
                        | "#mkCreate" Int Int Int Bytes
    // ------------------------------------------------
```
```vlm
    syntax InternalOp ::= "#newAccount" Int
   // -------------------------------------

   rule [create]:
         <k> #create ACCTFROM ACCTTO VALUE INITCODE
          => IncrementNonce(ACCTFROM)
          ~> #pushCallStack ~> #pushWorldState
          ~> #newAccount ACCTTO
          ~> #transferFundsFrom ACCTFROM ACCTTO VALUE
          ~> #mkCreate ACCTFROM ACCTTO VALUE INITCODE
         ...
         </k>

    rule <k> #mkCreate ACCTFROM ACCTTO VALUE INITCODE
          => AccessAccount(ACCTFROM) ~> AccessAccount(ACCTTO) ~> IncrementNonceOnCreate(ACCTTO, $SCHEDULE) ~> #loadProgram INITCODE ~> #initVM ~> #execute
         ...
         </k>
         <id> _ => ACCTTO </id>
         <gas> _GAVAIL => GCALL </gas>
         <callGas> GCALL => 0 </callGas>
         <caller> _ => ACCTFROM </caller>
         <callDepth> CD => CD +Int 1 </callDepth>
         <callData> _ => .Bytes </callData>
         <callValue> _ => VALUE </callValue>

    rule <k> #newAccount ACCT => #if NewAccount(ACCT) #then .K #else  #end EVMC_ACCOUNT_ALREADY_EXISTS #fi ... </k>
```
```k
    syntax InternalOp ::= "#newAccount" Int Int Int
   // ---------------------------------------------

   rule [create]:
        <k> #create ACCTFROM ACCTTO VALUE INITCODE
          => IncrementNonce(ACCTFROM)
          ~> #pushCallStack ~> #pushWorldState
          ~> #newAccount ACCTFROM ACCTTO VALUE
          ~> #mkCreate ACCTFROM ACCTTO VALUE INITCODE
         ...
         </k>

    rule <k> #mkCreate ACCTFROM ACCTTO VALUE INITCODE  => #loadProgram INITCODE ~> #initVM ~> #execute ... </k>
         <id> _ => ACCTTO </id>
         <gas> _GAVAIL => GCALL </gas>
         <callGas> GCALL => 0 </callGas>
         <caller> _ => ACCTFROM </caller>
         <callDepth> CD => CD +Int 1 </callDepth>
         <callData> _ => .Bytes </callData>
         <callValue> _ => VALUE </callValue>

    rule <k> #newAccount ACCTFROM ACCTTO VALUE => #if NewAccount(ACCTFROM, ACCTTO, VALUE) #then .K #else #end EVMC_ACCOUNT_ALREADY_EXISTS #fi ... </k>
```
```k
      syntax Bool ::= #isValidCode ( Bytes , Schedule ) [symbol(#isValidCode), function]
 // ----------------------------------------------------------------------------------
    rule #isValidCode( OUT ,  SCHED) => Ghasrejectedfirstbyte << SCHED >> impliesBool OUT[0] =/=Int 239 requires lengthBytes(OUT) >Int 0
    rule #isValidCode(_OUT , _SCHED) => true                                                            [owise]

    syntax Bool ::= #hasValidInitCode ( Int , Schedule ) [symbol(#hasValidInitCode), function]
 // ------------------------------------------------------------------------------------------
    rule #hasValidInitCode(INITCODELEN, SCHED) => notBool Ghasmaxinitcodesize << SCHED >> orBool INITCODELEN <=Int maxInitCodeSize < SCHED >

   syntax KItem ::= "#codeDeposit" Int
                   | "#mkCodeDeposit" Int
                   | "#finishCodeDeposit" Int Bytes

    rule <statusCode> _:ExceptionalStatusCode </statusCode>
         <k> #halt ~> #codeDeposit _ => #popCallStack ~> #popWorldState ~> 0 ~> #push ... </k> <output> _ => .Bytes </output>

    rule <statusCode> EVMC_REVERT </statusCode>
         <k> #halt ~> #codeDeposit _ => #popCallStack ~> #popWorldState ~> #refund GAVAIL ~> 0 ~> #push ... </k>
         <gas> GAVAIL </gas>

    rule <statusCode> EVMC_SUCCESS </statusCode>
         <k> #halt ~> #codeDeposit ACCT => #mkCodeDeposit ACCT ... </k>

    rule <k> #mkCodeDeposit ACCT
          => Gcodedeposit < SCHED > *Int lengthBytes(OUT) ~> #deductGas
          ~> #finishCodeDeposit ACCT OUT
         ...
         </k>
         <schedule> SCHED </schedule>
         <output> OUT => .Bytes </output>
      requires lengthBytes(OUT) <=Int maxCodeSize < SCHED > andBool #isValidCode(OUT, SCHED)

    syntax InternalOp ::= "#deductGas"
    rule <k>  G:Int ~> #deductGas => .K                   ... </k> <gas> GAVAIL => GAVAIL -Int G </gas> requires G <=Int GAVAIL

    syntax InternalOp ::= "#refund" Gas
                        | "#setLocalMem" Int Int Bytes
 // --------------------------------------------------
    rule [refund]: <k> #refund G:Int => .K ... </k> <gas> GAVAIL => GAVAIL +Int G </gas>

    rule <k> #mkCodeDeposit _ACCT => #popCallStack ~> #popWorldState ~> 0 ~> #push ... </k>
         <schedule> SCHED </schedule>
         <output> OUT => .Bytes </output>
      requires notBool ( lengthBytes(OUT) <=Int maxCodeSize < SCHED > andBool #isValidCode(OUT, SCHED) )

    rule <k> #finishCodeDeposit ACCT OUT
          => #popCallStack ~> #dropWorldState
          ~> #refund GAVAIL ~> SetAccountCode(ACCT, OUT) ~> ACCT ~> #push
         ...
         </k>
         <gas> GAVAIL </gas>

    rule <statusCode> _:ExceptionalStatusCode </statusCode>
         <k> #halt ~> #finishCodeDeposit ACCT _
          => #popCallStack ~> #dropWorldState
          ~> #refund GAVAIL ~> ACCT ~> #push
         ...
         </k>
         <gas> GAVAIL </gas>
         <schedule> FRONTIER </schedule>

    rule <statusCode> _:ExceptionalStatusCode </statusCode>
         <k> #halt ~> #finishCodeDeposit _ _ => #popCallStack ~> #popWorldState ~> 0 ~> #push ... </k>
         <schedule> SCHED </schedule>
      requires SCHED =/=K FRONTIER
```

### Call Operations

```k
    syntax InternalOp ::= "#call"                  Int Int Int Int Int Bytes Bool
                        | "#callWithCode"          Int Int Int Bytes Int Int Bytes Bool [symbol(callwithcode_check_fork)]
                        | "#mkCall"                Int Int Int Bytes     Int Bytes Bool
 // -----------------------------------------------------------------------------------
    rule [call.true]:
         <k> #call ACCTFROM ACCTTO ACCTCODE VALUE APPVALUE ARGS STATIC
          => #callWithCode ACCTFROM ACCTTO ACCTCODE GetAndResolveCode(ACCTCODE) VALUE APPVALUE ARGS STATIC
         ...
         </k>

    rule [call.false]:
         <k> #call ACCTFROM ACCTTO ACCTCODE VALUE APPVALUE ARGS STATIC
          => #callWithCode ACCTFROM ACCTTO ACCTCODE .Bytes VALUE APPVALUE ARGS STATIC
         ...
         </k> [owise]

    rule <k> #callWithCode ACCTFROM ACCTTO ACCTCODE BYTES VALUE APPVALUE ARGS STATIC
          => #pushCallStack ~> #pushWorldState
          ~> #transferFundsFrom ACCTFROM ACCTTO VALUE
          ~> #mkCall ACCTFROM ACCTTO ACCTCODE BYTES APPVALUE ARGS STATIC
         ...
         </k>

    rule <k> #mkCall ACCTFROM ACCTTO ACCTCODE BYTES APPVALUE ARGS STATIC:Bool
          => AccessAccount(ACCTFROM) ~> AccessAccount(ACCTTO) ~> #loadProgram BYTES ~> #initVM ~> #precompiled?(ACCTCODE, SCHED) ~> #execute
         ...
         </k>
         <callDepth> CD => CD +Int 1 </callDepth>
         <callData> _ => ARGS </callData>
         <callValue> _ => APPVALUE </callValue>
         <id> _ => ACCTTO </id>
         <gas> _GAVAIL:Int => GCALL:Int </gas>
         <callGas> GCALL:Int => 0:Int </callGas>
         <caller> _ => ACCTFROM </caller>
         <static> OLDSTATIC:Bool => OLDSTATIC orBool STATIC </static>
         <schedule> SCHED </schedule>
```

```k
    syntax KItem ::= "#return" Int Int
 // ----------------------------------
    rule [return.exception]:
         <statusCode> _:ExceptionalStatusCode </statusCode>
         <k> #halt ~> #return _ _
          => #popCallStack ~> #popWorldState ~> 0 ~> #push
          ...
         </k>
         <output> _ => .Bytes </output>

    rule [return.revert]:
         <statusCode> EVMC_REVERT </statusCode>
         <k> #halt ~> #return RETSTART RETWIDTH
          => #popCallStack ~> #popWorldState
          ~> 0 ~> #push ~> #refund GAVAIL ~> #setLocalMem RETSTART RETWIDTH OUT
         ...
         </k>
         <output> OUT </output>
         <gas> GAVAIL </gas>

    rule [return.success]:
         <statusCode> EVMC_SUCCESS </statusCode>
         <k> #halt ~> #return RETSTART RETWIDTH
          => #popCallStack ~> #dropWorldState
          ~> 1 ~> #push ~> #refund GAVAIL ~> #setLocalMem RETSTART RETWIDTH OUT
         ...
         </k>
         <output> OUT </output>
         <gas> GAVAIL </gas>
```

### Transfer Operation
```k
    syntax InternalOp ::= "#transferFundsFrom" Int Int Int
   // -------------------------------------------------------------------------------------------------
    rule [transferFundsFrom.success]:
      <k> #transferFundsFrom ACCTFROM ACCTTO VALUE => .K ... </k>
      requires TransferFrom(ACCTFROM, ACCTTO, VALUE)

    rule [transferFundsFrom.failure]:
      <k> #transferFundsFrom _ _ _ => #end EVMC_BALANCE_UNDERFLOW ... </k> [owise]
```

### BLS

```k
    syntax Bytes ::= #bls12point ( G1Point ) [symbol(#bls12point1), function]
 // -------------------------------------------------------------------------
    rule #bls12point((X, Y)) => #padToWidth(64, #asByteStack(X)) +Bytes #padToWidth(64, #asByteStack(Y))

    syntax Bytes ::= #bls12point ( G2Point ) [symbol(#bls12point2), function]
 // -------------------------------------------------------------------------
    rule #bls12point((X0 x X1, Y0 x Y1))
        => #padToWidth(64, #asByteStack(X0)) +Bytes #padToWidth(64, #asByteStack(X1))
            +Bytes #padToWidth(64, #asByteStack(Y0)) +Bytes #padToWidth(64, #asByteStack(Y1))

    syntax Bool ::= isValidBLS12Coordinate ( Int ) [symbol(isValidBLS12Coordinate), function, total]
  // -----------------------------------------------------------------------------------------------
    rule isValidBLS12Coordinate(X) => isValidBLS12Fp(X)

    syntax Bool ::= isValidBLS12Fp ( Int ) [symbol(isValidBLS12Fp), function, total]
  // -------------------------------------------------------------------------------
    rule isValidBLS12Fp(X) => X >=Int 0 andBool X <Int (1 <<Int 384) andBool X <Int BLS12_FIELD_MODULUS

    syntax Bool ::= isValidBLS12Scalar ( Int ) [symbol(isValidBLS12Scalar), function, total]
  // ---------------------------------------------------------------------------------------
    rule isValidBLS12Scalar(X) => X >=Int 0 andBool X <Int (1 <<Int 256)
```

```k
    syntax Bls12PairingResult ::= "bls12PairingError" | bls12PairingResult(Bool)
 // --------------------------------------------------------------------------
    syntax Bls12PairingResult ::= bls12PairingCheck(Bytes, List, List) [symbol(bls12PairingCheck), function, total]
 // -------------------------------------------------------------------------------------------------------------
    rule bls12PairingCheck(B:Bytes, L1:List, L2:List) => bls12PairingResult(BLS12PairingCheck(L1, L2))
        requires lengthBytes(B) ==Int 0
          andBool validBls12G1PairingPoints(L1)
          andBool validBls12G2PairingPoints(L2)
          andBool size(L1) ==Int size(L2)
          andBool size(L1) >Int 0
    rule bls12PairingCheck(B:Bytes, L1:List, L2:List)
        => bls12PairingCheck
            ( substrBytes(B, 384, lengthBytes(B))
            , L1 ListItem(
                ( Bytes2Int(substrBytes(B, 0, 64), BE, Unsigned)
                , Bytes2Int(substrBytes(B, 64, 128), BE, Unsigned)
                )
              )
            , L2 ListItem(
                ( Bytes2Int(substrBytes(B, 128, 192), BE, Unsigned)
                x Bytes2Int(substrBytes(B, 192, 256), BE, Unsigned)
                , Bytes2Int(substrBytes(B, 256, 320), BE, Unsigned)
                x Bytes2Int(substrBytes(B, 320, 384), BE, Unsigned)
                )
              )
            )
      requires lengthBytes(B) >=Int 384
    rule bls12PairingCheck(_:Bytes, _:List, _:List) => bls12PairingError  [owise]

    syntax Bool ::= validBls12G1PairingPoints(List)  [function, total]
    syntax Bool ::= validBls12G1PairingPoint(G1Point)  [function, total]
// ------------------------------------------------------------------
    rule validBls12G1PairingPoints(.List) => true
    rule validBls12G1PairingPoints(ListItem(P:G1Point) L:List) => validBls12G1PairingPoints(L)
      requires validBls12G1PairingPoint(P)
    rule validBls12G1PairingPoints(_) => false  [owise]

    rule validBls12G1PairingPoint((X, Y) #as P:G1Point)
        => isValidBLS12Coordinate(X)
          andBool isValidBLS12Coordinate(Y)
          andBool BLS12G1InSubgroup(P)

    syntax Bool ::= validBls12G2PairingPoints(List)  [function, total]
    syntax Bool ::= validBls12G2PairingPoint(G2Point)  [function, total]
// ------------------------------------------------------------------
    rule validBls12G2PairingPoints(.List) => true
    rule validBls12G2PairingPoints(ListItem(P:G2Point) L:List) => validBls12G2PairingPoints(L)
      requires validBls12G2PairingPoint(P)
    rule validBls12G2PairingPoints(_) => false  [owise]

    rule validBls12G2PairingPoint((X0 x X1, Y0 x Y1) #as P:G2Point)
        => isValidBLS12Coordinate(X0)
          andBool isValidBLS12Coordinate(X1)
          andBool isValidBLS12Coordinate(Y0)
          andBool isValidBLS12Coordinate(Y1)
          andBool BLS12G2InSubgroup(P)
```

```k
    syntax Bool ::= bls12ValidForAdd(Int, Int, Int, Int)  [function, total]
 // -----------------------------------------------------------------------
    rule bls12ValidForAdd(X0, Y0, X1, Y1)
        => true
            andBool isValidBLS12Coordinate(X0)
            andBool isValidBLS12Coordinate(Y0)
            andBool isValidBLS12Coordinate(X1)
            andBool isValidBLS12Coordinate(Y1)
            andBool BLS12G1OnCurve((X0, Y0))
            andBool BLS12G1OnCurve((X1, Y1))
```

```k
    syntax G1MsmResult ::= "g1MsmError" | g1MsmResult(G1Point)
 // ----------------------------------------------------------
    syntax G1MsmResult ::= bls12G1Msm(Bytes) [symbol(bls12G1Msm), function, total]
    syntax G1MsmResult ::= #bls12G1Msm(Bytes, List, List) [function, total]
    syntax G1MsmResult ::= #bls12G1MsmCheck(Bytes, List, List, Int, Int, Int) [function, total]
 // ----------------------------------------------------------------------------
    rule bls12G1Msm(B:Bytes) => g1MsmError requires lengthBytes(B) ==Int 0
    rule bls12G1Msm(B:Bytes) => #bls12G1Msm(B, .List, .List) requires lengthBytes(B) >Int 0

    rule #bls12G1Msm(B:Bytes, Ps:List, Ss:List) => g1MsmResult(BLS12G1Msm(... scalars: Ss, points: Ps))
        requires lengthBytes(B) ==Int 0
    rule #bls12G1Msm(B:Bytes, _:List, _:List) => g1MsmError
        requires 0 <Int lengthBytes(B) andBool lengthBytes(B) <Int 160
    rule #bls12G1Msm(B:Bytes, Ps:List, Ss:List)
        => #bls12G1MsmCheck
                ( substrBytes(B, 160, lengthBytes(B)), Ps, Ss
                , Bytes2Int(substrBytes(B, 0, 64), BE, Unsigned)
                , Bytes2Int(substrBytes(B, 64, 128), BE, Unsigned)
                , Bytes2Int(substrBytes(B, 128, 160), BE, Unsigned)
                )
        requires 160 <=Int lengthBytes(B)

    rule #bls12G1MsmCheck(B:Bytes, Ps:List, Ss:List, X:Int, Y:Int, N:Int)
        => #bls12G1Msm(B, Ps ListItem( ( X , Y ) ), Ss ListItem( N ))
      requires isValidBLS12Coordinate(X) andBool isValidBLS12Coordinate(Y)
        andBool isValidBLS12Scalar(N)
        andBool BLS12G1InSubgroup((X, Y))
    rule #bls12G1MsmCheck(_, _, _, _, _, _) => g1MsmError  [owise]

    syntax G1Point ::= "g1MsmResult.getPoint" "(" G1MsmResult ")" [function]
    rule g1MsmResult.getPoint(g1MsmResult(P)) => P
```

```k
    syntax G2MsmResult ::= "g2MsmError" | g2MsmResult(G2Point)
 // ----------------------------------------------------------
    syntax G2MsmResult ::= bls12G2Msm(Bytes) [symbol(bls12G2Msm), function, total]
    syntax G2MsmResult ::= #bls12G2Msm(Bytes, List, List) [function, total]
    syntax G2MsmResult ::= #bls12G2MsmCheck(Bytes, List, List, Int, Int, Int, Int, Int) [function, total]
 // ------------------------------------------------------------------------------------
    rule bls12G2Msm(B:Bytes) => g2MsmError requires lengthBytes(B) ==Int 0
    rule bls12G2Msm(B:Bytes) => #bls12G2Msm(B, .List, .List) requires lengthBytes(B) >Int 0

    rule #bls12G2Msm(B:Bytes, Ps:List, Ss:List) => g2MsmResult(BLS12G2Msm(... scalars: Ss, points: Ps))
        requires lengthBytes(B) ==Int 0
    rule #bls12G2Msm(B:Bytes, _:List, _:List) => g2MsmError
        requires 0 <Int lengthBytes(B) andBool lengthBytes(B) <Int 288
    rule #bls12G2Msm(B:Bytes, Ps:List, Ss:List)
        => #bls12G2MsmCheck
                ( substrBytes(B, 288, lengthBytes(B)), Ps, Ss
                , Bytes2Int(substrBytes(B, 0, 64), BE, Unsigned)
                , Bytes2Int(substrBytes(B, 64, 128), BE, Unsigned)
                , Bytes2Int(substrBytes(B, 128, 192), BE, Unsigned)
                , Bytes2Int(substrBytes(B, 192, 256), BE, Unsigned)
                , Bytes2Int(substrBytes(B, 256, 288), BE, Unsigned)
                )
        requires 288 <=Int lengthBytes(B)

    rule #bls12G2MsmCheck(B:Bytes, Ps:List, Ss:List, X0:Int, X1:Int, Y0:Int, Y1:Int, N:Int)
        => #bls12G2Msm(B, Ps ListItem( ( X0 x X1, Y0 x Y1 ) ), Ss ListItem( N ))
      requires isValidBLS12Coordinate(X0) andBool isValidBLS12Coordinate(X1)
        andBool isValidBLS12Coordinate(Y0) andBool isValidBLS12Coordinate(Y1)
        andBool isValidBLS12Scalar(N)
        andBool BLS12G2InSubgroup(( X0 x X1, Y0 x Y1 ))
    rule #bls12G2MsmCheck(_, _, _, _, _, _, _, _) => g2MsmError  [owise]

    syntax G2Point ::= "g2MsmResult.getPoint" "(" G2MsmResult ")" [function]
    rule g2MsmResult.getPoint(g2MsmResult(P)) => P
```

```k
    syntax Bool ::= bls12ValidForAdd2(Int, Int, Int, Int, Int, Int, Int, Int)  [function, total]
 // --------------------------------------------------------------------------------------------
    rule bls12ValidForAdd2(PX0, PX1, PY0, PY1, QX0, QX1, QY0, QY1)
        => true
            andBool isValidBLS12Coordinate(PX0)
            andBool isValidBLS12Coordinate(PX1)
            andBool isValidBLS12Coordinate(PY0)
            andBool isValidBLS12Coordinate(PY1)
            andBool isValidBLS12Coordinate(QX0)
            andBool isValidBLS12Coordinate(QX1)
            andBool isValidBLS12Coordinate(QY0)
            andBool isValidBLS12Coordinate(QY1)
            andBool BLS12G2OnCurve((PX0 x PX1, PY0 x PY1))
            andBool BLS12G2OnCurve((QX0 x QX1, QY0 x QY1))

    syntax Bool ::= "bls12PairingResult.get" "(" Bls12PairingResult ")" [function]
    rule bls12PairingResult.get(bls12PairingResult(P)) => P
```

Output Extraction
-----------------

```k
    rule getStatus(<generatedTop>... <statusCode> STATUS:StatusCode </statusCode> ...</generatedTop>) => getStatus(STATUS)

    syntax Int ::= getStatus(StatusCode) [function]
    rule getStatus(EVMC_REJECTED) => EVMC_REJECTED
    rule getStatus(EVMC_INTERNAL_ERROR) => EVMC_INTERNAL_ERROR
    rule getStatus(EVMC_SUCCESS) => EVMC_SUCCESS
    rule getStatus(EVMC_REVERT) => EVMC_REVERT
    rule getStatus(EVMC_FAILURE) => EVMC_FAILURE
    rule getStatus(EVMC_INVALID_INSTRUCTION) => EVMC_INVALID_INSTRUCTION
    rule getStatus(EVMC_UNDEFINED_INSTRUCTION) => EVMC_UNDEFINED_INSTRUCTION
    rule getStatus(EVMC_OUT_OF_GAS) => EVMC_OUT_OF_GAS
    rule getStatus(EVMC_BAD_JUMP_DESTINATION) => EVMC_BAD_JUMP_DESTINATION
    rule getStatus(EVMC_STACK_OVERFLOW) => EVMC_STACK_OVERFLOW
    rule getStatus(EVMC_STACK_UNDERFLOW) => EVMC_STACK_UNDERFLOW
    rule getStatus(EVMC_CALL_DEPTH_EXCEEDED) => EVMC_CALL_DEPTH_EXCEEDED
    rule getStatus(EVMC_INVALID_MEMORY_ACCESS) => EVMC_INVALID_MEMORY_ACCESS
    rule getStatus(EVMC_STATIC_MODE_VIOLATION) => EVMC_STATIC_MODE_VIOLATION
    rule getStatus(EVMC_PRECOMPILE_FAILURE) => EVMC_PRECOMPILE_FAILURE
    rule getStatus(EVMC_NONCE_EXCEEDED) => EVMC_NONCE_EXCEEDED

    rule getGasLeft(G) => 0 requires getStatus(G) =/=Int EVMC_SUCCESS andBool getStatus(G) =/=Int EVMC_REVERT
    rule getGasLeft(<generatedTop>... <gas> G </gas> ...</generatedTop>) => G [priority(51)]

    rule getOutput(G) => .Bytes requires getStatus(G) =/=Int EVMC_SUCCESS andBool getStatus(G) =/=Int EVMC_REVERT
    rule getOutput(<generatedTop>... <output> O </output> ...</generatedTop>) => O [priority(51)]
```

```k
endmodule
```
