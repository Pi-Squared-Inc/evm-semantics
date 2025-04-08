requires "../evm.md"


module VERIFICATION
    imports EDSL-PURE
    imports LEMMAS

  // ########################
  // Buffer Reasoning
  // From: tests/specs/benchmarks/verification.k
  // ########################

    rule #sizeWordStack(WS, N)  <Int SIZE => #sizeWordStack(WS, 0) +Int N  <Int SIZE  requires N =/=Int 0 [simplification]
    rule #sizeWordStack(WS, N) <=Int SIZE => #sizeWordStack(WS, 0) +Int N <=Int SIZE  requires N =/=Int 0 [simplification]

    rule SIZELIMIT <Int #sizeWordStack(WS, N) +Int DELTA  => SIZELIMIT <Int (#sizeWordStack(WS, 0) +Int N) +Int DELTA  requires N =/=Int 0 [simplification]
    rule SIZELIMIT <Int #sizeWordStack(WS, N)             => SIZELIMIT <Int  #sizeWordStack(WS, 0) +Int N              requires N =/=Int 0 [simplification]

endmodule


module BLOCK-SUMMARY
    imports VERIFICATION
    imports SUMMARIZATION-SIMPLIFICATION

    claim <kevm>
           <k>        #execute               </k>
           <schedule> SCHEDULE_CELL:Schedule </schedule>
           <useGas>   true                   </useGas>
           <ethereum>
             <evm>
               <callState>
                 <program> b"\x00\x00\x00\x00\x00\x00\x60\x1a\x60\x10\x01\x01\x00\x00\x00\x00\x00" </program>
                 //                                  ^6                   ^12
                 <wordStack>
                     (              W0:Int : WS:WordStack)
                  => (chop(W0:Int +Int 42) : WS:WordStack)
                 </wordStack>
                 <pc>   6  => 12 </pc>
                 <gas> GAS_CELL:Int => (GAS_CELL:Int -Int Gverylow < SCHEDULE_CELL:Schedule >
                                                     -Int Gverylow < SCHEDULE_CELL:Schedule >
                                                     -Int Gverylow < SCHEDULE_CELL:Schedule >
                                                     -Int Gverylow < SCHEDULE_CELL:Schedule >
                                       )
                 </gas>
                 ...
               </callState>
               ...
             </evm>
             ...
           </ethereum>
           ...
         </kevm>
      requires       Gverylow<SCHEDULE_CELL:Schedule>
                +Int Gverylow<SCHEDULE_CELL:Schedule>
                +Int Gverylow<SCHEDULE_CELL:Schedule>
                +Int Gverylow<SCHEDULE_CELL:Schedule>
               <=Int GAS_CELL:Int
       andBool #sizeWordStack(WS:WordStack, 0) <=Int 1000
       andBool SCHEDULE_CELL ==K DEFAULT
endmodule
