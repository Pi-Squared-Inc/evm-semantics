/*******************************************************************************
0 frontier nodes remaining.

┌─ 1 (root)
│
│  (13 steps)
└─ 2 (stuck, leaf)




 *******************************************************************************/
requires "../language.md"
module SUMMARY-PRAGUE-EXP-LT
    imports public EVM-CSE-PRELUDE
    
    rule [BASIC-BLOCK-1-TO-2]: <generatedTop>
           <k>
             ( #nextOpCode [ 10 ]
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
                   ( ListItem ( STACK0:Int ) ListItem ( STACK1:Int ) => ListItem ( powmod ( STACK0:Int , STACK1:Int , pow256 ) ) ) STACK_REST
                 </wordStack>
                 <pc>
                   ( PC_CELL => ( PC_CELL:Int +Int 1 ) )
                 </pc>
                 <gas>
                   ( GAS_CELL => ( ( GAS_CELL:Int -Int ( 50 *Int ( ( log2Int ( STACK1:Int ) /Int 8 ) +Int 1 ) ) ) +Int -10 ) )
                 </gas>
                 ...
               </callState>
               ...
             </evm>
           </ethereum>
           ...
         </generatedTop>
      requires ( size ( ListItem ( STACK0:Int ) ListItem ( STACK1:Int ) STACK_REST ) <Int 1025
       andBool ( 2 <=Int size ( ListItem ( STACK0:Int ) ListItem ( STACK1:Int ) STACK_REST )
       andBool ( 0 <Int STACK1:Int
       andBool ( ( ( GAS_CELL:Int -Int ( 50 *Int ( ( log2Int ( STACK1:Int ) /Int 8 ) +Int 1 ) ) ) +Int -10 ) >=Int 0
               ))))
       ensures 0 <Int STACK1:Int
      [priority(50), label(BASIC-BLOCK-1-TO-2)]

endmodule
