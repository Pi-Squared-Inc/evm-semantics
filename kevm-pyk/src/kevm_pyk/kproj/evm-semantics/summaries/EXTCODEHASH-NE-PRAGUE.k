/*******************************************************************************
0 frontier nodes remaining.

┌─ 1 (root)
│
│  (16 steps)
└─ 2 (stuck, leaf)




 *******************************************************************************/
requires "../language.md"
module SUMMARY-PRAGUE-EXTCODEHASH-NE
    imports public EVM-CSE-PRELUDE
    
    rule [BASIC-BLOCK-1-TO-2]: <generatedTop>
           <k>
             ( #nextOpCode [ 63 ]
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
                   ListItem ( ( STACK0:Int => GetCodeHash ( ... addr: ( STACK0:Int modInt pow160 ) ) ) )  STACK_REST:List 
                 </wordStack>
                 <pc>
                   ( PC_CELL => ( PC_CELL:Int +Int 1 ) )
                 </pc>
                 <gas>
                   ( GAS_CELL => ( GAS_CELL:Int -Int #if ( STACK0:Int modInt pow160 ) in ACCESSEDACCOUNTS_CELL:Set #then 100 #else 2600 #fi ) )
                 </gas>
                 ...
               </callState>
               <substate>
                 <accessedAccounts>
                   ( ACCESSEDACCOUNTS_CELL => ACCESSEDACCOUNTS_CELL:Set |Set SetItem ( ( STACK0:Int modInt pow160 ) ) )
                 </accessedAccounts>
                 ...
               </substate>
               ...
             </evm>
           </ethereum>
           ...
         </generatedTop>
      requires ( size ( ListItem ( STACK0:Int ) STACK_REST ) <Int 1024
       andBool ( 1 <=Int size ( ListItem ( STACK0:Int ) STACK_REST )
       andBool ( ( notBool IsAccountEmpty ( ... acct: ( STACK0:Int modInt 2 ^Int 160 ) ) )
       andBool ( ( GAS_CELL:Int -Int #if ( STACK0:Int modInt pow160 ) in ACCESSEDACCOUNTS_CELL:Set #then 100 #else 2600 #fi ) >=Int 0
               ))))
       ensures ( notBool IsAccountEmpty ( ... acct: ( STACK0:Int modInt pow160 ) ) )
      [priority(50), label(BASIC-BLOCK-1-TO-2)]

endmodule
