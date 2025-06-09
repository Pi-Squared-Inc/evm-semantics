/*******************************************************************************
0 frontier nodes remaining.

┌─ 1 (root)
│
│  (15 steps)
└─ 2 (stuck, leaf)




 *******************************************************************************/
requires "../language.md"
module SUMMARY-PRAGUE-MSTORE8
    imports public EVM-CSE-PRELUDE
    
    rule [BASIC-BLOCK-1-TO-2]: <generatedTop>
           <k>
             ( #nextOpCode [ 83 ]
             ~> #execute
             ~> K_CELL_DOTS => #execute
             ~> K_CELL_DOTS:K )
           </k>
           <schedule>
             PRAGUE
           </schedule>
           <ethereum>
             <evm>
               <callState>
                 <wordStack>
                   ( ListItem ( STACK0:Int ) ListItem ( STACK1:Int ) STACK_REST => STACK_REST:List )
                 </wordStack>
                 <localMem>
                   ( LOCALMEM_CELL => padRightBytes ( LOCALMEM_CELL:Bytes , ( STACK0:Int +Int 1 ) , 0 ) [ STACK0:Int <- ( STACK1:Int modInt 256 ) ] )
                 </localMem>
                 <pc>
                   ( PC_CELL => ( PC_CELL:Int +Int 1 ) )
                 </pc>
                 <gas>
                   ( GAS_CELL => ( ( GAS_CELL:Int -Int ( Cmem ( PRAGUE , #memoryUsageUpdate ( MEMORYUSED_CELL:Int , STACK0:Int , 1 ) ) -Int Cmem ( PRAGUE , MEMORYUSED_CELL:Int ) ) ) +Int -3 ) )
                 </gas>
                 <memoryUsed>
                   ( MEMORYUSED_CELL => #memoryUsageUpdate ( MEMORYUSED_CELL:Int , STACK0:Int , 1 ) )
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
       andBool ( ( ( GAS_CELL:Int -Int ( Cmem ( PRAGUE , #memoryUsageUpdate ( MEMORYUSED_CELL:Int , STACK0:Int , 1 ) ) -Int Cmem ( PRAGUE , MEMORYUSED_CELL:Int ) ) ) +Int -3 ) >=Int 0
               )))
      [priority(50), label(BASIC-BLOCK-1-TO-2)]

endmodule
