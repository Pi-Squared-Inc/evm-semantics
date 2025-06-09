/*******************************************************************************
0 frontier nodes remaining.

┌─ 1 (root)
│
│  (13 steps)
└─ 2 (stuck, leaf)




 *******************************************************************************/
requires "../language.md"
module SUMMARY-PRAGUE-BLOBHASH-GT
    imports public EVM-CSE-PRELUDE
    
    rule [BASIC-BLOCK-1-TO-2]: <generatedTop>
           <k>
             ( #nextOpCode [ 73 ]
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
                   ListItem ( ( STACK0:Int => 0 ) ) STACK_REST
                 </wordStack>
                 <pc>
                   ( PC_CELL => ( PC_CELL:Int +Int 1 ) )
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
      requires ( size ( ListItem ( STACK0:Int ) STACK_REST ) <Int 1024
       andBool ( 1 <=Int size ( ListItem ( STACK0:Int ) STACK_REST )
       andBool ( ( notBool STACK0:Int <Int BlobHashesSize ( ) )
       andBool ( ( GAS_CELL:Int +Int -3 ) >=Int 0
               ))))
       ensures BlobHashesSize ( ) <=Int STACK0:Int
      [priority(50), label(BASIC-BLOCK-1-TO-2)]

endmodule
