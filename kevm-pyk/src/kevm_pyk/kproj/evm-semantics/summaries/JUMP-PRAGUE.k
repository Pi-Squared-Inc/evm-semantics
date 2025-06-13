/*******************************************************************************
0 frontier nodes remaining.

┌─ 1 (root)
│
│  (13 steps)
└─ 2 (stuck, leaf)




 *******************************************************************************/
requires "../language.md"
module SUMMARY-PRAGUE-JUMP
    imports public EVM-CSE-PRELUDE
    
    rule [BASIC-BLOCK-1-TO-2]: <generatedTop>
           <k>
             ( #nextOpCode [ 86 ]
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
                 <jumpDests>
                   JUMPDESTS_CELL
                 </jumpDests>
                 <wordStack>
                   ( ListItem ( STACK0:Int ) STACK_REST => STACK_REST:List )
                 </wordStack>
                 <pc>
                   ( _PC_CELL => STACK0:Int )
                 </pc>
                 <gas>
                   ( GAS_CELL => ( GAS_CELL:Int +Int -8 ) )
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
       andBool ( 1 ==Int JUMPDESTS_CELL [ STACK0:Int ]
       andBool ( STACK0:Int <Int lengthBytes ( JUMPDESTS_CELL )
       andBool ( ( GAS_CELL:Int +Int -8 ) >=Int 0
               )))))
       andBool STACK0:Int =/=Int 1510
       ensures ( 1 ==Int JUMPDESTS_CELL:Bytes [ STACK0:Int ]
       andBool ( STACK0:Int <Int lengthBytes ( JUMPDESTS_CELL:Bytes )
               ))
      [priority(50), label(BASIC-BLOCK-1-TO-2)]

endmodule
