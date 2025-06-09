/*******************************************************************************
0 frontier nodes remaining.

┌─ 1 (root)
│
│  (13 steps)
└─ 2 (stuck, leaf)




 *******************************************************************************/
requires "../language.md"
module SUMMARY-CANCUN-PC
    imports public EVM-CSE-PRELUDE
    
    rule [BASIC-BLOCK-1-TO-2]: <generatedTop>
           <k>
             ( #nextOpCode [ 88 ]
             ~> #execute
             ~> K_CELL_DOTS => #execute
             ~> K_CELL_DOTS:K )
           </k>
           <schedule>
             CANCUN
           </schedule>
           <ethereum>
             <evm>
               <callState>
                 <wordStack>
                   ( STACK_REST => ListItem ( PC_CELL:Int ) STACK_REST:List )
                 </wordStack>
                 <pc>
                   ( PC_CELL => ( PC_CELL:Int +Int 1 ) )
                 </pc>
                 <gas>
                   ( GAS_CELL => ( GAS_CELL:Int +Int -2 ) )
                 </gas>
                 ...
               </callState>
               ...
             </evm>
           </ethereum>
           ...
         </generatedTop>
      requires ( size ( STACK_REST ) <Int 1024
       andBool ( 0 <=Int size ( STACK_REST )
       andBool ( ( GAS_CELL:Int +Int -2 ) >=Int 0
               )))
       ensures size ( STACK_REST:List ) <Int 1024
      [priority(50), label(BASIC-BLOCK-1-TO-2)]

endmodule
