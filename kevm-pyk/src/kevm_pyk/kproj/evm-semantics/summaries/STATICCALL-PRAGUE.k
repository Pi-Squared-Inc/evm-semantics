/*******************************************************************************
0 frontier nodes remaining.

┌─ 1 (root)
│
│  (27 steps)
└─ 2 (stuck, leaf)




 *******************************************************************************/
requires "../language.md"
module SUMMARY-PRAGUE-STATICCALL
    imports public EVM-CSE-PRELUDE
    
    rule [BASIC-BLOCK-1-TO-2]: <generatedTop>
           <k>
             ( #nextOpCode [ 250 ]
             ~> #execute
             ~> K_CELL_DOTS => AccessAccount ( ... acct: ( STACK1:Int modInt pow160 ) )
             ~> #call ID_CELL:Int ( STACK1:Int modInt pow160 ) ( STACK1:Int modInt pow160 ) 0 0 #range ( LOCALMEM_CELL:Bytes , STACK2:Int , STACK3:Int ) true
             ~> #return STACK4:Int STACK5:Int
             ~> #pc [ STATICCALL ]
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
                   ( ListItem ( STACK0:Int ) ListItem ( STACK1:Int ) ListItem ( STACK2:Int ) ListItem ( STACK3:Int ) ListItem ( STACK4:Int ) ListItem ( STACK5:Int ) STACK_REST => ListItem ( STACK_REST:List ) )
                 </wordStack>
                 <localMem>
                   LOCALMEM_CELL
                 </localMem>
                 <gas>
                   ( GAS_CELL => ( ( GAS_CELL:Int -Int ( Cmem ( PRAGUE , #memoryUsageUpdate ( #memoryUsageUpdate ( MEMORYUSED_CELL:Int , STACK2:Int , STACK3:Int ) , STACK4:Int , STACK5:Int ) ) -Int Cmem ( PRAGUE , MEMORYUSED_CELL:Int ) ) ) -Int ( ( #if 0 <Int delegation ( GetAccountInfoAndWarmIt ( ... acct: ( STACK1:Int modInt pow160 ) ) ) #then #if ( 0 <Int delegation ( GetAccountInfoAndWarmIt ( ... acct: ( STACK1:Int modInt pow160 ) ) ) andThenBool ( ( STACK1:Int modInt pow160 ) ==Int delegation ( GetAccountInfoAndWarmIt ( ... acct: ( STACK1:Int modInt pow160 ) ) ) orElseBool AccessedAccount ( ... acct: delegation ( GetAccountInfoAndWarmIt ( ... acct: ( STACK1:Int modInt pow160 ) ) ) ) ) ) #then 100 #else 2600 #fi #else 0 #fi +Int #if isWarm ( GetAccountInfoAndWarmIt ( ... acct: ( STACK1:Int modInt pow160 ) ) ) #then 100 #else 2600 #fi ) +Int Cgascap ( PRAGUE , STACK0:Int , ( GAS_CELL:Int -Int ( Cmem ( PRAGUE , #memoryUsageUpdate ( #memoryUsageUpdate ( MEMORYUSED_CELL:Int , STACK2:Int , STACK3:Int ) , STACK4:Int , STACK5:Int ) ) -Int Cmem ( PRAGUE , MEMORYUSED_CELL:Int ) ) ) , ( #if 0 <Int delegation ( GetAccountInfoAndWarmIt ( ... acct: ( STACK1:Int modInt pow160 ) ) ) #then #if ( 0 <Int delegation ( GetAccountInfoAndWarmIt ( ... acct: ( STACK1:Int modInt pow160 ) ) ) andThenBool ( ( STACK1:Int modInt pow160 ) ==Int delegation ( GetAccountInfoAndWarmIt ( ... acct: ( STACK1:Int modInt pow160 ) ) ) orElseBool AccessedAccount ( ... acct: delegation ( GetAccountInfoAndWarmIt ( ... acct: ( STACK1:Int modInt pow160 ) ) ) ) ) ) #then 100 #else 2600 #fi #else 0 #fi +Int #if isWarm ( GetAccountInfoAndWarmIt ( ... acct: ( STACK1:Int modInt pow160 ) ) ) #then 100 #else 2600 #fi ) ) ) ) )
                 </gas>
                 <memoryUsed>
                   ( MEMORYUSED_CELL => #memoryUsageUpdate ( #memoryUsageUpdate ( MEMORYUSED_CELL:Int , STACK2:Int , STACK3:Int ) , STACK4:Int , STACK5:Int ) )
                 </memoryUsed>
                 <callGas>
                   ( _CALLGAS_CELL => Cgascap ( PRAGUE , STACK0:Int , ( GAS_CELL:Int -Int ( Cmem ( PRAGUE , #memoryUsageUpdate ( #memoryUsageUpdate ( MEMORYUSED_CELL:Int , STACK2:Int , STACK3:Int ) , STACK4:Int , STACK5:Int ) ) -Int Cmem ( PRAGUE , MEMORYUSED_CELL:Int ) ) ) , ( #if 0 <Int delegation ( GetAccountInfoAndWarmIt ( ... acct: ( STACK1:Int modInt pow160 ) ) ) #then #if ( 0 <Int delegation ( GetAccountInfoAndWarmIt ( ... acct: ( STACK1:Int modInt pow160 ) ) ) andThenBool ( ( STACK1:Int modInt pow160 ) ==Int delegation ( GetAccountInfoAndWarmIt ( ... acct: ( STACK1:Int modInt pow160 ) ) ) orElseBool AccessedAccount ( ... acct: delegation ( GetAccountInfoAndWarmIt ( ... acct: ( STACK1:Int modInt pow160 ) ) ) ) ) ) #then 100 #else 2600 #fi #else 0 #fi +Int #if isWarm ( GetAccountInfoAndWarmIt ( ... acct: ( STACK1:Int modInt pow160 ) ) ) #then 100 #else 2600 #fi ) ) )
                 </callGas>
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
      requires ( size ( ListItem ( STACK0:Int ) ListItem ( STACK1:Int ) ListItem ( STACK2:Int ) ListItem ( STACK3:Int ) ListItem ( STACK4:Int ) ListItem ( STACK5:Int ) STACK_REST ) <Int 1025
       andBool ( 6 <=Int size ( ListItem ( STACK0:Int ) ListItem ( STACK1:Int ) ListItem ( STACK2:Int ) ListItem ( STACK3:Int ) ListItem ( STACK4:Int ) ListItem ( STACK5:Int ) STACK_REST )
       andBool ( AccountExists ( ... acct: ( STACK1:Int modInt 2 ^Int 160 ) )
       andBool ( GetAccountBalance ( ... acct: ID_CELL ) >=Int 0
       andBool ( CALLDEPTH_CELL <Int 1024
               )))))
       ensures ( CALLDEPTH_CELL:Int <Int 1024
       andBool ( 0 <=Int GetAccountBalance ( ... acct: ID_CELL:Int )
       andBool ( AccountExists ( ... acct: ( STACK1:Int modInt pow160 ) )
               )))
      [priority(20), label(BASIC-BLOCK-1-TO-2)]

endmodule
