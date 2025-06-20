/*******************************************************************************
0 frontier nodes remaining.

┌─ 1 (root)
│
│  (28 steps)
└─ 2 (stuck, leaf)




 *******************************************************************************/
requires "../language.md"
module SUMMARY-CANCUN-CALL
    imports public EVM-CSE-PRELUDE
    
    rule [BASIC-BLOCK-1-TO-2]: <generatedTop>
           <k>
             ( #nextOpCode [ 241 ]
             ~> #execute
             ~> K_CELL_DOTS => AccessAccount ( ... acct: ( STACK1:Int modInt pow160 ) )
             ~> #call ID_CELL:Int ( STACK1:Int modInt pow160 ) ( STACK1:Int modInt pow160 ) STACK2:Int STACK2:Int #range ( LOCALMEM_CELL:Bytes , STACK3:Int , STACK4:Int ) false
             ~> #return STACK5:Int STACK6:Int
             ~> #pc [ CALL ]
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
                   ( ListItem ( STACK0:Int ) ListItem ( STACK1:Int ) ListItem ( STACK2:Int ) ListItem ( STACK3:Int ) ListItem ( STACK4:Int ) ListItem ( STACK5:Int ) ListItem ( STACK6:Int ) STACK_REST => ListItem ( STACK_REST:List ) )
                 </wordStack>
                 <localMem>
                   LOCALMEM_CELL
                 </localMem>
                 <gas>
                   ( GAS_CELL => ( ( GAS_CELL:Int -Int ( Cmem ( CANCUN , #memoryUsageUpdate ( #memoryUsageUpdate ( MEMORYUSED_CELL:Int , STACK3:Int , STACK4:Int ) , STACK5:Int , STACK6:Int ) ) -Int Cmem ( CANCUN , MEMORYUSED_CELL:Int ) ) ) -Int ( ( ( #if isWarm ( GetAccountInfoAndWarmIt ( ... acct: ( STACK1:Int modInt pow160 ) ) ) #then 100 #else 2600 #fi +Int #if ( notBool STACK2:Int ==Int 0 ) #then 25000 #else 0 #fi ) +Int Cxfer ( CANCUN , STACK2:Int ) ) +Int Cgascap ( CANCUN , STACK0:Int , ( GAS_CELL:Int -Int ( Cmem ( CANCUN , #memoryUsageUpdate ( #memoryUsageUpdate ( MEMORYUSED_CELL:Int , STACK3:Int , STACK4:Int ) , STACK5:Int , STACK6:Int ) ) -Int Cmem ( CANCUN , MEMORYUSED_CELL:Int ) ) ) , ( ( #if isWarm ( GetAccountInfoAndWarmIt ( ... acct: ( STACK1:Int modInt pow160 ) ) ) #then 100 #else 2600 #fi +Int #if ( notBool STACK2:Int ==Int 0 ) #then 25000 #else 0 #fi ) +Int Cxfer ( CANCUN , STACK2:Int ) ) ) ) ) )
                 </gas>
                 <memoryUsed>
                   ( MEMORYUSED_CELL => #memoryUsageUpdate ( #memoryUsageUpdate ( MEMORYUSED_CELL:Int , STACK3:Int , STACK4:Int ) , STACK5:Int , STACK6:Int ) )
                 </memoryUsed>
                 <callGas>
                   ( _CALLGAS_CELL => ( Cgascap ( CANCUN , STACK0:Int , ( GAS_CELL:Int -Int ( Cmem ( CANCUN , #memoryUsageUpdate ( #memoryUsageUpdate ( MEMORYUSED_CELL:Int , STACK3:Int , STACK4:Int ) , STACK5:Int , STACK6:Int ) ) -Int Cmem ( CANCUN , MEMORYUSED_CELL:Int ) ) ) , ( ( #if isWarm ( GetAccountInfoAndWarmIt ( ... acct: ( STACK1:Int modInt pow160 ) ) ) #then 100 #else 2600 #fi +Int #if ( notBool STACK2:Int ==Int 0 ) #then 25000 #else 0 #fi ) +Int Cxfer ( CANCUN , STACK2:Int ) ) ) +Int #if STACK2:Int ==Int 0 #then 0 #else 2300 #fi ) )
                 </callGas>
                 <static>
                   ( STATIC_CELL => false )
                 </static>
                 <callDepth>
                   CALLDEPTH_CELL
                 </callDepth>
                 ...
               </callState>
               <substate>
                 <accessedAccounts>
                   ( ACCESSEDACCOUNTS_CELL => ACCESSEDACCOUNTS_CELL:Set |Set SetItem ( ( STACK1:Int modInt pow160 ) ) )
                 </accessedAccounts>
                 ...
               </substate>
               ...
             </evm>
           </ethereum>
           
           ...
         </generatedTop>
      requires ( size ( ListItem ( STACK0:Int ) ListItem ( STACK1:Int ) ListItem ( STACK2:Int ) ListItem ( STACK3:Int ) ListItem ( STACK4:Int ) ListItem ( STACK5:Int ) ListItem ( STACK6:Int ) STACK_REST ) <Int 1025
       andBool ( 7 <=Int size ( ListItem ( STACK0:Int ) ListItem ( STACK1:Int ) ListItem ( STACK2:Int ) ListItem ( STACK3:Int ) ListItem ( STACK4:Int ) ListItem ( STACK5:Int ) ListItem ( STACK6:Int ) STACK_REST )
       andBool ( ( notBool STATIC_CELL )
       andBool ( AccountExists ( ... acct: ( STACK1:Int modInt 2 ^Int 160 ) )
       andBool ( IsAccountEmpty ( ... acct: ( STACK1:Int modInt 2 ^Int 160 ) )
       andBool ( GetAccountBalance ( ... acct: ID_CELL ) >=Int STACK2:Int
       andBool ( CALLDEPTH_CELL <Int 1024
               )))))))
       ensures ( ( notBool STATIC_CELL:Bool )
       andBool ( CALLDEPTH_CELL:Int <Int 1024
       andBool ( STACK2:Int <=Int GetAccountBalance ( ... acct: ID_CELL:Int )
       andBool ( AccountExists ( ... acct: ( STACK1:Int modInt pow160 ) )
       andBool ( IsAccountEmpty ( ... acct: ( STACK1:Int modInt pow160 ) )
               )))))
      [priority(50), label(BASIC-BLOCK-1-TO-2)]

endmodule
