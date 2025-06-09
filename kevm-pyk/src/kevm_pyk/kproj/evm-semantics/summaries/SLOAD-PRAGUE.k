/*******************************************************************************
0 frontier nodes remaining.

┌─ 1 (root)
│
│  (15 steps)
└─ 2 (stuck, leaf)




 *******************************************************************************/
requires "../language.md"
module SUMMARY-PRAGUE-SLOAD
    imports public EVM-CSE-PRELUDE
    
    rule [BASIC-BLOCK-1-TO-2]: <generatedTop>
           <k>
             ( #nextOpCode [ 84 ]
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
                 <id>
                   ID_CELL
                 </id>
                 <wordStack>
                   ListItem ( ( STACK0:Int => GetAccountStorage ( ... acct: ID_CELL:Int , key: STACK0:Int ) ) ) STACK_REST
                 </wordStack>
                 <pc>
                   ( PC_CELL => ( PC_CELL:Int +Int 1 ) )
                 </pc>
                 <gas>
                   ( GAS_CELL => ( GAS_CELL:Int -Int #if AccessedStorage ( ... acct: ID_CELL:Int , key: STACK0:Int ) #then 100 #else 2100 #fi ) )
                 </gas>
                 ...
               </callState>
               ...
             </evm>
           </ethereum>
           ...
         </generatedTop>
      requires ( size ( ListItem ( STACK0:Int ) STACK_REST ) <Int 1025
       andBool ( 1 <=Int size ( ListItem ( STACK0:Int ) STACK_REST )
       andBool ( ( GAS_CELL:Int -Int #if AccessedStorage ( ... acct: ID_CELL:Int , key: STACK0:Int ) #then 100 #else 2100 #fi ) >=Int 0
               )))
      [priority(50), label(BASIC-BLOCK-1-TO-2)]

endmodule
