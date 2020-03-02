//===-- Executor.h ----------------------------------------------*- C++ -*-===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// Class to perform actual execution, hides implementation details from external
// interpreter.
//
//===----------------------------------------------------------------------===//

#ifndef KLEE_EXECUTOR_H
#define KLEE_EXECUTOR_H

#include "klee/ExecutionState.h"
#include "klee/Interpreter.h"
#include "klee/Expr.h"
#include "klee/ForkTag.h"
#include "klee/util/Ref.h"
#include "klee/Internal/Module/Cell.h"
#include "klee/Internal/Module/KInstruction.h"
#include "klee/Internal/Module/KModule.h"
#include "llvm/Support/CallSite.h"
#include "cloud9/worker/SymbolicEngine.h"

#include "syncat/syncs.h"

#include <vector>
#include <string>
#include <map>
#include <set>

using namespace syncat;
using namespace std;

struct KTest;

namespace llvm {
  class BasicBlock;
  class BranchInst;
  class CallInst;
  class Constant;
  class ConstantExpr;
  class Function;
  class GlobalValue;
  class Instruction;
  class TargetData;
  class Twine;
  class Value;
}

namespace klee {  
  class Array;
  struct Cell;
  class ExecutionState;
  class ExternalDispatcher;
  class Expr;
  class ExprSerializer;
  class InstructionInfoTable;
  struct KFunction;
  struct KInstruction;
  class KInstIterator;
  class KModule;
  class MemoryManager;
  class MemoryObject;
  class ObjectState;
  class PTree;
  class Searcher;
  class SeedInfo;
  class SpecialFunctionHandler;
  struct StackFrame;
  class StatsTracker;
  class TimingSolver;
  class TreeStreamWriter;

  enum schedule_point_type
  {
    SCHED_NONE = 0,
    ORDINARY,
    SYNC_READ,
    SYNC_WRITE,
    SYNC_OUTSIDE,
    SYNC_REGION_END
  };

  struct Invariant
  {
    //all initialized to 0xDEADBEEF
    int gSyncVar_0;
    int gSyncVar_1;
    int gSyncVar_2;
    int gSyncVar_3;

    //initialize to NULL
    ExecutionState* state;
  };
  /// \todo Add a context object to keep track of data only live
  /// during an instruction step. Should contain addedStates,
  /// removedStates, and haltExecution, among others.

class Executor : public Interpreter, public ::cloud9::worker::SymbolicEngine {
  friend class BumpMergingSearcher;
  friend class MergingSearcher;
  friend class RandomPathSearcher;
  friend class OwningSearcher;
  friend class WeightedRandomSearcher;
  friend class SpecialFunctionHandler;
  friend class StatsTracker;
  friend class ObjectState;

public:
  class Timer {
  public:
    Timer();
    virtual ~Timer();

    /// The event callback.
    virtual void run() = 0;
  };

  typedef std::pair<ExecutionState*,ExecutionState*> StatePair;

private:
  class TimerInfo;

  KModule *kmodule;
  InterpreterHandler *interpreterHandler;
  Searcher *searcher;

  ExternalDispatcher *externalDispatcher;
  TimingSolver *solver;
  MemoryManager *memory;
  std::set<ExecutionState*> states;
  StatsTracker *statsTracker;
  ExprSerializer *exprRecorder;
  TreeStreamWriter *pathWriter, *symPathWriter;
  SpecialFunctionHandler *specialFunctionHandler;
  std::vector<TimerInfo*> timers;
  PTree *processTree;
  ExecutionState *activeState;

  /// whether all the sync regions saw so far reach fixed-point.
  /// Initialize to false.
  /// Set to true by the first sync region reaching fixed-point.
  /// Set to false if another sync region does not reach its fixed point after
  /// it is true.
  bool allRegionReachFixedPoint;
  int firstRegionReachFixedPoint;

  /// the number of valid invariant elements.
  unsigned int totalValid;

  /// the set of invariant and its state.
  std::vector<Invariant> invariantSet;
  typedef std::vector<Invariant>::iterator InvariantIterator;
  

  typedef int SyncRegionID;
  typedef map<SyncRegionID, set<SyncVarLogicalAddr> > SyncVarAddrSet;
  typedef map<ExecutionState*, SyncAddrRecord> SyncAddrRecords;
  typedef multimap<ExecutionState*, SyncRecord> SyncRecords;
  typedef pair<SyncRecords::iterator, SyncRecords::iterator> SyncRecordRange;
  
