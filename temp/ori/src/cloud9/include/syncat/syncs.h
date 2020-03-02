#ifndef __SYNCS_H__
#define __SYNCS_H__

#include "klee/ExecutionState.h"
#include "klee/Expr.h"
#include "klee/util/Ref.h"
#include "klee/Internal/Module/KModule.h"

#include "../../lib/Core/Memory.h"

#include <vector>
#include <map>
#include <set>

using namespace std;
using namespace klee;

namespace syncat {

struct SyncVar
{
  int value; //sufficient for sync var, int or bool.
  
  const MemoryObject *mo; //logical address base
  ref<Expr> offset; //logical address offset
  Expr::Width type; //Data type(width, # of bits).
  
  //sync variable logic address. It is the same to MemoryObject->address + offset.
  //And it is the same across different enumerated interleaving states.
  uint64_t addr;
  
  uint64_t getEffectiveAddress() const
  {
    return addr;
  }

  void dump()
  {
    std::cout <<"Address: " <<addr <<", Value: " << value <<std::endl;
  }
};

//Which context to record?
//Answer: when the number of participating threads is 2, 
//We only record two contexts. Both are derived from the previous invariant interleaving state.
//Specifically, since there is a scheduling point between two consecutive sync regions, and the
//invariant state is the last scheduled state when all the enumerated states have been explored
//and killed due to their identity to the invariant state, there will be two states derived from
//the only invariant state when the beginning of the next new sync region is hit. There must be
//marking on them to respect the fact that they are derived from the last sync region. 
//After recording the context when each hits the beginning of the sync region, their marking
//should still be kept and should not be erased until all their sync variable initial values have
//been recorded. The other newly enumerated states should not perform the recording. 
//
//How can we distinguish the two or many contexts/states so that their sync variable values are
//recorded accordingly? 
//  Answer: we can assign an ID to distinguish them. This indicates there are more than 1 sync 
//  context. Each context has its own sync variable recording, and they may be the same. There
//  is no need to figure out which iteration they belong to, just push them into sync-region-specific
//  vector.
//
//When to assign the ID?
//  Answer: when an invariant state's first forking(enumeration) happens. 
//  This indicates we have
//  to mark which state is an invariant state. A new field: bInvariantState for each state.
//
//How can we know when all the sync variables have been recorded?
//  Answer: we don't know when all sync variables have been recorded. But we employ the fact that
//  only invariant state will survive after interleaving reduction. So, whenever we establish a
//  state as an invariant state, we set up its marking. Second, when a new state is enumerated, 
//  we clear its marking.
//
//How to encode the context? What operations are to perform?
//  Answer: encode the context as stackTrace.
//  Answer: operator == to check whether two contexts are the same.
//
//What should be included in ExecutionContext?
//  Answer: stackTrace (functions, PCs).
//
//Do we need the ID for different ExecutionState?
//  Answer: we can also use their address as the key to index them. 
//  Map<ExecutionState*, syncRecord>. Given a new state derived from the previous invariant state,
//  we first record its context when the first thread arrives at the beginning of the current sync region.
//  Then, we record its sync variable address and value as the first time we perform write to them.
//
//How to determine whether we have explored the sync region?
//  Answer: if the stackTrace of the current state is the same as that of one execution state which
//  has been explored previously, and the sync variables have the same initial values, we can set
//  bEnumerated (per-execution state) to false so that there will be no new forking of this state.
//
//How to determine the number of sync variables for the current sync region?
//  Answer: we should maintain a set of all the sync variable addresses for each sync region.
//  map<int, set<syncVarAddr>> syncVarAddrSet;
//
//How to determine the mapping from address to a sync variable?
//  Answer: we do not have such a mapping. Instead, address of an sync variable is treated as
//  the identifier of a sync variable.


//Auxiliary field to ExecutionState
//bool bRecording; //initialized to false. Set to true when recordSyncVar() API is handled.
//used at store instruction interpretation, and set to false again there.
//
//bool bEnumerating; //(initialized to true. If a previous syncRecord with the same execution
//execution context and sync variable values is found, it would be set to false. It is
//accessed before any ExecutionState is being forked. If false, no new state will be enumerated.
//
//bool bInvariantState; //initialized to false. When a state is installed as an invariant state,
//it is set to true. States forked directly by invariant states are invariant states.
//
//bool bDirectDescendent; //initialize to false. When a state is installed as an invariant state, it is
//set to true. States forked by an invariant state where bDirectDescendent is true is an invariant state
//(its bInvariantState is set to true), but their bDirectDescendent will be set to false. 
//
//Combining bInvariantState and bDirectDescendent, we can achieve the following effects:
//1. The descendents of an invariant state whose bDirectDescendent is true, are also invariant states.
//    their bInvariant is set to true, and their bDirectDescendent is set to false.
//2. The descendents of an invairant state whose bDirectDescendent is false, are not an invariant state.
//    their bInvariant is set to false, and their bDirectDescendent is set to false.
//3. Only invariant states are compared againts previous sync records to figure out whether they
//   have been explored before. If explored, their bEnumerating is set to false to disable any
//   interleaving enumeration on them.
//4. Only invariant state at the beginning of a sync region are examined in 3.
//5. Only values and addresses of an invariant state at the beginning of a sync region are examined
//   or recorded in 3.

struct SyncVarLogicalAddr
{
  const MemoryObject *mo; //logical address base
  ref<Expr> offset;       //logical address offset
  Expr::Width type;

