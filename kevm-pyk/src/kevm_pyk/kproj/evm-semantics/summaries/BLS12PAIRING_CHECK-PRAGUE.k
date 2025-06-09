/*******************************************************************************
0 frontier nodes remaining.

┌─ 1 (root)
│
│  (15 steps)
└─ 2 (stuck, leaf)




 *******************************************************************************/
requires "../language.md"
module SUMMARY-PRAGUE-BLS12PAIRING_CHECK
    imports public EVM-CSE-PRELUDE
    
    rule [BASIC-BLOCK-1-TO-2]: <generatedTop>
           <k>
             ( #precompiled? ( 15 , PRAGUE )
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
                 ( _OUTPUT_CELL => #if bls12PairingResult.get ( bls12PairingCheck ( CALLDATA_CELL:Bytes , .List , .List ) ) #then b"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01" #else b"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" #fi )
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
                   ( GAS_CELL => ( ( GAS_CELL:Int -Int ( 32600 *Int ( lengthBytes ( CALLDATA_CELL:Bytes ) /Int 384 ) ) ) +Int -37700 ) )
                 </gas>
                 ...
               </callState>
               ...
             </evm>
           </ethereum>
           ...
         </generatedTop>
      requires ( size ( WORDSTACK_CELL ) <Int 1024
       andBool ( bls12PairingCheck ( CALLDATA_CELL , .List , .List ) =/=K bls12PairingError
       andBool ( ( ( GAS_CELL:Int -Int ( 32600 *Int ( lengthBytes ( CALLDATA_CELL:Bytes ) /Int 384 ) ) ) +Int -37700 ) >=Int 0
               )))
       ensures ( size ( WORDSTACK_CELL:List ) <Int 1024
       andBool ( bls12PairingError =/=K bls12PairingCheck ( CALLDATA_CELL:Bytes , .List , .List )
               ))
      [priority(50), label(BASIC-BLOCK-1-TO-2)]

endmodule
