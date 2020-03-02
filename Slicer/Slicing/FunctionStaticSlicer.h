// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.

#ifndef SLICING_FUNCTIONSTATICSLICER_H
#define SLICING_FUNCTIONSTATICSLICER_H

#include <map>
#include <utility> /* pair */

#include "llvm/IR/Value.h"
#include "llvm/ADT/SetVector.h"
#include "llvm/IR/InstIterator.h"

#include "../PointsTo/PointsTo.h"
#include "../Modifies/Modifies.h"
#include "PostDominanceFrontier.h"

namespace llvm { namespace slicing {

  typedef llvm::SmallSetVector<llvm::ptr::PointsToSets::Pointee, 10> ValSet;
  typedef std::vector<std::pair<llvm::ptr::PointsToSets::Pointee, llvm::ptr::PointsToSets::Pointee> > DefRcChainSet;
#define __SLICING_FUN__ "Criteria"
#define __WRAPPING_FUN__ "codeWrapping"
#define __ATOMIC_FUN__ "atomic_cmpxchg"
#define __ATOMIC_FUN_1__ "atomic_cmpxchg1"
#define __WAIT_FOR_ALL_FUN__ "waitForAll"
#define __PTHREAD_CREATE__ "pthread_create"
#define __READ_ENV_FILE__ "ReadEnvFile"
#define __FOPEN__ "fopen"
#define __FSCANF__  "fscanf"
#define __SSCANF__  "sscanf"
#define __STRCMP__ "strcmp"
#define __GETC__ "_IO_getc"

  class FunctionStaticSlicer;

  class InsInfo {
    private:
      typedef llvm::ptr::PointsToSets::Pointee Pointee;

    public:
      InsInfo(const llvm::Instruction *i, const llvm::ptr::PointsToSets &PS,
          const llvm::mods::Modifies &MOD, FunctionStaticSlicer& fss);

      const Instruction *getIns() const { return ins; }

      bool addRC(const Pointee &var) { return RC.insert(var); }
      bool addDEF(const Pointee &var) { return DEF.insert(var); }
      bool addREF(const Pointee &var) { return REF.insert(var); }
      void addDefRcChain(std::pair<Pointee, Pointee> chain) { return DefRcChain.push_back(chain); }
      void deslice() { sliced = false; }

      ValSet::const_iterator RC_begin() const { return RC.begin(); }
      ValSet::const_iterator RC_end() const { return RC.end(); }
      ValSet::const_iterator DEF_begin() const { return DEF.begin(); }
      ValSet::const_iterator DEF_end() const { return DEF.end(); }
      ValSet::const_iterator REF_begin() const { return REF.begin(); }
      ValSet::const_iterator REF_end() const { return REF.end(); }
      DefRcChainSet::const_iterator DefRcChain_begin() const { return DefRcChain.begin(); }
      DefRcChainSet::const_iterator DefRcChain_end() const { return DefRcChain.end(); }

      bool isSliced() const { return sliced; }
      void dumpRC();
      void dumpDEF();
      void dumpREF();
      void dump();
      bool isWriteSide(CallInst const* const C);
      const Instruction* findSlicingInst(CallInst const* const C, bool isWriteSide);
      bool addParameterToREF(Value *parameter);

    private:
      void addDEFArray(const ptr::PointsToSets &PS, const Value *V,
          uint64_t lenConst);
      void addREFArray(const ptr::PointsToSets &PS, const Value *V,
          uint64_t lenConst);
      void handleVariousFuns(const ptr::PointsToSets &PS, const CallInst *C,
          const Function *F);

      const llvm::Instruction *ins;
      ValSet RC, DEF, REF;
      
      //i's Def is j's Rc. Only valid when sliced is false.
      //Push into 
      DefRcChainSet DefRcChain;
      bool sliced;

      //Fix Radix over-slicing bugs:
      //key[0] = malloc(n);
      //key[1] = malloc(n);
      //if(key[0] == NULL || key[1] == NULL)
      //{
      //  exit(-1);
      //}
      //
      //key[0] is always sliced because the slicer is field insensitive.
      //the code above is considered as:
      //key = malloc(n)
      //key = malloc(n)
      //...

      //Add members to record all operands for GetElementPtrConstantExpr.
      //If all the fields are ConstantInt, it is easy to check their equality.
      //But, if any of them is not ConstantInt, we have to conservatively assume their
      //equality.
      //
      //In fact, a very easy fix is to treat all conservatively. The slice currently
      //treat all are different and thus is field-insensitve.
  };

  class FunctionStaticSlicer {
    typedef llvm::ptr::PointsToSets::Pointee Pointee;