  //Record all the sync variable address for a given sync region. We assume
  //sync region is identified by a unique number, which is part of manual
  //annotation. Under such an assumption, we have the following facts:
  //1. when syncVarAddrSet[syncRegionID].size() is 0, it means this sync region
  //   has never been explored before. (Answer to: How to identify it is the first iteration
  //   for a sync variable? If the address cannot be found in syncVarAddSet[syncRegionID].)
  //2. when syncVarAddrSet[syncRegionID].size() is > 0, it means certain sync variables
  //    have been written in the previous exploration (it may be previous iteration or current
  //    iteration), and their initial values have been recorded somehow (as part of
  //    ExecutionState or Executor).
  //3. when syncVarAddrSet[syncRegionID].find(syncAddr) == syncVarAddrSet[syncRegionID].end(),
  //    syncAddr has not been recorded before.
  //    
  //Life time: After recording, it should not be cleared until the program finishes.
  //When to record: in the first iteration and Exploring time.
  //Major usage: 
  //1. to provide sync variable addresses at Beginning for later iterations.
  SyncVarAddrSet syncVarAddrSet;
  
  //dump sync addresses for all sync regions.
  void dumpSyncVarAddrSet();

  //Major usage: API recordSyncVarLocally. Check whether a sync variable's initial
  //            value has already been recorded when the sync region is explored in
  //            the first iteration.
  //when to record: in the first iteration and Exploring time.           
  //Life time: in the first iteration and in one region. It should be cleared after an
  //          invariant state is scheduled to explore the next sync region (when an 
  //          invariant state is forked, it is the time to clear it.
  SyncAddrRecords syncAddrRecords;
  
  //find out whether the current sync variable's initial value has already been recorded.
  //if it has not been recorded for the currentState, record it and return true.
  //otherwise, do nothing and return false.
  bool recordSyncVarLocally(ExecutionState* currentState, SyncVar& syncVar);
  
  void EraseSyncAddrRecords(ExecutionState *state)
  {
    SyncAddrRecords::iterator it = syncAddrRecords.find(state);
    if(it != syncAddrRecords.end())
    {
      syncAddrRecords.erase(it);
    }
  }

  //In any iteration, we want to see whether current <syncRegionID, executionContext, sync
  //variable initial values> have been recorded before. 
  //case 1: 1st iteration. The checking will fail at the first comparison, because there is
  //no region with such a syncRegionID. So, we have to record its <syncRegionID, executionContext>
  //at this point. However, at this point, we cannot record its sync variable value or address,
  //because we have not seen them yet. 

  //The global cache.
  //Global means it is accessible in Executor until program terminates.
  //It records executionContext, sync variable initial values, and other auxiliary information.
  //The idea is to compare syncRegionID, executionContext, sync variable in sequence as
  //shown in Algorithm 1. An ExecutionState may live across iterations, there must be a way
  //to distinguish the current iteration from all previous iterations, at least.
  //Why? How?
  //A: It seems there is no such a need. Because, later iteration already have all sync variable
  //    addresses recorded, and if it has different initial values or executionContext, all these
  //    information is obtained at Beginning. No Exploring time indexing with the current 
  //    ExecutionState is needed, because the comparison is based on syncRegionID, executionContext,
  //    and sync variable values (current iteration and unique values in previous iterations).
  //Life time: until program terminates and do not need clearing in the middle.
  //When to record: Exploring for the first iteration, Beginning for later iteration
  SyncRecords syncRecords;
  void RecordSync(ExecutionState* state, SyncRecord& record)
  {
    syncRecords.insert(make_pair(state, record));
  }

  //Update the entry of global cache for ExecutionState in sync region syncRegionID with
  //new sync variable syncVar.
  //Only used in first iteration.
  bool InsertSyncRecord(ExecutionState* state, int syncRegionID, SyncVar &syncVar);
  
  //set bDone to true for sync region explored in 1st iteration.
  void finalizeSyncRecord(ExecutionState* state, int regionID);
  
  void InsertSyncRecord(SyncRecord &syncRecord);
  
  //Check whether a sync region is the first time to be explored within an ExecutionState.
  bool isRegionFirstTimeExplored(int syncRegionID);
  
  //Check whether current sync region has been explored with the same ExecutionContext
  //and initial values for sync variables.
  bool isAFixedPoint(SyncRecord &syncRecord);

  //dump sync records.
  void dumpSyncRecords();

  //fill all the sync var initial values for the syncRecord.
  void FillValuesToSyncRecord(SyncRecord &syncRecord);

