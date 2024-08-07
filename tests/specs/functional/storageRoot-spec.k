requires "evm.md"
requires "edsl.md"

module VERIFICATION
    imports EVM
    imports EDSL

    syntax KItem ::= runLemma ( Step ) [symbol(runLemma)] | doneLemma ( Step )
 // -------------------------------------------------------
    rule <k> runLemma(S) => doneLemma(S) ... </k>

    syntax Step ::= String | MerkleTree | Bytes
 // -------------------------------------------

endmodule

module STORAGEROOT-SPEC
    imports VERIFICATION

    claim [merkle.1]:
          <k> runLemma ( #storageRoot( .Map ) ) => doneLemma ( .MerkleTree ) </k>

    claim [merkle.2]:
          <k> runLemma ( #rlpEncodeString ( "" ) ) => doneLemma ( b"\x80" ) </k>

    claim [merkle.3]:
          <k> runLemma ( #rlpEncodeString ( "\x82\x04\xd2" ) ) => doneLemma ( b"\x83\x82\x04\xd2" ) </k>

    // uint pos0;
    //
    // pos0 = 1234;
    claim [merkle.4]:
          <k> runLemma  ( Keccak256( #rlpEncodeMerkleTree( #storageRoot( #hashedLocation( "Solidity", 0, .IntList ) |-> 1234 ) ) ) )
           => doneLemma ( "6ff6cfba457bc662332201b53a8bda503e307197962f2c51e5e2dcc3809e19be" )
          </k>

    // mapping (uint => uint) pos0;
    //
    // pos0[0] = 100;
    // pos0[1] = 200;
    claim [merkle.5]:
          <k> runLemma  ( Keccak256( #rlpEncodeMerkleTree( #storageRoot( #hashedLocation( "Solidity", 0, 0 ) |-> 100 #hashedLocation( "Solidity", 0, 1 ) |-> 200 ) ) ) )
           => doneLemma ( "27093708a19995cf73ddd4b27049a7e33fb49e242bde6c1bffbb6596b67b8b3e" )
          </k>

    // uint                   pos0;
    // mapping (uint => uint) pos1;
    //
    // pos0    = 600;
    // pos1[0] = 200;
    // pos1[5] = 24;
    claim [merkle.6]:
          <k> runLemma  ( Keccak256( #rlpEncodeMerkleTree( #storageRoot( #hashedLocation( "Solidity", 0, .IntList ) |-> 600 #hashedLocation( "Solidity", 1, 0 ) |-> 200 #hashedLocation( "Solidity", 1, 5 ) |-> 24 ) ) ) )
           => doneLemma ( "7df5d7b198240b49434b4e1dbff02fcb0649dd91650ae0fae191b2881cbb009e" )
          </k>

    // mapping (uint => uint) pos0;
    // mapping (uint => uint) pos1;
    //
    // pos0[0] = 123;
    // pos0[1] = 456;
    // pos1[6] = 56;
    // pos1[9] = 333;
    claim [merkle.7]:
          <k> runLemma  ( Keccak256( #rlpEncodeMerkleTree( #storageRoot( #hashedLocation( "Solidity", 0, 0 ) |-> 123 #hashedLocation( "Solidity", 0, 1 ) |-> 456 #hashedLocation( "Solidity", 1, 6 ) |-> 56 #hashedLocation( "Solidity", 1, 9 ) |-> 333 ) ) ) )
           => doneLemma ( "e3d130ca69a8d33ad2058d86ba26ec414f6e5639930041d6a266ee88b25ea835" )
          </k>

    // uint                                     pos0;
    // mapping (uint => uint)                   pos1;
    // uint                                     pos2;
    // mapping (uint => mapping (uint => uint)) pos3;
    //
    // pos0       = 1234;
    // pos1[0]    = 0;
    // pos1[1]    = 1;
    // pos2       = 100;
    // pos3[0][0] = 42;
    // pos3[2][1] = 2019;
    claim [merkle.8]:
          <k> runLemma  ( Keccak256( #rlpEncodeMerkleTree( #storageRoot( #hashedLocation( "Solidity", 0, .IntList ) |-> 1234 #hashedLocation( "Solidity", 1, 0 ) |-> 0 #hashedLocation( "Solidity", 1, 1 ) |-> 1 #hashedLocation( "Solidity", 2, .IntList ) |-> 100 #hashedLocation( "Solidity", 3, 0 0 ) |-> 42 #hashedLocation( "Solidity", 3, 2 1 ) |-> 2019 ) ) ) )
           => doneLemma ( "1a40e309e184fb6483112c37def9ed52e5ee36aa4b570a234a962b3a8f186610" )
          </k>
endmodule
