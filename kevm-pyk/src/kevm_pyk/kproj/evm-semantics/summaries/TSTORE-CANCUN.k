/*******************************************************************************
0 frontier nodes remaining.

┌─ 1 (root)
│
│  (13 steps)
└─ 2 (stuck, leaf)




 *******************************************************************************/
requires "../language.md"
module SUMMARY-CANCUN-TSTORE
    imports public EVM-CSE-PRELUDE
    
    rule [BASIC-BLOCK-1-TO-2]: <generatedTop>
           <k>
             ( #nextOpCode [ 93 ]
             ~> #execute
             ~> K_CELL_DOTS => SetAccountTransientStorage ( ... acct: ID_CELL:Int , key: STACK0:Int , value: STACK1:Int )
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
                   ( ListItem ( STACK0:Int ) ListItem ( STACK1:Int ) STACK_REST => STACK_REST:List )
                 </wordStack>
                 <pc>
                   ( PC_CELL => ( PC_CELL:Int +Int 1 ) )
                 </pc>
                 <gas>
                   ( GAS_CELL => ( GAS_CELL:Int +Int -100 ) )
                 </gas>
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
      requires ( size ( ListItem ( STACK0:Int ) ListItem ( STACK1:Int ) STACK_REST ) <Int 1025
       andBool ( 2 <=Int size ( ListItem ( STACK0:Int ) ListItem ( STACK1:Int ) STACK_REST )
       andBool ( ( notBool STATIC_CELL )
       andBool ( ( GAS_CELL:Int +Int -100 ) >=Int 0
               ))))
       ensures ( notBool STATIC_CELL:Bool )
      [priority(50), label(BASIC-BLOCK-1-TO-2)]

endmodule