  /// All the states of which each corresponds to an unique invariant class.
  /// A state can be added to this set only after its invariant is not in the
  ///  current invariantSet.
  std::vector<ExecutionState*> invariantStates;

  /// Used to track states that have been added during the current
  /// instructions step. 
  /// \invariant \ref addedStates is a subset of \ref states. 
  /// \invariant \ref addedStates and \ref removedStates are disjoint.
  std::set<ExecutionState*> addedStates;
  /// Used to track states that have been removed during the current
  /// instructions step. 
  /// \invariant \ref removedStates is a subset of \ref states. 
  /// \invariant \ref addedStates and \ref removedStates are disjoint.
  std::set<ExecutionState*> removedStates;
  
  /// Map of globals to their representative memory object.
  std::map<const llvm::GlobalValue*, MemoryObject*> globalObjects;

  /// Map of globals to their bound address. This also includes
  /// globals that have no representative object (i.e. functions).
  std::map<const llvm::GlobalValue*, ref<ConstantExpr> > globalAddresses;

  /// The set of legal function addresses, used to validate function
  /// pointers. We use the actual Function* address as the function address.
  std::set<uint64_t> legalFunctions;

  /// Disables forking, instead a random path is chosen. Enabled as
  /// needed to control memory usage. \see fork()
  bool atMemoryLimit;

  /// Disables forking, set by client. \see setInhibitForking()
  bool inhibitForking;

  /// Signals the executor to halt execution at the next instruction
  /// step.
  bool haltExecution;  

  /// Whether implied-value concretization is enabled. Currently
  /// false, it is buggy (it needs to validate its writes).
  bool ivcEnabled;

  /// The maximum time to allow for a single stp query.
  double stpTimeout;
  double instrTime;

  llvm::Function* getCalledFunction(llvm::CallSite &cs, ExecutionState &state);

  /// For debugging
  void DumpStateSet() __attribute__((noinline))
  {
    unsigned int num = 0;
    for(std::set<ExecutionState*>::iterator it=states.begin(), ie = states.end();
        it != ie; ++it)
    {
      num++;
      ExecutionState *state = *it;
      std::cout << "State: "<<num <<"\t, "<< state << "\t\n" <<std::endl;
      std::cout << "\t == Call Stack ==\n";
      //state->getStackTrace().dump();
      state->dumpStacks();
    }

    std::cout <<std::endl;
    std::cout <<"\tTotal: "<<num <<"states\n";
  }

  void DumpStates();
 
  void dumpStack(); 
  void dumpLocals();

  void executeInstruction(ExecutionState &state, KInstruction *ki);

  void printFileLine(ExecutionState &state, KInstruction *ki);

  void run(ExecutionState &initialState);

  // Given a concrete object in our [klee's] address space, add it to 
  // objects checked code can reference.
  MemoryObject *addExternalObject(ExecutionState &state, void *addr, 
                                  unsigned size, bool isReadOnly);

  void initializeGlobalObject(ExecutionState &state, ObjectState *os, 
            const llvm::Constant *c,
            unsigned offset);
  void initializeGlobals(ExecutionState &state);

  void stepInstruction(ExecutionState &state);
  void updateStates(ExecutionState *current);
  void finalizeRemovedStates();

  void transferToBasicBlock(llvm::BasicBlock *dst, 
          llvm::BasicBlock *src,
          ExecutionState &state);

  void callExternalFunction(ExecutionState &state,
                            KInstruction *target,
                            llvm::Function *function,
                            std::vector< ref<Expr> > &arguments);

  void callUnmodelledFunction(ExecutionState &state,
                            KInstruction *target,
                            llvm::Function *function,
                            std::vector<ref<Expr> > &arguments);

  ObjectState *bindObjectInState(ExecutionState &state, const MemoryObject *mo,
                                 bool isLocal, const Array *array = 0);

  /// Resolve a pointer to the memory objects it could point to the
  /// start of, forking execution when necessary and generating errors
  /// for pointers to invalid locations (either out of bounds or
  /// address inside the middle of objects).
  ///
  /// \param results[out] A list of ((MemoryObject,ObjectState),
  /// state) pairs for each object the given address can point to the
  /// beginning of.
  typedef std::vector< std::pair<std::pair<const MemoryObject*, const ObjectState*>, 
                                 ExecutionState*> > ExactResolutionList;

  void resolveExact(ExecutionState &state,
                    ref<Expr> p,
                    ExactResolutionList &results,
                    const std::string &name);

