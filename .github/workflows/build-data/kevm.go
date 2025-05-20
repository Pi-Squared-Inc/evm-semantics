package vm

import (
	// #cgo CPPFLAGS: -I../../../vlm/kllvm
	// #cgo LDFLAGS: -lulmkllvm -L../../../vlm/kllvm -lkevm -L../../../evm-semantics/libkevm
	// #include <ulm_kllvm_c.h>
	// #include <dlfcn.h>
	"C"
	"errors"
	"sync"
	"unsafe"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/tracing"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/params"
	"github.com/holiman/uint256"
)

type KEVM struct {
	Context BlockContext
	TxContext
	StateDB StateDB

	chainRules params.Rules
	counter int
}

var (
	mutex sync.RWMutex
	dbs = map[int]StateDB{}
	hash = map[int]GetHashFunc{}
	snapshots = map[int][]int{}
	counter = 0
)

func ULMLoadLanguage(path string) {
	C.dlopen(C.CString(path), C.RTLD_LAZY)
}

func NewKEVM(blockCtx BlockContext, txCtx TxContext, statedb StateDB, chainConfig *params.ChainConfig, chainRules params.Rules) *KEVM {
	kevm := &KEVM{
		Context: blockCtx,
		TxContext: txCtx,
		StateDB: statedb,
		chainRules: chainRules,
		counter: counter,
	}
        chainId, _ := uint256.FromBig(chainConfig.ChainID)
	mutex.Lock()
	dbs[counter] = statedb
	hash[counter] = blockCtx.GetHash
	C.init_network_geth(make_256(chainId), C.int(counter))
	counter = counter + 1
	mutex.Unlock()
	return kevm
}
func (kevm *KEVM) getSchedule() C.schedule_t {
	if (kevm.chainRules.IsPrague) {
		return C.PRAGUE
	} else if (kevm.chainRules.IsCancun) {
		return C.CANCUN
	} else if (kevm.chainRules.IsShanghai) {
		return C.SHANGHAI
	} else if (kevm.chainRules.IsMerge) {
		return C.MERGE
	} else if (kevm.chainRules.IsLondon) {
		return C.LONDON
	} else if (kevm.chainRules.IsBerlin) {
		return C.BERLIN
	} else if (kevm.chainRules.IsIstanbul) {
		return C.ISTANBUL
	} else if (kevm.chainRules.IsPetersburg) {
		return C.PETERSBURG
	} else if (kevm.chainRules.IsConstantinople) {
		return C.CONSTANTINOPLE
	} else if (kevm.chainRules.IsByzantium) {
		return C.BYZANTIUM
	} else if (kevm.chainRules.IsEIP158) {
		return C.SPURIOUS_DRAGON
	} else if (kevm.chainRules.IsEIP150) {
		return C.TANGERINE_WHISTLE
	} else if (kevm.chainRules.IsHomestead) {
		return C.HOMESTEAD
	} else {
		return C.FRONTIER
	}
}
func make_parse_delegation(target common.Address, ok bool) unsafe.Pointer {
	if ok {
		return C.make_parse_delegation(make_160(target), C.bool(true))
	}
	return C.make_parse_delegation(nil, C.bool(false))
}

func make_160(addr common.Address) unsafe.Pointer {
	return C.CBytes(addr.Bytes())
}

func make_256(i *uint256.Int) unsafe.Pointer {
	var bytes = [32]byte{}
	if i != nil {
		bytes = i.Bytes32()
	}
	return C.CBytes(bytes[:])
}

func make_256_hash(i common.Hash) unsafe.Pointer {
	return C.CBytes(i.Bytes())
}

func make_hash(ptr unsafe.Pointer) common.Hash {
	return common.Hash(C.GoBytes(ptr, C.int(32)))
}

func make_address(ptr unsafe.Pointer) common.Address {
	return common.Address(C.GoBytes(ptr, C.int(20)))
}

func make_address_free(ptr unsafe.Pointer) common.Address {
	result := make_address(ptr)
	C.free(ptr)
	return result
}

func make_uint256(ptr unsafe.Pointer) *uint256.Int {
	return new(uint256.Int).SetBytes(C.GoBytes(ptr, C.int(32)))
}