  bool operator < (const SyncVarLogicalAddr& B) const
  {
    uint64_t addrA = mo->address + dyn_cast<ConstantExpr>(offset)->getSExtValue(64);
    uint64_t addrB = B.mo->address + dyn_cast<ConstantExpr>(B.offset)->getSExtValue(64);

    return addrA < addrB;
  }

  uint64_t getEffectiveAddress() const
  {
    return mo->address + dyn_cast<ConstantExpr>(offset)->getSExtValue(64);
  }
};


//map from sync variable address to sync variable control records.
typedef uint64_t SyncVarAddr;
typedef int SyncVarValue;
typedef map<SyncVarAddr, SyncVar> SyncVarMap; 

//simplified ExecutionState
struct ExecutionContext
{
  //which thread is currently running.
  int runningThreadId;

  //how many threads are there.
  int numThreads;
  
  typedef pair<KFunction*, const KInstruction*> Position;
  typedef vector<Position> CallStack;

  //Call stack for the running thread.
  CallStack curCallStack;

  //map from thread ids to their call stacks.
  //for other suspending threads.
  map<uint64_t, CallStack> threadCallStacks;

  ExecutionContext(): runningThreadId(-1), numThreads(0) { }

  void dump()
  {
    std::cout << "Current Thread:" << std::endl;
    dumpCallStack(curCallStack);
    std::cout << "Stacks for current thread end--------\n";

    map<uint64_t, CallStack>::const_iterator ib=threadCallStacks.begin(), ie=threadCallStacks.end();
    for( ; ib != ie; ++ib)
    {
      std::cout << "Stacks for one thread begin--------\n";
      dumpCallStack(ib->second);
      std::cout << "Stacks for one thread end--------\n";
    }
  }

  void dumpCallStack(const CallStack &A)
  {
    CallStack::const_iterator ibA=A.begin(), ieA=A.end();

    for( ; ibA != ieA; ++ibA)
    {
      KFunction *kFunction = ibA->first;
      Function* function = kFunction->function;
      std::cout<< function->getName().str() << std::endl;
      std::cout<< "PC: \n";
      ibA->second->inst->dump();
    }
  }


  bool operator == (const ExecutionContext& context) const
  {
    if(numThreads != context.numThreads || threadCallStacks.size() != context.threadCallStacks.size())
    {
      return false;
    }

    if(!isCallStackEquivalent(curCallStack, context.curCallStack, true))
    {
      return false;
    }
    
    map<uint64_t, CallStack>::const_iterator ib=threadCallStacks.begin();
    map<uint64_t, CallStack>::const_iterator ie=threadCallStacks.end();
    map<uint64_t, CallStack>::const_iterator ibContext=context.threadCallStacks.begin();
    for( ; ib != ie; ++ib, ++ibContext)
    {
      if(!isCallStackEquivalent(ib->second, ibContext->second, false))
      {
        return false;
      }
    }

    return true;
  }

  private:
  //Ignoring their arguments, whether there are equal
  //Note: call stack comparison can be done in two ways:
  //1. Two call stacks are considered the same if and only if they have the same number of
  //  frames and each frame is the same.
  //2. Two call stacks are considered the same if their top frames (latest one) are in the same
  //  function. Since we consider a sync region's behavior only depends on sync variables, no
  //  side effects of local variables or function arguments would affect it.
  bool isCallStackEquivalent(const CallStack& A, const CallStack& B, bool bCurrent) const
  {
#if 0
    if(A.size() != B.size())
      return false;
#endif

    CallStack::const_iterator ibA=A.begin(), ieA=A.end();
    CallStack::const_iterator ibB=B.begin(), ieB=B.end();
    for( ; (ibA != ieA && ibB != ieB); ++ibA, ++ibB)
    {
      if(bCurrent)
      {
        bCurrent = false;
        //skip checking CheckInvariant.
        continue;
      }
      else
      {
        if(ibA->first == ibB->first && ibA->second == ibB->second)
        {
          continue;
        }
        else
        {
          return false;
        }
      }
    }

    return true;
  }
};

//From sync region ID to the set of sync variable addresses.
//map<int, set<syncVarAddr> > syncVarAddrSet; 

//One sync region can correspond to several Execution States in one iteration.
//ExecutionState *state is used as a key to differentiate them.
//
//One Execution State has only one Execution context.
//One Execution State may access several sync variables.
//One sync variable, in one iteration, has only one value.
//The same execution context may be seen in multiple iterations, in the same sync region,
//and with different values. We should have different records for them.
struct SyncRecord
{
  //Execution context
  ExecutionContext executionContext;

