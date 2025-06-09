/*******************************************************************************
0 frontier nodes remaining.

┌─ 1 (root)
│
│  (11 steps)
└─ 2 (stuck, leaf)




 *******************************************************************************/
requires "../language.md"
module SUMMARY-PRAGUE-ECPAIRING
    imports public EVM-CSE-PRELUDE
    
    rule [BASIC-BLOCK-1-TO-2]: <generatedTop>
           <k>
             ( #precompiled? ( 8 , PRAGUE )
             ~> #execute
             ~> K_CELL_DOTS => #ecpairing ( .List , .List , 0 , CALLDATA_CELL:Bytes , lengthBytes ( CALLDATA_CELL:Bytes ) )
             ~> #pc [ ECPAIRING ]
             ~> #execute
             ~> K_CELL_DOTS:K )
           </k>
           <schedule>
             PRAGUE
           </schedule>
           <ethereum>
             <evm>
               <callState>
                 <callData>
                   CALLDATA_CELL
                 </callData>
                 <wordStack>
                   WORDSTACK_CELL
                 </wordStack>
                 <gas>
                   ( GAS_CELL => ( ( GAS_CELL:Int -Int ( 34000 *Int ( lengthBytes ( CALLDATA_CELL:Bytes ) /Int 192 ) ) ) +Int -45000 ) )
                 </gas>
                 ...
               </callState>
               ...
             </evm>
           </ethereum>
           ...
         </generatedTop>
      requires ( size ( WORDSTACK_CELL ) <Int 1024
       andBool ( 0 ==Int lengthBytes ( CALLDATA_CELL ) %Int 192
       andBool ( ( ( GAS_CELL:Int -Int ( 34000 *Int ( lengthBytes ( CALLDATA_CELL:Bytes ) /Int 192 ) ) ) +Int -45000 ) >=Int 0
               )))
       ensures ( size ( WORDSTACK_CELL:List ) <Int 1024
       andBool ( 0 ==Int lengthBytes ( CALLDATA_CELL:Bytes ) %Int 192
               ))
      [priority(50), label(BASIC-BLOCK-1-TO-2)]

endmodule
