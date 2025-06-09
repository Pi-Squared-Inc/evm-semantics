/*******************************************************************************
0 frontier nodes remaining.

┌─ 1 (root)
│
│  (14 steps)
└─ 2 (stuck, leaf)




 *******************************************************************************/
requires "../language.md"
module SUMMARY-PRAGUE-BLS12G2ADD
    imports public EVM-CSE-PRELUDE
    
    rule [BASIC-BLOCK-1-TO-2]: <generatedTop>
           <k>
             ( #precompiled? ( 13 , PRAGUE )
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
                 ( _OUTPUT_CELL => #bls12point ( BLS12G2Add ( ( Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 0 , 64 ) , BE , Unsigned ) x Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 64 , 128 ) , BE , Unsigned ) , Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 128 , 192 ) , BE , Unsigned ) x Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 192 , 256 ) , BE , Unsigned ) ) , ( Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 256 , 320 ) , BE , Unsigned ) x Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 320 , 384 ) , BE , Unsigned ) , Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 384 , 448 ) , BE , Unsigned ) x Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 448 , 512 ) , BE , Unsigned ) ) ) ) )
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
                   ( GAS_CELL => ( GAS_CELL:Int +Int -600 ) )
                 </gas>
                 ...
               </callState>
               ...
             </evm>
           </ethereum>
           ...
         </generatedTop>
      requires ( size ( WORDSTACK_CELL ) <Int 1024
       andBool ( 512 ==Int lengthBytes ( CALLDATA_CELL )
       andBool ( bls12ValidForAdd2 ( Bytes2Int ( substrBytes ( CALLDATA_CELL , 0 , 64 ) , BE , Unsigned ) , Bytes2Int ( substrBytes ( CALLDATA_CELL , 64 , 128 ) , BE , Unsigned ) , Bytes2Int ( substrBytes ( CALLDATA_CELL , 128 , 192 ) , BE , Unsigned ) , Bytes2Int ( substrBytes ( CALLDATA_CELL , 192 , 256 ) , BE , Unsigned ) , Bytes2Int ( substrBytes ( CALLDATA_CELL , 256 , 320 ) , BE , Unsigned ) , Bytes2Int ( substrBytes ( CALLDATA_CELL , 320 , 384 ) , BE , Unsigned ) , Bytes2Int ( substrBytes ( CALLDATA_CELL , 384 , 448 ) , BE , Unsigned ) , Bytes2Int ( substrBytes ( CALLDATA_CELL , 448 , 512 ) , BE , Unsigned ) )
       andBool ( ( GAS_CELL:Int +Int -600 ) >=Int 0
               ))))
       ensures ( 512 ==Int lengthBytes ( CALLDATA_CELL:Bytes )
       andBool ( size ( WORDSTACK_CELL:List ) <Int 1024
       andBool ( 0 <=Int Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 0 , 64 ) , BE , Unsigned )
       andBool ( 0 <=Int Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 64 , 128 ) , BE , Unsigned )
       andBool ( 0 <=Int Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 128 , 192 ) , BE , Unsigned )
       andBool ( 0 <=Int Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 192 , 256 ) , BE , Unsigned )
       andBool ( 0 <=Int Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 256 , 320 ) , BE , Unsigned )
       andBool ( 0 <=Int Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 320 , 384 ) , BE , Unsigned )
       andBool ( 0 <=Int Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 384 , 448 ) , BE , Unsigned )
       andBool ( 0 <=Int Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 448 , 512 ) , BE , Unsigned )
       andBool ( Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 0 , 64 ) , BE , Unsigned ) <Int BLS12_FIELD_MODULUS
       andBool ( Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 0 , 64 ) , BE , Unsigned ) <Int 39402006196394479212279040100143613805079739270465446667948293404245721771497210611414266254884915640806627990306816
       andBool ( Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 64 , 128 ) , BE , Unsigned ) <Int BLS12_FIELD_MODULUS
       andBool ( Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 128 , 192 ) , BE , Unsigned ) <Int BLS12_FIELD_MODULUS
       andBool ( Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 192 , 256 ) , BE , Unsigned ) <Int BLS12_FIELD_MODULUS
       andBool ( Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 256 , 320 ) , BE , Unsigned ) <Int BLS12_FIELD_MODULUS
       andBool ( Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 320 , 384 ) , BE , Unsigned ) <Int BLS12_FIELD_MODULUS
       andBool ( Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 384 , 448 ) , BE , Unsigned ) <Int BLS12_FIELD_MODULUS
       andBool ( Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 448 , 512 ) , BE , Unsigned ) <Int BLS12_FIELD_MODULUS
       andBool ( Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 64 , 128 ) , BE , Unsigned ) <Int 39402006196394479212279040100143613805079739270465446667948293404245721771497210611414266254884915640806627990306816
       andBool ( Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 128 , 192 ) , BE , Unsigned ) <Int 39402006196394479212279040100143613805079739270465446667948293404245721771497210611414266254884915640806627990306816
       andBool ( Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 192 , 256 ) , BE , Unsigned ) <Int 39402006196394479212279040100143613805079739270465446667948293404245721771497210611414266254884915640806627990306816
       andBool ( Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 256 , 320 ) , BE , Unsigned ) <Int 39402006196394479212279040100143613805079739270465446667948293404245721771497210611414266254884915640806627990306816
       andBool ( Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 320 , 384 ) , BE , Unsigned ) <Int 39402006196394479212279040100143613805079739270465446667948293404245721771497210611414266254884915640806627990306816
       andBool ( Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 384 , 448 ) , BE , Unsigned ) <Int 39402006196394479212279040100143613805079739270465446667948293404245721771497210611414266254884915640806627990306816
       andBool ( Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 448 , 512 ) , BE , Unsigned ) <Int 39402006196394479212279040100143613805079739270465446667948293404245721771497210611414266254884915640806627990306816
       andBool ( BLS12G2OnCurve ( ( Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 0 , 64 ) , BE , Unsigned ) x Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 64 , 128 ) , BE , Unsigned ) , Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 128 , 192 ) , BE , Unsigned ) x Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 192 , 256 ) , BE , Unsigned ) ) )
       andBool ( BLS12G2OnCurve ( ( Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 256 , 320 ) , BE , Unsigned ) x Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 320 , 384 ) , BE , Unsigned ) , Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 384 , 448 ) , BE , Unsigned ) x Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 448 , 512 ) , BE , Unsigned ) ) )
               ))))))))))))))))))))))))))))
      [priority(50), label(BASIC-BLOCK-1-TO-2)]

endmodule
