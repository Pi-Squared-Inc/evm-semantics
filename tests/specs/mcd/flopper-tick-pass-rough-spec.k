requires "verification.k"

module FLOPPER-TICK-PASS-ROUGH-SPEC
    imports VERIFICATION

    // Flopper_tick
    rule [Flopper.tick.pass.rough]:
      <k> #execute ~> CONTINUATION => #halt ~> CONTINUATION </k>
      <exit-code> 1 </exit-code>
      <mode> NORMAL </mode>
      <schedule> ISTANBUL </schedule>
      <ethereum>
        <evm>
          <output> .ByteArray </output>
          <statusCode> _ => EVMC_SUCCESS </statusCode>
          <endPC> _ => ?_ </endPC>
          <callStack> _VCallStack </callStack>
          <interimStates> _ </interimStates>
          <touchedAccounts> _ => ?_ </touchedAccounts>
          <callState>
            <program> Flopper_bin_runtime </program>
            <jumpDests> #computeValidJumpDests(Flopper_bin_runtime) </jumpDests>
            <id> ACCT_ID </id>
            <caller> CALLER_ID </caller>
            <callData> #abiCallData("tick", #uint256(ABI_id)) ++ CD => ?_ </callData>
            <callValue> VCallValue </callValue>
            <wordStack> .WordStack => ?_ </wordStack>
            <localMem> .Memory => ?_ </localMem>
            <pc> 0 => ?_ </pc>
            <gas> #gas(VGas) => ?_ </gas>
            <memoryUsed> 0 => ?_ </memoryUsed>
            <callGas> _ => ?_ </callGas>
            <static> false </static>
            <callDepth> VCallDepth </callDepth>
          </callState>
          <substate>
            <selfDestruct> _VSelfDestruct </selfDestruct>
            <log> _ => ?_ </log>
            <refund> _Vrefund => ?_ </refund>
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
            <ommerBlockHeaders> _ </ommerBlockHeaders>
          </block>
        </evm>
        <network>
          <chainID> VChainId </chainID>
          <activeAccounts> SetItem(ACCT_ID)
          SetItem(1)
          SetItem(2)
          SetItem(3)
          SetItem(4)
          SetItem(5)
          SetItem(6)
          SetItem(7)
          SetItem(8)
          SetItem(9) _ </activeAccounts>
          <accounts>
            <account>
              <acctID> ACCT_ID </acctID>
              <balance> ACCT_ID_balance </balance>
              <code> Flopper_bin_runtime </code>
              <storage> ACCT_ID_STORAGE => ACCT_ID_STORAGE [ #Flopper.bids[ABI_id].lot <- (Pad *Int Lot) /Int #Wad ] [ #Flopper.bids[ABI_id].guy_tic_end <- #WordPackAddrUInt48UInt48(Guy, Tic, TIME +Int Tau) ] </storage>
              <origStorage> ACCT_ID_ORIG_STORAGE </origStorage>
              <nonce> _Nonce_Flopper => ?_ </nonce>
            </account>
            <account>
              <acctID> 1 </acctID>
              <balance> ECREC_BAL </balance>
              <code> .ByteArray </code>
              <storage> _:Map </storage>
              <origStorage> _ </origStorage>
              <nonce> _ </nonce>
            </account>
            <account>
              <acctID> 2 </acctID>
              <balance> SHA256_BAL </balance>
              <code> .ByteArray </code>
              <storage> _:Map </storage>
              <origStorage> _ </origStorage>
              <nonce> _ </nonce>
            </account>
            <account>
              <acctID> 3 </acctID>
              <balance> RIP160_BAL </balance>
              <code> .ByteArray </code>
              <storage> _:Map </storage>
              <origStorage> _ </origStorage>
              <nonce> _ </nonce>
            </account>
            <account>
              <acctID> 4 </acctID>
              <balance> ID_BAL </balance>
              <code> .ByteArray </code>
              <storage> _:Map </storage>
              <origStorage> _ </origStorage>
              <nonce> _ </nonce>
            </account>
            <account>
              <acctID> 5 </acctID>
              <balance> MODEXP_BAL </balance>
              <code> .ByteArray </code>
              <storage> _:Map </storage>
              <origStorage> _ </origStorage>
              <nonce> _ </nonce>
            </account>
            <account>
              <acctID> 6 </acctID>
              <balance> ECADD_BAL </balance>
              <code> .ByteArray </code>
              <storage> _:Map </storage>
              <origStorage> _ </origStorage>
              <nonce> _ </nonce>
            </account>
            <account>
              <acctID> 7 </acctID>
              <balance> ECMUL_BAL </balance>
              <code> .ByteArray </code>
              <storage> _:Map </storage>
              <origStorage> _ </origStorage>
              <nonce> _ </nonce>
            </account>
            <account>
              <acctID> 8 </acctID>
              <balance> ECPAIRING_BAL </balance>
              <code> .ByteArray </code>
              <storage> _:Map </storage>
              <origStorage> _ </origStorage>
              <nonce> _ </nonce>
            </account>
            <account>
              <acctID> 9 </acctID>
              <balance> BLAKE2_BAL </balance>
              <code> .ByteArray </code>
              <storage> _:Map </storage>
              <origStorage> _ </origStorage>
              <nonce> _ </nonce>
            </account>
           ...
          </accounts>
          <txOrder> _ </txOrder>
          <txPending> _ </txPending>
          <messages> _ </messages>
        </network>
      </ethereum>
    requires #rangeAddress(ACCT_ID)
     andBool ACCT_ID =/=Int 0
     andBool #notPrecompileAddress(ACCT_ID)
     andBool #rangeAddress(CALLER_ID)
     andBool #rangeAddress(ORIGIN_ID)
     andBool #rangeUInt(256, TIME)
     andBool #rangeUInt(256, ACCT_ID_balance)
     andBool #rangeUInt(256, ECREC_BAL)
     andBool #rangeUInt(256, SHA256_BAL)
     andBool #rangeUInt(256, RIP160_BAL)
     andBool #rangeUInt(256, ID_BAL)
     andBool #rangeUInt(256, MODEXP_BAL)
     andBool #rangeUInt(256, ECADD_BAL)
     andBool #rangeUInt(256, ECMUL_BAL)
     andBool #rangeUInt(256, ECPAIRING_BAL)
     andBool #rangeUInt(256, BLAKE2_BAL)
     andBool VCallDepth <=Int 1024
     andBool #rangeUInt(256, VCallValue)
     andBool #rangeUInt(256, VChainId)

     andBool (#rangeUInt(256, ABI_id)
     andBool (#rangeUInt(256, Pad)
     andBool (#rangeUInt(48, Ttl)
     andBool (#rangeUInt(48, Tau)
     andBool (#rangeUInt(256, Lot)
     andBool (#rangeAddress(Guy)
     andBool (#rangeUInt(48, Tic)
     andBool (#rangeUInt(48, End)
     andBool ((#sizeByteArray(CD) <=Int 1250000000)
     andBool ((#notPrecompileAddress(Guy))
     andBool ((#rangeUInt(48, TIME))
     andBool (#rangeUInt(256, Junk_0)
     andBool (#rangeUInt(256, Junk_1)
     andBool (#rangeUInt(256, Junk_2)
     andBool (#rangeUInt(256, Junk_3)
     andBool (((VCallValue ==Int 0))
     andBool (((Tic ==Int 0))
     andBool (((End <Int TIME))
     andBool (((Pad *Int Lot <=Int maxUInt256))
     andBool ((#rangeUInt(48, TIME +Int Tau))))))))))))))))))))))

     andBool #lookup(ACCT_ID_STORAGE, #Flopper.pad) ==Int Pad
     andBool #lookup(ACCT_ID_STORAGE, #Flopper.ttl_tau) ==Int #WordPackUInt48UInt48(Ttl, Tau)
     andBool #lookup(ACCT_ID_STORAGE, #Flopper.bids[ABI_id].lot) ==Int Lot
     andBool #lookup(ACCT_ID_STORAGE, #Flopper.bids[ABI_id].guy_tic_end) ==Int #WordPackAddrUInt48UInt48(Guy, Tic, End)
     andBool #lookup(ACCT_ID_ORIG_STORAGE, #Flopper.pad) ==Int Junk_0
     andBool #lookup(ACCT_ID_ORIG_STORAGE, #Flopper.ttl_tau) ==Int Junk_1
     andBool #lookup(ACCT_ID_ORIG_STORAGE, #Flopper.bids[ABI_id].lot) ==Int Junk_2
     andBool #lookup(ACCT_ID_ORIG_STORAGE, #Flopper.bids[ABI_id].guy_tic_end) ==Int Junk_3
     andBool #Flopper.pad =/=Int #Flopper.ttl_tau
     andBool #Flopper.pad =/=Int #Flopper.bids[ABI_id].lot
     andBool #Flopper.pad =/=Int #Flopper.bids[ABI_id].guy_tic_end
     andBool #Flopper.ttl_tau =/=Int #Flopper.bids[ABI_id].lot
     andBool #Flopper.ttl_tau =/=Int #Flopper.bids[ABI_id].guy_tic_end
     andBool #Flopper.bids[ABI_id].lot =/=Int #Flopper.bids[ABI_id].guy_tic_end

    // Flopper_addu48u48
    rule [Flopper.addu48u48.pass]:
      <k> #execute ~> CONTINUATION => #execute ~> CONTINUATION </k>
      <exit-code> 1 </exit-code>
      <mode> NORMAL </mode>
      <schedule> ISTANBUL </schedule>
      <ethereum>
        <evm>
          <output> VOutput => VOutput </output>
          <statusCode> _ => ?_ </statusCode>
          <endPC> _ => ?_ </endPC>
          <callStack> _VCallStack </callStack>
          <interimStates> _ </interimStates>
          <touchedAccounts> _ => ?_ </touchedAccounts>
          <callState>
            <program> Flopper_bin_runtime </program>
            <jumpDests> #computeValidJumpDests(Flopper_bin_runtime) </jumpDests>
            <id> ACCT_ID </id>
            <caller> CALLER_ID </caller>
            <callData> _ => ?_ </callData>
            <callValue> VCallValue </callValue>
            <wordStack> ABI_y : ABI_x : JMPTO : WS  =>  JMPTO : ABI_x +Int ABI_y : WS </wordStack>
            <localMem> _ </localMem>
            <pc> 8757 => 8798 </pc>
            <gas> #gas(VGas) => #gas ( ( VGas +Int 66 ) ) </gas>
            <memoryUsed> VMemoryUsed </memoryUsed>
            <callGas> _ => ?_ </callGas>
            <static> _ </static>
            <callDepth> VCallDepth </callDepth>
          </callState>
          <substate>
            <selfDestruct> _VSelfDestruct </selfDestruct>
            <log> _ => ?_ </log>
            <refund> _Vrefund => ?_ </refund>
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
            <ommerBlockHeaders> _ </ommerBlockHeaders>
          </block>
        </evm>
        <network>
          <chainID> VChainId </chainID>
          <activeAccounts> SetItem(ACCT_ID)
          SetItem(1)
          SetItem(2)
          SetItem(3)
          SetItem(4)
          SetItem(5)
          SetItem(6)
          SetItem(7)
          SetItem(8)
          SetItem(9) _ </activeAccounts>
          <accounts>
            <account>
              <acctID> ACCT_ID </acctID>
              <balance> ACCT_ID_balance </balance>
              <code> Flopper_bin_runtime </code>
              <storage> ACCT_ID_STORAGE => ACCT_ID_STORAGE  </storage>
              <origStorage> ACCT_ID_ORIG_STORAGE </origStorage>
              <nonce> _Nonce_Flopper => ?_ </nonce>
            </account>
            <account>
              <acctID> 1 </acctID>
              <balance> ECREC_BAL </balance>
              <code> .ByteArray </code>
              <storage> _:Map </storage>
              <origStorage> _ </origStorage>
              <nonce> _ </nonce>
            </account>
            <account>
              <acctID> 2 </acctID>
              <balance> SHA256_BAL </balance>
              <code> .ByteArray </code>
              <storage> _:Map </storage>
              <origStorage> _ </origStorage>
              <nonce> _ </nonce>
            </account>
            <account>
              <acctID> 3 </acctID>
              <balance> RIP160_BAL </balance>
              <code> .ByteArray </code>
              <storage> _:Map </storage>
              <origStorage> _ </origStorage>
              <nonce> _ </nonce>
            </account>
            <account>
              <acctID> 4 </acctID>
              <balance> ID_BAL </balance>
              <code> .ByteArray </code>
              <storage> _:Map </storage>
              <origStorage> _ </origStorage>
              <nonce> _ </nonce>
            </account>
            <account>
              <acctID> 5 </acctID>
              <balance> MODEXP_BAL </balance>
              <code> .ByteArray </code>
              <storage> _:Map </storage>
              <origStorage> _ </origStorage>
              <nonce> _ </nonce>
            </account>
            <account>
              <acctID> 6 </acctID>
              <balance> ECADD_BAL </balance>
              <code> .ByteArray </code>
              <storage> _:Map </storage>
              <origStorage> _ </origStorage>
              <nonce> _ </nonce>
            </account>
            <account>
              <acctID> 7 </acctID>
              <balance> ECMUL_BAL </balance>
              <code> .ByteArray </code>
              <storage> _:Map </storage>
              <origStorage> _ </origStorage>
              <nonce> _ </nonce>
            </account>
            <account>
              <acctID> 8 </acctID>
              <balance> ECPAIRING_BAL </balance>
              <code> .ByteArray </code>
              <storage> _:Map </storage>
              <origStorage> _ </origStorage>
              <nonce> _ </nonce>
            </account>
            <account>
              <acctID> 9 </acctID>
              <balance> BLAKE2_BAL </balance>
              <code> .ByteArray </code>
              <storage> _:Map </storage>
              <origStorage> _ </origStorage>
              <nonce> _ </nonce>
            </account>
           ...
          </accounts>
          <txOrder> _ </txOrder>
          <txPending> _ </txPending>
          <messages> _ </messages>
        </network>
      </ethereum>
    requires #rangeAddress(ACCT_ID)
     andBool ACCT_ID =/=Int 0
     andBool #notPrecompileAddress(ACCT_ID)
     andBool #rangeAddress(CALLER_ID)
     andBool #rangeAddress(ORIGIN_ID)
     andBool #rangeUInt(256, TIME)
     andBool #rangeUInt(256, ACCT_ID_balance)
     andBool #rangeUInt(256, ECREC_BAL)
     andBool #rangeUInt(256, SHA256_BAL)
     andBool #rangeUInt(256, RIP160_BAL)
     andBool #rangeUInt(256, ID_BAL)
     andBool #rangeUInt(256, MODEXP_BAL)
     andBool #rangeUInt(256, ECADD_BAL)
     andBool #rangeUInt(256, ECMUL_BAL)
     andBool #rangeUInt(256, ECPAIRING_BAL)
     andBool #rangeUInt(256, BLAKE2_BAL)
     andBool VCallDepth <=Int 1024
     andBool #rangeUInt(256, VCallValue)
     andBool #rangeUInt(256, VChainId)

     andBool (#rangeUInt(48, ABI_x)
     andBool (#rangeUInt(48, ABI_y)
     andBool ((#sizeWordStack(WS) <=Int 100)
     andBool (#rangeUInt(256, VMemoryUsed)
     andBool ((#rangeUInt(48, ABI_x +Int ABI_y)))))))
    [trusted]


endmodule