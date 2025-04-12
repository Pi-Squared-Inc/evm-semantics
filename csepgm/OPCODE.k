requires "evm.md"
module OPCODE
    imports EVM

    rule [ADD-SUMMARY-0]:
           <k> ( #next [ ADD ] ~> .K => .K ) ... </k>
           <ethereum>
             <evm>
               <callState>
                 <wordStack> ( ListItem(W0:Int) => ListItem(chop ( ( W0:Int +Int W1:Int ) )) )
                             ( ( ListItem(W1:Int) WS ) => WS )
                   </wordStack>
                 <pc> ( PC_CELL:Int => ( PC_CELL:Int +Int 1 ) ) </pc>
                 <gas> ( GAS_CELL:Int => ( GAS_CELL:Int -Int 3 ) ) </gas>
                 ...
               </callState>
               ...
             </evm>
             ...
           </ethereum>
      requires ( 3 <=Int GAS_CELL:Int )
      [priority(20)]    

    rule [SUB-SUMMARY-0]:
           <k>
             ( #next [ SUB ] ~> .K => .K )
             ...
           </k>
           <ethereum>
             <evm>
               <callState>
                 <wordStack>
                   ( ListItem( W0:Int => chop ( ( W0:Int -Int W1:Int ) ) ) ( ( ListItem(W1:Int) WS:List ) => WS:List ) )
                 </wordStack>
                 <pc>
                   ( PC_CELL:Int => ( PC_CELL:Int +Int 1 ) )
                 </pc>
                 <gas>
                   ( GAS_CELL:Int => ( GAS_CELL:Int -Int 3 ) )
                 </gas>
                 ...
               </callState>
               ...
             </evm>
             ...
           </ethereum>
      requires 3 <=Int GAS_CELL:Int
      [priority(20)]

    rule [PUSH-SUMMARY-1]:
           <k>
             ( #next [ PUSH ( N:Int ) ] ~> .K => .K )
             ...
           </k>
           <ethereum>
             <evm>
               <callState>
                 <program>
                   PROGRAM_CELL:Bytes
                 </program>
                 <wordStack>
                   ( WS:List => ( ListItem(#asWord ( #range ( PROGRAM_CELL:Bytes , ( PC_CELL:Int +Int 1 ) , N:Int ) )) WS:List ) )
                 </wordStack>
                 <pc>
                   ( PC_CELL:Int => ( ( PC_CELL:Int +Int N:Int ) +Int 1 ) )
                 </pc>
                 <gas>
                   ( GAS_CELL:Int => ( GAS_CELL:Int -Int 3 ) )
                 </gas>
                 ...
               </callState>
               ...
             </evm>
             ...
           </ethereum>

      requires ( ( notBool size ( WS:List ) <Int 0 )
       andBool ( ( notBool 1023 <Int size ( WS:List ) )
       andBool ( 3 <=Int GAS_CELL:Int
               )))


    rule [SWAP-SUMMARY-0]:
           <k>
             ( #next [ SWAP ( N:Int ) ] ~> .K => .K )
             ...
           </k>
           <ethereum>
             <evm>
               <callState>
                 <wordStack>
                   (ListItem(W0:Int) => ListItem(WS [ ( N:Int +Int -1 )])) 
                   ( WS:List => WS:List [ ( N:Int +Int -1 ) <- W0:Int ] )
                 </wordStack>
                 <pc>
                   ( PC_CELL:Int => ( PC_CELL:Int +Int 1 ) )
                 </pc>
                 <gas>
                   ( GAS_CELL:Int => ( GAS_CELL:Int -Int 3 ) )
                 </gas>
                 ...
               </callState>
               ...
             </evm>
             ...
           </ethereum>

      requires ( size ( WS:List ) <=Int 1023
       andBool ( ( N:Int ) <=Int size ( WS:List )
       andBool ( 3 <=Int GAS_CELL:Int
               )))
      [priority(20)]

    rule [DUP-SUMMARY-0]:
           <k>
             ( #next [ DUP ( N:Int ) ] ~> .K => .K )
             ...
           </k>
           <ethereum>
             <evm>
               <callState>
                 <wordStack>
                   WS:List => (ListItem(WS[ N:Int +Int -1 ]) WS)
                 </wordStack>
                 <pc>
                   ( PC_CELL:Int => ( PC_CELL:Int +Int 1 ) )
                 </pc>
                 <gas>
                   ( GAS_CELL:Int => ( GAS_CELL:Int -Int 3 ) )
                 </gas>
                 ...
               </callState>
               ...
             </evm>
             ...
           </ethereum>

      requires ( N:Int <=Int size ( WS:List )
       andBool ( size ( WS:List ) <=Int 1023
       andBool ( 3 <=Int GAS_CELL:Int
               )))
      [priority(20)]


    rule [JUMPDEST-SUMMARY-0]:
           <k>
             ( #next [ JUMPDEST ] ~> .K => .K )
             ...
           </k>
           <ethereum>
             <evm>
               <callState>
                 <pc>
                   ( PC_CELL:Int => ( PC_CELL:Int +Int 1 ) )
                 </pc>
                 <gas>
                   ( GAS_CELL:Int => ( GAS_CELL:Int -Int 1 ) )
                 </gas>
                 ...
               </callState>
               ...
             </evm>
             ...
           </ethereum>
      requires ( 1 <=Int GAS_CELL:Int )
      [priority(20)]

    syntax KItem  ::= OpCode
    syntax OpCode ::= NullStackOp | StackOp | BinStackOp | PushOp
    syntax NullStackOp ::= "JUMPDEST" | "STOP"
    syntax StackOp ::= DUP  ( Int ) [symbol(DUP)]
                     | SWAP ( Int ) [symbol(SWAP)]
    syntax BinStackOp ::= "ADD" | "MUL" | "SUB" | "DIV" | "EXP" | "MOD"
    syntax PushOp ::= "PUSHZERO" | PUSH ( Int ) [symbol(PUSH)]
    syntax MaybeOpCode ::= ".NoOpCode" | OpCode



    syntax InternalOp ::= "#next" "[" MaybeOpCode "]"
 // -------------------------------------------------
    rule <k> (#next [ .NoOpCode ] ~> K) => .K </k>
         <output> _ => .Bytes </output>


    syntax BinStackOp ::= "JUMPI"

    rule   <k> ( #next [ JUMPI ] ~> .K => .K ) ... </k>
           <ethereum>
             <evm>
               <callState>
                 <pc> ( _PC_CELL:Int => DEST ) </pc>
                 <wordStack> ( ListItem(DEST) ListItem(I) WS => WS) </wordStack>
                 <gas> ( GAS_CELL:Int => ( GAS_CELL:Int -Int 10 ) ) </gas>
                 ...
               </callState>
               ...
             </evm>
             ...
           </ethereum>
      requires ( 10 <=Int GAS_CELL:Int ) andBool I =/=Int 0
      [priority(20)]

    rule   <k> ( #next [ JUMPI ] ~> .K => .K ) ... </k>
           <ethereum>
             <evm>
               <callState>
                 <pc> ( PC_CELL:Int => PC_CELL +Int 1) </pc>
                 <wordStack> ( ListItem(_) ListItem(I) WS => WS) </wordStack>
                 <gas> ( GAS_CELL:Int => ( GAS_CELL:Int -Int 1 ) ) </gas>
                 ...
               </callState>
               ...
             </evm>
             ...
           </ethereum>
      requires ( 1 <=Int GAS_CELL:Int )  andBool I ==Int 0
      [priority(20)]

    rule [step]:
         <k> (.K => #next [ #lookupOpCode(PGM, PCOUNT, SCHED) ]) ~> #execute ... </k>
         <program> PGM </program>
         <pc> PCOUNT </pc>
         <schedule> SCHED </schedule>

    syntax MaybeOpCode ::= "#lookupOpCode" "(" Bytes "," Int "," Schedule ")" [function, total]
 // -------------------------------------------------------------------------------------------
    rule #lookupOpCode(BA, I, SCHED) => #dasmOpCode(BA[I], SCHED) requires 0 <=Int I andBool I <Int lengthBytes(BA)
    rule #lookupOpCode(_, _, _)  => .NoOpCode [owise]

    syntax OpCode ::= #dasmOpCode ( Int , Schedule ) [symbol(#dasmOpCode), function, memo, total]
 // ---------------------------------------------------------------------------------------------
    rule #dasmOpCode(   0,     _ ) => STOP
    rule #dasmOpCode(   1,     _ ) => ADD
    rule #dasmOpCode(   3,     _ ) => SUB
    rule #dasmOpCode(  87,     _ ) => JUMPI
    rule #dasmOpCode(  91,     _ ) => JUMPDEST
    rule #dasmOpCode(  96,     _ ) => PUSH(1)
    rule #dasmOpCode(  97,     _ ) => PUSH(2)
    rule #dasmOpCode( 128,     _ ) => DUP(1)
    rule #dasmOpCode( 129,     _ ) => DUP(2)
    rule #dasmOpCode( 144,     _ ) => SWAP(1)
    rule #dasmOpCode( 145,     _ ) => SWAP(2)

endmodule
