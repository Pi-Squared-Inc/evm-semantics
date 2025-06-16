/*******************************************************************************
 *************** MANUALLY SUMMARIZED *******************************************
 *******************************************************************************/

requires "../language.md"
module SUMMARY-CANCUN-SWAP-01
    imports public EVM-CSE-PRELUDE

    rule [SWAP-N-SUMMARY-0]:
         <generatedTop>
           <k>
             ( #nextOpCode [(144 #Or 145 #Or 146 #Or 147
                         #Or 148 #Or 149 #Or 150 #Or 151
                         #Or 152 #Or 153 #Or 154 #Or 155
                         #Or 156 #Or 157 #Or 158 #Or 159) #as OpCode
                           ]
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
                 <program>
                   PROGRAM_CELL
                 </program>
                 <wordStack>
                   STACK_REST:List
                => STACK_REST:List[(OpCode -Int 143) <- STACK_REST[0]][0 <- STACK_REST[(OpCode -Int 143)]]
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
       andBool 1 +Int (OpCode -Int 143) <=Int size ( STACK_REST )
       andBool 3 <=Int GAS_CELL:Int

endmodule