  /// Allocate and bind a new object in a particular state. NOTE: This
  /// function may fork.
  ///
  /// \param isLocal Flag to indicate if the object should be
  /// automatically deallocated on function return (this also makes it
  /// illegal to free directly).
  ///
  /// \param target Value at which to bind the base address of the new
  /// object.
  ///
  /// \param reallocFrom If non-zero and the allocation succeeds,
  /// initialize the new object from the given one and unbind it when
  /// done (realloc semantics). The initialized bytes will be the
  /// minimum of the size of the old and new objects, with remaining
  /// bytes initialized as specified by zeroMemory.
  void executeAlloc(ExecutionState &state,
                    ref<Expr> size,
                    bool isLocal,
                    KInstruction *target,
                    bool zeroMemory=false,
                    const ObjectState *reallocFrom=0);

  /// Free the given address with checking for errors. If target is
  /// given it will be bound to 0 in the resulting states (this is a
  /// convenience for realloc). Note that this function can cause the
  /// state to fork and that \ref state cannot be safely accessed
  /// afterwards.
  void executeFree(ExecutionState &state,
                   ref<Expr> address,
                   KInstruction *target = 0);
  
  void executeCall(ExecutionState &state, 
                   KInstruction *ki,
                   llvm::Function *f,
                   std::vector< ref<Expr> > &arguments);
                   
  // do address resolution / object binding / out of bounds checking
  // and perform the operation
  void executeMemoryOperation(ExecutionState &state,
                              bool isWrite,
                              ref<Expr> address,
                              ref<Expr> value /* undef if read */,
                              KInstruction *target /* undef if write */);

  void executeMakeSymbolic(ExecutionState &state, const MemoryObject *mo,
      bool shared=false);

  void executeEvent(ExecutionState &state, unsigned int type,
      long int value);

  /// Create a new state where each input condition has been added as
  /// a constraint and return the results. The input state is included
  /// as one of the results. Note that the output vector may included
  /// NULL pointers for states which were unable to be created.
  void branch(ExecutionState &state,
              ref<Expr> condition,
              const std::vector< std::pair< BasicBlock*, ref<Expr> > > &options,
              std::vector< std::pair<BasicBlock*, ExecutionState*> > &branches, int reason);

  // Fork current and return states in which condition holds / does
  // not hold, respectively. One of the states is necessarily the
  // current state, and one of the states may be null.
  StatePair fork(ExecutionState &current, ref<Expr> condition, bool isInternal, int reason);
  StatePair fork(ExecutionState &current, int reason);
  ForkTag getForkTag(ExecutionState &current, int reason);

  /// Add the given (boolean) condition as a constraint on state. This
  /// function is a wrapper around the state's addConstraint function
  /// which also manages manages propogation of implied values,
  /// validity checks, and seed patching.
  void addConstraint(ExecutionState &state, ref<Expr> condition);

  // Called on [for now] concrete reads, replaces constant with a symbolic
  // Used for testing.
  ref<Expr> replaceReadWithSymbolic(ExecutionState &state, ref<Expr> e);

  const Cell& eval(KInstruction *ki, unsigned index, 
                   ExecutionState &state) const;

  Cell& getArgumentCell(ExecutionState &state,
                        KFunction *kf,
                        unsigned index) {
    return state.stack().back().locals[kf->getArgRegister(index)];
  }

  Cell& getArgumentCell(StackFrame &sf, 
      KFunction *kf, 
      unsigned index) {
    return sf.locals[kf->getArgRegister(index)];
  }

  Cell& getDestCell(ExecutionState &state,
                    KInstruction *target) {
    return state.stack().back().locals[target->dest];
  }

  void bindLocal(KInstruction *target, 
                 ExecutionState &state, 
                 ref<Expr> value);
  void bindArgument(KFunction *kf, 
                    unsigned index,
                    ExecutionState &state,
                    ref<Expr> value);

  ref<klee::ConstantExpr> evalConstantExpr(const llvm::ConstantExpr *ce);

  /// Return a unique constant value for the given expression in the
  /// given state, if it has one (i.e. it provably only has a single
  /// value). Otherwise return the original expression.
  ref<Expr> toUnique(const ExecutionState &state, ref<Expr> &e);

  /// Return a constant value for the given expression, forcing it to
  /// be constant in the given state by adding a constraint if
  /// necessary. Note that this function breaks completeness and
  /// should generally be avoided.
  ///
  /// \param purpose An identify string to printed in case of concretization.
  ref<klee::ConstantExpr> toConstant(ExecutionState &state, ref<Expr> e, 
                                     const char *purpose);

