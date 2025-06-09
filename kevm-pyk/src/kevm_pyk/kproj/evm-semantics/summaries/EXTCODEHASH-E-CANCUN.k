/*******************************************************************************
0 frontier nodes remaining.

┌─ 1 (root)
│
│  (16 steps)
└─ 2 (stuck, leaf)




 *******************************************************************************/
requires "../language.md"
module SUMMARY-CANCUN-EXTCODEHASH-E
    imports public EVM-CSE-PRELUDE
    
    rule [BASIC-BLOCK-1-TO-2]: <generatedTop>
           <k>
             ( #nextOpCode [ 63 ]
             ~> #execute
             ~> K_CELL_DOTS => AccessAccount ( ... acct: ( STACK0:Int modInt pow160 ) )
             ~> #execute
             ~> K_CELL_DOTS:K )
           </k>
           <schedule>
             CANCUN
           </schedule>
           <ethereum>
             <evm>
               <callState>
                 <wordStack>
                   ListItem ( ( STACK0:Int => 0 ) ) ( STACK_REST => ListItem ( STACK_REST:List ) )
                 </wordStack>
                 <pc>
                   ( PC_CELL => ( PC_CELL:Int +Int 1 ) )
                 </pc>
                 <gas>
                   ( GAS_CELL => ( GAS_CELL:Int -Int #if AccessedAccount ( ... acct: ( STACK0:Int modInt pow160 ) ) #then 100 #else 2600 #fi ) )
                 </gas>
                 ...
               </callState>
               ...
             </evm>
           </ethereum>
           
           ...
         </generatedTop>
      requires ( size ( ListItem ( STACK0:Int ) STACK_REST ) <Int 1024
       andBool ( 1 <=Int size ( ListItem ( STACK0:Int ) STACK_REST )
       andBool ( IsAccountEmpty ( ... acct: ( STACK0:Int modInt 2 ^Int 160 ) )
       andBool ( ( GAS_CELL:Int -Int #if AccessedAccount ( ... acct: ( STACK0:Int modInt pow160 ) ) #then 100 #else 2600 #fi ) >=Int 0
               ))))
       ensures IsAccountEmpty ( ... acct: ( STACK0:Int modInt pow160 ) )
      [priority(50), label(BASIC-BLOCK-1-TO-2)]

endmodule
