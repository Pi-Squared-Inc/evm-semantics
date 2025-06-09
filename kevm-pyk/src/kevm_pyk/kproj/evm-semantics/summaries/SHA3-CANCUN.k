/*******************************************************************************
0 frontier nodes remaining.

┌─ 1 (root)
│
│  (16 steps)
└─ 2 (stuck, leaf)




 *******************************************************************************/
requires "../language.md"
module SUMMARY-CANCUN-SHA3
    imports public EVM-CSE-PRELUDE
    
    rule [BASIC-BLOCK-1-TO-2]: <generatedTop>
           <k>
             ( #nextOpCode [ 32 ]
             ~> #execute
             ~> K_CELL_DOTS => #execute
             ~> K_CELL_DOTS:K )
           </k>
           <schedule>
             CANCUN
           </schedule>
           <ethereum>
             <evm>
               <callState>
                 <wordStack>
                   ( ListItem ( STACK0:Int ) ListItem ( STACK1:Int ) => ListItem ( keccak ( #range ( LOCALMEM_CELL:Bytes , STACK0:Int , STACK1:Int ) ) ) ) STACK_REST
                 </wordStack>
                 <localMem>
                   LOCALMEM_CELL
                 </localMem>
                 <pc>
                   ( PC_CELL => ( PC_CELL:Int +Int 1 ) )
                 </pc>
                 <gas>
                   ( GAS_CELL => ( ( ( GAS_CELL:Int -Int ( Cmem ( CANCUN , #memoryUsageUpdate ( MEMORYUSED_CELL:Int , STACK0:Int , STACK1:Int ) ) -Int Cmem ( CANCUN , MEMORYUSED_CELL:Int ) ) ) -Int ( 6 *Int ( STACK1:Int up/Int 32 ) ) ) +Int -30 ) )
                 </gas>
                 <memoryUsed>
                   ( MEMORYUSED_CELL => #memoryUsageUpdate ( MEMORYUSED_CELL:Int , STACK0:Int , STACK1:Int ) )
                 </memoryUsed>
                 ...
               </callState>
               ...
             </evm>
           </ethereum>
           ...
         </generatedTop>
      requires ( size ( ListItem ( STACK0:Int ) ListItem ( STACK1:Int ) STACK_REST ) <Int 1025
       andBool ( 2 <=Int size ( ListItem ( STACK0:Int ) ListItem ( STACK1:Int ) STACK_REST )
       andBool ( ( ( ( GAS_CELL:Int -Int ( Cmem ( CANCUN , #memoryUsageUpdate ( MEMORYUSED_CELL:Int , STACK0:Int , STACK1:Int ) ) -Int Cmem ( CANCUN , MEMORYUSED_CELL:Int ) ) ) -Int ( 6 *Int ( STACK1:Int up/Int 32 ) ) ) +Int -30 ) >=Int 0
               )))
      [priority(50), label(BASIC-BLOCK-1-TO-2)]

endmodule
