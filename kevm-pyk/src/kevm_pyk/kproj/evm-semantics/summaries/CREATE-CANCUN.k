/*******************************************************************************
0 frontier nodes remaining.

┌─ 1 (root)
│
│  (21 steps)
└─ 2 (stuck, leaf)




 *******************************************************************************/
requires "../language.md"
module SUMMARY-CANCUN-CREATE
    imports public EVM-CSE-PRELUDE
    
    rule [BASIC-BLOCK-1-TO-2]: <generatedTop>
           <k>
             ( #nextOpCode [ 240 ]
             ~> #execute
             ~> K_CELL_DOTS => AccessAccount ( ... acct: #newAddr ( ID_CELL:Int , GetAccountNonce ( ... acct: ID_CELL:Int ) ) )
             ~> #create ID_CELL:Int #newAddr ( ID_CELL:Int , GetAccountNonce ( ... acct: ID_CELL:Int ) ) STACK0:Int #range ( LOCALMEM_CELL:Bytes , STACK1:Int , STACK2:Int )
             ~> #codeDeposit #newAddr ( ID_CELL:Int , GetAccountNonce ( ... acct: ID_CELL:Int ) )
             ~> #pc [ CREATE ]
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
                 <gas>
                   ( GAS_CELL => ( ( ( ( GAS_CELL:Int -Int ( Cmem ( CANCUN , #memoryUsageUpdate ( MEMORYUSED_CELL:Int , STACK1:Int , STACK2:Int ) ) -Int Cmem ( CANCUN , MEMORYUSED_CELL:Int ) ) ) -Int Cinitcode ( CANCUN , STACK2:Int ) ) +Int -32000 ) /Int 64 ) )
                 </gas>
                 <memoryUsed>
                   ( MEMORYUSED_CELL => #memoryUsageUpdate ( MEMORYUSED_CELL:Int , STACK1:Int , STACK2:Int ) )
                 </memoryUsed>
                 <callGas>
                   ( _CALLGAS_CELL => #allBut64th ( ( ( ( GAS_CELL:Int -Int ( Cmem ( CANCUN , #memoryUsageUpdate ( MEMORYUSED_CELL:Int , STACK1:Int , STACK2:Int ) ) -Int Cmem ( CANCUN , MEMORYUSED_CELL:Int ) ) ) -Int Cinitcode ( CANCUN , STACK2:Int ) ) +Int -32000 ) ) )
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
      requires ( size ( ListItem ( STACK0:Int ) ListItem ( STACK1:Int ) ListItem ( STACK2:Int ) STACK_REST ) <Int 1025
       andBool ( 3 <=Int size ( ListItem ( STACK0:Int ) ListItem ( STACK1:Int ) ListItem ( STACK2:Int ) STACK_REST )
       andBool ( ( notBool STATIC_CELL )
       andBool ( #hasValidInitCode ( STACK2:Int , CANCUN )
       andBool ( GetAccountBalance ( ... acct: ID_CELL ) >=Int STACK0:Int
       andBool ( CALLDEPTH_CELL <Int 1024
       andBool ( 0 <=Int GetAccountNonce ( ... acct: ID_CELL )
       andBool ( GetAccountNonce ( ... acct: ID_CELL ) <Int maxUInt64
               ))))))))
       ensures ( ( notBool STATIC_CELL:Bool )
       andBool ( STACK2:Int <=Int 49152
       andBool ( CALLDEPTH_CELL:Int <Int 1024
       andBool ( 0 <=Int GetAccountNonce ( ... acct: ID_CELL:Int )
       andBool ( STACK0:Int <=Int GetAccountBalance ( ... acct: ID_CELL:Int )
       andBool ( GetAccountNonce ( ... acct: ID_CELL:Int ) <Int maxUInt64
               ))))))
      [priority(50), label(BASIC-BLOCK-1-TO-2)]

endmodule
