requires "../evm.md"

module BLOCK-SUMMARY
    imports EDSL-PURE
    imports LEMMAS
    imports SUMMARIZATION-SIMPLIFICATION

    claim <kevm>
           <k>
             ( #next [ ADD ] ~> .K => .K )
            ...
           </k>
           <schedule>
             SCHEDULE_CELL:Schedule
           </schedule>
           <useGas>
             ( USEGAS_CELL:Bool => true )
           </useGas>
           <ethereum>
             <evm>
               <callState>
                 <wordStack>
                   ( ( W0:Int => chop ( ( W0:Int +Int W1:Int ) ) ) : ( ( W1:Int : WS:WordStack ) => WS:WordStack ) )
                 </wordStack>
                 <pc>
                   ( PC_CELL:Int => ( PC_CELL:Int +Int 1 ) )
                 </pc>
                 <gas>
                   ( GAS_CELL:Int => ( GAS_CELL:Int -Int Gverylow < SCHEDULE_CELL:Schedule > ) )
                 </gas>
                 ...
               </callState>
               ...
             </evm>
             ...
           </ethereum>
           ...
         </kevm>
      requires ( USEGAS_CELL:Bool
       andBool ( Gverylow < SCHEDULE_CELL:Schedule > <=Int GAS_CELL:Int
               ))
endmodule