    public:
    typedef std::map<const llvm::Instruction *, InsInfo *> InsInfoMap;

    FunctionStaticSlicer(llvm::Function &F, llvm::ModulePass *MP,
        const llvm::ptr::PointsToSets &PT,
        const llvm::mods::Modifies &mods) :
      fun(F), MP(MP), modSet(mods) {
        for (llvm::inst_iterator I = llvm::inst_begin(F), E = llvm::inst_end(F);
            I != E; ++I)
          insInfoMap.insert(InsInfoMap::value_type(&*I, new InsInfo(&*I, PT, mods, *this)));
      }
    ~FunctionStaticSlicer();

    ValSet::const_iterator relevant_begin(const llvm::Instruction *I) const {
      return getInsInfo(I)->RC_begin();
    }
    ValSet::const_iterator relevant_end(const llvm::Instruction *I) const {
      return getInsInfo(I)->RC_end();
    }

    ValSet::const_iterator REF_begin(const llvm::Instruction *I) const {
      return getInsInfo(I)->REF_begin();
    }
    ValSet::const_iterator REF_end(const llvm::Instruction *I) const {
      return getInsInfo(I)->REF_end();
    }

    ValSet::const_iterator RC_begin(const llvm::Instruction *I) const {
      return getInsInfo(I)->RC_begin();
    }
    ValSet::const_iterator RC_end(const llvm::Instruction *I) const {
      return getInsInfo(I)->RC_end();
    }

    bool isRCEmpty(const llvm::Instruction *I) const { return RC_begin(I) == RC_end(I); }
    void deslice(const llvm::Instruction *I) { getInsInfo(I)->deslice(); }

    template<typename FwdValueIterator>
      bool addCriterion(const llvm::Instruction *ins, FwdValueIterator b,
          FwdValueIterator const e, bool desliceIfChanged = false) {
        InsInfo *ii = getInsInfo(ins);
        bool change = false;
        for (; b != e; ++b)
          if (ii->addRC(*b))
            change = true;
        if (change && desliceIfChanged)
          ii->deslice();
        
        return change;
      }

    void addInitialCriterion(const llvm::Instruction *ins,
        const Pointee &cond = Pointee(0, 0),
        bool deslice = true) {
      InsInfo *ii = getInsInfo(ins);
      if (cond.first)
        ii->addRC(cond);

#if 0
      //add REF into RC for slicing criteria.
      for (ValSet::const_iterator I = ii->REF_begin(), E = ii->REF_end(); I != E ; I++)
      {
        const Pointee &REFi = *I;
        ii->addRC(REFi);
      }

      ii->deslice();
#endif
    }
    void calculateStaticSlice();
    bool slice();
    static void removeUndefs(ModulePass *MP, Function &F);

    void addSkipAssert(const llvm::CallInst *CI) {
      skipAssert.insert(CI);
    }

    bool shouldSkipAssert(const llvm::CallInst *CI) {
      return skipAssert.count(CI);
    }

    void dumpContext(const llvm::Value * val);
    void dump();
    void dumpRC();
    void dumpBC();
    void dumpSC();
    void dumpDEF();
    void dumpREF();
    void dumpCriteria();

    InsInfo *getInsInfo(const llvm::Instruction *i) const 
    {
      InsInfoMap::const_iterator I = insInfoMap.find(i);
      assert(I != insInfoMap.end());
      return I->second;
    }

    private:
    llvm::Function &fun;
    const mods::Modifies &modSet;
    llvm::ModulePass *MP;
    InsInfoMap insInfoMap;
    llvm::SmallSetVector<const llvm::CallInst *, 10> skipAssert;

    static bool sameValues(const Pointee &val1, const Pointee &val2);
    void crawlBasicBlock(const llvm::BasicBlock *bb);
    bool computeRCi(InsInfo *insInfoi, InsInfo *insInfoj);
    bool computeRCi(InsInfo *insInfoi);
    void computeRC();

    void computeSCi(const llvm::Instruction *i, const llvm::Instruction *j);
    void computeSC();

    bool computeBC();
    bool updateRCSC(llvm::PostDominanceFrontier::DomSetType::const_iterator start,
        llvm::PostDominanceFrontier::DomSetType::const_iterator end);

    public:
    static bool isAllParametersUndefs(CallInst *callInst);
    static void removeUndefBranches(ModulePass *MP, Function &F);
    static void removeUndefCalls(ModulePass *MP, Function &F);
  };

  bool findInitialCriterion(llvm::Function &F, FunctionStaticSlicer &ss,
      bool startingFunction = false);

}}

#endif
