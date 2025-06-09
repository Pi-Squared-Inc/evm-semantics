/*******************************************************************************
0 frontier nodes remaining.

┌─ 1 (root)
│
│  (14 steps)
└─ 2 (stuck, leaf)




 *******************************************************************************/
requires "../language.md"
module SUMMARY-CANCUN-STOP
    imports public EVM-CSE-PRELUDE
    
    rule [BASIC-BLOCK-1-TO-2]: <generatedTop>
           <k>
             ( #nextOpCode [ 0 ]
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
                 ( _OUTPUT_CELL => b"" )
               </output>
               <statusCode>
                 ( _STATUSCODE_CELL => EVMC_SUCCESS )
               </statusCode>
               <callState>
                 <wordStack>
                   STACK_REST
                 </wordStack>
                 <gas>
                   _GAS_CELL
                 </gas>
                 ...
               </callState>
               ...
             </evm>
           </ethereum>
           ...
         </generatedTop>
      requires ( size ( STACK_REST ) <Int 1025
       andBool ( 0 <=Int size ( STACK_REST )
               ))
       ensures size ( STACK_REST:List ) <Int 1025
      [priority(50), label(BASIC-BLOCK-1-TO-2)]

endmodule
