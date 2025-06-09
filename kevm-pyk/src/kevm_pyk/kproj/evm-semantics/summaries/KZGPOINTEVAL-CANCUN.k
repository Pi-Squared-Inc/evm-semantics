/*******************************************************************************
0 frontier nodes remaining.

┌─ 1 (root)
│
│  (14 steps)
└─ 2 (stuck, leaf)




 *******************************************************************************/
requires "../language.md"
module SUMMARY-CANCUN-KZGPOINTEVAL
    imports public EVM-CSE-PRELUDE
    
    rule [BASIC-BLOCK-1-TO-2]: <generatedTop>
           <k>
             ( #precompiled? ( 10 , CANCUN )
             ~> #execute
             ~> K_CELL_DOTS => #halt
             ~> K_CELL_DOTS:K )
           </k>
           <schedule>
             CANCUN
           </schedule>
           <ethereum>
             <evm>
               <output>
                 ( _OUTPUT_CELL => b"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00s\xed\xa7S)\x9d}H39\xd8\x08\t\xa1\xd8\x05S\xbd\xa4\x02\xff\xfe[\xfe\xff\xff\xff\xff\x00\x00\x00\x01" )
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
                   ( GAS_CELL => ( GAS_CELL:Int +Int -50000 ) )
                 </gas>
                 ...
               </callState>
               ...
             </evm>
           </ethereum>
           ...
         </generatedTop>
      requires ( size ( WORDSTACK_CELL ) <Int 1024
       andBool ( 192 ==Int lengthBytes ( CALLDATA_CELL )
       andBool ( #kzg2vh ( substrBytes ( CALLDATA_CELL , 96 , 144 ) ) ==Bytes substrBytes ( CALLDATA_CELL , 0 , 32 )
       andBool ( Bytes2Int ( substrBytes ( CALLDATA_CELL , 32 , 64 ) , BE , Unsigned ) <Int 52435875175126190479447740508185965837690552500527637822603658699938581184513
       andBool ( Bytes2Int ( substrBytes ( CALLDATA_CELL , 64 , 96 ) , BE , Unsigned ) <Int 52435875175126190479447740508185965837690552500527637822603658699938581184513
       andBool ( verifyKZGProof ( substrBytes ( CALLDATA_CELL , 96 , 144 ) , substrBytes ( CALLDATA_CELL , 32 , 64 ) , substrBytes ( CALLDATA_CELL , 64 , 96 ) , substrBytes ( CALLDATA_CELL , 144 , 192 ) )
       andBool ( ( GAS_CELL:Int +Int -50000 ) >=Int 0
               )))))))
       ensures ( 192 ==Int lengthBytes ( CALLDATA_CELL:Bytes )
       andBool ( size ( WORDSTACK_CELL:List ) <Int 1024
       andBool ( Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 32 , 64 ) , BE , Unsigned ) <Int 52435875175126190479447740508185965837690552500527637822603658699938581184513
       andBool ( Bytes2Int ( substrBytes ( CALLDATA_CELL:Bytes , 64 , 96 ) , BE , Unsigned ) <Int 52435875175126190479447740508185965837690552500527637822603658699938581184513
       andBool ( Sha256raw ( substrBytes ( CALLDATA_CELL:Bytes , 96 , 144 ) ) [ 0 <- 1 ] ==K substrBytes ( CALLDATA_CELL:Bytes , 0 , 32 )
       andBool ( verifyKZGProof ( substrBytes ( CALLDATA_CELL:Bytes , 96 , 144 ) , substrBytes ( CALLDATA_CELL:Bytes , 32 , 64 ) , substrBytes ( CALLDATA_CELL:Bytes , 64 , 96 ) , substrBytes ( CALLDATA_CELL:Bytes , 144 , 192 ) )
               ))))))
      [priority(50), label(BASIC-BLOCK-1-TO-2)]

endmodule
