requires "../evm.md"

module BLOCK-SUMMARY
    imports EDSL-PURE
    imports LEMMAS
    imports SUMMARIZATION-SIMPLIFICATION

    claim <kevm>
           <k>        #execute ...           </k>
           <schedule> SCHEDULE_CELL:Schedule </schedule>
           <useGas>   true                   </useGas>
           <ethereum>
             <evm>
               <callState>
                 <program> b"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x01\x00" </program>
                 <wordStack>
                     (W0:Int : W1:Int : W2:Int   : WS:WordStack)
                 =>  (chop(W0:Int +Int W1:Int +Int W2:Int)
                                                 : WS:WordStack)
                 </wordStack>
                 <pc>  10  => 12 </pc>
                 <gas> GAS_CELL:Int => (GAS_CELL:Int -Int Gverylow < SCHEDULE_CELL:Schedule >
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
      requires       Gverylow<SCHEDULE_CELL:Schedule> +Int Gverylow<SCHEDULE_CELL:Schedule>
               <=Int GAS_CELL:Int
       andBool SCHEDULE_CELL ==K DEFAULT
endmodule