  /// Bind a constant value for e to the given target. NOTE: This
  /// function may fork state if the state has multiple seeds.
  void executeGetValue(ExecutionState &state, ref<Expr> e, KInstruction *target);

  /// Get textual information regarding a memory address.
  std::string getAddressInfo(ExecutionState &state, ref<Expr> address) const;

  // remove state from queue and delete
  bool terminateState(ExecutionState &state, bool silenced);
  // call exit handler and terminate state
  void terminateStateEarly(ExecutionState &state, const llvm::Twine &message);
  // call exit handler and terminate state
  void terminateStateOnExit(ExecutionState &state);
  // call error handler and terminate state
  void terminateStateOnError(ExecutionState &state, 
                             const llvm::Twine &message,
                             const char *suffix,
                             const llvm::Twine &longMessage="");

  // call error handler and terminate state, for execution errors
  // (things that should not be possible, like illegal instruction or
  // unlowered instrinsic, or are unsupported, like inline assembly)
  void terminateStateOnExecError(ExecutionState &state, 
                                 const llvm::Twine &message,
                                 const llvm::Twine &info="") {
    terminateStateOnError(state, message, "exec.err", info);
  }

  /// bindModuleConstants - Initialize the module constant table.
  void bindModuleConstants();

  template <typename TypeIt>
  void computeOffsets(KGEPInstruction *kgepi, TypeIt ib, TypeIt ie);

  /// bindInstructionConstants - Initialize any necessary per instruction
  /// constant values.
  void bindInstructionConstants(KInstruction *KI);

  void handlePointsToObj(ExecutionState &state, 
                         KInstruction *target, 
                         const std::vector<ref<Expr> > &arguments);

  void doImpliedValueConcretization(ExecutionState &state,
                                    ref<Expr> e,
                                    ref<ConstantExpr> value);

  /// Add a timer to be executed periodically.
  ///
  /// \param timer The timer object to run on firings.
  /// \param rate The approximate delay (in seconds) between firings.
  void addTimer(Timer *timer, double rate);

  void initTimers();
  void processTimers(ExecutionState *current);
  void resetTimers();

  /// Pthread create needs a specific StackFrame instead of the one of the current state
  void bindArgumentToPthreadCreate(KFunction *kf, unsigned index, 
           StackFrame &sf, ref<Expr> value);

  /// Finds the functions coresponding to an address.
  /// For now, it only support concrete values for the thread and function pointer argument.
  /// Can be extended easily to take care of symbolic function pointers.
  /// \param address address of the function pointer
  KFunction* resolveFunction(ref<Expr> address);


  //pthread handlers
  void executeThreadCreate(ExecutionState &state, thread_id_t tid,
      ref<Expr> start_function, ref<Expr> arg);

  void executeThreadExit(ExecutionState &state);
  
  void executeProcessExit(ExecutionState &state);
  
  void executeProcessFork(ExecutionState &state, KInstruction *ki,
      process_id_t pid);

  //Design 1:
  //we want to use sleep(1) to mark a scheduling point for a shared memory
  //read/write in an ad hoc sync, while using sleep(2) to mark a busy-wait
  //scheduling point. For the latter, the thread invoking sleep(2) will not
  //be scheduled until all the other threads have invoked sleep(2). E.g, there are
  //3 threads. Thread 1 invokes sleep(2) and will be disabled without rescheduled immediately.
  //Thread 2 invokes sleep(2) and the same happens. Now Thread 1 and 2 are disabled because 
  //they have invoked sleep(2). Only Thread 3 can be scheduled. Thread 3 schedules itself
  //again and again until it invokes sleep(2). Now, there is no other thread schedulable.
  //Because all of them invoked sleep(2). At this time, we enable all of them. And the scheduling
  //continues as normal. 
  //
  //Design 2:
  //However, this cannot covers all the possible schedulings. In order to
  //enumerate all the possible interleavings, we also have to mark sync variable write with sleep(3).
  //sleep(1): shared memory read/write
  //sleep(2): sync variable read in sync-loop(busy-wait loop)
  //sleep(3): sync variable write.
  //If a thread invokes sleep(2), it will be disabled.
  //If a thread invokes sleep(1), scheduler performs as normal. The thread is still enabled and eligible
  //for being scheduled.
  //If a thread invokes sleep(3), it will enable all the threads which were disabled because of invoking
  //sleep(2).
  //Even the second design is flawed. If the ad hoc sync is not a barrier(the last thread must invoke sleep(3) and
  //enable all the other threads having invoked sleep(2)), then the scheduler is broken. In fact, we should not
  //make any assumption about which thread invokes sleep(3) but to record the fact whether any thread has already
  //invoked sleep(3). Thus, the only assumption we make is: firstAB and lastAB(barrier) are instances of iAB, where
  //i can be any single thread perform the release operation.
  //
  //Design 3:
  //Therefore, the scheduler has to record whether any thread has invoked sleep(3). If not, any thread invokes sleep(2)
  //will be disabled. After any thread invokes sleep(3), all the threads having been disabled because of sleep(2) will
  //be enabled and any thread invokes sleep(2) thereafter will not be disabled.
  //
  //The above design is not engineering-oriented but idea-verification-oriented. We do not care about engineering
  //discipline as much as the prototype's capability to sufficiently verify our idea. The ideal design should reuse
  //the interpreter's special function handler mechanism and materialize sleep(1), sleep(2), and sleep(3) as three
  //new functions; and the declaration of schedule() should not be changed.
#if 0 
  bool schedule(ExecutionState &state, bool yield);
#else
  bool schedule(ExecutionState &state, bool yield, schedule_point_type schedule_type = SCHED_NONE);
#endif

