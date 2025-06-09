/*******************************************************************************
0 frontier nodes remaining.

┌─ 1 (root)
│
│  (15 steps)
└─ 2 (stuck, leaf)




 *******************************************************************************/
requires "../language.md"
module SUMMARY-PRAGUE-BLS12G2MSM
    imports public EVM-CSE-PRELUDE
    
    rule [BASIC-BLOCK-1-TO-2]: <generatedTop>
           <k>
             ( #precompiled? ( 14 , PRAGUE )
             ~> #execute
             ~> K_CELL_DOTS => #halt
             ~> K_CELL_DOTS:K )
           </k>
           <schedule>
             PRAGUE
           </schedule>
           <ethereum>
             <evm>
               <output>
                 ( _OUTPUT_CELL => #bls12point ( g2MsmResult.getPoint ( bls12G2Msm ( CALLDATA_CELL:Bytes ) ) ) )
               </output>
               <statusCode>
                 ( _STATUSCODE_CELL => EVMC_SUCCESS )
               </statusCode>
               <callState>
                 <callData>
                   CALLDATA_CELL
                 </callData>
                 <wordStack>
                   WORDSTACK_CELL
                 </wordStack>
                 <gas>
                   ( GAS_CELL => ( GAS_CELL:Int -Int ( ( ( 22500 *Int ( lengthBytes ( CALLDATA_CELL:Bytes ) /Int 288 ) ) *Int Cbls12g2MsmDiscount ( PRAGUE , ( lengthBytes ( CALLDATA_CELL:Bytes ) /Int 288 ) ) ) /Int 1000 ) ) )
                 </gas>
                 ...
               </callState>
               ...
             </evm>
           </ethereum>
           ...
         </generatedTop>
      requires ( size ( WORDSTACK_CELL ) <Int 1024
       andBool ( bls12G2Msm ( CALLDATA_CELL ) =/=K g2MsmError
       andBool ( ( GAS_CELL:Int -Int ( ( ( 22500 *Int ( lengthBytes ( CALLDATA_CELL:Bytes ) /Int 288 ) ) *Int Cbls12g2MsmDiscount ( PRAGUE , ( lengthBytes ( CALLDATA_CELL:Bytes ) /Int 288 ) ) ) /Int 1000 ) ) >=Int 0
               )))
       ensures ( size ( WORDSTACK_CELL:List ) <Int 1024
       andBool ( g2MsmError =/=K bls12G2Msm ( CALLDATA_CELL:Bytes )
               ))
      [priority(50), label(BASIC-BLOCK-1-TO-2)]

endmodule