  //sync variables(identified by their address) and their values
  //one execution state may have several sets of initial values.
  //They are recorded as different syncRecords.
  SyncVarMap syncVarMap;

  //state is used to identify different execution state in the same sync region.
  ExecutionState* state;

  //Whether the state has been terminated.
  bool bKilled;

  //sync region ID. Debugging purpose.
  int syncRegionID; //auxiliary field.

  //whether the exploration in the current region is finished.
  //Initialize to false; set to true when invariant derivation happens or when
  //a record is initialized in a later iteration.
  //Used to check whether a region has been explored before.
  bool bDone;

  void dump()
  {
    std::cout << "Region ID: "<< syncRegionID << std::endl;
    std::cout << "bDone: " <<bDone <<std::endl;
    std::cout << "state: " << state <<std::endl;

    //dump sync var map.
    SyncVarMap::iterator it=syncVarMap.begin(), ie=syncVarMap.end();
    for( ; it != ie; ++it)
    {
      it->second.dump();
    }

    //dump execution context.
    executionContext.dump();
  }
};

struct SyncAddrRecord
{
  ExecutionState* state;
  int syncRegionID;

  //once sync var's initial value has been recorded, it will be pushed
  //into syncVarMap.
  SyncVarMap syncVarMap;
};

//map from ExecutionState in the same sync region to their corresponding record.
//ExecutionState* is only valid when the corresponding ExecutionState is alive.
//An ExecutionState is alive only when its corresponding sync region is being explored.
//After entering a new sync region, all the ExecutionStates alive in the previous sync region,
//except the invariant states, are all killed due to interleaving reduction.
//Thus, this map is used to map an ExecutionState* to its corresponding sync record when the
//ExecutionState is alive. But its syncRecord lives until the program is terminated. The other
//way to use this map is to iterate all sync records as if they are in a vector.
//
//The usage as a map is to distinguish different ExecutionStates and corresponding syncRecord,
//because ExecutionStates are scheduled by Cloud9 according allocated time quota. If ExecutionState
//context swith happens, Cloud9 has to make sure the corresponding sync record is being updated.
//
//The uage as a vector is to identify whether a sync record is the same as that of the ExecutionState
//being explored. 
//
//Algorithm 1:
//The algorithm is as following (Happen at the beginning of a sync region).
//step 0. Get the next sync record.
//step 1. use syncRecord.syncRegionID to check whether the sync record is for the sync region being
//        explored. If not, go to step 0. Othersise, go to step 2.
//step 2. check whether their executionContexts are the same. If not, go to step 0.
//        Otherwise, go to step 3.
//step 3. use syncID->syncVarAddr map to find all the sync variable addresses for the current sync
//        region.
//step 4. compare corresponding sync variable's value. If they are the same, then set bEnumerating
//        to false. Otherwise, go to step 0.
//
//If no such a sync record is found, either due to first time exploration or it has not been explored
//with current sync variable valuations, then create a new blank sync record as follows
//1. set syncRegionID to the current sync region ID.
//2. set ExecutionState* state to current ExecutionState's address.
//3. set executionContext to current execution context, including all threading call stacks.
//Note: since no sync variable access has happened yet, there is no way to fill syncVarMap.
//      It is simply left as empty. Later on, to decide whether a sync variable has been
//      explored, it is sufficient to check whether its address can be found in syncVarMap.
//      If found, it means, its initial value has been recorded; Otherwise, its value has
//      not been recorded and needs to be recorded.
//
//If SyncVarAddrSet is empty for current sync region, it indicates that the current sync region
//has not been explored before and there is no sync var address recorded. Then, we cannot access
//its initial values.
//
//Algorithm 2:
//Later on, just before a write to a sync variable happens, we retrieve its syncRecord.
//And extract sync var address and retrieve its value,
//Then, store it into the syncRecord.
//Thus, record API:
//1. Instrumented by Front end as recordSyncVar(%addr). Very similar to snapshot()
//2. Interpreted by Cloud9. (Similar to a Load instruction)
//    record the %addr
//    retrieve and store its value
//OR:
//1. Instrumented by Front end as recordSync(), without parameters.
//2. Interpreted by Cloud9.
//  set bRecording to true. (bRecording initialized to false per-executionstate)
//  when Cloud9 sees the next store instruction,
//    record the %addr
//    retrieve and store its value
//    set bRecording to false
//    perform its normal store as original.
//
//Note:  the executionState context switch does not matter, because we use
//        executionState address to index their corresponding record. And we
//        do not need to track executionstate as part of record or store instruction.

//Algorithm 3: set bEnumerating, bInvariantState, bDirectDescendent and bRecording properly.
//
//
//typedef map<ExecutionState*, syncRecord> SyncRecords;
//SyncRecords syncRecords;

} //end syncat namespace

#endif
