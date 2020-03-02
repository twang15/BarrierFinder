#include "klee/Executor.h"
namespace klee {

  void Executor::DumpStates() __attribute__((noinline))
  {
    for(std::set<ExecutionState*>::iterator it=states.begin(), ie = states.end();
        it != ie; ++it)
    {
      ExecutionState *state = *it;
      std::cout << "((klee::ExecutionState *) "<< state <<")" 
                << "\tInvariant: " << state->bInvariantState 
                << "\tDirect: " << state->bDirectDescendent
                << "\tEnumerating: " << state->bEnumerating
                << "\tDumpTrace: " << state->bDumpTrace << std::endl;
    }
  }
  
  void Executor::dumpSyncVarAddrSet()
  {
    for(SyncVarAddrSet::iterator it=syncVarAddrSet.begin(), ie=syncVarAddrSet.end();
        it != ie; ++it)
    {
      std::cout <<"Sync Region: " <<it->first <<std::endl;

      int i=0;
      for(set<SyncVarLogicalAddr>::iterator sb=it->second.begin(), se=it->second.end(); 
          sb != se; ++sb)
      {
        std::cout <<"Addr "<< i <<": " <<sb->getEffectiveAddress() << std::endl;
        i++;
      }

      std::cout <<std::endl;
    }
  }

  void Executor::dumpSyncRecords()
  {
    SyncRecords::iterator ib = syncRecords.begin(), ie = syncRecords.end();

    for( ; ib != ie; ++ib)
    {
      std::cout <<"======================\n";
      ib->second.dump();
    }
  }

}
