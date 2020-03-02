//===-- Executor_Memory.cpp -----------------------------------------------===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "klee/Executor.h"

#include "Memory.h"
#include "MemoryManager.h"
#include "TimingSolver.h"
#include "klee/util/ExprPPrinter.h"
#include "klee/Internal/Module/InstructionInfoTable.h"

#include "llvm/Support/CommandLine.h"

#include <glog/logging.h>

#include <sstream>

using namespace llvm;

namespace {

cl::opt<bool>
SimplifySymIndices("simplify-sym-indices",
                   cl::init(false));

cl::opt<unsigned>
MaxSymArraySize("max-sym-array-size",
                cl::init(0));
}


namespace klee {

void Executor::bindLocal(KInstruction *target, ExecutionState &state,
                         ref<Expr> value) {
  getDestCell(state, target).value = value;
}

void Executor::bindArgument(KFunction *kf, unsigned index,
                            ExecutionState &state, ref<Expr> value) {
  getArgumentCell(state, kf, index).value = value;
}


void Executor::bindArgumentToPthreadCreate(KFunction *kf, unsigned index,
             StackFrame &sf, ref<Expr> value) {
  getArgumentCell(sf, kf, index).value = value;
}

ObjectState *Executor::bindObjectInState(ExecutionState &state,
                                         const MemoryObject *mo,
                                         bool isLocal,
                                         const Array *array) {
  ObjectState *os = array ? new ObjectState(mo, array) : new ObjectState(mo);
  state.addressSpace().bindObject(mo, os);

  // Its possible that multiple bindings of the same mo in the state
  // will put multiple copies on this list, but it doesn't really
  // matter because all we use this list for is to unbind the object
  // on function return.
  if (isLocal)
    state.stack().back().allocas.push_back(mo);

  return os;
}

void Executor::resolveExact(ExecutionState &state,
                            ref<Expr> p,
                            ExactResolutionList &results,
                            const std::string &name) {
  // XXX we may want to be capping this?
  ResolutionList rl;
  state.addressSpace().resolve(state, solver, p, rl);

  ExecutionState *unbound = &state;
  for (ResolutionList::iterator it = rl.begin(), ie = rl.end();
       it != ie; ++it) {
    ref<Expr> inBounds = EqExpr::create(p, it->first->getBaseExpr());

    StatePair branches = fork(*unbound, inBounds, true, KLEE_FORK_INTERNAL);

    if (branches.first)
      results.push_back(std::make_pair(*it, branches.first));

    unbound = branches.second;
    if (!unbound) // Fork failure
      break;
  }

  if (unbound) {
    terminateStateOnError(*unbound,
                          "memory error: invalid pointer: " + name,
                          "ptr.err",
                          getAddressInfo(*unbound, p));
  }
}

KFunction* Executor::resolveFunction(ref<Expr> address)
{
  for (std::vector<KFunction*>::iterator fi = kmodule->functions.begin();
   fi != kmodule->functions.end(); fi++) {
    KFunction* f = (*fi);
    ref<Expr> addr = Expr::createPointer((uint64_t) (void*) f->function);
    if(addr == address)
      return f;
  }
  return NULL;
}

void Executor::executeAlloc(ExecutionState &state,
                            ref<Expr> size,
                            bool isLocal,
                            KInstruction *target,
                            bool zeroMemory,
                            const ObjectState *reallocFrom) {

  size = toUnique(state, size);
  if (ConstantExpr *CE = dyn_cast<ConstantExpr>(size)) {
    MemoryObject *mo = memory->allocate(&state, CE->getZExtValue(), isLocal, false,
                                        state.prevPC()->inst);
    if (!mo) {
      bindLocal(target, state,
                ConstantExpr::alloc(0, Context::get().getPointerWidth()));
    } else {
      ObjectState *os = bindObjectInState(state, mo, isLocal);
      if (zeroMemory) {
        os->initializeToZero();
      } else {
        os->initializeToRandom();
      }
      bindLocal(target, state, mo->getBaseExpr());

      if (reallocFrom) {
        unsigned count = std::min(reallocFrom->size, os->size);
        for (unsigned i=0; i<count; i++)
          os->write(i, reallocFrom->read8(i));
        state.addressSpace().unbindObject(reallocFrom->getObject());
      }
    }

    return;
  }

  // XXX For now we just pick a size. Ideally we would support
  // symbolic sizes fully but even if we don't it would be better to
  // "smartly" pick a value, for example we could fork and pick the
  // min and max values and perhaps some intermediate (reasonable
  // value).
  //
  // It would also be nice to recognize the case when size has
  // exactly two values and just fork (but we need to get rid of
  // return argument first). This shows up in pcre when llvm
  // collapses the size expression with a select.

  ref<ConstantExpr> example;

  bool success = solver->getValue(data::ALLOC_RANGE_CHECK, state, size, example);
  assert(success && "FIXME: Unhandled solver failure");
  (void) success;

  // Try and start with a small example.
  Expr::Width W = example->getWidth();
  while (example->Ugt(ConstantExpr::alloc(128, W))->isTrue()) {
    ref<ConstantExpr> tmp = example->LShr(ConstantExpr::alloc(1, W));
    bool res;
    bool success = solver->mayBeTrue(data::ALLOC_RANGE_CHECK, state, EqExpr::create(tmp, size), res);
    assert(success && "FIXME: Unhandled solver failure");
    (void) success;
    if (!res)
      break;
    example = tmp;
  }

  StatePair fixedSize = fork(state, EqExpr::create(example, size), true, KLEE_FORK_INTERNAL);

  if (fixedSize.second) {
    // Check for exactly two values
    ref<ConstantExpr> tmp;
    bool success = solver->getValue(data::ALLOC_RANGE_CHECK, *fixedSize.second, size, tmp);
    assert(success && "FIXME: Unhandled solver failure");
    (void) success;
    bool res;
    success = solver->mustBeTrue(data::ALLOC_RANGE_CHECK, *fixedSize.second,
                                 EqExpr::create(tmp, size),
                                 res);
    assert(success && "FIXME: Unhandled solver failure");
    (void) success;
    if (res) {
      executeAlloc(*fixedSize.second, tmp, isLocal,
                   target, zeroMemory, reallocFrom);
    } else {
      // See if a *really* big value is possible. If so assume
      // malloc will fail for it, so lets fork and return 0.
      Expr::Width W = example->getWidth();
      StatePair hugeSize =
        fork(*fixedSize.second,
             UltExpr::create(ConstantExpr::alloc(1<<31, W), size),
             true, KLEE_FORK_INTERNAL);
      if (hugeSize.first) {
        LOG(INFO) << "Found huge malloc, returing 0";
        bindLocal(target, *hugeSize.first,
                  ConstantExpr::alloc(0, Context::get().getPointerWidth()));
      }

      if (hugeSize.second) {
        std::ostringstream info;
        ExprPPrinter::printOne(info, "  size expr", size);
        info << "  concretization : " << example << "\n";
        info << "  unbound example: " << tmp << "\n";
        terminateStateOnError(*hugeSize.second,
                              "concretized symbolic size",
                              "model.err",
                              info.str());
      }
    }
  }

  if (fixedSize.first) { // can be zero when fork fails
    executeAlloc(*fixedSize.first, example, isLocal,
                 target, zeroMemory, reallocFrom);
  }
}

void Executor::executeFree(ExecutionState &state,
                           ref<Expr> address,
                           KInstruction *target) {
  StatePair zeroPointer = fork(state, Expr::createIsZero(address), true, KLEE_FORK_INTERNAL);
  if (zeroPointer.first) {
    if (target)
      bindLocal(target, *zeroPointer.first, Expr::createPointer(0));
  }
  if (zeroPointer.second) { // address != 0
    ExactResolutionList rl;
    resolveExact(*zeroPointer.second, address, rl, "free");

    for (Executor::ExactResolutionList::iterator it = rl.begin(),
           ie = rl.end(); it != ie; ++it) {
      const MemoryObject *mo = it->first.first;
      if (mo->isLocal) {
        terminateStateOnError(*it->second,
                              "free of alloca",
                              "free.err",
                              getAddressInfo(*it->second, address));
      } else if (mo->isGlobal) {
        terminateStateOnError(*it->second,
                              "free of global",
                              "free.err",
                              getAddressInfo(*it->second, address));
      } else {
        it->second->addressSpace().unbindObject(mo);
        if (target)
          bindLocal(target, *it->second, Expr::createPointer(0));
      }
    }
  }
}

bool Executor::recordSyncVarLocally(ExecutionState* currentState, SyncVar& syncVar)
{
  SyncAddrRecords::iterator it = syncAddrRecords.find(currentState);

  if(it != syncAddrRecords.end())
  {
    //at least one sync variable of currentState has been recorded.
    SyncVarMap syncVarMap = it->second.syncVarMap;
    SyncVarMap::iterator varIt;
    varIt = syncVarMap.find(syncVar.addr);

    if(varIt == syncVarMap.end())
    {
      //cannot find it; record.
      syncVarMap[syncVar.addr] = syncVar;

      //update currentState's syncVarMap.
      syncAddrRecords[currentState].syncVarMap = syncVarMap;

      return true;
    }
    else
    {
      //found it.
      return false;
    }
  }
  else
  {
    //no sync variable of currentState has been recorded.
    //Record it.
    SyncAddrRecord syncAddrRecord;
    syncAddrRecord.state = currentState;
    syncAddrRecord.syncRegionID = currentState->currentSyncRegionID;
    syncAddrRecord.syncVarMap[syncVar.addr] = syncVar;

    syncAddrRecords[currentState] = syncAddrRecord;
    return true;
  }
}

//Implementation of Algorithm 1 in include/syncat/syncs.h
//Warning: this function is used in iterations other than the 1st iteration.
//ExecutionState* should not be used as key to index global 
//cache (syncRecords) anymore.
bool Executor::isAFixedPoint(SyncRecord &syncRecord)
{
  //Disable fixed-point algorithm without affecting invariant derivation alg.
#if 1
  return false;
#endif

  SyncRecords::iterator ib = syncRecords.begin(), ie = syncRecords.end();
  
  for( ; ib != ie; ++ib)
  {
    if( ib->second.bDone
        && ib->second.syncRegionID == syncRecord.syncRegionID
        && ib->second.executionContext == syncRecord.executionContext
      )
    {
      int bEqual = true;
      SyncVarMap::iterator ibVar = syncRecord.syncVarMap.begin();
      SyncVarMap::iterator ieVar = syncRecord.syncVarMap.end();
      for( ; ibVar != ieVar; ++ibVar)
      {
        SyncVarMap::iterator syncvarIt = ib->second.syncVarMap.find(ibVar->second.addr);

        if(syncvarIt != ib->second.syncVarMap.end())
        {
          if(syncvarIt->second.value != ibVar->second.value)
          {
            bEqual = false;
            break;
          }
        }
        else
        {
          assert(0 && "Fail to find the address in syncVarMap. Something is wrong.\n");
        }
      }

      if(bEqual)
      {
        return true;
      }
      else
      {
        continue;
      }
    }
  }

  return false;
}

/*
 * read current value for each sync var which has its address recorded in syncVarAddrSet.
 * update syncRecord accordingly.
 *
 * Warning: this API is valid for iterators other than the 1st iteration.
 * */
void Executor::FillValuesToSyncRecord(SyncRecord &syncRecord)
{
  set<SyncVarLogicalAddr> &syncAddrs = syncVarAddrSet[syncRecord.syncRegionID];
  for(set<SyncVarLogicalAddr>::iterator ibAddr=syncAddrs.begin(), ieAddr=syncAddrs.end();
      ibAddr != ieAddr; ++ibAddr)
  {
    uint64_t effectiveAddr = ibAddr->getEffectiveAddress();
    ref<Expr> addr = ConstantExpr::create(effectiveAddr, Expr::Int64);
    ObjectPair result;
    if(syncRecord.state->addressSpace().resolveOne(dyn_cast<ConstantExpr>(addr), result))
    {
      const ObjectState *os = result.second;
      ref<Expr> value = os->read(ibAddr->offset, ibAddr->type);
      ConstantExpr *CE = dyn_cast<ConstantExpr>(value);
      int newValue = CE->getSExtValue(ibAddr->type);
      SyncVar syncVar;
      syncVar.mo = ibAddr->mo;
      syncVar.offset = ibAddr->offset;
      syncVar.type = ibAddr->type;
      syncVar.addr = effectiveAddr;
      syncVar.value = newValue;

      //Insert syncVar.
      syncRecord.syncVarMap[syncVar.addr] = syncVar;
    }
    else
    {
      assert(0 && "Fail to resolve current address.\n");
    }
  }
}

bool Executor::InsertSyncRecord(ExecutionState* state, int syncRegionID, SyncVar &syncVar)
{
  SyncRecordRange range = syncRecords.equal_range(state);

  for(SyncRecords::iterator it=range.first; it != range.second; ++it)
  {
    if(it->second.syncRegionID == syncRegionID)
    {
      SyncVarMap::iterator itV = it->second.syncVarMap.find(syncVar.addr);
      if(itV == it->second.syncVarMap.end())
      {
        it->second.syncVarMap[syncVar.addr] = syncVar;
        return true;
      }
    }
  }

  return false;
}

void Executor::finalizeSyncRecord(ExecutionState* state, int regionID)
{
  SyncRecordRange range = syncRecords.equal_range(state);
  for(SyncRecords::iterator it=range.first; it != range.second; ++it)
  {
    if(it->second.syncRegionID == regionID && !it->second.bDone)
    {
      it->second.bDone = true;
      break;
    }
  }
}

void Executor::InsertSyncRecord(SyncRecord &syncRecord)
{
  RecordSync(syncRecord.state, syncRecord);
}

//Check whether a sync region is the first time to be explored within an ExecutionState.
bool Executor::isRegionFirstTimeExplored(int syncRegionID)
{
  SyncRecords::iterator it=syncRecords.begin(), ie=syncRecords.end();
  for( ; it != ie; ++it)
  {
    if(it->second.syncRegionID == syncRegionID && it->second.bDone)
    {
      return false;
    }
  }

  return true;
}

bool Executor::findInvariant(Invariant invariant)
{
  bool retVal = false;
  InvariantIterator ib = invariantSet.begin();
  InvariantIterator ie = invariantSet.end();
  Invariant temp;
  int regionID = invariant.state->currentSyncRegionID;
  //mark the syncRecord is complete.
  finalizeSyncRecord(invariant.state, regionID);


  if(totalValid == 1)
  {
    for(; ib != ie; ++ib)
    {
      temp = *ib;
      if(temp.gSyncVar_0 == invariant.gSyncVar_0)
      {
        retVal = true;
        break;
      }
    }
  }
  else if(totalValid == 2)
  {
    for(; ib != ie; ++ib)
    {
      temp = *ib;
      if(temp.gSyncVar_0 == invariant.gSyncVar_0 
          && temp.gSyncVar_1 == invariant.gSyncVar_1
        )
      {
        retVal = true;
        break;
      }
    }
  }
  else if(totalValid == 3)
  {
    for(; ib != ie; ++ib)
    {
      temp = *ib;
      if(temp.gSyncVar_0 == invariant.gSyncVar_0 
          && temp.gSyncVar_1 == invariant.gSyncVar_1
          && temp.gSyncVar_2 == invariant.gSyncVar_2
        )
      {
        retVal = true;
        break;
      }
    }
  }
  else if(totalValid == 4)
  {
    for(; ib != ie; ++ib)
    {
      temp = *ib;
      if(temp.gSyncVar_0 == invariant.gSyncVar_0 
          && temp.gSyncVar_1 == invariant.gSyncVar_1
          && temp.gSyncVar_2 == invariant.gSyncVar_2
          && temp.gSyncVar_3 == invariant.gSyncVar_3
        )
      {
        retVal = true;
        break;
      }
    }
  }
  else
  {
    assert(0 && "Invalid total number of sync vars.\n");
    return false;
  }

  //call stack test: whether all the other threads stop at boundary.
  //the callSite is 
  //call void @printY
  //sleep->mySleep->__thread_preempt.
  //The current thread's prevPC(current instruction) is DeriveInvariant and
  //do not need to test again.
  bool stopAtBoundary = invariant.state->isStopAtBoundary();
  if(stopAtBoundary)
  {
    invariant.state->isStopAtBoundary();
  }

  //Not found, need insert the new invariant.
  if(!retVal)
  {

    if(stopAtBoundary)
    {
      //update invariantSet and invariantStates.
      invariantSet.push_back(invariant);
      invariantStates.push_back(invariant.state);
      invariant.state->bFirstTimeExplored = false;
      invariant.state->bInvariantState = true;
      invariant.state->bDirectDescendent = true;
      invariant.state->bOutSideSyncRegion = false;
      invariant.state->bEnumerating = true;
      invariant.state->bDumpTrace = true;
      //invariant.state->bRoot = false;

      //separate the current state from being scheduled.
      fireStateDisableSchedule(invariant.state);
    }
    else
    {
      //kill the current state
      terminateStateOnError(*invariant.state, 
          " ******** Killed because of not a new invariant state.", 
          "system.reduce.Invariant");

      //only record the invariant.
      invariant.state = NULL;
      invariantSet.push_back(invariant);
    }

  }
  else
  {
    if(temp.state == NULL)
    {
      //the previous invariant's state does not satisfy the boundary condition.
      //Need to update invariantSet.
      if(stopAtBoundary)
      {
        //remove the previous invariant, of which the state is NULL.
        invariantSet.erase(ib);

        //update the invariantSet, so that invariant's state is updated.
        invariantSet.push_back(invariant);          
        invariantStates.push_back(invariant.state);
        invariant.state->bFirstTimeExplored = false;
        invariant.state->bInvariantState = true;
        invariant.state->bDirectDescendent = true;
        invariant.state->bOutSideSyncRegion = false;
        invariant.state->bEnumerating = true;
        invariant.state->bDumpTrace = true;
        //invariant.state->bRoot = false;

        //separate the current state from being scheduled.
        fireStateDisableSchedule(invariant.state);
      }
      else
      {
        //kill the current state
        terminateStateOnError(*invariant.state, 
            " ******** Killed because of not a new invariant state.", 
            "system.reduce.Invariant");
      }
    }
    else
    {
      //kill the current state
      terminateStateOnError(*invariant.state, 
          " ******** Killed because of not a new invariant state.", 
          "system.reduce.Invariant");
    }
  }

  return false;
}

void Executor::executeMemoryOperation(ExecutionState &state,
                                      bool isWrite,
                                      ref<Expr> address,
                                      ref<Expr> value /* undef if read */,
                                      KInstruction *target /* undef if write */) {
  Expr::Width type = (isWrite ? value->getWidth() :
                     getWidthForLLVMType(target->inst->getType()));
  unsigned bytes = Expr::getMinBytesForWidth(type);
  if(bytes > 100)
  {
    DumpStateSet();
  }

  if (SimplifySymIndices) {
    if (!isa<ConstantExpr>(address))
      address = state.constraints().simplifyExpr(address);
    if (isWrite && !isa<ConstantExpr>(value))
      value = state.constraints().simplifyExpr(value);
  }

  ObjectPair op;
  bool resolved = false;

  // fast path: single in-bounds resolution
  solver->setTimeout(stpTimeout);
  if (!state.addressSpace().resolveOne(state, solver, address, op, resolved)) {
    address = toConstant(state, address, "resolveOne failure");
    resolved = state.addressSpace().resolveOne(cast<ConstantExpr>(address), op);
  }
  solver->setTimeout(0);

  if (resolved) {
    const MemoryObject *mo = op.first;

    if (MaxSymArraySize && mo->size>=MaxSymArraySize) {
      address = toConstant(state, address, "max-sym-array-size");
    }

    ref<Expr> offset = mo->getOffsetExpr(address);

    solver->setTimeout(stpTimeout);
    bool success = solver->mustBeTrue(data::SINGLE_ADDRESS_RESOLUTION, state,
                                      mo->getBoundsCheckOffset(offset, bytes),
                                      resolved);
    solver->setTimeout(0);
    if (!success) {
      state.pc() = state.prevPC();
      terminateStateEarly(state, "query timed out");
      return;
    }
  }

  if (resolved) {
    const MemoryObject *mo = op.first;
    const ObjectState *os = op.second;
    ref<Expr> offset = mo->getOffsetExpr(address);

    if (isWrite) {
      //time to record sync variable address and value.
      //Only in record in the first iteration by intercepting store instruction.
      //In later iterations, record is made at the beginning of a sync region in handleCheckInvariant.
      if(state.bFirstTimeExplored && state.bRecording)
      {
        //read old value before write.
        ref<Expr> result = os->read(offset, type);
        ConstantExpr *CE = dyn_cast<ConstantExpr>(result);
        int oldValue = CE->getSExtValue(type);
        int offset_val = dyn_cast<ConstantExpr>(offset)->getSExtValue();

        //Q: is logical address the same across execution state? why?
        //A: After forking, new execution state is the same as the old one,
        //including their process address space. Before a shared object is
        //written, its original memory object mo is kept while its object state os
        //is newly allocated. The mapping from mo to os is updated accordingly,
        //with mo unchanged and os changed. See getWriteable
        //

        //Logical address has two parts: base and offset.
        //mo->address is the base, offset is calculated as in
        //  ref<Expr> offset = mo->getOffsetExpr(address);
        //the address (ref<Expr> base for Store/Load instruction) is
        //  mo->address + offset
        //After resolving with stp solver, ref<Expr> base is resolved into
        //two parts: mo->address + offset.
        //
        //Data type (byte width) is calculated as:
        //  Expr::Width type = getWidthForLLVMType(ki->inst->getType());

        //record logical address.
        //We record the resolved result, mo, offset, and type, so that when
        //we see such a record, we can read its value as follows:
        //  ObjectState *os = state.addressSpace().findObject(mo);
        //  ref<Expr> result = os->read(offset, type);
        //  ConstantExpr *CE = dyn_cast<ConstantExpr>(result);
        //  int oldValue = CE->getSExtValue(type);
        //To distinguish sync variables, we use (mo->address+offset) as the key.

        //If a sync var is only accessed by 1 thread
        //out of many, then bRecording will be set to true and false only once, which
        //is sufficient to record only sync variable's initial value. But, if each thread
        //writes the sync variable at least once, bRecording alone cannot achieve the
        //intented effect: record only sync variable's initial value. We have to rely
        //on other information: 
        //option 1. Add a new ExecutionState-specific field to record whether a recordSyncVar
        //has been executed (<Inst*, bSeen>). When handling recordSyncVar(), figure out
        //whether bSeen is true or false. If true, the recordSyncVar() has been handled and bRecording
        //should not be set to true. Otherwise, set bRecording to true.
        //
        //option 2. before creation of the new record, we simply look up it
        //in syncVarMap with the sync variable's address (mo->address + offset) as the
        //key in local cache (region-specific cache). 
        //If found, it indicates the initial value has already been recorded and 
        //should not record it again; otherwise, it has not been recorded yet and should
        //be recorded.
        //
        //option 3. Before insertion of the new record, we simply look up it in
        //syncVarMap with sync variable's address as the key in global cache. If found, it
        //indicates the initial value has already been recorded and should not record it again;
        //otherwise, it has not been recorded yet and should be recorded.
        //
        //Previously, we simply decide to use option 2. But it turns out option 3 is the
        //simplest, because it does not involve local cache cleaning before entering the next
        //region.

        SyncVar syncVar;
        syncVar.mo = mo;
        syncVar.offset = offset;
        syncVar.type = type;
        syncVar.value = oldValue;
        syncVar.addr = mo->address + offset_val;

        //record syncVar in local cache. 
        //only when it is the first time that a sync variable is recorded,
        //bRecorded can be true. It is also the time when such a record is
        //taken for the current execution state in the 1st iteration.

        //bool bRecorded = recordSyncVarLocally(&state, syncVar);

        //if(bRecorded)
        {
          //record sync var address in global cache for the current sync region,
          //for queries of sync variable initial values at the beginning of
          //the current sync region in the future iteration.
          SyncVarLogicalAddr logicalAddr;
          logicalAddr.mo = mo;
          logicalAddr.offset = offset;
          logicalAddr.type = type;

          //Assume that all sync variable addresses are recorded after 1st iteration.
          //If syncVarAddrSet.size() is 0, it indicates that it is the 1st time this
          //sync region is explored. ExecutionContext can be recorded into two forms:
          //1. as part of ExecutionState.
          //2. as part of Executor. Then, there must be a map from ExecutionState to
          //   ExecutionContext inside Executor.
          //
          //In either form, it has to be cleared before entering next sync region.
          //Here, we choose form 1. 
          //When the invariant state is scheduled, it is the right time to clear the
          //executionContext.
          //
          //When is the time to record SyncRecord for current sync region and execution state?
          //A: overall, there are 3 timings: beginning(when the 1st thread hit the beginning point
          //   of a sync region), exploring(when a sync variable is being written), ending(when a 
          //   sync region is fully explored. Two outcomes: installed as an invariant state OR killed
          //   due to not be an invariant state.)
          //case 1. If it is the first time to explore a sync region (isRegionFirstTimeExplored).
          //         Since at the beginning,
          //        we do not have sync variable addresses and cannot obtain all the information,
          //        including sync variable initial values and executionContext, it is not feasible.
          //        
          //        Exploring. We first record executionContext into the global cache; then when we
          //        hit a new sync variable first time 
          //          syncVarAddrSet[syncRegionID].find(syncAddr) == syncVarAddrSet[syncRegionID].end()
          //        we record its address in syncVarAddrSet[syncRegionID] and its syncVar record
          //        into global cache. We do not know which one is the last one to see in current
          //        sync region, and we do not rely on such knowledge.
          //         Since multiple ExecutionStates can co-exist in the same sync region simultaneously,
          //         ExecutionState* is used a key to index syncRecords. But, such a usage is only
          //         need in the first iteration. For later iterations, we do not rely on ExecutionState*
          //         as the key, because we only need compare and record <syncRegionID, executionContext,
          //         sync variable initial values> and do not need to index global cache with ExecutionState*
          //         as the key to figure out which entry to record the information triple, and we will not
          //         record ExecutionState* as well in all the later iterations (only first iteration record
          //         and use such information.)
          //         One ExecutionState* may live across multiple
          //         sync regions in the first iteration, this is the reason why SyncRecords is a
          //         multimap and we need syncRegionID to distinguish them. 
          //
          //        Ending. When a state is installed as an invariant state. At that time, we know 
          //        the current sync region exploration is finished and all sync var addresses have
          //        been captured. Then, we record them and the previous recorded executionContext into
          //        global cache. Compared to Exploring, it only record syncRecord of the invariant state
          //        into global cache. It is not sufficient to capture syncRecords for ExecutionStates
          //        which have the same initial values but different executionContexts.
          //
          //        Therefore, Beginning is not feasible; Ending is too late and not sufficient; Exploring
          //        is the only choice.
          //
          //case 2. If it is not the first time to explore a sync region. 
          //        Beginning. Different from case 1, we have all the sync variable addresses recorded
          //        and thus can access with syncVarAddrSet[syncRegionID], and read their values to
          //        compare against syncRecords in global cache. If they have the same initial values
          //        and executionContext, then ExecutionState.bEnumerating should be set to false to
          //        disable any further interleaving enumeration.
          //
          //        Exploring or Ending is not reasonable and is not discussed.
          //

          //Record logical addresses of all sync variables for current sync region.
          //We assume all the sync variables are accessed in each sync region exploration.
          syncVarAddrSet[state.currentSyncRegionID].insert(logicalAddr);

          //first time recording. Record it into global cache, too.
          InsertSyncRecord(&state, state.currentSyncRegionID, syncVar);

          //do not record any further values. 
          state.bRecording = false;     
        }
      }
      

      if (os->readOnly) {
        terminateStateOnError(state,
                              "memory error: object read only",
                              "readonly.err");
      } else {
        ObjectState *wos = state.addressSpace().getWriteable(mo, os);
        wos->write(offset, value);
      }
    } else {
      ref<Expr> result = os->read(offset, type);

      if (interpreterOpts.MakeConcreteSymbolic)
        result = replaceReadWithSymbolic(state, result);

      bindLocal(target, state, result);
    }

    return;
  }

  // we are on an error path (no resolution, multiple resolution, one
  // resolution with out of bounds)

  ResolutionList rl;
  solver->setTimeout(stpTimeout);
  bool incomplete = state.addressSpace().resolve(state, solver, address, rl,
                                               0, stpTimeout);
  solver->setTimeout(0);

  // XXX there is some query wasteage here. who cares?
  ExecutionState *unbound = &state;

  for (ResolutionList::iterator i = rl.begin(), ie = rl.end(); i != ie; ++i) {
    const MemoryObject *mo = i->first;
    const ObjectState *os = i->second;
    ref<Expr> inBounds = mo->getBoundsCheckPointer(address, bytes);

    StatePair branches = fork(*unbound, inBounds, true, KLEE_FORK_INTERNAL);
    ExecutionState *bound = branches.first;

    // bound can be 0 on failure or overlapped
    if (bound) {
      if (isWrite) {
        if (os->readOnly) {
          terminateStateOnError(*bound,
                                "memory error: object read only",
                                "readonly.err");
        } else {
          ObjectState *wos = bound->addressSpace().getWriteable(mo, os);
          wos->write(mo->getOffsetExpr(address), value);
        }
      } else {
        ref<Expr> result = os->read(mo->getOffsetExpr(address), type);
        bindLocal(target, *bound, result);
      }
    }

    unbound = branches.second;
    if (!unbound)
      break;
  }

  // XXX should we distinguish out of bounds and overlapped cases?
  if (unbound) {
    if (incomplete) {
      terminateStateEarly(*unbound, "query timed out (resolve)");
    } else {
#if 1
      terminateStateOnError(*unbound,
                            "memory error: out of bound pointer",
                            "ptr.err",
                            getAddressInfo(*unbound, address));
#endif
    }
  }
}


void Executor::executeMakeSymbolic(ExecutionState &state,
                                   const MemoryObject *mo,
                                   bool shared) {

  // TODO(sbucur): Memory object may not be the same across states

  // First, create a new symbolic array
  static unsigned id = 0;
  const Array *array = new Array("arr" + llvm::utostr(++id),
                                 mo->size);

	ObjectState *os = bindObjectInState(state, mo, false, array);
	os->isShared = shared;
	state.addSymbolic(mo, array);
}

void Executor::executeGetValue(ExecutionState &state,
                               ref<Expr> e,
                               KInstruction *target) {
  e = state.constraints().simplifyExpr(e);
  ref<ConstantExpr> value;
  bool success = solver->getValue(data::USER_GET_VALUE, state, e, value);
  assert(success && "FIXME: Unhandled solver failure");
  (void) success;
  bindLocal(target, state, value);
  return;
}

ref<Expr> Executor::replaceReadWithSymbolic(ExecutionState &state,
                                            ref<Expr> e) {
  unsigned n = interpreterOpts.MakeConcreteSymbolic;
  if (!n)
    return e;

  // right now, we don't replace symbolics (is there any reason too?)
  if (!isa<ConstantExpr>(e))
    return e;

  if (n != 1 && random() %  n)
    return e;

  // create a new fresh location, assert it is equal to concrete value in e
  // and return it.

  static unsigned id;
  const Array *array = new Array("rrws_arr" + llvm::utostr(++id),
                                 Expr::getMinBytesForWidth(e->getWidth()));
  ref<Expr> res = Expr::createTempRead(array, e->getWidth());
  ref<Expr> eq = NotOptimizedExpr::create(EqExpr::create(e, res));
  std::cerr << "Making symbolic: " << eq << "\n";
  state.addConstraint(eq);
  return res;
}

}
