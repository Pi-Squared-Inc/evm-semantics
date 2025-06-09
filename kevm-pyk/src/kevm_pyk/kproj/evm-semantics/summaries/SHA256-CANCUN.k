/*******************************************************************************
0 frontier nodes remaining.

┌─ 1 (root)
│
│  (14 steps)
└─ 2 (stuck, leaf)




 *******************************************************************************/
requires "../language.md"
module SUMMARY-CANCUN-SHA256
    imports public EVM-CSE-PRELUDE
    
    rule [BASIC-BLOCK-1-TO-2]: <generatedTop>
           <k>
             ( #precompiled? ( 2 , CANCUN )
             ~> #execute
             ~> K_CELL_DOTS => #halt
             ~> K_CELL_DOTS:K )
           </k>
           <schedule>
             CANCUN
           </schedule>
           <ethereum>
             <evm>
               <output>
                 ( _OUTPUT_CELL => #parseHexBytesAux ( #alignHexString ( Sha256 ( CALLDATA_CELL:Bytes ) ) ) )
               </output>
               <statusCode>
                 ( _STATUSCODE_CELL => EVMC_SUCCESS )
               </statusCode>
               <callState>
                 <callData>
                   CALLDATA_CELL
                 </callData>
                 <wordStack>
                   WORDSTACK_CELL
                 </wordStack>
                 <gas>
                   ( GAS_CELL => ( ( GAS_CELL:Int -Int ( 12 *Int ( lengthBytes ( CALLDATA_CELL:Bytes ) up/Int 32 ) ) ) +Int -60 ) )
                 </gas>
                 ...
               </callState>
               ...
             </evm>
           </ethereum>
           ...
         </generatedTop>
      requires ( size ( WORDSTACK_CELL ) <Int 1024
       andBool ( ( ( GAS_CELL:Int -Int ( 12 *Int ( lengthBytes ( CALLDATA_CELL:Bytes ) up/Int 32 ) ) ) +Int -60 ) >=Int 0
               ))
       ensures size ( WORDSTACK_CELL:List ) <Int 1024
      [label(BASIC-BLOCK-1-TO-2)]

endmodule
