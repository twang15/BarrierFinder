//===-- ExecutionState.h ----------------------------------------*- C++ -*-===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef KLEE_EXECUTIONSTATE_H
#define KLEE_EXECUTIONSTATE_H

#include "klee/Constraints.h"
#include "klee/Expr.h"
#include "klee/Internal/ADT/TreeStream.h"

// FIXME: We do not want to be exposing these? :(
#include "../../lib/Core/AddressSpace.h"
#include "klee/Internal/Module/KInstIterator.h"

#include "llvm/Instructions.h"
#include "llvm/Support/TimeValue.h"

#include "klee/Threading.h"
#include "klee/MultiProcess.h"
#include "klee/AddressPool.h"
#include "klee/StackTrace.h"

#include "syncat/syncs.h"

#include <map>
#include <set>
#include <vector>

#include <boost/shared_ptr.hpp>
using boost::shared_ptr;

#include <glog/logging.h>

using namespace llvm;
using namespace syncat;

namespace cloud9 {
namespace worker {
class SymbolicState;
}
}

namespace llvm {
class Instruction;
}

namespace klee {
  class Array;
  class CallPathNode;
  struct Cell;
  struct KFunction;
  struct KInstruction;
  class MemoryObject;
  class PTreeNode;
  struct InstructionInfo;
  class Executor;

  class ExecutionState;

namespace c9 {
std::ostream &printStateStack(std::ostream &os, const ExecutionState &state);
std::ostream &printStateConstraints(std::ostream &os, const ExecutionState &state);
std::ostream &printStateMemorySummary(std::ostream &os, const ExecutionState &state);
}

std::ostream &operator<<(std::ostream &os, const ExecutionState &state); // XXX Cloud9 hack
std::ostream &operator<<(std::ostream &os, const MemoryMap &mm);

typedef uint64_t wlist_id_t;

class ExecutionState {
  friend class ObjectState;

public:
  typedef std::vector<StackFrame> stack_ty;

  typedef std::map<thread_uid_t, Thread> threads_ty;
  typedef std::map<process_id_t, Process> processes_ty;
  typedef std::map<wlist_id_t, std::set<thread_uid_t> > wlists_ty;

private:
  // unsupported, use copy constructor
  ExecutionState &operator=(const ExecutionState&); 
  std::map< std::string, std::string > fnAliases;

  cloud9::worker::SymbolicState *c9State;

  void setupMain(KFunction *kf);
  void setupTime();
  void setupAddressPool();
public:
  /* System-level parameters */
  Executor *executor;

  unsigned depth;

  /// Disables forking, set by user code.
  bool forkDisabled;

  ///Exhaustive enumeration of ad hoc sync interleavings.
  //whether sleep(3) has been invoked by any thread. Sleep(3) is
  //to mark sync variable write. See detailed design note in Executor.h
  //initialized to false.
  bool syncWriteReached;

  //number of threads in the current process.
  //Initial value 0; increment by 1 when a new thread is created,
  //decrement by 1 when a thread is exiting.
  unsigned int numOfThreads;

  //whether in sync variable recording mode.
  bool bRecording;

  //enumeration of interleaving enabled or not.
  bool bEnumerating;

  //whether trace is to be dumped.
  bool bDumpTrace;

  //whether it is an invariant state.
  bool bInvariantState;

  //whether a direct descendent of an invariant state.
  bool bDirectDescendent;

  //current sync region id
  int currentSyncRegionID;

  //whether it is the first time exploration of the current sync region.
  bool bFirstTimeExplored;

  //whether it is a root state or 
  //(a decendent of a root state and has not executed any CheckInvariant yet.)
  bool bRoot;

  //whether the current thread is outside of a sync region.
  bool bOutSideSyncRegion;

  //the execution context when the 1st thread hit the beginning of
  //a new sync region.
  ExecutionContext executionContext;

  mutable double queryCost;
  double weight;

  TreeOStream pathOS, symPathOS;
  unsigned instsSinceCovNew;

  bool coveredNew;
  sys::TimeValue lastCoveredTime;

  void setCoveredNew() {
    coveredNew = true;
    lastCoveredTime = sys::TimeValue::now();
  }

  std::map<const std::string*, std::set<unsigned> > coveredLines;

  PTreeNode *ptreeNode;

  int crtForkReason;
  Instruction *crtSpecialFork;


  /// ordered list of symbolics: used to generate test cases. 
  //
  // FIXME: Move to a shared list structure (not critical).
  std::vector< std::pair<const MemoryObject*, const Array*> > symbolics;

  ConstraintManager globalConstraints;


  // For a multi threaded ExecutionState
  threads_ty threads;
  processes_ty processes;

  wlists_ty waitingLists;
  wlist_id_t wlistCounter;

  uint64_t stateTime;

  AddressPool addressPool;
  AddressSpace::cow_domain_t cowDomain;

  Thread& createThread(thread_id_t tid, KFunction *kf);
  Process& forkProcess(process_id_t pid);
  void terminateThread(threads_ty::iterator it);
  void terminateProcess(processes_ty::iterator it);

  threads_ty::iterator nextThread(threads_ty::iterator it) {
    if (it == threads.end())
      it = threads.begin();
    else {
      it++;
      if (it == threads.end())
        it = threads.begin();
    }

    crtProcessIt = processes.find(crtThreadIt->second.getPid());

    return it;
  }

