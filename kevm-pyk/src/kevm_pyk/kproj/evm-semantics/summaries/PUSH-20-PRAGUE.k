/*******************************************************************************
0 frontier nodes remaining.

┌─ 1 (root)
│
│  (13 steps)
└─ 2 (stuck, leaf)




 *******************************************************************************/
requires "../language.md"
module SUMMARY-PRAGUE-PUSH-20
    imports public EVM-CSE-PRELUDE
    
    rule [BASIC-BLOCK-1-TO-2]: <generatedTop>
           <k>
             ( #nextOpCode [ 115 ]
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
                 <program>
                   PROGRAM_CELL
                 </program>
                 <wordStack>
                   ( STACK_REST => ListItem ( #asWord ( #range ( PROGRAM_CELL:Bytes , ( PC_CELL:Int +Int 1 ) , 20 ) ) ) STACK_REST:List )
                 </wordStack>
                 <pc>
                   ( PC_CELL => ( PC_CELL:Int +Int 21 ) )
                 </pc>
                 <gas>
                   ( GAS_CELL => ( GAS_CELL:Int +Int -3 ) )
                 </gas>
                 ...
               </callState>
               ...
             </evm>
           </ethereum>
           ...
         </generatedTop>
      requires ( size ( STACK_REST ) <Int 1005
       andBool ( 0 <=Int size ( STACK_REST )
       andBool ( ( GAS_CELL:Int +Int -3 ) >=Int 0
               )))
       ensures size ( STACK_REST:List ) <Int 1005
      [priority(50), label(BASIC-BLOCK-1-TO-2)]

endmodule
