requires "verification.k"

module ECRECOVER00-SIGVALID-SPEC
  imports VERIFICATION

  // fn-execute-sigvalid
  claim
    <k> (#execute => #halt) ~> _ </k>
    <mode> NORMAL </mode>
    <schedule> ISTANBUL </schedule>
    <useGas> true </useGas>
    <ethereum>
      <evm>
        <output> _ => #buf(32, RECOVERED) </output>
        <statusCode> _ => EVMC_SUCCESS </statusCode>
        <callStack> _ </callStack>
        <interimStates> _ </interimStates>
        <touchedAccounts> _ => ?_ </touchedAccounts>
        <callState>
          <program> #parseByteStack("0x608060405260043610610041576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff1680634480949514610046575b600080fd5b34801561005257600080fd5b506100a06004803603608081101561006957600080fd5b8101908080359060200190929190803560ff16906020019092919080359060200190929190803590602001909291905050506100e2565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b60008060018686868660405160008152602001604052604051808581526020018460ff1660ff1681526020018381526020018281526020019450505050506020604051602081039080840390855afa158015610142573d6000803e3d6000fd5b505050602060405103519050600073ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff1611151561018957600080fd5b8091505094935050505056fea165627a7a72305820ec9368f63b82a680b2493003123eec414f661d1259fdf9d0082a8815d68a9a7e0029") </program>
          <jumpDests> #computeValidJumpDests(#parseByteStack("0x608060405260043610610041576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff1680634480949514610046575b600080fd5b34801561005257600080fd5b506100a06004803603608081101561006957600080fd5b8101908080359060200190929190803560ff16906020019092919080359060200190929190803590602001909291905050506100e2565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b60008060018686868660405160008152602001604052604051808581526020018460ff1660ff1681526020018381526020018281526020019450505050506020604051602081039080840390855afa158015610142573d6000803e3d6000fd5b505050602060405103519050600073ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff1611151561018957600080fd5b8091505094935050505056fea165627a7a72305820ec9368f63b82a680b2493003123eec414f661d1259fdf9d0082a8815d68a9a7e0029")) </jumpDests>
          <id> CONTRACT_ID </id> // this
          <caller> MSG_SENDER </caller> // msg.sender
          <callData> #abiCallData("execute", #bytes32(HASH), #uint8(SIGV), #bytes32(SIGR), #bytes32(SIGS)) </callData> // msg.data
          <callValue> 0 </callValue> // msg.value
          <wordStack> .WordStack => ?_ </wordStack>
          <localMem> .Bytes => ?_ </localMem>
          <pc> 0 => ?_ </pc>
          <gas> #gas(_VGAS) => ?_ </gas>
          <memoryUsed> 0 => ?_ </memoryUsed>
          <callGas> _ => ?_ </callGas>
          <static> false </static> // NOTE: non-static call
          <callDepth> CD </callDepth>
        </callState>
        <versionedHashes> _ </versionedHashes>
        <substate>
          <selfDestruct> _ </selfDestruct>
          <log> _ </log>
          <refund> _ </refund>
          <accessedAccounts> _ => ?_ </accessedAccounts>
          <accessedStorage> _ => ?_ </accessedStorage>
          <createdAccounts> _ => ?_ </createdAccounts>
        </substate>
        <gasPrice> _ </gasPrice>
        <origin> _ </origin> // tx.origin
        <blockhashes> _BLOCK_HASHES </blockhashes> // block.blockhash
        <block>
          <previousHash> _ </previousHash>
          <ommersHash> _ </ommersHash>
          <coinbase> _ </coinbase> // block.coinbase
          <stateRoot> _ </stateRoot>
          <transactionsRoot> _ </transactionsRoot>
          <receiptsRoot> _ </receiptsRoot>
          <logsBloom> _ </logsBloom>
          <difficulty> _ </difficulty>
          <number> BLOCK_NUM </number> // block.number
          <gasLimit> _ </gasLimit>
          <gasUsed> _ </gasUsed>
          <timestamp> NOW </timestamp> // now = block.timestamp
          <extraData> _ </extraData>
          <mixHash> _ </mixHash>
          <blockNonce> _ </blockNonce>
          <baseFee> _ </baseFee>
          <ommerBlockHeaders> _ </ommerBlockHeaders>
          <withdrawalsRoot> _ </withdrawalsRoot>
          <blobGasUsed> _ </blobGasUsed>
          <excessBlobGas> _ </excessBlobGas>
          <beaconRoot> _ </beaconRoot>
        </block>
      </evm>
      <network>
        <chainID> _ </chainID>

        <accounts>
          <account>
            <acctID> CONTRACT_ID </acctID>
            <balance> CONTRACT_BAL </balance>
            <code> #parseByteStack("0x608060405260043610610041576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff1680634480949514610046575b600080fd5b34801561005257600080fd5b506100a06004803603608081101561006957600080fd5b8101908080359060200190929190803560ff16906020019092919080359060200190929190803590602001909291905050506100e2565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b60008060018686868660405160008152602001604052604051808581526020018460ff1660ff1681526020018381526020018281526020019450505050506020604051602081039080840390855afa158015610142573d6000803e3d6000fd5b505050602060405103519050600073ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff1611151561018957600080fd5b8091505094935050505056fea165627a7a72305820ec9368f63b82a680b2493003123eec414f661d1259fdf9d0082a8815d68a9a7e0029") </code>
            <storage>
_
            </storage>
            <origStorage>
_
            </origStorage>
            <nonce> CONTRACT_NONCE </nonce>
            <transientStorage>
                _
            </transientStorage>
          </account>

          <account>
            <acctID> CALLEE_ID </acctID>
            <balance> CALLEE_BAL </balance>
            <code> _ </code>
            <storage>
                _
            </storage>
            <origStorage>
                _
            </origStorage>
            <nonce> CALLEE_NONCE </nonce>
            <transientStorage>
                _
            </transientStorage>
          </account>

          <account>
            // precompiled account for ECCREC
            <acctID> 1 </acctID>
            <balance> 0 </balance>
            <code> .Bytes </code>
            <storage> .Map </storage>
            <origStorage> .Map </origStorage>
            <nonce> 0 </nonce>
           <transientStorage> .Map </transientStorage>
          </account>


          ...
        </accounts>
        <txOrder> _ </txOrder>
        <txPending> _ </txPending>
        <messages> _ </messages>
        ...
      </network>
    </ethereum>
    requires #rangeAddress(CONTRACT_ID)
     andBool #rangeAddress(CALLEE_ID)
     andBool #rangeUInt(256, NOW)
     andBool #rangeUInt(128, BLOCK_NUM) // Solidity

     // Account address normality
     andBool CONTRACT_ID >Int 0 andBool (notBool #isPrecompiledAccount(CONTRACT_ID, BYZANTIUM))
     andBool CALLEE_ID   >Int 0 andBool (notBool #isPrecompiledAccount(CALLEE_ID  , BYZANTIUM))

     andBool #rangeUInt(256, CONTRACT_BAL)
     andBool #rangeUInt(256, CALLEE_BAL)
     andBool #range(0 <= CD < 1024)
     andBool #rangeNonce(CONTRACT_NONCE)
     andBool #rangeNonce(CALLEE_NONCE)
     andBool #rangeAddress(MSG_SENDER)
     andBool #rangeUInt(256, HASH)
     andBool #rangeUInt(8, SIGV)
     andBool #rangeBytes(32, SIGR)
     andBool #rangeBytes(32, SIGS)
     andBool RECOVERED ==Int #asWord(#ecrec(#bufStrict(32, HASH), #bufStrict(32, SIGV), #bufStrict(32, SIGR), #bufStrict(32, SIGS)))
     andBool notBool #ecrecEmpty(#bufStrict(32, HASH), #bufStrict(32, SIGV), #bufStrict(32, SIGR), #bufStrict(32, SIGS))
endmodule

