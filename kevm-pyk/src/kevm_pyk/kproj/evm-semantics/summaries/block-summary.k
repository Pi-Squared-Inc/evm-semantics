requires "../cse.md"

// Run using:
// kprove kevm-pyk/src/kevm_pyk/kproj/evm-semantics/summaries/block-summary.k --definition /home/njr/.cache/kdist-e374d3c/evm-semantics/summary --md-selector k -I /home/njr/workspace/kevm-pyk/src/kevm_pyk/kproj/evm-semantics -I /home/njr/workspace/kevm-pyk/src/kevm_pyk/kproj/plugin --depth 100

module BLOCK-SUMMARY
    imports CSE

    claim
           <k>        #execute               </k>
           <schedule> SCHEDULE_CELL:Schedule </schedule>
           <ethereum>
             <evm>
               <callState>
                 //              00                  05  06              10                  15
                 <program>   b"\x00\x00\x00\x00\x5b\x00\x60\x1a\x60\x10\x01\x01\x80\x60\x04\x57\x00\x00" </program>
                 //  04:  JUMPDEST
                 //       STOP      # Change to JUMPDEST as a No-Op to actually loop.
                 //  06:  PUSH 0x1a
                 //  08:  PUSH 0x10
                 //  10:  ADD
                 //       ADD
                 //  12:  ADD
                 //       DUP
                 //  14:  PUSH 0x04
                 //       JUMPI
                 <jumpDests> b"\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" </jumpDests>
                 <wordStack>
                     (ListItem(W0:Int)               ListItem(WS:WordStack))
                  => (ListItem(chop(W0:Int +Int 42)) ListItem(WS:WordStack))
                 </wordStack>
                 <pc>   6  => 04 </pc>
                        // ==========================
                        // Uncomment for other branch
                        // ==========================
                        // => 16 </pc>
                 <gas> GAS_CELL:Int => (GAS_CELL:Int -Int Gverylow < SCHEDULE_CELL:Schedule >
                                                     -Int Gverylow < SCHEDULE_CELL:Schedule >
                                                     -Int Gverylow < SCHEDULE_CELL:Schedule >
                                                     -Int Gverylow < SCHEDULE_CELL:Schedule >
                                                     -Int Gverylow < SCHEDULE_CELL:Schedule >
                                                     -Int Gverylow < SCHEDULE_CELL:Schedule >
                                                     -Int Ghigh    < SCHEDULE_CELL:Schedule>
                                       )
                 </gas>
                 ...
               </callState>
               ...
             </evm>
             ...
           </ethereum>
       requires      Gverylow<SCHEDULE_CELL:Schedule>
                +Int Gverylow<SCHEDULE_CELL:Schedule>
                +Int Gverylow<SCHEDULE_CELL:Schedule>
                +Int Gverylow<SCHEDULE_CELL:Schedule>
                +Int Gverylow<SCHEDULE_CELL:Schedule>
                +Int Gverylow<SCHEDULE_CELL:Schedule> // PUSH(1)/ADD/DUP
                +Int Ghigh   <SCHEDULE_CELL:Schedule> // JUMPI
               <=Int GAS_CELL:Int
       andBool #sizeWordStack(WS:WordStack, 0) <=Int 100
       andBool SCHEDULE_CELL ==K CANCUN

       andBool 0 =/=Int chop(W0 +Int 42)
   // ==========================
   // Uncomment for other branch
   // ==========================
   //  andBool 0  ==Int chop(W0 +Int 42)
endmodule
