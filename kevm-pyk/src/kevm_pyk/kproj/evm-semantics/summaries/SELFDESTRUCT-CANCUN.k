/*******************************************************************************
0 frontier nodes remaining.

┌─ 1 (root)
│
│  (22 steps)
└─ 2 (stuck, leaf)




 *******************************************************************************/
requires "../language.md"
module SUMMARY-CANCUN-SELFDESTRUCT
    imports public EVM-CSE-PRELUDE
    
    rule [BASIC-BLOCK-1-TO-2]: <generatedTop>
           <k>
             ( #nextOpCode [ maxUInt8 ]
             ~> #execute
             ~> K_CELL_DOTS => SelfDestruct ( ... acct: ID_CELL:Int , to: ( STACK0:Int modInt pow160 ) )
             ~> #halt
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
                 <id>
                   ID_CELL
                 </id>
                 <wordStack>
                   ( ListItem ( STACK0:Int ) STACK_REST => ListItem ( STACK_REST:List ) )
                 </wordStack>
                 <gas>
                   ( GAS_CELL => ( ( ( GAS_CELL:Int -Int #if ( IsAccountEmpty ( ... acct: ( STACK0:Int modInt pow160 ) ) andBool ( notBool GetAccountBalance ( ... acct: ID_CELL:Int ) ==Int 0 ) ) #then 25000 #else 0 #fi ) -Int #if ( STACK0:Int modInt pow160 ) in ACCESSEDACCOUNTS_CELL:Set #then 0 #else 2600 #fi ) +Int -5000 ) )
                 </gas>
                 <static>
                   ( STATIC_CELL => false )
                 </static>
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
      requires ( size ( ListItem ( STACK0:Int ) STACK_REST ) <Int 1025
       andBool ( 1 <=Int size ( ListItem ( STACK0:Int ) STACK_REST )
       andBool ( ( notBool STATIC_CELL )
       andBool ( AccountExists ( ... acct: ( STACK0:Int modInt 2 ^Int 160 ) )
       andBool ( ( ( ( GAS_CELL:Int -Int #if ( IsAccountEmpty ( ... acct: ( STACK0:Int modInt pow160 ) ) andBool ( notBool GetAccountBalance ( ... acct: ID_CELL:Int ) ==Int 0 ) ) #then 25000 #else 0 #fi ) -Int #if ( STACK0:Int modInt pow160 ) in ACCESSEDACCOUNTS_CELL:Set #then 0 #else 2600 #fi ) +Int -5000 ) >=Int 0
               )))))
       ensures ( ( notBool STATIC_CELL:Bool )
       andBool ( AccountExists ( ... acct: ( STACK0:Int modInt pow160 ) )
               ))
      [priority(50), label(BASIC-BLOCK-1-TO-2)]

endmodule
