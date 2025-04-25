requires "evm.md"

module SUM_TO_N
    imports EVM

    syntax Int ::= Get(List, Int) [alias]
    rule Get(L:List, I:Int) => {`List:get`(L,I)}:>Int

    rule [STNSTART]:  <k>        #execute               </k>
           <schedule> CANCUN </schedule>
           <ethereum>
             <evm>
               <callState>
                 //  0:       PUSH(1) 0                 // s = 0
                 //  2:       PUSH(2) 65535             // n = 65535
                 //  5: loop: JUMPDEST
                 //  6:       SWAP; DUP 2; ADD; SWAP    // s = s+n
                 // 10:       PUSH(1) 1; SWAP; SUB      // n = n-1
                 // 14:       DUP;
                 // 15:       PUSH loop
                 // 17:       JUMPI
                 //             00  .   .   .   .   05  .   .   .   .   10  .   .   .   .   15  .   .   .
                 // <program>   b"\x60\x00\x61\xff\xff\x5b\x90\x81\x01\x90\x60\x01\x90\x03\x80\x60\x05\x57\x00" </program>
                 // <jumpDests> b"\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" </jumpDests>
                 <wordStack>
                     .List
                  => (ListItem(1000000000) ListItem(0))
                 </wordStack>
                 <pc>   0  => 5 </pc>
                        // ==========================
                        // Uncomment for other branch
                        // ==========================
                        // => 16 </pc>
                 <gas> GAS_CELL:Int => (GAS_CELL:Int -Int 6)
                 </gas>
                 ...
               </callState>
               ...
             </evm>
             ...
           </ethereum>
       requires 6  <=Int GAS_CELL:Int


    rule [STNEND]:  <k>        #execute               </k>
           <schedule> CANCUN </schedule>
           <ethereum>
             <evm>
               <callState>
                 //  0:       PUSH(1) 0                 // s = 0
                 //  2:       PUSH(2) 65535             // n = 65535
                 //  5: loop: JUMPDEST
                 //  6:       SWAP; DUP 2; ADD; SWAP    // s = s+n
                 // 10:       PUSH(1) 1; SWAP; SUB      // n = n-1
                 // 14:       DUP;
                 // 15:       PUSH loop
                 // 17:       JUMPI
                 //             00  .   .   .   .   05  .   .   .   .   10  .   .   .   .   15  .   .   .
                 // <program>   b"\x60\x00\x61\xff\xff\x5b\x90\x81\x01\x90\x60\x01\x90\x03\x80\x60\x05\x57\x00" </program>
                 // <jumpDests> b"\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" </jumpDests>

                 // ------- Dynamic -----------------------------------------------------------------------------
                 <wordStack> (ListItem(N) ListItem(SUM)) => (ListItem(0) ListItem(chop(SUM +Int N))) </wordStack>
                 <pc>        5                           => 17                                       </pc>
                 <gas>       GAS_CELL:Int                => (GAS_CELL:Int -Int 38)                   </gas>
                 // ---------------------------------------------------------------------------------------------
                 ...
               </callState>
               ...
             </evm>
             ...
           </ethereum>
       requires 38 <=Int GAS_CELL:Int
       andBool 0 ==Int chop(N -Int 1)


    rule [STNCONT]:  <k>        #execute               </k>
           <schedule> CANCUN </schedule>
           <ethereum>
             <evm>
               <callState>
                 //  0:       PUSH(1) 0                 // s = 0
                 //  2:       PUSH(2) 65535             // n = 65535
                 //  5: loop: JUMPDEST
                 //  6:       SWAP; DUP 2; ADD; SWAP    // s = s+n
                 // 10:       PUSH(1) 1; SWAP; SUB      // n = n-1
                 // 14:       DUP;
                 // 15:       PUSH loop
                 // 17:       JUMPI
                 //             00  .   .   .   .   05  .   .   .   .   10  .   .   .   .   15  .   .   .
                 // <program>   b"\x60\x00\x61\xff\xff\x5b\x90\x81\x01\x90\x60\x01\x90\x03\x80\x60\x05\x57\x00" </program>
                 // <jumpDests> b"\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" </jumpDests>

                 // ------- Dynamic -------------------------------------------------------------------------------------------
                 // <wordStack> (ListItem(N) ListItem(SUM)) => (ListItem(chop(N -Int 1)) ListItem(chop(SUM +Int N))) </wordStack>
                 <wordStack> S:List => S [ 0 <- chop( Get(S, 0) -Int 1 ) ] [ 1 <- chop( Get(S,0) +Int Get(S,1) ) ]   </wordStack>
                 <pc>        5                           => 5                                                     </pc>
                 <gas>       GAS_CELL:Int                => (GAS_CELL:Int -Int 38)                                </gas>
                 // -----------------------------------------------------------------------------------------------------------
                 ...
               </callState>
               ...
             </evm>
             ...
           </ethereum>
       requires 38 <=Int GAS_CELL:Int
       andBool 0 =/=Int chop(Get(S,0) -Int 1)

endmodule
