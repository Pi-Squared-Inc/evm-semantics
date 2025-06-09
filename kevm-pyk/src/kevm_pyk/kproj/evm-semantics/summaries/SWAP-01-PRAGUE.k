/*******************************************************************************
 *************** MANUALLY SUMMARIZED *******************************************
 *******************************************************************************/

requires "../language.md"
module SUMMARY-PRAGUE-SWAP-01
    imports public EVM-CSE-PRELUDE

    rule [SWAP-N-SUMMARY-0]:
         <generatedTop>
           <k>
             ( #nextOpCode [ 144 ]
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
                   STACK_REST:List
                => STACK_REST:List[1 <- STACK_REST[0]][0 <- STACK_REST[1]]
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
      requires size ( STACK_REST ) <=Int 1024
       andBool 2 <=Int size ( STACK_REST )
       andBool 3 <=Int GAS_CELL:Int

endmodule