func (kevm *KEVM) getBlock() unsafe.Pointer {
	difficulty, _ := uint256.FromBig(kevm.Context.Difficulty)
	number, _ := uint256.FromBig(kevm.Context.BlockNumber)
	base_fee, _ := uint256.FromBig(kevm.Context.BaseFee)
	blob_base_fee, _ := uint256.FromBig(kevm.Context.BlobBaseFee)
	var random = new(uint256.Int)
	if kevm.Context.Random != nil {
		random.SetBytes(kevm.Context.Random.Bytes())
	}
	return C.make_block(make_160(kevm.Context.Coinbase), make_256(difficulty), make_256(number), C.ulong(kevm.Context.GasLimit), C.long(kevm.Context.Time), make_256(random), make_256(base_fee), make_256(blob_base_fee))
}

func (kevm *KEVM) getMessage(caller common.Address, addr common.Address, isCreate bool, gas uint64, value *uint256.Int, data []byte, code []byte, blob_hashes []common.Hash) unsafe.Pointer {
	gas_price, _ := uint256.FromBig(kevm.TxContext.GasPrice)
	var array_of_hex_hashes [](unsafe.Pointer)
	if len(blob_hashes) > 0 {
		array_of_hex_hashes = make([](unsafe.Pointer), len(blob_hashes))
		for i, hash := range blob_hashes {
			array_of_hex_hashes[i] = make_256_hash(hash)
		}

		return C.make_message(make_160(caller), make_160(caller), make_160(addr), make_160(addr), C.bool(isCreate), C.ulong(gas), make_256(value), C.CBytes(data), C.ulong(len(data)), C.CBytes(code), C.ulong(len(code)), 0, false, true, make_256(gas_price), (*unsafe.Pointer)(&array_of_hex_hashes[0]), C.ulong(len(blob_hashes)))
	}
	array_of_hex_hashes = make([](unsafe.Pointer), 0)
	return C.make_message(make_160(caller), make_160(caller), make_160(addr), make_160(addr), C.bool(isCreate), C.ulong(gas), make_256(value), C.CBytes(data), C.ulong(len(data)), C.CBytes(code), C.ulong(len(code)), 0, false, true, make_256(gas_price), (*unsafe.Pointer)(nil), C.ulong(0))
}

func (kevm *KEVM) getSubstate() unsafe.Pointer {
  return C.make_substate()
}

func (kevm *KEVM) executeCallFrame(schedule C.schedule_t, block unsafe.Pointer, message unsafe.Pointer, substate unsafe.Pointer) (result unsafe.Pointer, gas uint64) {
	result = C.make_result()
	var gas_ptr = C.make_gas()
	C.execute_call_frame_c(schedule, block, message, substate, result, gas_ptr)
	gas = uint64(C.get_gas(gas_ptr))
	C.free(gas_ptr)
	return result, gas
}

func (kevm *KEVM) applySubstate(substate unsafe.Pointer) {
	for i := 0; i < int(C.get_self_destruct_len(substate)); i++ {
		kevm.StateDB.SelfDestruct(make_address_free(C.get_self_destruct(substate, C.ulong(i))))
	}
	for i := 0; i < int(C.get_log_len(substate)); i++ {
		addr := make_address_free(C.get_log_account(substate, C.ulong(i)))
		topics := make([]common.Hash, int(C.get_log_topic_len(substate, C.ulong(i))))
		for j := 0; j < int(C.get_log_topic_len(substate, C.ulong(i))); j++ {
			topics[j] = make_hash(C.get_log_topic(substate, C.ulong(i), C.ulong(j)))
		}
		data := C.GoBytes(C.get_log_data(substate, C.ulong(i)), C.get_log_data_len(substate, C.ulong(i)))
		log := &types.Log{
			Address: addr,
			Topics: topics,
			Data: data,
			BlockNumber: kevm.Context.BlockNumber.Uint64(),
		}
		kevm.StateDB.AddLog(log)
	}
	var refund = uint64(C.get_refund(substate))
	if refund != 0 {
	  kevm.StateDB.AddRefund(refund)
        }
}

func (kevm *KEVM) getOutput(result unsafe.Pointer) []byte {
  return C.GoBytes(C.get_result_data(result), C.get_result_data_len(result))
}

