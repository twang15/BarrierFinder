#ifndef __VALUE_RANGE_PROPAGATION_H__
#define __VALUE_RANGE_PROPAGATION_H__

#include "llvm/IR/Module.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Constants.h"
#include "llvm/ADT/PostOrderIterator.h"
#include "llvm/ADT/SetOperations.h"
#include "llvm/ADT/SetVector.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/IR/CFG.h"

#include "utility.h"
using namespace llvm;
using namespace Util;

namespace vrp {
  struct valueRange 
  {
    bdSet propagateDRC(Function *func, DRC *drc, BasicBlock *referenceBB);

    typedef std::pair<const BasicBlock*, bbData*> bType;
    typedef std::map<const BasicBlock *, bbData*> BBMap;
    typedef SetVector<const BasicBlock*> WorkList;
    typedef SmallVector<Pointer, 10> DRCSet;

    bool IdentifyGep(const Instruction *ins, DRC *drc);
    void dumpBBMap(BBMap &map);
    void dumpDRCSet(DRCSet &drcSet);
  };
}

#endif
