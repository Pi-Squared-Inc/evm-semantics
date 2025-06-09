/*******************************************************************************
0 frontier nodes remaining.

┌─ 1 (root)
│
│  (14 steps)
└─ 2 (stuck, leaf)




 *******************************************************************************/
requires "../language.md"
module SUMMARY-PRAGUE-BLAKE2F
    imports public EVM-CSE-PRELUDE
    
    rule [BASIC-BLOCK-1-TO-2]: <generatedTop>
           <k>
             ( #precompiled? ( 9 , PRAGUE )
             ~> #execute
             ~> K_CELL_DOTS => #halt
             ~> K_CELL_DOTS:K )
           </k>
           <schedule>
             PRAGUE
           </schedule>
           <ethereum>
             <evm>
               <output>
                 ( _OUTPUT_CELL => #parseHexBytes ( replace ( ... haystack: Blake2Compress ( CALLDATA_CELL:Bytes ) , needle: "0x" , replacement: "" , times: countAllOccurrences ( ... haystack: Blake2Compress ( CALLDATA_CELL:Bytes ) , needle: "0x" ) ) ) )
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
                   ( GAS_CELL => ( GAS_CELL:Int -Int #asWord ( #range ( CALLDATA_CELL:Bytes , 0 , 4 ) ) ) )
                 </gas>
                 ...
               </callState>
               ...
             </evm>
           </ethereum>
           ...
         </generatedTop>
      requires ( size ( WORDSTACK_CELL ) <Int 1024
       andBool ( 213 ==Int lengthBytes ( CALLDATA_CELL )
       andBool ( CALLDATA_CELL [ 212 ] <=Int 1
       andBool ( ( notBool 1 <Int CALLDATA_CELL [ 212 ] )
       andBool ( ( GAS_CELL:Int -Int #asWord ( #range ( CALLDATA_CELL:Bytes , 0 , 4 ) ) ) >=Int 0
               )))))
       ensures ( 213 ==Int lengthBytes ( CALLDATA_CELL:Bytes )
       andBool ( size ( WORDSTACK_CELL:List ) <Int 1024
       andBool ( CALLDATA_CELL:Bytes [ 212 ] <=Int 1
               )))
      [priority(50), label(BASIC-BLOCK-1-TO-2)]

endmodule