  void executeThreadNotifyOne(ExecutionState &state, wlist_id_t wlist);

  void executeFork(ExecutionState &state, KInstruction *ki, uint64_t reason);

public:
  Executor(const InterpreterOptions &opts, InterpreterHandler *ie);
  virtual ~Executor();

  const InterpreterHandler& getHandler() {
    return *interpreterHandler;
  }

  // XXX should just be moved out to utility module
  ref<ConstantExpr> evalConstant(const llvm::Constant *c);

  virtual void setPathWriter(TreeStreamWriter *tsw) {
    pathWriter = tsw;
  }
  virtual void setSymbolicPathWriter(TreeStreamWriter *tsw) {
    symPathWriter = tsw;
  }      

  virtual const llvm::Module *
  setModule(llvm::Module *module, const ModuleOptions &opts);
  
  const KModule* getKModule() const {return kmodule;} 

  virtual void runFunctionAsMain(llvm::Function *f,
                                 int argc,
                                 char **argv,
                                 char **envp);

  /*** Runtime options ***/
  
  virtual void setHaltExecution(bool value) {
    haltExecution = value;
  }

  virtual void setInhibitForking(bool value) {
    inhibitForking = value;
  }

  /*** State accessor methods ***/

  virtual unsigned getPathStreamID(const ExecutionState &state);

  virtual unsigned getSymbolicPathStreamID(const ExecutionState &state);

  virtual void getConstraintLog(const ExecutionState &state,
                                std::string &res,
                                bool asCVC = false);

  virtual bool getSymbolicSolution(const ExecutionState &state, 
                                   std::vector< 
                                   std::pair<std::string,
                                   std::vector<unsigned char> > >
                                   &res);

  Expr::Width getWidthForLLVMType(llvm::Type *type) const;

  void PrintDump(std::ostream &os);
  void PrintDumpOnErrorSignal();

  /*** Cloud9 symbolic execution engine methods ***/

  virtual ExecutionState *createRootState(llvm::Function *f);
  virtual void initRootState(ExecutionState *state, int argc, char **argv, char **envp);

  virtual void stepInState(ExecutionState *state);

  virtual void destroyStates();

  virtual void destroyState(klee::ExecutionState *state);

  virtual klee::Searcher *initSearcher(klee::Searcher *base);

  virtual klee::KModule *getModule() {
    return kmodule;
  }

  //Hack for dynamic cast in CoreStrategies, TODO Solve it as soon as possible
  static bool classof(const SymbolicEngine* engine){ return true; }

public:
  std::vector<ExecutionState*> & getInvariantStates(void)
  {
    return invariantStates;
  }

  unsigned int & getTotalValid(void)
  {
    return totalValid;
  }

  void setTotalValid(unsigned int total)
  {
    totalValid = total;
  }

  std::vector<Invariant>& getInvariantSet(void)
  {
    return invariantSet;
  }

  //Invariant derivation and interleaving reduction for
  //equivalent states.
  bool findInvariant(Invariant invariant);

  ExecutionState* getCurrentActiveState(void)
  {
    return activeState; 
  }

  unsigned int getSizeOfStates(void)
  {
    return states.size();
  }

  StatsTracker *getStatsTracker(void)
  {
    return statsTracker;
  }
};
  
} // End klee namespace

#endif
