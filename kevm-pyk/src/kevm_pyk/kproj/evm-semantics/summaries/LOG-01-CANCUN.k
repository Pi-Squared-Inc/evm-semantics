/*******************************************************************************
0 frontier nodes remaining.

┌─ 1 (root)
│
│  (16 steps)
└─ 2 (stuck, leaf)




 *******************************************************************************/
requires "../language.md"
module SUMMARY-CANCUN-LOG-01
    imports public EVM-CSE-PRELUDE
    
    rule [BASIC-BLOCK-1-TO-2]: <generatedTop>
           <k>
             ( #nextOpCode [ 161 ]
             ~> #execute
             ~> K_CELL_DOTS => Log1 ( ... acct: ID_CELL:Int , topic0: STACK2:Int , data: #range ( LOCALMEM_CELL:Bytes , STACK0:Int , STACK1:Int ) )
             ~> #execute
             ~> K_CELL_DOTS:K )
           </k>
           <schedule>
             CANCUN
           </schedule>
           <ethereum>
             <evm>
               <callState>
                 <id>
                   ID_CELL
                 </id>
                 <wordStack>
                   ( ListItem ( STACK0:Int ) ListItem ( STACK1:Int ) ListItem ( STACK2:Int ) STACK_REST => STACK_REST:List )
                 </wordStack>
                 <localMem>
                   LOCALMEM_CELL
                 </localMem>
                 <pc>
                   ( PC_CELL => ( PC_CELL:Int +Int 1 ) )
                 </pc>
                 <gas>
                   ( GAS_CELL => ( ( ( GAS_CELL:Int -Int ( Cmem ( CANCUN , #memoryUsageUpdate ( MEMORYUSED_CELL:Int , STACK0:Int , STACK1:Int ) ) -Int Cmem ( CANCUN , MEMORYUSED_CELL:Int ) ) ) -Int ( 8 *Int STACK1:Int ) ) +Int -750 ) )
                 </gas>
                 <memoryUsed>
                   ( MEMORYUSED_CELL => #memoryUsageUpdate ( MEMORYUSED_CELL:Int , STACK0:Int , STACK1:Int ) )
                 </memoryUsed>
                 <static>
                   ( STATIC_CELL => false )
                 </static>
                 ...
               </callState>
               ...
             </evm>
           </ethereum>
           
           ...
         </generatedTop>
      requires ( size ( ListItem ( STACK0:Int ) ListItem ( STACK1:Int ) ListItem ( STACK2:Int ) STACK_REST ) <Int 1025
       andBool ( 3 <=Int size ( ListItem ( STACK0:Int ) ListItem ( STACK1:Int ) ListItem ( STACK2:Int ) STACK_REST )
       andBool ( ( notBool STATIC_CELL )
       andBool ( ( ( ( GAS_CELL:Int -Int ( Cmem ( CANCUN , #memoryUsageUpdate ( MEMORYUSED_CELL:Int , STACK0:Int , STACK1:Int ) ) -Int Cmem ( CANCUN , MEMORYUSED_CELL:Int ) ) ) -Int ( 8 *Int STACK1:Int ) ) +Int -750 ) >=Int 0
               ))))
       ensures ( notBool STATIC_CELL:Bool )
      [priority(50), label(BASIC-BLOCK-1-TO-2)]

endmodule
