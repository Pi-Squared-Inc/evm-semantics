/*******************************************************************************
0 frontier nodes remaining.

┌─ 1 (root)
│
│  (17 steps)
└─ 2 (stuck, leaf)




 *******************************************************************************/
requires "../language.md"
module SUMMARY-CANCUN-RETURNDATACOPY-GT
    imports public EVM-CSE-PRELUDE
    
    rule [BASIC-BLOCK-1-TO-2]: <generatedTop>
           <k>
             ( #nextOpCode [ 62 ]
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
                 OUTPUT_CELL
               </output>
               <statusCode>
                 ( _STATUSCODE_CELL => EVMC_INVALID_MEMORY_ACCESS )
               </statusCode>
               <callState>
                 <wordStack>
                   ( ListItem ( STACK0:Int ) ListItem ( STACK1:Int ) ListItem ( STACK2:Int ) STACK_REST => STACK_REST:List )
                 </wordStack>
                 <gas>
                   ( GAS_CELL => ( ( ( GAS_CELL:Int -Int ( Cmem ( CANCUN , #memoryUsageUpdate ( MEMORYUSED_CELL:Int , STACK0:Int , STACK2:Int ) ) -Int Cmem ( CANCUN , MEMORYUSED_CELL:Int ) ) ) -Int ( 3 *Int ( STACK2:Int up/Int 32 ) ) ) +Int -3 ) )
                 </gas>
                 <memoryUsed>
                   ( MEMORYUSED_CELL => #memoryUsageUpdate ( MEMORYUSED_CELL:Int , STACK0:Int , STACK2:Int ) )
                 </memoryUsed>
                 ...
               </callState>
               ...
             </evm>
           </ethereum>
           ...
         </generatedTop>
      requires ( size ( ListItem ( STACK0:Int ) ListItem ( STACK1:Int ) ListItem ( STACK2:Int ) STACK_REST ) <Int 1024
       andBool ( 3 <=Int size ( ListItem ( STACK0:Int ) ListItem ( STACK1:Int ) ListItem ( STACK2:Int ) STACK_REST )
       andBool ( ( notBool ( STACK1:Int +Int STACK2:Int ) <=Int lengthBytes ( OUTPUT_CELL ) )
       andBool ( ( ( ( GAS_CELL:Int -Int ( Cmem ( CANCUN , #memoryUsageUpdate ( MEMORYUSED_CELL:Int , STACK0:Int , STACK2:Int ) ) -Int Cmem ( CANCUN , MEMORYUSED_CELL:Int ) ) ) -Int ( 3 *Int ( STACK2:Int up/Int 32 ) ) ) +Int -3 ) >=Int 0
               ))))
       ensures lengthBytes ( OUTPUT_CELL:Bytes ) <Int ( STACK1:Int +Int STACK2:Int )
      [priority(50), label(BASIC-BLOCK-1-TO-2)]

endmodule