  void scheduleNext(threads_ty::iterator it) {
    assert(it != threads.end());

    crtThreadIt = it;
    crtProcessIt = processes.find(crtThreadIt->second.getPid());
  }

  wlist_id_t getWaitingList() { return wlistCounter++; }
  void sleepThread(wlist_id_t wlist);
  void notifyOne(wlist_id_t wlist, thread_uid_t tid);
  void notifyAll(wlist_id_t wlist, uint64_t all=1);

  threads_ty::iterator crtThreadIt;
  processes_ty::iterator crtProcessIt;

  unsigned int preemptions;


  /* Shortcut methods */

  Thread &crtThread() { return crtThreadIt->second; }
  const Thread &crtThread() const { return crtThreadIt->second; }

  Process &crtProcess() { return crtProcessIt->second; }
  const Process &crtProcess() const { return crtProcessIt->second; }

  ConstraintManager &constraints() { return globalConstraints; }
  const ConstraintManager &constraints() const { return globalConstraints; }

  AddressSpace &addressSpace() { return crtProcess().addressSpace; }
  const AddressSpace &addressSpace() const { return crtProcess().addressSpace; }

  /// For testing only, get global var's address
  void *getGlobalVariable(char *varName = "mystring") __attribute__((noinline))
  {
    //StringRef gVarName = "mystring";
    StringRef gVarName = varName;
    return addressSpace().findGlobalVariable(gVarName);
  }

  KInstIterator& pc() { return crtThread().pc; }
  const KInstIterator& pc() const { return crtThread().pc; }

  KInstIterator& prevPC() { return crtThread().prevPC; }
  const KInstIterator& prevPC() const { return crtThread().prevPC; }

  stack_ty& stack() { return crtThread().stack; }
  const stack_ty& stack() const { return crtThread().stack; }

  std::string getFnAlias(std::string fn);
  void addFnAlias(std::string old_fn, std::string new_fn);
  void removeFnAlias(std::string fn);

  /* Logging support */
  unsigned char state_id[20];
  unsigned char parent_id[20];
  unsigned char fork_id[20];

#define __STANDALONE_DEBUG__   
#ifdef __STANDALONE_DEBUG__  
  /* Stand-alone mode debugging support */
  unsigned int UINT_state_id;
  unsigned int UINT_parent_id;
  unsigned int UINT_fork_id;
  static unsigned int stateCounter;
#endif

  /* Various counters */
  uint64_t totalInstructions;
  uint64_t totalBranches;
  uint64_t totalForks;
  mutable uint64_t totalQueries; // TODO(bucur): Fix this atrocity
  mutable uint64_t totalTime;
public:
  ExecutionState(Executor *_executor, KFunction *kf);

  // XXX total hack, just used to make a state so solver can
  // use on structure
  ExecutionState(Executor *_executor, const std::vector<ref<Expr> > &assumptions);

  ~ExecutionState();
  
  ExecutionState *branch(bool copy = false);

  void pushFrame(Thread &t, KInstIterator caller, KFunction *kf) {
    t.stack.push_back(StackFrame(caller,kf));
  }
  void pushFrame(KInstIterator caller, KFunction *kf) {
    pushFrame(crtThread(), caller, kf);
  }

  void popFrame(Thread &t) {
    StackFrame &sf = t.stack.back();
    for (std::vector<const MemoryObject*>::iterator it = sf.allocas.begin(),
           ie = sf.allocas.end(); it != ie; ++it)
      processes.find(t.getPid())->second.addressSpace.unbindObject(*it);
    t.stack.pop_back();
  }
  void popFrame() {
    popFrame(crtThread());
  }

  void addSymbolic(const MemoryObject *mo, const Array *array) { 
    symbolics.push_back(std::make_pair(mo, array));
  }
  void addConstraint(ref<Expr> e) { 
    constraints().addConstraint(e);
  }

  bool merge(const ExecutionState &b);

  cloud9::worker::SymbolicState *getCloud9State() const { return c9State; }
  void setCloud9State(cloud9::worker::SymbolicState *state) { c9State = state; }

  StackTrace getStackTrace() const;

  /// for debugging.
  StackTrace getStackTrace(ExecutionState::threads_ty::iterator &it) const;

  ExecutionContext::CallStack getExecutionContext(const Thread &thread) const;
  ExecutionContext getExecutionContext() const;

  void dumpStacks();

  bool isExternalCallSafe() const;
  
  int numOfEnabledThreads()
  {
    int enabledCount = 0;

    for(threads_ty::iterator it = threads.begin();
        it != threads.end();  it++) {
      if(it->second.enabled) {
        enabledCount++;
      }
    }

    return enabledCount;
  }

  bool isCurrentThreadEnabled()
  {
    return crtThread().enabled;
  }

  //test whether all other threads except the current thread stop at boundary.
  bool isStopAtBoundary()
  {
    for(ExecutionState::threads_ty::iterator it = threads.begin();
        it != threads.end();  it++)
    {
      if(&(crtThread()) == &(it->second))
      {
        continue;
      }

      StackTrace stackTrace = getStackTrace(it);
      if(!stackTrace.isStopAtSyncBoundary())
      {
        return false;
      }
    }

    return true;
  }

};

//unsigned int stateCounter = 0;
}

#endif