func (kevm *KEVM) getError(result unsafe.Pointer) error {
  var enum_val = C.get_result_error(result)
  switch enum_val {
  case C.EVMC_SUCCESS:
	  return nil;
  case C.EVMC_OUT_OF_GAS:
	  return ErrOutOfGas
  case C.EVMC_CALL_DEPTH_EXCEEDED:
	  return ErrDepth
  case C.EVMC_BALANCE_UNDERFLOW:
	  return ErrInsufficientBalance
  case C.EVMC_ACCOUNT_ALREADY_EXISTS:
	  return ErrContractAddressCollision
  case C.EVMC_REVERT:
	  return ErrExecutionReverted
  case C.EVMC_INVALID_CODE:
	  return ErrInvalidCode
  case C.EVMC_BAD_JUMP_DESTINATION:
	  return ErrInvalidJump
  case C.EVMC_STATIC_MODE_VIOLATION:
	  return ErrWriteProtection
  case C.EVMC_INVALID_MEMORY_ACCESS:
	  return ErrReturnDataOutOfBounds
  case C.EVMC_NONCE_EXCEEDED:
	  return ErrNonceUintOverflow
  default:
	  return errors.New("unexpected status code")
  }
}

func (kevm *KEVM) cleanup(block unsafe.Pointer, message unsafe.Pointer, substate unsafe.Pointer, result unsafe.Pointer) {
	C.cleanup_transaction(block, message, substate, result)
	mutex.Lock()
	delete(dbs, kevm.counter)
	delete(hash, kevm.counter)
	delete(snapshots, kevm.counter)
	mutex.Unlock()
}
//export GethIsNewContract
func GethIsNewContract(statedb C.int, ptr unsafe.Pointer) C.bool {
	address := make_address(ptr)
	return C.bool(dbs[int(statedb)].IsNewContract(address))
}

//export GethExist
func GethExist(statedb C.int, ptr unsafe.Pointer) C.bool {
	address := make_address(ptr)
	return C.bool(dbs[int(statedb)].Exist(address))
}

//export GethAddAccount
func GethAddAccount(statedb C.int, ptr unsafe.Pointer) C.bool {
	address := make_address(ptr)
	// Ensure there's no existing contract already at the designated address.
	// Account is regarded as existent if any of these three conditions is met:
	// - the nonce is non-zero
	// - the code is non-empty
	// - the storage is non-empty
	contractHash := dbs[int(statedb)].GetCodeHash(address)
	storageRoot := dbs[int(statedb)].GetStorageRoot(address)
	if dbs[int(statedb)].GetNonce(address) != 0 ||
		(contractHash != (common.Hash{}) && contractHash != types.EmptyCodeHash) || // non-empty code
		(storageRoot != (common.Hash{}) && storageRoot != types.EmptyRootHash) { // non-empty storage
		return false
	}
	if !dbs[int(statedb)].Exist(address) {
		dbs[int(statedb)].CreateAccount(address)
	}
	dbs[int(statedb)].CreateContract(address)
	return true
}

//export GethGetAccountBalance
func GethGetAccountBalance(statedb C.int, ptr unsafe.Pointer) unsafe.Pointer {
	addr := make_address(ptr)
	return make_256(dbs[int(statedb)].GetBalance(addr))
}

//export GethAddAccountBalance
func GethAddAccountBalance(statedb C.int, acct_ptr unsafe.Pointer, balance_ptr unsafe.Pointer) {
	addr := make_address(acct_ptr)
	balance := make_uint256(balance_ptr)
	dbs[int(statedb)].AddBalance(addr, balance, tracing.BalanceChangeUnspecified)
}

//export GethSubAccountBalance
func GethSubAccountBalance(statedb C.int, acct_ptr unsafe.Pointer, balance_ptr unsafe.Pointer) {
	addr := make_address(acct_ptr)
	balance := make_uint256(balance_ptr)
	dbs[int(statedb)].SubBalance(addr, balance, tracing.BalanceChangeUnspecified)
}

//export GethGetCodeHash
func GethGetCodeHash(statedb C.int, ptr unsafe.Pointer) unsafe.Pointer {
	addr := make_address(ptr)
	return make_256_hash(dbs[int(statedb)].GetCodeHash(addr))
}

//export GethParseDelegation
func GethParseDelegation(statedb C.int, ptr unsafe.Pointer) unsafe.Pointer {
	addr := make_address(ptr)
	code := dbs[int(statedb)].GetCode(addr)
	if target, ok := types.ParseDelegation(code); ok {
		return make_parse_delegation(target, true)
	}
	return make_parse_delegation(common.Address{}, false)
}

//export GethGetAccountCode
func GethGetAccountCode(statedb C.int, ptr unsafe.Pointer) unsafe.Pointer {
	addr := make_address(ptr)
	code := dbs[int(statedb)].GetCode(addr)
	if witness := dbs[int(statedb)].Witness(); witness != nil {
		witness.AddCode(code)
	}

	return C.CBytes(code)
}

