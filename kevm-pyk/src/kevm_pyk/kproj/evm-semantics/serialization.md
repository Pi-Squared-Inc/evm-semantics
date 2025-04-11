Parsing/Unparsing
=================

```k
requires "plugin/krypto.md"
requires "evm-types.md"
requires "json-rpc.md"
```

```k
module SERIALIZATION
    imports KRYPTO
    imports EVM-TYPES
    imports STRING-BUFFER
    imports JSON-EXT
```

Address/Hash Helpers
--------------------

-   `keccak` serves as a wrapper around the `Keccak256` in `KRYPTO`.

```k
    syntax Int ::= keccak ( Bytes ) [symbol(keccak), function, total, smtlib(smt_keccak)]
 // -------------------------------------------------------------------------------------
    rule [keccak]: keccak(WS) => #parseHexWord(Keccak256(WS)) [concrete]
```


- `#sender` computes the sender of the transaction from its data and signature.
- `sender.pre.EIP155`, `sender.EIP155.signed` and `sender.EIP155.unsigned` need to adapt the `TW` value before passing it to the `ECDSARecover`.
- `sender` is used by the `ecrec` precompile and does not need to adapt the parameters.

```k
    syntax Account ::= #sender ( TxData , Int , Bytes , Bytes , Int ) [function, symbol(senderTxData)      ]
                     | #sender ( Bytes  , Int , Bytes , Bytes )       [function, symbol(senderBytes), total]
                     | #sender ( Bytes )                              [function, symbol(senderReturn)      ]
 // --------------------------------------------------------------------------------------------------------
    rule [sender.pre.EIP155]:      #sender(_:TxData, TW             => TW +Int 27           , _, _, _) requires TW ==Int 0                orBool TW ==Int 1
    rule [sender.EIP155.signed]:   #sender(_:TxData, TW             => (TW -Int 35) modInt 2, _, _, B) requires TW ==Int 2 *Int B +Int 35 orBool TW ==Int 2 *Int B +Int 36
    rule [sender.EIP155.unsigned]: #sender(T:TxData, TW, TR, TS, _) => #sender(#hashTxData(T), TW, TR, TS) [owise]

    rule [sender]: #sender(HT, TW, TR, TS) => #sender(ECDSARecover(HT, TW, TR, TS))

    rule #sender(b"")   => .Account
    rule #sender(BYTES) => #addr(#parseHexWord(Keccak256(BYTES))) requires BYTES =/=K b""
```


- `#hashTxData` returns the Keccak-256 message hash `HT` to be signed.
The encoding schemes are applied in `#rlpEcondeTxData`.

```k
    syntax Bytes ::= #hashTxData ( TxData ) [symbol(hashTxData), function]
``` 

The EVM test-sets are represented in JSON format with hex-encoding of the data and programs.
Here we provide some standard parser/unparser functions for that format.

Parsing
-------

These parsers can interpret hex-encoded strings as `Int`s, `Bytes`s, and `Map`s.

-   `#parseHexWord` interprets a string as a single hex-encoded `Word`.
-   `#parseHexBytes` interprets a string as a hex-encoded stack of bytes.
-   `#alignHexString` makes sure that the length of a (hex)string is even.
-   `#parseByteStack` interprets a string as a hex-encoded stack of bytes, but makes sure to remove the leading "0x".
-   `#parseMap` interprets a JSON key/value object as a map from `Word` to `Word`.
-   `#parseAddr` interprets a string as a 160 bit hex-endcoded address.

```k
    syntax Int ::= #parseWord    ( String ) [symbol(#parseWord), function]
                 | #parseHexWord ( String ) [symbol(#parseHexWord), function]
 // -------------------------------------------------------------------------
    rule #parseHexWord("")   => 0
    rule #parseHexWord("0x") => 0
    rule #parseHexWord(S)    => String2Base(replaceAll(S, "0x", ""), 16) requires (S =/=String "") andBool (S =/=String "0x")

    rule #parseWord("") => 0
    rule #parseWord(S)  => #parseHexWord(S) requires lengthString(S) >=Int 2 andBool substrString(S, 0, 2) ==String "0x"
    rule #parseWord(S)  => String2Int(S) [owise]

    syntax String ::= #alignHexString ( String ) [symbol(#alignHexString), function, total]
 // ---------------------------------------------------------------------------------------
    rule #alignHexString(S) => S             requires         lengthString(S) modInt 2 ==Int 0
    rule #alignHexString(S) => "0" +String S requires notBool lengthString(S) modInt 2 ==Int 0

    syntax Bytes ::= #parseHexBytes     ( String ) [symbol(parseHexBytes), function]
                   | #parseHexBytesAux  ( String ) [symbol(parseHexBytesAux), function]
                   | #parseByteStack    ( String ) [symbol(parseByteStack), function, memo]
 // ---------------------------------------------------------------------------------------
    rule #parseByteStack(S) => #parseHexBytes(replaceAll(S, "0x", ""))
    rule #parseHexBytes(S)  => #parseHexBytesAux(#alignHexString(S))

    rule #parseHexBytesAux("") => .Bytes
    rule #parseHexBytesAux(S)  => Int2Bytes(lengthString(S) /Int 2, String2Base(S, 16), BE) requires lengthString(S) >=Int 2
 // ---------------------------------------------------------------------------------------
    syntax Map ::= #parseMap ( JSON ) [symbol(#parseMap), function]
 // ---------------------------------------------------------------
    syntax Int ::= #parseAddr ( String ) [symbol(#parseAddr), function]

endmodule
```
