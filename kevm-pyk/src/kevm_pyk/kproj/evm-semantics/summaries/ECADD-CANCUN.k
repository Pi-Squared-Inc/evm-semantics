/*******************************************************************************
0 frontier nodes remaining.

┌─ 1 (root)
│
│  (15 steps)
└─ 2 (stuck, leaf)




 *******************************************************************************/
requires "../language.md"
module SUMMARY-CANCUN-ECADD
    imports public EVM-CSE-PRELUDE
    
    rule [BASIC-BLOCK-1-TO-2]: <generatedTop>
           <k>
             ( #precompiled? ( 6 , CANCUN )
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
                 ( _OUTPUT_CELL => #point ( BN128Add ( ( #asWord ( #range ( CALLDATA_CELL:Bytes , 0 , 32 ) ) , #asWord ( #range ( CALLDATA_CELL:Bytes , 32 , 32 ) ) ) , ( #asWord ( #range ( CALLDATA_CELL:Bytes , 64 , 32 ) ) , #asWord ( #range ( CALLDATA_CELL:Bytes , 96 , 32 ) ) ) ) ) )
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
                   ( GAS_CELL => ( GAS_CELL:Int +Int -150 ) )
                 </gas>
                 ...
               </callState>
               ...
             </evm>
           </ethereum>
           ...
         </generatedTop>
      requires ( size ( WORDSTACK_CELL ) <Int 1024
       andBool ( isValidPoint ( ( #asWord ( #range ( CALLDATA_CELL , 0 , 32 ) ) , #asWord ( #range ( CALLDATA_CELL , 32 , 32 ) ) ) )
       andBool ( isValidPoint ( ( #asWord ( #range ( CALLDATA_CELL , 64 , 32 ) ) , #asWord ( #range ( CALLDATA_CELL , 96 , 32 ) ) ) )
       andBool ( ( GAS_CELL:Int +Int -150 ) >=Int 0
               ))))
       ensures ( size ( WORDSTACK_CELL:List ) <Int 1024
       andBool ( isValidPoint ( ( #asWord ( #range ( CALLDATA_CELL:Bytes , 0 , 32 ) ) , #asWord ( #range ( CALLDATA_CELL:Bytes , 32 , 32 ) ) ) )
       andBool ( isValidPoint ( ( #asWord ( #range ( CALLDATA_CELL:Bytes , 64 , 32 ) ) , #asWord ( #range ( CALLDATA_CELL:Bytes , 96 , 32 ) ) ) )
               )))
      [priority(50), label(BASIC-BLOCK-1-TO-2)]

endmodule
