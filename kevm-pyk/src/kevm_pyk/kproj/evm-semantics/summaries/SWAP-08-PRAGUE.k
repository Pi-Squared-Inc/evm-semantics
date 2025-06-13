/*******************************************************************************
 *************** MANUALLY SUMMARIZED *******************************************
 *******************************************************************************/

requires "../language.md"
module SUMMARY-PRAGUE-SWAP-08
    imports public EVM-CSE-PRELUDE

    rule [SWAP-N-SUMMARY-0]:
         <generatedTop>
           <k>
             ( #nextOpCode [ 151 ]
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
                => #ComputeSwap(8, STACK_REST)
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
       andBool #CheckSwap(8, STACK_REST)
       andBool 3 <=Int GAS_CELL:Int

endmodule
