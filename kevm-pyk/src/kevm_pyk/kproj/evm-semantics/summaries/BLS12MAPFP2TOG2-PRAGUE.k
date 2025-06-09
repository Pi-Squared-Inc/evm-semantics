/*******************************************************************************
0 frontier nodes remaining.

┌─ 1 (root)
│
│  (14 steps)
└─ 2 (stuck, leaf)




 *******************************************************************************/
requires "../language.md"
module SUMMARY-PRAGUE-BLS12MAPFP2TOG2
    imports public EVM-CSE-PRELUDE
    
    rule [BASIC-BLOCK-1-TO-2]: <generatedTop>
           <k>
             ( #precompiled? ( 17 , PRAGUE )
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
                 ( _OUTPUT_CELL => #bls12point ( BLS12MapFp2ToG2 ( Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 0 , 64 ) , BE , Unsigned ) , Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 64 , 128 ) , BE , Unsigned ) ) ) )
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
                   ( GAS_CELL => ( GAS_CELL:Int +Int -23800 ) )
                 </gas>
                 ...
               </callState>
               ...
             </evm>
           </ethereum>
           ...
         </generatedTop>
      requires ( size ( WORDSTACK_CELL ) <Int 1024
       andBool ( 128 ==Int lengthBytes ( CALLDATA_CELL )
       andBool ( isValidBLS12Fp ( Bytes2Int ( substrBytes ( CALLDATA_CELL , 0 , 64 ) , BE , Unsigned ) )
       andBool ( isValidBLS12Fp ( Bytes2Int ( substrBytes ( CALLDATA_CELL , 64 , 128 ) , BE , Unsigned ) )
       andBool ( ( GAS_CELL:Int +Int -23800 ) >=Int 0
               )))))
       ensures ( 128 ==Int lengthBytes ( CALLDATA_CELL:Bytes )
       andBool ( size ( WORDSTACK_CELL:List ) <Int 1024
       andBool ( size ( WORDSTACK_CELL:List ) <=Int 1023
       andBool ( 0 <=Int Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 0 , 64 ) , BE , Unsigned )
       andBool ( 0 <=Int Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 64 , 128 ) , BE , Unsigned )
       andBool ( Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 0 , 64 ) , BE , Unsigned ) <Int BLS12_FIELD_MODULUS
       andBool ( Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 0 , 64 ) , BE , Unsigned ) <Int 39402006196394479212279040100143613805079739270465446667948293404245721771497210611414266254884915640806627990306816
       andBool ( Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 64 , 128 ) , BE , Unsigned ) <Int BLS12_FIELD_MODULUS
       andBool ( Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 64 , 128 ) , BE , Unsigned ) <Int 39402006196394479212279040100143613805079739270465446667948293404245721771497210611414266254884915640806627990306816
               )))))))))
      [priority(50), label(BASIC-BLOCK-1-TO-2)]

endmodule
