/*******************************************************************************
0 frontier nodes remaining.

┌─ 1 (root)
│
│  (14 steps)
└─ 2 (stuck, leaf)




 *******************************************************************************/
requires "../language.md"
module SUMMARY-CANCUN-MODEXP
    imports public EVM-CSE-PRELUDE
    
    rule [BASIC-BLOCK-1-TO-2]: <generatedTop>
           <k>
             ( #precompiled? ( 5 , CANCUN )
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
                 ( _OUTPUT_CELL => #modexp1 ( #asWord ( #range ( CALLDATA_CELL:Bytes , 0 , 32 ) ) , #asWord ( #range ( CALLDATA_CELL:Bytes , 32 , 32 ) ) , #asWord ( #range ( CALLDATA_CELL:Bytes , 64 , 32 ) ) , #range ( CALLDATA_CELL:Bytes , 96 , maxInt ( 0 , ( lengthBytes ( CALLDATA_CELL:Bytes ) +Int -96 ) ) ) ) )
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
                   ( GAS_CELL => ( GAS_CELL:Int -Int Cmodexp ( CANCUN , CALLDATA_CELL:Bytes , #asWord ( #range ( CALLDATA_CELL:Bytes , 0 , 32 ) ) , #asWord ( #range ( CALLDATA_CELL:Bytes , 32 , 32 ) ) , #asWord ( #range ( CALLDATA_CELL:Bytes , 64 , 32 ) ) ) ) )
                 </gas>
                 ...
               </callState>
               ...
             </evm>
           </ethereum>
           ...
         </generatedTop>
      requires ( size ( WORDSTACK_CELL ) <Int 1024
       andBool ( ( GAS_CELL:Int -Int Cmodexp ( CANCUN , CALLDATA_CELL:Bytes , #asWord ( #range ( CALLDATA_CELL:Bytes , 0 , 32 ) ) , #asWord ( #range ( CALLDATA_CELL:Bytes , 32 , 32 ) ) , #asWord ( #range ( CALLDATA_CELL:Bytes , 64 , 32 ) ) ) ) >=Int 0
               ))
       ensures size ( WORDSTACK_CELL:List ) <Int 1024
      [label(BASIC-BLOCK-1-TO-2)]

endmodule
