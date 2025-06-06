requires "verification.k"
requires "vat-arithmetic-spec.k"

module VAT-FORK-DIFF-PASS-ROUGH-SPEC
    imports VERIFICATION
    imports VAT-ARITHMETIC-SPEC

    // Vat_fork-diff
    claim [Vat.fork-diff.pass.rough]:
      <k> #execute ~> CONTINUATION => #halt ~> CONTINUATION </k>
      <mode> NORMAL </mode>
      <schedule> ISTANBUL </schedule>
      <useGas> true </useGas>
      <ethereum>
        <evm>
          <output> .Bytes </output>
          <statusCode> _ => EVMC_SUCCESS </statusCode>
          <callStack> _VCallStack </callStack>
          <interimStates> _ </interimStates>
          <touchedAccounts> _ => ?_ </touchedAccounts>
          <callState>
            <program> Vat_bin_runtime </program>
            <jumpDests> #computeValidJumpDests(Vat_bin_runtime) </jumpDests>
            <id> ACCT_ID </id>
            <caller> CALLER_ID </caller>
            <callData> #abiCallData("fork", #bytes32(ABI_ilk), #address(ABI_src), #address(ABI_dst), #int256(ABI_dink), #int256(ABI_dart)) +Bytes CD => ?_ </callData>
            <callValue> VCallValue </callValue>
            <wordStack> .WordStack => ?_ </wordStack>
            <localMem> .Bytes => ?_ </localMem>
            <pc> 0 => ?_ </pc>
            <gas> #gas(VGas) => ?_ </gas>
            <memoryUsed> 0 => ?_ </memoryUsed>
            <callGas> _ => ?_ </callGas>
            <static> false </static>
            <callDepth> VCallDepth </callDepth>
          </callState>
          <versionedHashes> _ </versionedHashes>
          <substate>
            <selfDestruct> _VSelfDestruct </selfDestruct>
            <log> _ => ?_ </log>
            <refund> _Vrefund => ?_ </refund>
            <accessedAccounts> _ => ?_ </accessedAccounts>
            <accessedStorage> _ => ?_ </accessedStorage>
            <createdAccounts> _ => ?_ </createdAccounts>
          </substate>
          <gasPrice> _ </gasPrice>
          <origin> ORIGIN_ID </origin>
          <blockhashes> _ </blockhashes>
          <block>
            <previousHash> _ </previousHash>
            <ommersHash> _ </ommersHash>
            <coinbase> _ </coinbase>
            <stateRoot> _ </stateRoot>
            <transactionsRoot> _ </transactionsRoot>
            <receiptsRoot> _ </receiptsRoot>
            <logsBloom> _ </logsBloom>
            <difficulty> _ </difficulty>
            <number> _BLOCK_NUMBER </number>
            <gasLimit> _ </gasLimit>
            <gasUsed> _ </gasUsed>
            <timestamp> TIME </timestamp>
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
          <chainID> VChainId </chainID>
          <accounts>
            <account>
              <acctID> ACCT_ID </acctID>
              <balance> ACCT_ID_balance </balance>
              <code> Vat_bin_runtime </code>
              <storage>
                (#Vat.can[ABI_src][CALLER_ID] |-> Can_src)
                (#Vat.can[ABI_dst][CALLER_ID] |-> Can_dst)
                (#Vat.ilks[ABI_ilk].rate |-> Rate)
                (#Vat.ilks[ABI_ilk].spot |-> Spot)
                (#Vat.ilks[ABI_ilk].dust |-> Dust)
                (#Vat.urns[ABI_ilk][ABI_src].ink |-> Ink_u)
                (#Vat.urns[ABI_ilk][ABI_src].art |-> Art_u)
                (#Vat.urns[ABI_ilk][ABI_dst].ink |-> Ink_v)
                (#Vat.urns[ABI_ilk][ABI_dst].art |-> Art_v)
                ACCT_ID_STORAGE =>
                  (#Vat.can[ABI_src][CALLER_ID] |-> Can_src)
                  (#Vat.can[ABI_dst][CALLER_ID] |-> Can_dst)
                  (#Vat.ilks[ABI_ilk].rate |-> Rate)
                  (#Vat.ilks[ABI_ilk].spot |-> Spot)
                  (#Vat.ilks[ABI_ilk].dust |-> Dust)
                  (#Vat.urns[ABI_ilk][ABI_src].ink |-> Ink_u -Int ABI_dink)
                  (#Vat.urns[ABI_ilk][ABI_src].art |-> Art_u -Int ABI_dart)
                  (#Vat.urns[ABI_ilk][ABI_dst].ink |-> Ink_v +Int ABI_dink)
                  (#Vat.urns[ABI_ilk][ABI_dst].art |-> Art_v +Int ABI_dart)
                  ACCT_ID_STORAGE
              </storage>
              <origStorage> ACCT_ID_ORIG_STORAGE </origStorage>
              <nonce> _Nonce_Vat => ?_ </nonce>
              <transientStorage> _ </transientStorage>
            </account>
           ...
          </accounts>
          <txOrder> _ </txOrder>
          <txPending> _ </txPending>
          <messages> _ </messages>
          ...
        </network>
      </ethereum>
      requires #rangeAddress(ACCT_ID)
       andBool ACCT_ID =/=Int 0
       andBool #notPrecompileAddress(ACCT_ID)
       andBool #rangeAddress(CALLER_ID)
       andBool #rangeAddress(ORIGIN_ID)
       andBool #rangeUInt(256, TIME)
       andBool #rangeUInt(256, ACCT_ID_balance)
       andBool VCallDepth <=Int 1024
       andBool #rangeUInt(256, VCallValue)
       andBool #rangeUInt(256, VChainId)

       andBool (#rangeBytes(32, ABI_ilk)
       andBool (#rangeAddress(ABI_src)
       andBool (#rangeAddress(ABI_dst)
       andBool (#rangeSInt(256, ABI_dink)
       andBool (#rangeSInt(256, ABI_dart)
       andBool (#rangeUInt(256, Can_src)
       andBool (#rangeUInt(256, Can_dst)
       andBool (#rangeUInt(256, Rate)
       andBool (#rangeUInt(256, Spot)
       andBool (#rangeUInt(256, Dust)
       andBool (#rangeUInt(256, Ink_u)
       andBool (#rangeUInt(256, Art_u)
       andBool (#rangeUInt(256, Ink_v)
       andBool (#rangeUInt(256, Art_v)
       andBool ((lengthBytes(CD) <=Int 1250000000)
       andBool ((ABI_src =/=Int ABI_dst)
       andBool (((VCallValue ==Int 0))
       andBool ((((ABI_src ==Int CALLER_ID) orBool (Can_src ==Int 1)))
       andBool ((((ABI_dst ==Int CALLER_ID) orBool (Can_dst ==Int 1)))
       andBool ((((Art_u -Int ABI_dart) *Int Rate <=Int (Ink_u -Int ABI_dink) *Int Spot))
       andBool ((((Art_v +Int ABI_dart) *Int Rate <=Int (Ink_v +Int ABI_dink) *Int Spot))
       andBool (((((Art_u -Int ABI_dart) *Int Rate >=Int Dust) orBool (Art_u -Int ABI_dart ==Int 0)))
       andBool (((((Art_v +Int ABI_dart) *Int Rate >=Int Dust) orBool (Art_v +Int ABI_dart ==Int 0)))
       andBool ((#rangeUInt(256, Ink_u -Int ABI_dink))
       andBool ((#rangeUInt(256, Ink_v +Int ABI_dink))
       andBool ((#rangeUInt(256, Art_u -Int ABI_dart))
       andBool ((#rangeUInt(256, Art_v +Int ABI_dart))
       andBool ((#rangeUInt(256, (Ink_u -Int ABI_dink) *Int Spot))
       andBool ((#rangeUInt(256, (Ink_v +Int ABI_dink) *Int Spot)))))))))))))))))))))))))))))))

    [depends(VAT-ARITHMETIC-SPEC.Vat.addui.pass,VAT-ARITHMETIC-SPEC.Vat.subui.pass,VAT-ARITHMETIC-SPEC.Vat.muluu.pass)]

endmodule
