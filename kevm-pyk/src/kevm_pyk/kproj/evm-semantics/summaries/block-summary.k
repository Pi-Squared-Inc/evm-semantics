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
                 <program> PROGRAM_CELL:Bytes </program>
                 <wordStack>
                     (W0:Int : W1:Int            : WS:WordStack)
                 =>  (chop((W0:Int +Int W1:Int)) : WS:WordStack)
                 </wordStack>
                 <pc>  PC_CELL:Int  => (PC_CELL:Int +Int 1) </pc>
                 <gas> GAS_CELL:Int => (GAS_CELL:Int -Int Gverylow < SCHEDULE_CELL:Schedule >)
                 </gas>
                 ...
               </callState>
               ...
             </evm>
             ...
           </ethereum>
           ...
         </kevm>
      requires Gverylow<SCHEDULE_CELL:Schedule> <=Int GAS_CELL:Int
       andBool #lookupOpCode(PROGRAM_CELL, PC_CELL, SCHEDULE_CELL) ==K ADD
endmodule
