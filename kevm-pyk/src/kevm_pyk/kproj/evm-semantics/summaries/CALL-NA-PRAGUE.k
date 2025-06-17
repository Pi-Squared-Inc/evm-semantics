/*******************************************************************************
0 frontier nodes remaining.

┌─ 1 (root)
│
│  (27 steps)
└─ 2 (stuck, leaf)




 *******************************************************************************/
requires "../language.md"
module SUMMARY-PRAGUE-CALL-NA
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
             PRAGUE
           </schedule>
           <ethereum>
             <evm>
               <callState>
                 <id>
                   ID_CELL
                 </id>
                 <wordStack>
                   ( ListItem ( STACK0:Int ) ListItem ( STACK1:Int ) ListItem ( STACK2:Int ) ListItem ( STACK3:Int ) ListItem ( STACK4:Int ) ListItem ( STACK5:Int ) ListItem ( STACK6:Int ) STACK_REST:List => STACK_REST:List )
                 </wordStack>
                 <localMem>
                   LOCALMEM_CELL
                 </localMem>
                 <gas>
                   ( GAS_CELL => ( ( GAS_CELL:Int -Int ( Cmem ( PRAGUE , #memoryUsageUpdate ( #memoryUsageUpdate ( MEMORYUSED_CELL:Int , STACK3:Int , STACK4:Int ) , STACK5:Int , STACK6:Int ) ) -Int Cmem ( PRAGUE , MEMORYUSED_CELL:Int ) ) ) -Int ( ( ( ( #if 0 <Int delegation ( GetAccountInfoAndWarmIt ( ... acct: ( STACK1:Int modInt pow160 ) ) ) #then #if ( 0 <Int delegation ( GetAccountInfoAndWarmIt ( ... acct: ( STACK1:Int modInt pow160 ) ) ) andThenBool ( ( STACK1:Int modInt pow160 ) ==Int delegation ( GetAccountInfoAndWarmIt ( ... acct: ( STACK1:Int modInt pow160 ) ) ) orElseBool AccessedAccount ( ... acct: delegation ( GetAccountInfoAndWarmIt ( ... acct: ( STACK1:Int modInt pow160 ) ) ) ) ) ) #then 100 #else 2600 #fi #else 0 #fi +Int #if isWarm ( GetAccountInfoAndWarmIt ( ... acct: ( STACK1:Int modInt pow160 ) ) ) #then 100 #else 2600 #fi ) +Int #if ( notBool STACK2:Int ==Int 0 ) #then 25000 #else 0 #fi ) +Int Cxfer ( PRAGUE , STACK2:Int ) ) +Int Cgascap ( PRAGUE , STACK0:Int , ( GAS_CELL:Int -Int ( Cmem ( PRAGUE , #memoryUsageUpdate ( #memoryUsageUpdate ( MEMORYUSED_CELL:Int , STACK3:Int , STACK4:Int ) , STACK5:Int , STACK6:Int ) ) -Int Cmem ( PRAGUE , MEMORYUSED_CELL:Int ) ) ) , ( ( ( #if 0 <Int delegation ( GetAccountInfoAndWarmIt ( ... acct: ( STACK1:Int modInt pow160 ) ) ) #then #if ( 0 <Int delegation ( GetAccountInfoAndWarmIt ( ... acct: ( STACK1:Int modInt pow160 ) ) ) andThenBool ( ( STACK1:Int modInt pow160 ) ==Int delegation ( GetAccountInfoAndWarmIt ( ... acct: ( STACK1:Int modInt pow160 ) ) ) orElseBool AccessedAccount ( ... acct: delegation ( GetAccountInfoAndWarmIt ( ... acct: ( STACK1:Int modInt pow160 ) ) ) ) ) ) #then 100 #else 2600 #fi #else 0 #fi +Int #if isWarm ( GetAccountInfoAndWarmIt ( ... acct: ( STACK1:Int modInt pow160 ) ) ) #then 100 #else 2600 #fi ) +Int #if ( notBool STACK2:Int ==Int 0 ) #then 25000 #else 0 #fi ) +Int Cxfer ( PRAGUE , STACK2:Int ) ) ) ) ) )
                 </gas>
                 <memoryUsed>
                   ( MEMORYUSED_CELL => #memoryUsageUpdate ( #memoryUsageUpdate ( MEMORYUSED_CELL:Int , STACK3:Int , STACK4:Int ) , STACK5:Int , STACK6:Int ) )
                 </memoryUsed>
                 <callGas>
                   ( _CALLGAS_CELL => ( Cgascap ( PRAGUE , STACK0:Int , ( GAS_CELL:Int -Int ( Cmem ( PRAGUE , #memoryUsageUpdate ( #memoryUsageUpdate ( MEMORYUSED_CELL:Int , STACK3:Int , STACK4:Int ) , STACK5:Int , STACK6:Int ) ) -Int Cmem ( PRAGUE , MEMORYUSED_CELL:Int ) ) ) , ( ( ( #if 0 <Int delegation ( GetAccountInfoAndWarmIt ( ... acct: ( STACK1:Int modInt pow160 ) ) ) #then #if ( 0 <Int delegation ( GetAccountInfoAndWarmIt ( ... acct: ( STACK1:Int modInt pow160 ) ) ) andThenBool ( ( STACK1:Int modInt pow160 ) ==Int delegation ( GetAccountInfoAndWarmIt ( ... acct: ( STACK1:Int modInt pow160 ) ) ) orElseBool AccessedAccount ( ... acct: delegation ( GetAccountInfoAndWarmIt ( ... acct: ( STACK1:Int modInt pow160 ) ) ) ) ) ) #then 100 #else 2600 #fi #else 0 #fi +Int #if isWarm ( GetAccountInfoAndWarmIt ( ... acct: ( STACK1:Int modInt pow160 ) ) ) #then 100 #else 2600 #fi ) +Int #if ( notBool STACK2:Int ==Int 0 ) #then 25000 #else 0 #fi ) +Int Cxfer ( PRAGUE , STACK2:Int ) ) ) +Int #if STACK2:Int ==Int 0 #then 0 #else 2300 #fi ) )
                 </callGas>
                 <static>
                   ( STATIC_CELL => false )
                 </static>
                 <callDepth>
                   CALLDEPTH_CELL
                 </callDepth>
                 ...
               </callState>
               ...
             </evm>
           </ethereum>
           ...
         </generatedTop>
      requires ( size ( ListItem ( STACK0:Int ) ListItem ( STACK1:Int ) ListItem ( STACK2:Int ) ListItem ( STACK3:Int ) ListItem ( STACK4:Int ) ListItem ( STACK5:Int ) ListItem ( STACK6:Int ) STACK_REST:List ) <Int 1025
       andBool ( 7 <=Int size ( ListItem ( STACK0:Int ) ListItem ( STACK1:Int ) ListItem ( STACK2:Int ) ListItem ( STACK3:Int ) ListItem ( STACK4:Int ) ListItem ( STACK5:Int ) ListItem ( STACK6:Int ) STACK_REST:List )
       andBool ( ( notBool STATIC_CELL )
       andBool ( ( notBool AccountExists ( ... acct: ( STACK1:Int modInt 2 ^Int 160 ) ) )
       andBool ( IsAccountEmpty ( ... acct: ( STACK1:Int modInt 2 ^Int 160 ) )
       andBool ( GetAccountBalance ( ... acct: ID_CELL ) >=Int STACK2:Int
       andBool ( CALLDEPTH_CELL <Int 1024
               )))))))
       ensures ( ( notBool STATIC_CELL:Bool )
       andBool ( CALLDEPTH_CELL:Int <Int 1024
       andBool ( STACK2:Int <=Int GetAccountBalance ( ... acct: ID_CELL:Int )
       andBool ( ( notBool AccountExists ( ... acct: ( STACK1:Int modInt pow160 ) ) )
       andBool ( IsAccountEmpty ( ... acct: ( STACK1:Int modInt pow160 ) )
               )))))
      [priority(50), label(BASIC-BLOCK-1-TO-2)]

endmodule
