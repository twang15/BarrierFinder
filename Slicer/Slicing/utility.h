#ifndef __UTILITY__
#define __UTILITY__
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Constants.h"
#include "llvm/ADT/SetOperations.h"
#include "llvm/IR/CFG.h"
#include <map>
#include <set>

using namespace llvm;
using namespace std;

namespace Util {

  enum RangeType
  {
    SINGLE = 0,
    MULTIPLE = 1,
    HALF_POSITIVE = 2,
    WILD_GUESS = 3
  };

  typedef void* Pointer;
  typedef set<ConstantInt*> bdSet;
  struct Ranges
  {
    bdSet values;
    unsigned int num;
    RangeType type;
  };

  /*representation of De-Reference Chain.*/
  class DRC {
    public:

      bool operator == (DRC &other)
      {
        return (drc == other.drc);
      }

      void push_back(Pointer pointer)
      {
        drc.push_back(pointer);
      }

      int size() const
      {
        return drc.size();
      }

      void setAccessType(bool read)
      {
        bRead = read;
      }

      bool getAccessType()
      {
        return bRead;
      }

      Pointer operator[](int idx)
      {
        assert(idx >= 0 && "Index should not be less than 0 !");
        return drc[idx];
      }

      void __attribute__ ((noinline)) dump();
      void clear();//clear the DRC
      bool isOnHeap();//Heap or Global memory. Do not consider stack memory.
      bool isConstant();//For a write drc. Whether it stores a constant.
      const ConstantInt *getValue();//For a write drc. Return its constant value.
      void setValue(const ConstantInt *cv);
      void setInsContext(const Instruction *ins);
      const Instruction * getInsContext();

      void setCallContext(const Instruction * call);
      const Instruction * getCallContext();

    public:
      DRC() { bRead = true; insContext = NULL; callContext = NULL;}
      DRC(DRC& other)
      {
        bRead = other.bRead;
        drc = other.drc;
        bConstant = other.bConstant;
        value = other.value;
        insContext = other.insContext;
        callContext = other.callContext;
      }
      virtual ~DRC(){}

    private:
      SmallVector<Pointer, 10> drc;
      bool bRead;//Read or Write ?
      bool bConstant;// For a write DRC, constant ?
      const ConstantInt *value; //Null for non-const.

      //The instruction context. The BB containing this drc
      //can be obtained by insContext->getParent, so we
      //do not need a pointer to the BB.
      const Instruction *insContext;      
      const Instruction *callContext; //the root call-site
  };
  
  enum KillDef
  {
    KILL_UNKNOWN = 0,
    KILL_OTHERS,
    KILL_EMPTY
  };

  struct bbData
  {
    ConstantInt* Gen; //Can only generate one def(sequence number).
    KillDef Kill; //Kill nothing or all the others.
    bdSet In;
    bdSet Out;

    void dump();
    void dumpSet(bdSet &vec);
  };
  
  typedef set<DRC*> SetOfDRC;
  
  enum scheduleType
  {
    schedule_ordinary_read = 0,
    schedule_ordinary_write,
    schedule_read,
    schedule_write
  };

  struct SchedulePoint
  {
    scheduleType type;
    Instruction* context; //the instruction following scheduling function.
  };

  typedef vector<SchedulePoint> SchedulePointSet;
  typedef SmallVector <BasicBlock*, 2> LoopBBSet;

  struct Sync
  {
    //Get filled in findAllCriteria() 
    unsigned int id;
    Instruction * readCriteria;
    Instruction* end; //last instruction, read-side criteria.
    Instruction *writeCriteria;
    
    LoopBBSet readLoopBBSet;
    BasicBlock* loopLatchBB;
    Instruction *writeInst; //the write to sync var, instruction before writeCriteria.
    Instruction *readLoopExitBranch; //the branch instruction to loop exit bb.

    Function *readSideFunction;
    Function *writeSideFunction;

    bool bInSameFunction;
    
    //Filled when boundary detection happens.
    Instruction* begin; //first instruction
    //Instruction* end; //last instruction, read-side criteria.
    SetOfDRC syncVars; //all the exposed sync variables.
    typedef set<BasicBlock*> SyncBBSet;
    SyncBBSet bbSet; //all the bbs.

    //scheduling points <Instruction*, type(ordinary, readLoop, write)>
    SchedulePointSet schedulePointSet;
  };
}


#endif