//export GethGetAccountCodeLength
func GethGetAccountCodeLength(statedb C.int, ptr unsafe.Pointer) C.int {
	addr := make_address(ptr)
	return C.int(len(dbs[int(statedb)].GetCode(addr)))
}

//export GethSetAccountCode
func GethSetAccountCode(statedb C.int, acct_ptr unsafe.Pointer, code_ptr unsafe.Pointer, length C.int) {
	addr := make_address(acct_ptr)
	code := C.GoBytes(code_ptr, length)
	dbs[int(statedb)].SetCode(addr, code)
}

//export GethGetAccountNonce
func GethGetAccountNonce(statedb C.int, ptr unsafe.Pointer) C.ulong {
	addr := make_address(ptr)
	return C.ulong(dbs[int(statedb)].GetNonce(addr))
}

//export GethSetAccountNonce
func GethSetAccountNonce(statedb C.int, acct_ptr unsafe.Pointer, nonce C.ulong) {
	addr := make_address(acct_ptr)
	var dummy_tracing tracing.NonceChangeReason
	dbs[int(statedb)].SetNonce(addr, uint64(nonce), dummy_tracing)
}

//export GethGetAccountStorage
func GethGetAccountStorage(statedb C.int, acct_ptr unsafe.Pointer, key_ptr unsafe.Pointer) unsafe.Pointer {
	addr := make_address(acct_ptr)
	key := make_hash(key_ptr)
	return make_256_hash(dbs[int(statedb)].GetState(addr, key))
}

//export GethSetAccountStorage
func GethSetAccountStorage(statedb C.int, acct_ptr unsafe.Pointer, key_ptr unsafe.Pointer, val_ptr unsafe.Pointer) {
	addr := make_address(acct_ptr)
	key := make_hash(key_ptr)
	val := make_hash(val_ptr)
	dbs[int(statedb)].SetState(addr, key, val)
}

//export GethGetAccountOrigStorage
func GethGetAccountOrigStorage(statedb C.int, acct_ptr unsafe.Pointer, key_ptr unsafe.Pointer) unsafe.Pointer {
	addr := make_address(acct_ptr)
	key := make_hash(key_ptr)
	return make_256_hash(dbs[int(statedb)].GetCommittedState(addr, key))
}

//export GethGetBlockhash
func GethGetBlockhash(statedb C.int, offset C.int) unsafe.Pointer {
	var hash = hash[int(statedb)](uint64(offset))
	if hash != (common.Hash{}) {
		if witness := dbs[int(statedb)].Witness(); witness != nil {
			witness.AddBlockHash(uint64(offset))
		}
	}
	return make_256_hash(hash)
}

//export GethAccessAccount
func GethAccessAccount(statedb C.int, acct_ptr unsafe.Pointer) {
	addr := make_address(acct_ptr)
	dbs[int(statedb)].AddAddressToAccessList(addr)
}

//export GethAccessedAccount
func GethAccessedAccount(statedb C.int, acct_ptr unsafe.Pointer) C.bool {
	addr := make_address(acct_ptr)
	return C.bool(dbs[int(statedb)].AddressInAccessList(addr))
}

//export GethAccessStorage
func GethAccessStorage(statedb C.int, acct_ptr unsafe.Pointer, key_ptr unsafe.Pointer) {
	addr := make_address(acct_ptr)
	key := make_hash(key_ptr)
	dbs[int(statedb)].AddSlotToAccessList(addr, key)
}

//export GethAccessedStorage
func GethAccessedStorage(statedb C.int, acct_ptr unsafe.Pointer, key_ptr unsafe.Pointer) C.bool {
	addr := make_address(acct_ptr)
	key := make_hash(key_ptr)
	_, accessed := dbs[int(statedb)].SlotInAccessList(addr, key)
	return C.bool(accessed)
}

//export GethPushState
func GethPushState(statedb C.int) {
	snapshots[int(statedb)] = append(snapshots[int(statedb)], dbs[int(statedb)].Snapshot())
}

//export GethCommit
func GethCommit(statedb C.int) {
	snapshots[int(statedb)] = snapshots[int(statedb)][:len(snapshots[int(statedb)]) - 1]
}

//export GethRollback
func GethRollback(statedb C.int) {
	dbs[int(statedb)].RevertToSnapshot(snapshots[int(statedb)][len(snapshots[int(statedb)]) - 1])
	GethCommit(statedb)
}
