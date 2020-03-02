// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
#include <vector>
#include <sstream>
#include <time.h>

#include "llvm/IR/Instructions.h"
#include "llvm/IR/Function.h"
#include "llvm/Pass.h"
#include "llvm/IR/Value.h"
#include "llvm/Transforms/IPO/PassManagerBuilder.h"
#include "llvm/IR/CallSite.h"
#include "llvm/ADT/SCCIterator.h"
#include "llvm/ADT/SmallVector.h"

#include "FunctionStaticSlicer.h"
#include "../Callgraph/Callgraph.h"
#include "../Modifies/Modifies.h"
#include "../PointsTo/PointsTo.h"

#include "utility.h"
#include "BoundaryDetection.h"
#include "Instrumenter.h"

using namespace llvm;
using namespace std;
using namespace llvm::slicing;
using namespace Util;

namespace llvm { namespace slicing { namespace detail {

  typedef ptr::PointsToSets::Pointee Pointee;
  typedef std::map<const Pointee, const Pointee> ParamsToArgs;
  typedef std::set<Pointee> RelevantSet;

  static void fillParamsToArgs(const CallInst *C, const Function *F,
      ParamsToArgs &toArgs)
  {
    Function::const_arg_iterator p = F->arg_begin();

    for (unsigned a = 0; a < C->getNumArgOperands(); ++a, ++p) 
    {
      const Value *P = &*p;
      const Value *A = C->getArgOperand(a);
      if (!isConstantValue(A))
        toArgs.insert(ParamsToArgs::value_type(Pointee(P, -1),
              Pointee(A, -1)));
    }
  }

  static void getRelevantVarsAtCall(const CallInst *C, const Function *F,
      ValSet::const_iterator b,
      const ValSet::const_iterator &e,
      RelevantSet &out) 
  {
    assert(!isInlineAssembly(C) && "Inline assembly is not supported!");

    ParamsToArgs toArgs;
    fillParamsToArgs(C, F, toArgs);

    for (; b != e; ++b) 
    {
      ParamsToArgs::const_iterator it = toArgs.find(*b);
      if (it != toArgs.end())
        out.insert(it->second);
      else if (!isLocalToFunction(b->first, F))
        out.insert(*b);
    }
  }

  static void getRelevantVarsAtExit(const CallInst *C, const ReturnInst *R,
      ValSet::const_iterator b,
      const ValSet::const_iterator &e,
      RelevantSet &out) 
  {
    assert(!isInlineAssembly(C) && "Inline assembly is not supported!");

    if (callToVoidFunction(C)) 
    {
      std::copy(b, e, std::inserter(out, out.begin()));
      return;
    }

    for ( ; b != e; ++b)
    {
      if (b->first == C) 
      {
        Value *ret = R->getReturnValue();
        if (!ret) 
        {
          /*		    C->dump();
                    C->getCalledValue()->dump();
                    R->dump();*/
          //		    abort();
          return;
        }

        out.insert(Pointee(R->getReturnValue(), -1));
      } 
      else
      {
        out.insert(*b);
      }
    }
  }
}}}

namespace llvm 
{
  namespace interSlice
  {
#define __SLICING_FUN__ "Criteria"
#define __WRAPPING_FUN__ "codeWrapping"
#define __ATOMIC_FUN__ "atomic_cmpxchg"
#define __ATOMIC_FUN_1__ "atomic_cmpxchg1"
#define __WAIT_FOR_ALL_FUN__ "waitForAll"

    class StaticSlicer 
    {
      public:
        typedef std::map<llvm::Function const*, FunctionStaticSlicer *> Slicers;
        typedef std::multimap<llvm::Function const*,llvm::CallInst const*>
          FuncsToCalls;
        typedef std::multimap<llvm::CallInst const*,llvm::Function const*>
          CallsToFuncs;

        StaticSlicer(ModulePass *MP, Module &M,
            const ptr::PointsToSets &PS,
            const callgraph::Callgraph &CG,
            const mods::Modifies &MOD);

        ~StaticSlicer();

        void computeSlice();
        bool sliceModule();
        bool isFrontendLibraryAPI(const Function *fun);

      private:
        typedef llvm::SmallVector<const llvm::Function *, 20> InitFuns;

        void buildDicts(const ptr::PointsToSets &PS, const CallInst *c);
        void buildDicts(const ptr::PointsToSets &PS);

        template<typename OutIterator>
          void emitToCalls(llvm::Function const* const f, OutIterator out);

        template<typename OutIterator>
          void emitToExits(llvm::Function const* const f, OutIterator out);

        void runFSS(Function &F, const ptr::PointsToSets &PS,
            const callgraph::Callgraph &CG, const mods::Modifies &MOD);

        ModulePass *MP;
        Module &module;
        Slicers slicers;
        InitFuns initFuns;
        FuncsToCalls funcsToCalls;
        CallsToFuncs callsToFuncs;
    };

    /*
     * UP operation.
     * */
    template<typename OutIterator>
      void StaticSlicer::emitToCalls(const Function *f, OutIterator out) 
      {
        const Instruction *entry = getFunctionEntry(f);
        const ValSet::const_iterator relBgn = slicers[f]->relevant_begin(entry);
        const ValSet::const_iterator relEnd = slicers[f]->relevant_end(entry);

        FuncsToCalls::const_iterator c, e;
        std::tie(c, e) = funcsToCalls.equal_range(f);

        for ( ; c != e; ++c) 
        {
          const CallInst *CI = c->second;
          const Function *g = CI->getParent()->getParent();
          FunctionStaticSlicer *FSS = slicers[g];

          /*map callee's relevant variables to caller's.*/
          using namespace llvm::slicing::detail;
          RelevantSet R;
          getRelevantVarsAtCall(c->second, f, relBgn, relEnd, R);

          if (FSS->addCriterion(CI, R.begin(), R.end(), !FSS->shouldSkipAssert(CI))) 
          {
            FSS->addCriterion(CI, FSS->REF_begin(CI), FSS->REF_end(CI));
            *out++ = g;
          }
        }
      }

    /*
     * DOWN operation.
     * */
    template<typename OutIterator>
      void StaticSlicer::emitToExits(const Function *f, OutIterator out) 
      {
        typedef std::vector<const CallInst *> CallsVec;

        CallsVec C;
        getFunctionCalls(f, std::back_inserter(C));

        for (CallsVec::const_iterator c = C.begin(); c != C.end(); ++c) 
        {
          const ValSet::const_iterator relBgn =
            slicers[f]->relevant_begin(getSuccInBlock(*c));
          const ValSet::const_iterator relEnd =
            slicers[f]->relevant_end(getSuccInBlock(*c));

          CallsToFuncs::const_iterator g, e;
          std::tie(g, e) = callsToFuncs.equal_range(*c);

          for ( ; g != e; ++g) 
          {
            typedef std::vector<const llvm::ReturnInst *> ExitsVec;
            const Function *callie = g->second;

            /*map caller's relevant variables to callee's.*/
            ExitsVec E;
            getFunctionExits(callie, std::back_inserter(E));

            for (ExitsVec::const_iterator e = E.begin(); e != E.end(); ++e) 
            {
              using namespace llvm::slicing::detail;
              RelevantSet R;
              getRelevantVarsAtExit(*c, *e, relBgn, relEnd, R);
              if (slicers[g->second]->addCriterion(*e, R.begin(),R .end()))
                *out++ = g->second;
            }
          }
        }
      }

    void StaticSlicer::buildDicts(const ptr::PointsToSets &PS, const CallInst *c) 
    {
      typedef std::vector<const Function *> FunCon;
      FunCon G;
      getCalledFunctions(c, PS, std::back_inserter(G));

      for (FunCon::const_iterator I = G.begin(), E = G.end(); I != E; ++I) 
      {
        const Function *h = *I;
        
        StringRef fName;
        FunCon threadEntryFunctions;
        fName = h->getName();
        if(fName.equals(__PTHREAD_CREATE__))
        {
          const Value *stripped = c->getOperand(2)->stripPointerCasts();
          if(const Function *F = dyn_cast<Function>(stripped))
          {
            threadEntryFunctions.push_back(F);
          }
          else
          {
            typedef ptr::PointsToSets::PointsToSet PTSet;
            const PTSet &S = getPointsToSet(stripped, PS); 
            for (PTSet::const_iterator i = S.begin(), e = S.end(); i != e; ++i)
            {
              if (const Function *F = dyn_cast<Function>(i->first))
              {
                threadEntryFunctions.push_back(F);
              }
            }
          }

          FunCon::const_iterator i = threadEntryFunctions.begin();
          FunCon::const_iterator e = threadEntryFunctions.end();
          for( ; i != e; ++i)
          {
            const Function *threadFunc = *i;
            if (!memoryManStuff(threadFunc) && !threadFunc->isDeclaration()) 
            {
              funcsToCalls.insert(std::make_pair(threadFunc, c));
              callsToFuncs.insert(std::make_pair(c, threadFunc));
            }
          }
        }
        else
        {
          if (!memoryManStuff(h) && !h->isDeclaration()) 
          {
            funcsToCalls.insert(std::make_pair(h, c));
            callsToFuncs.insert(std::make_pair(c, h));
          }
        }
      }
    }

    void StaticSlicer::buildDicts(const ptr::PointsToSets &PS)
    {
      for (Module::const_iterator f = module.begin(); f != module.end(); ++f)
        if (!f->isDeclaration() && !memoryManStuff(&*f))
          for (const_inst_iterator I = inst_begin(*f), E = inst_end(*f);
              I != E; ++I)
            if (const CallInst *c = dyn_cast<CallInst>(&*I)) 
            {
              if (isInlineAssembly(c)) 
              {
                errs() << "ERROR: Inline assembler detected in " <<
                  f->getName() << ", skipping\n";
                continue;
              }

              buildDicts(PS, c);
            }
    }

    StaticSlicer::StaticSlicer(ModulePass *MP, Module &M, const ptr::PointsToSets &PS,
        const callgraph::Callgraph &CG, const mods::Modifies &MOD) : MP(MP), module(M),
    slicers(), initFuns(), funcsToCalls(), callsToFuncs() 
    {
      for (Module::iterator f = M.begin(); f != M.end(); ++f)
        if (!f->isDeclaration() && !memoryManStuff(&*f))
          runFSS(*f, PS, CG, MOD);

      buildDicts(PS);
    }

    StaticSlicer::~StaticSlicer() 
    {
      for (Slicers::const_iterator I = slicers.begin(), E = slicers.end();
          I != E; ++I)
        delete I->second;
    }

    void StaticSlicer::runFSS(Function &F, const ptr::PointsToSets &PS,
        const callgraph::Callgraph &CG, const mods::Modifies &MOD) 
    {
      callgraph::Callgraph::range_iterator callees = CG.callees(&F);
      bool starting = std::distance(callees.first, callees.second) == 0;

      FunctionStaticSlicer *FSS = new FunctionStaticSlicer(F, MP, PS, MOD);
#if 1			
      bool hadAssert = slicing::findInitialCriterion(F, *FSS, starting);
#else
      bool hadAssert = false;
#endif

      /*
       * Functions with an assert might not have a return and slicer wouldn't
       * compute them at all in that case.
       */
      if (starting || hadAssert)
        initFuns.push_back(&F);

      slicers.insert(Slicers::value_type(&F, FSS));
    }

    void StaticSlicer::computeSlice() 
    {
      typedef SmallVector<const Function *, 20> WorkSet;
      WorkSet Q(initFuns);

      while (!Q.empty()) 
      {
        //errs() << "Q size: " << Q.size();
        for (WorkSet::const_iterator f = Q.begin(); f != Q.end(); ++f)
          slicers[*f]->calculateStaticSlice();

        WorkSet tmp;
        for (WorkSet::const_iterator f = Q.begin(); f != Q.end(); ++f) 
        {
          emitToCalls(*f, std::inserter(tmp, tmp.end()));
          emitToExits(*f, std::inserter(tmp, tmp.end()));
        }

        std::swap(tmp,Q);
      }
    }
        
    bool StaticSlicer::isFrontendLibraryAPI(const Function *fun)
    {
      StringRef name = fun->getName();
      if(name == "printX" || name == "printY" || name == "DeriveInvariant"
          || name == "flushAll" || name == "printChar"
          || name == "waitForAll" || name == "snapshot"
          || name == "snapshot64" || name == "InitializeSwitchesAndCounter"
          || name == "IncrementCounter"
          || name == "DecrementCounter"
          || name == "appendY"
          || name == "loopExit" || name == "loopCurrent"
        )
      {
        return true;
      }

      return false;
    }

    bool StaticSlicer::sliceModule() 
    {
      bool modified = false;
      for (Slicers::iterator s = slicers.begin(); s != slicers.end(); ++s)
      {
        //Do not perform slicing on frontend's library APIs.
        const Function *fun = s->first;
        if(!isFrontendLibraryAPI(fun))
        {
          modified |= s->second->slice();
        }
      }

      if (modified)
        for (Module::iterator I = module.begin(), E = module.end(); I != E; ++I)
          if (!I->isDeclaration())
            FunctionStaticSlicer::removeUndefs(MP, *I);

      return modified;
    }
  }
}

namespace llvm 
{
  namespace interSlice
  {
    class Slicer : public ModulePass 
    {
      public:
        int currentLoopID;
        static char ID;
        Module* module;
        Slicer() : ModulePass(ID)
      {
        initializeSlicerPass(*PassRegistry::getPassRegistry());
        bSnapshot = false;
        currentLoopID = 0;
      }

        virtual bool runOnModule(Module &M);

        void getAnalysisUsage(AnalysisUsage &AU) const 
        {
          AU.addRequired<DominatorTreeWrapperPass>();
          AU.addRequired<PostDominanceFrontier>();
          //        AU.addRequired<CallGraphWrapperPass>();
          AU.addRequired<LoopInfoWrapperPass>();
        }

        ~Slicer()
        {
          freeDRCSet();
        }

      public:
        ptr::PointsToSets *PS;
        set<Function*> funcSet;
        mods::Modifies * modSet;
        mods::ProgramStructure *PStructure;

      public:
        //Implementation notes:
        //1. Although many APIs are similar to intra-slice, there are various differences.
        //   The APIs' names will be reused while the code will be adapted and re-written
        //   with slightly different assumptions for inter-slicer.
        //2. APIS are grouped according to their positions in the work-flow.
        //3. Data types and members will be defined again here without sharing with intra-slice.

        //step 0. Inter-PointTo analysis, inter-ModSet analysis, callGraph build.

        //step 1. find all slicing criteria.
        vector<CallSite> calls;
        typedef map<unsigned int, Sync> SyncSet;
        typedef map<unsigned int, Sync>::iterator SyncSetIt;
        SyncSet syncSet;
        bool isSyncPairsInSameFunction();
        bool isReadSideCriteria(CallInst *callInst);
        void collectSyncInfo(CallInst *callInst);
        bool findAllCriteria(vector<CallSite> &calls, Module &M);

        //step 2. detect boundaries, scheduling points, snapshoting points, and tracing points.
        void computeGenKillEffectForOneBB(BasicBlock *bb, AuxiliaryInfo& auxInfo);
        bool computeChanges(AuxiliaryInfo& auxInfo, AuxiliaryInfo& oldAuxInfo);
        void handleBinaryOperator(BinaryOperator *BO, AuxiliaryInfo& auxInfo);
        void handleGetElementPtrInst(GetElementPtrInst *gep, AuxiliaryInfo& auxInfo);
        void handleTruncInst(TruncInst *trunc, AuxiliaryInfo& auxInfo);
        void handleSextInst(SExtInst *sext, AuxiliaryInfo& auxInfo);
        void handleCallInst(CallInst *call, AuxiliaryInfo& auxInfo);
        bool handleStoreInst(StoreInst *SI, AuxiliaryInfo& auxInfo, BasicBlock::reverse_iterator &i);
        bool updateOutGlobal(AuxiliaryInfo &auxInfo, DRC *drc);
        bool handleLoadInst(LoadInst *LI, AuxiliaryInfo& auxInfo, BasicBlock::reverse_iterator &i);
        void handleCmpInst(CmpInst* CI, AuxiliaryInfo& auxInfo);
        void handleBranchInst(BranchInst *BI, AuxiliaryInfo& auxInfo);
        void computeGenKillEffectForOneInst(Instruction *ins, AuxiliaryInfo& auxInfo, 
                                            BasicBlock::reverse_iterator& i);
        Instruction* findSyncBoundary(Function &F, AuxiliaryMap &auxiliaryMap, Instruction *readSideCriteria, Sync &sync); 
        void detectSyncBoundary(void);
      
      public:
        typedef SmallVector<Pointer, 10> DRCSet;
        DRCSet drcSet;

        bool insertDRCSet(DRC *drc, DRCSet &drcSet, bool insertAlways = false); 
        void freeDRCSet(DRCSet& drcSet);
        void freeDRCSet(void);
        void dumpDRCSet();
        void dumpDRCSet(DRCSet& drcSet);
        DRCSet& IdentifyDRCSet(vector<BasicBlock*>& bbSet, DRCSet& drcSet, 
                               bool insertAlways = false, Instruction *callContext = NULL);
        void detectSyncSchedulePoint(void);

        //step 3. detect the set of all sync variables for all the syncs.
        bool insertDRCSet(DRC *drc, bool insertAlways = false);
        DRCSet & IdentifyDRCSet(Sync& sync);

        //step 4. inter-slice.
        //Reuse LLVMSlicer's inter-modSet, inter-pointTo, inter-callGraph, and 
        //inter-slice framework, intra-slice.

        //step 5. sanity-check and fixRanges. Inter-vrp if necessary, the sequential region detection
        //        may still be needed.
        struct pthreadCreateInfo
        {
          CallInst *callInst; //the call instruction
          bool bInLoop; //whether it's inside a loop.
          Loop *PthreadCreateLoop;
          unsigned level; //loop nest level. 0 if not inside a loop.
          Function *entryFunction; //the thread entry function.
        };

        vector<pthreadCreateInfo> vecPthreadCreate;
        unsigned analyzePthread_Create(Module &M);
        void FixNumOfThreads(Loop *pthreadCreateLoop); 
        ConstantInt *FindLastAssigment(vector<BasicBlock*>& bbSet, Instruction * IndVar);
        
        //step 6. instrumentation.
        bool bSnapshot;
        void insertLoopID(Module *mod, Instruction *insertBefore);
        void insertSyncID(Module& mod);
        void insertSyncBeginString(Module& mod);
        void instrumentSlice(Module& mod, Function *F);
        void instrumentSlice_allAB(Module& mod, Function *F);
        void instrumentWaitForAll(Module& mod);
        
        //interface between frontend and cloud9 scheduler.
        void insertSchedulePointForReadSide(Module *mod, Instruction *insertBefore);
        void insertSchedulePointForWriteSide(Module *mod, Instruction *insertBefore);
        void insertSchedulePointForOrdinary(Module *mod, Instruction *insertBefore);
        void insertSchedulePointBetweenSyncRegions(Module *mod, Instruction *insertBefore);
        bool isInsideReadSideLoop(BasicBlock *bb);


        //step 7. clean up.
        void removeAuxilaryFunction(StringRef funcName);

        //Notes:
        //a. step 0 and 4 are implemented in LLVMSlicer and slightly adapted towards our goal.
        //b. step 0~7 are in parallel in runOnModule.
      public:
        void dumpFunModifies(const Function *fun);
        void dumpModifies();
    };
  }
}

using namespace llvm::interSlice;
    char Slicer::ID;
#if 1
    //The Slicer serves as the front end of our framework.
    //It will look the call graph as well, not only CFG.
    //It will do the instrumentation and code wrapping, not decided yet.
    INITIALIZE_PASS_BEGIN(Slicer, "slice-inter", "Slices the code interprocedurally", false, false)
      INITIALIZE_PASS_DEPENDENCY(DominatorTreeWrapperPass)
      INITIALIZE_PASS_DEPENDENCY(PostDominanceFrontier)
      //  INITIALIZE_PASS_DEPENDENCY(CallGraphWrapperPass)
      INITIALIZE_PASS_DEPENDENCY(LoopInfoWrapperPass)
      INITIALIZE_PASS_END(Slicer, "slice-inter", "Slices the code interprocedurally", false, false)
      ModulePass* createSlicerPass(void)
      {
        return new Slicer();
      }
#else
    static RegisterPass<Slicer> X("slice-inter", "Slices the code interprocedurally");
#endif

namespace llvm 
{
  namespace interSlice
  {
    void Slicer::dumpFunModifies(const Function *fun)
    {
      const mods::Modifies::ModSet& mod = getModSet(fun, *modSet);
      mods::dumpFunModifies(mod, fun);
    }

    void Slicer::dumpModifies()
    {
      mods::dumpModifies(*PStructure, *modSet);
    }

    bool Slicer::runOnModule(Module &M) 
    {
      clock_t start = clock();

      module = &M;
      
      //step 0. interprocedural point-to analysis, 
      //interprocedural modSet analysis, call graph analysis.
      ptr::PointsToSets PS;
      {
        ptr::ProgramStructure P(M);
        computePointsToSets(P, PS);
      }

      this->PS = &PS;

      callgraph::Callgraph CG(M, PS);

      mods::Modifies MOD;
      this->modSet = &MOD;
      mods::ProgramStructure P1(M);
      this->PStructure = &P1;
      {
        computeModifies(P1, CG, PS, MOD);
      }
      
      //step 1. Find all slicing criteria.
      bool inSameFunction = findAllCriteria(calls, M);

#if 0
      //barrier fault-injection BEGIN
      //1. No slicing.
      //2. No IA or ET in cloud9.
      //
      //3. Simple instrumentation. Instrument scheduling points after
      //   each global variable
      instrumentSlice_allAB(M, NULL);
      instrumentWaitForAll(M);
      removeAuxilaryFunction(__SLICING_FUN__);
      return true;
      //barrier fault-injection END

      if(!inSameFunction)
      {
        //Specialize for allAB
        //1. No thread-model checking
        //2. No slicing
        //3. Simple instrumentation: instrument after Criteria; no
        //   code structure analysis
        //
        instrumentSlice_allAB(M, NULL);
        removeAuxilaryFunction(__SLICING_FUN__);
        
        instrumentWaitForAll(M);

        return false;
      }
#endif


      //The following code is for FFT barriers.

      //step 2. Assumption, motivation(why & what purpose), note.
      //detect sync boundaries, scheduling points, snapshoting points,
      //        and tracing points, etc.
      detectSyncBoundary();
      detectSyncSchedulePoint();

      //step 3. detect the set of all sync variables for all the syncs.
      //Find heap or global variables exposed by Syncs.
      //Sync sync = syncSet.begin()->second;
      for(SyncSetIt i = syncSet.begin(), e = syncSet.end(); i != e; ++i)
      {
        Sync sync = i->second;
        IdentifyDRCSet(sync);
      }
      
      //step 4. inter-slice.
      //Reuse LLVMSlicer's inter-modSet, inter-pointTo, inter-callGraph, and 
      //inter-slice framework, intra-slice.
      bool sliced = false;
#if 1
      StaticSlicer SS(this, M, PS, CG, MOD);
      SS.computeSlice();
      sliced = SS.sliceModule();
#endif
      
      //step 5. Sanity check. 
      //a. Thread modeling(pthread_create resides in a loop).
      //b. Loop should be analyzable(easy to extract induction variable, step size,
      //   start value, upper bound, etc).
      //c. (We do not require work-crew threading model). The analysis would be simpler if
      //   we assume the variable controlling #threads in the program is known to us.
      
      //Find all the pthread_create calls in the module. We assume there is no address-taken.
      //(Even we have PointTo analysis and can verify such a property.)
      unsigned numPthreadCreate = analyzePthread_Create(M); //number of pthread_create invokation.
      
      //currently, we assume there is only one pthread_create. We may relax this restriction later
      //to handle multiple pthread_create invokation.
      //a. a work-crew threading app may have multiple pthread_create for phased computation.
      //b. a work-crew threading app may have multiple pthread_create under different input.
      //c. ...
      assert(numPthreadCreate == 1 && "currently, we assume there is only one pthread_create.");

      //Loop analysis(may be replaced by Scalar-evolution in the future for generality, the current
      //algorithm is ad hoc and has almost no generality), extract IV, step, trip count, start value.
      FixNumOfThreads(vecPthreadCreate[0].PthreadCreateLoop);

      //step 6. Instrument scheduling points, snapping shot points and tracing points.
      instrumentSlice(M, NULL);

      //step 7. clean up. Remove slicing criteria.
      removeAuxilaryFunction(__SLICING_FUN__);
      
      clock_t end = clock();
      errs() << "Elapse time: " << (double)(end - start)/CLOCKS_PER_SEC << "\n";

      return sliced;
    }

    void Slicer::instrumentWaitForAll(Module& mod)
    {
      //instrument waitForAll: main thread should wait until all children have exited.
      //Two special basic blocks: UnifiedUnreachableBlock and UnifiedReturnBlock
      Function *main = mod.getFunction("main");
      for (Function::iterator I = main->begin(), E = main->end(); I != E; ++I) 
      {
        BasicBlock &bb = *I;
        if(bb.getName() == "UnifiedReturnBlock" || bb.getName() == "UnifiedUnreachableBlock")
        {
          Instruction *terminator = bb.getTerminator();
          insertWaitForAll(&mod, terminator);
        }
      }

      //the UnifiedReturnBlock or UnifiedUnreachableBlock may not appear.
      std::vector<BasicBlock*> ReturningBlocks;
      std::vector<BasicBlock*> UnreachableBlocks;
      for (BasicBlock &I : *main)
        if (isa<ReturnInst>(I.getTerminator()))
          ReturningBlocks.push_back(&I);
        else if (isa<UnreachableInst>(I.getTerminator()))
          UnreachableBlocks.push_back(&I);

      if (UnreachableBlocks.size() == 1)
      {
        BasicBlock *UnreachableBlock = UnreachableBlocks.front();
        Instruction *terminator = UnreachableBlock->getTerminator();
        insertWaitForAll(&mod, terminator);
      }

      if (ReturningBlocks.size() == 1)
      {
        BasicBlock *ReturningBlock = ReturningBlocks.front();
        Instruction *terminator = ReturningBlock->getTerminator();
        insertWaitForAll(&mod, terminator);
      }
    }
    
    /*
     * 1. compute whether read and write in the same function for each sync.
     * */
    bool Slicer::isSyncPairsInSameFunction()
    {
      bool result = true;
      for(SyncSetIt i=syncSet.begin(), e=syncSet.end(); i != e; ++i)
      {
        Sync sync = i->second;
        unsigned int id = sync.id;
        sync.bInSameFunction = (sync.readSideFunction == sync.writeSideFunction);

        //2019.3.30: a tempary fix to distinguish allAB and barriers.
        result = result & sync.bInSameFunction;

        syncSet[id] = sync;
      }

      return result;
    }

    bool Slicer::isReadSideCriteria(CallInst *callInst)
    {
      //Get its parent BB.
      BasicBlock *parentBB = callInst->getParent();

      //Get the first instruction in parentBB.
      Instruction& firstInst = parentBB->front();
      return (callInst == &firstInst);
    }

    void Slicer::collectSyncInfo(CallInst *callInst)
    {
      //read-side or write-side ?
      bool bReadSideCriteria = isReadSideCriteria(callInst);
      ConstantInt *syncId = dyn_cast<ConstantInt>(callInst->getOperand(0));
      unsigned int id = syncId->getSExtValue();
      Sync sync;
      SyncSetIt it;
      it = syncSet.find(id);
      if(it != syncSet.end())
      {
        sync = it->second;
      }
      else
      {
        sync.id = id;
      }

      if(bReadSideCriteria)
      {
        sync.readCriteria = callInst;
        sync.end = callInst;

        //readLoopExitBranch
        BasicBlock *parentBB = callInst->getParent();
        BasicBlock *predBB = parentBB->getSinglePredecessor();
        assert(predBB != NULL && "More than one predecessor for Criteria BB !");
        TerminatorInst *termInst = predBB->getTerminator();
        BranchInst *BI = dyn_cast<BranchInst>(termInst);
        assert(BI != NULL && "The terminator is not a branch instruction !");
        assert(BI->isConditional() && "BI is not conditional branch inst !");
        assert(!isConstantValue(BI->getCondition()) && "BI is unconditional !");
        sync.readLoopExitBranch = BI;

        //readSideFunction
        sync.readSideFunction = parentBB->getParent();

        //readLoop
        LoopInfo *loopInfo = &getAnalysis<LoopInfoWrapperPass>(*(sync.readSideFunction)).getLoopInfo();
        const vector<BasicBlock*>& loopBBs = loopInfo->getLoopFor(predBB)->getBlocks(); 
        for(vector<BasicBlock*>::const_iterator i = loopBBs.begin(), e = loopBBs.end(); i != e; ++i)
        {
          BasicBlock *bb = *i;
          sync.readLoopBBSet.push_back(bb);
        }
        sync.loopLatchBB = loopInfo->getLoopFor(predBB)->getLoopLatch();

        Loop *parentLoop = loopInfo->getLoopFor(predBB)->getParentLoop ();
        if(parentLoop != NULL)
        {
          SmallVector<BasicBlock *, 4> ExitBlocks;
          parentLoop->getExitBlocks(ExitBlocks);
          ExitBlocks.size();
        }
      }
      else
      {
        sync.writeCriteria = callInst;

        //writeInst
        StoreInst* write = dyn_cast<StoreInst>(callInst->getPrevNode());
        assert(write != NULL && "The previous instruction is not a write !");
        sync.writeInst = write;

        //writeSideFunction
        sync.writeSideFunction = callInst->getParent()->getParent();
      }

      //update syncSet
      syncSet[id] = sync;
    }

    //step 2. detect sync boundries.
    void Slicer::computeGenKillEffectForOneBB(BasicBlock *bb, AuxiliaryInfo& auxInfo)
    {
      for(BasicBlock::reverse_iterator i = bb->rbegin(), e = bb->rend(); i != e; ++i)
      {
        Instruction &ins = *i;
        computeGenKillEffectForOneInst(&ins, auxInfo, i);
      }
    }

    bool Slicer::computeChanges(AuxiliaryInfo& auxInfo, AuxiliaryInfo& oldAuxInfo)
    {
      InsSet diffLocal = set_difference(auxInfo.outLocal, oldAuxInfo.outLocal);

      if(diffLocal.size() != 0)
      {
        return true;
      }

      //SetOfDRC diffGlobal = set_difference(auxInfo.outGlobal, oldAuxInfo.outGlobal);
      bool bLarger = false;
      for(SetOfDRC::iterator ib=auxInfo.outGlobal.begin(), ie=auxInfo.outGlobal.end();
          ib != ie; ++ib)
      {
        DRC* element = *ib;
        if(oldAuxInfo.outGlobal.size() == 0)
        {
          bLarger = true;
          break;
        }

        bool bFound = false;
        for(SetOfDRC::iterator oldIb=oldAuxInfo.outGlobal.begin(), oldIe=oldAuxInfo.outGlobal.end();
            oldIb != oldIe; ++oldIb)
        {
          DRC *oldElement = *oldIb;
          if(*element == *oldElement)
          {
            bFound = true;
            break;
          }
        }

        if(!bFound)
        {
          return true;
        }
      }

      return false;
    }

    void Slicer::handleBinaryOperator(BinaryOperator *BO, AuxiliaryInfo& auxInfo)
    {
      Instruction *boInst = dyn_cast<Instruction>(BO);
      InsSet::iterator it = auxInfo.outLocal.find(boInst);
      if(auxInfo.outLocal.end() != it)
      {
        auxInfo.outLocal.erase(it);

        if(!isConstantValue(BO->getOperand(0)))
        {
          auxInfo.outLocal.insert(dyn_cast<Instruction>(BO->getOperand(0)));
        }

        if(!isConstantValue(BO->getOperand(1)))
        {
          auxInfo.outLocal.insert(dyn_cast<Instruction>(BO->getOperand(1)));
        }
      }
    }

    void Slicer::handleCallInst(CallInst *call, AuxiliaryInfo& auxInfo)
    {
      StringRef functionName = call->getCalledFunction ()->getName();
      if(functionName == StringRef("Criteria"))
      {
        errs() << "Skip it\n";
      }
      else if(functionName ==StringRef("atomic_cmpxchg") 
          || functionName == StringRef("atomic_cmpxchg1"))
      {
        InsSet::iterator it = auxInfo.outLocal.find(call);
        if(auxInfo.outLocal.end() != it)
        {
          auxInfo.outLocal.erase(it);
        }

        if(!isConstantValue(call->getOperand(0)))
        {
          auxInfo.outLocal.insert(dyn_cast<Instruction>(call->getOperand(0)));
        }

        if(!isConstantValue(call->getOperand(1)))
        {
          auxInfo.outLocal.insert(dyn_cast<Instruction>(call->getOperand(1)));
        }
      }
      else
      {
        assert(0 && "Unsupported: inter-procedural analysis\n");
      }
    }

    void Slicer::handleGetElementPtrInst(GetElementPtrInst *gep, AuxiliaryInfo& auxInfo)
    {
      //The following code sequence in Raytrace should be considered as DRC-2.
      //  %t = load @gm
      //  %nproc = gep %t, 0, 0
      //  %21 = load %nproc
      //
      //The right place to handle it should be in handleLoadInst.
      //However, the concept of DRC is not interesting anymore. It was introduced as a specialized data structure used 
      //in vrp. But, now we discarded vrp because we understand and use the inter-slice as our slicer.
      //It should be fine to handle this instruction sequence here by treating : ?
      InsSet::iterator it = auxInfo.outLocal.find(gep);
      if(auxInfo.outLocal.end() != it)
      {
        auxInfo.outLocal.erase(it);
      }
    }

    void Slicer::handleTruncInst(TruncInst *trunc, AuxiliaryInfo& auxInfo)
    {
      InsSet::iterator it = auxInfo.outLocal.find(trunc);
      if(auxInfo.outLocal.end() != it)
      {
        auxInfo.outLocal.erase(it);
      }

      if(!isConstantValue(trunc->getOperand(0)))
      {
        auxInfo.outLocal.insert(dyn_cast<Instruction>(trunc->getOperand(0)));
      }
    }

    bool Slicer::handleStoreInst(StoreInst *SI, AuxiliaryInfo& auxInfo, BasicBlock::reverse_iterator &i)
    {
      const Value *op = elimConstExpr(SI->getPointerOperand());
      Instruction *addr = dyn_cast<Instruction>(const_cast<Value*>(op));
      if(!isa<ConstantPointerNull>(op))
      {
        if(AllocaInst *allocInst = dyn_cast<AllocaInst>(addr))
        {
          //store and load share the same addr for a stack variable access or drc-1.
          //For drc-4, it is not ture.
          InsSet::iterator it = auxInfo.outLocal.find(addr);
          if(auxInfo.outLocal.end() != it)
          {
            auxInfo.outLocal.erase(it);
          }

          Argument *arg = dyn_cast<Argument>(SI->getOperand(0));
          bool isArgument = (arg != NULL);

          if(!isConstantValue(SI->getOperand(0)) && !isArgument)
          {
            auxInfo.outLocal.insert(dyn_cast<Instruction>(SI->getOperand(0)));
          }

          return true;
        }
        else if(GetElementPtrInst *gep = dyn_cast<GetElementPtrInst>(addr))
        {
          //Identify DRC for Global, it could be drc-1 or drc-4.
          //DRC-4 is load, gep, gep, load. 
          //verify this by looking ahead 3 instructions (load, gep, gep)
          if(SI->getPrevNode() == gep)
          {
            if(GetElementPtrInst *gep2 = dyn_cast<GetElementPtrInst>(gep->getOperand(0)))
            {
              if(gep2 == gep->getPrevNode())
              {
                if(LoadInst *firstLoad = dyn_cast<LoadInst>(gep2->getOperand(0)))
                {
                  if(gep2->getPrevNode() == firstLoad)
                  {
                    bool globalOrHeapVar = false;
                    GlobalVariable *gAddr = dyn_cast<GlobalVariable>(firstLoad->getPointerOperand());
                    globalOrHeapVar = ((gAddr != NULL) || pointsToHeapVariable(firstLoad->getPointerOperand(), *PS)); 
                    if(globalOrHeapVar)
                    {
                      //successfully identify a drc-4.
                      //firstLoad, gep2, gep, SI

                      //Create the DRC
                      DRC *drc = new DRC;

                      //firstLoad
                      drc->push_back(gAddr);
                      drc->setAccessType(false);//this DRC is a write.

                      //gep2 
                      User::const_op_iterator opIter = gep2->op_begin();
                      ++opIter; //skip operand 0, it is a pseudo register.
                      //push offsets into drc.
                      for(User::const_op_iterator End = gep2->op_end(); opIter != End; ++opIter){
                        drc->push_back(*opIter);
                      }

                      //gep
                      opIter = gep->op_begin();
                      ++opIter; //skip operand 0, it is a pseudo register.
                      //push offsets into drc.
                      for(User::const_op_iterator End = gep->op_end(); opIter != End; ++opIter){
                        drc->push_back(*opIter);
                      }

                      //Find read drc.
                      bool bFound = false;
                      SetOfDRC::iterator ib=auxInfo.outGlobal.begin();
                      for(SetOfDRC::iterator ie=auxInfo.outGlobal.end(); ib != ie; ++ib)
                      {
                        DRC* element = *ib;
                        if(*element == *drc)
                        {
                          bool bRead = element->getAccessType();

                          if(bRead)
                            bFound = true;

                          break;
                        }
                      }

                      //Found in outGlobal
                      if(bFound)
                      {
                        auxInfo.outGlobal.erase(ib);
                      }

                      delete drc;
                      drc = NULL;

                      //Advance iterator 3 times
                      ++i; //gep
                      ++i; //gep2
                      ++i; //firstLoad

                      //put referenced value into outLocal.
                      const Value* r = elimConstExpr(SI->getValueOperand());
                      if(!isConstantValue(r))
                      {
                        Instruction *inst = dyn_cast<Instruction>(const_cast<Value*>(r));
                        auxInfo.outLocal.insert(inst);
                      }

                      return true;
                    }
                  }
                }
              }
            }
          }
        }
        else
        {
          assert(0 && "Not implemented yet !\n");
        }
      }

      return false;
    }
    
    //Find drc before insertion.
    bool Slicer::updateOutGlobal(AuxiliaryInfo &auxInfo, DRC *drc)
    {
      bool bFound = false;
      for(SetOfDRC::iterator ib=auxInfo.outGlobal.begin(), ie=auxInfo.outGlobal.end();
          ib != ie; ++ib)
      {
        DRC* element = *ib;
        if(*element == *drc)
        {
          bFound = true;
          break;
        }
      }

      //Insert into outGlobal
      if(!bFound)
      {
        auxInfo.outGlobal.insert(drc);
      }
      else
      {
        delete drc;
        drc = NULL;
      }

      return bFound;
    }
    
    bool Slicer::handleLoadInst(LoadInst *LI, AuxiliaryInfo& auxInfo, BasicBlock::reverse_iterator &i)
    {
      const Value *op = elimConstExpr(LI->getPointerOperand());
      Instruction *addr = dyn_cast<Instruction>(const_cast<Value*>(op));

      //load @p, drc-1
      if(addr == NULL)
      {
        InsSet::iterator it = auxInfo.outLocal.find(dyn_cast<Instruction>(LI));
        if(auxInfo.outLocal.end() != it)
        {
          auxInfo.outLocal.erase(it);
        }

        if(GlobalVariable *gAddr = dyn_cast<GlobalVariable>(const_cast<Value*>(op)))
        {
          DRC* drc = new DRC;
          drc->push_back(gAddr);
          drc->setAccessType(true); // Read
          updateOutGlobal(auxInfo, drc);

          return true;

        }
        else
        {
          assert(0 && "Not implemented yet.");
        }
      }

      //drc-4 or local access.
      if(!isa<ConstantPointerNull>(op))
      {
        InsSet::iterator it = auxInfo.outLocal.find(dyn_cast<Instruction>(LI));
        if(auxInfo.outLocal.end() != it)
        {
          auxInfo.outLocal.erase(it);
        }

        if(AllocaInst *allocInst = dyn_cast<AllocaInst>(addr))
        {

          //if a variable is local, and it depdends on an argument
          //then we consider it is well-defined and reachable to any of its uses.
          bool argDefined = false;
          for(const User *U: op->users())
          {
            if(const StoreInst *store = dyn_cast<const StoreInst>(U))
            {
              if(Argument *arg = dyn_cast<Argument>(store->getOperand(0)))
              {
                argDefined = true;
                break;
              }
            }
          }

          //the source addr is on stack, thus it is a load from local variable.
          //it will be killed by store to the same source address.
          if(!argDefined)
          {
            auxInfo.outLocal.insert(addr);
          }

          return true;
        }
        else if(GetElementPtrInst *gep = dyn_cast<GetElementPtrInst>(addr))
        {
          //Identify DRC for Global, it could be drc-1 or drc-4.
          //DRC-4 is load, gep, gep, load. 
          //verify this by looking ahead 3 instructions (load, gep, gep)
          if(LI->getPrevNode() == gep)
          {
            if(GetElementPtrInst *gep2 = dyn_cast<GetElementPtrInst>(gep->getOperand(0)))
            {
              if(LoadInst *firstLoad = dyn_cast<LoadInst>(gep2->getOperand(0)))
              {
                if(gep2->getPrevNode() == firstLoad)
                {
                  using namespace ptr;
                  const PTSet &ptSet = getPointsToSet(firstLoad->getPointerOperand(), *PS);
                  
                  //code for debugging only.
                  if(ptSet.size() < 0)
                  {
                    dumpPointsToSet(ptSet);
                  }

                  bool globalOrHeapVar = false;
                  GlobalVariable *gAddr = dyn_cast<GlobalVariable>(firstLoad->getPointerOperand());
                  globalOrHeapVar = ((gAddr != NULL) || pointsToHeapVariable(firstLoad->getPointerOperand(), *PS)); 

                  if(globalOrHeapVar)
                  {
                    //successfully identify a drc-4.
                    //firstLoad, gep2, gep, LI

                    //Create the DRC
                    DRC *drc = new DRC;

                    //firstLoad
                    drc->push_back(gAddr);
                    drc->setAccessType(true);//this DRC is a Read.

                    //gep2 
                    User::const_op_iterator opIter = gep2->op_begin();
                    ++opIter; //skip operand 0, it is a pseudo register.
                    //push offsets into drc.
                    for(User::const_op_iterator End = gep2->op_end(); opIter != End; ++opIter){
                      drc->push_back(*opIter);
                    }

                    //gep
                    opIter = gep->op_begin();
                    ++opIter; //skip operand 0, it is a pseudo register.
                    //push offsets into drc.
                    for(User::const_op_iterator End = gep->op_end(); opIter != End; ++opIter){
                      drc->push_back(*opIter);
                    }

                    updateOutGlobal(auxInfo, drc);

                    //Advance iterator 3 times
                    ++i; //gep
                    ++i; //gep2
                    ++i; //firstLoad
                  }
                }
              }
            }
            else if(LoadInst *load = dyn_cast<LoadInst>(gep->getOperand(0))) //drc-2
            {
              using namespace ptr;
              const PTSet &ptSet = getPointsToSet(load->getPointerOperand(), *PS);

              //code for debugging only.
              if(ptSet.size() < 0)
              {
                dumpPointsToSet(ptSet);
              }

              //for Raytrace drc-2
              bool globalOrHeapVar = false;
              GlobalVariable *gAddr = dyn_cast<GlobalVariable>(load->getPointerOperand());
              globalOrHeapVar = ((gAddr != NULL) || pointsToHeapVariable(load->getPointerOperand(), *PS));

              if(globalOrHeapVar)
              {
                //Create the DRC
                DRC *drc = new DRC;
                drc->push_back(load);
                drc->setAccessType(true);//this DRC is a Read.

                //gep
                User::const_op_iterator opIter = gep->op_begin();
                ++opIter; //skip operand 0, it is a pseudo register.

                //push offsets into drc.
                for(User::const_op_iterator End = gep->op_end(); opIter != End; ++opIter){
                  drc->push_back(*opIter);
                }

                updateOutGlobal(auxInfo, drc);

                ++i;//gep
                ++i;//load
              }
            }
          }
        }
        else
        {
          assert(0 && "Not implemented yet !\n");
        }
      }

      return false;
    }

    void Slicer::handleBranchInst(BranchInst *BI, AuxiliaryInfo& auxInfo)
    {
      if(BI->isConditional() && !isConstantValue(BI->getCondition()))
      {
        bool bGlobal = isa<GlobalValue>(BI->getCondition())? true : false;
        Instruction *condition = dyn_cast<Instruction>(BI->getCondition());
        //add to local
        if(!bGlobal)
        {
          //dumpSet(auxInfo.outLocal);
          auxInfo.outLocal.insert(condition);
        }
        else
        {
          //auxInfo.outGlobal.insert(condition);
          assert(0 && "Not implemented. Unnecessary now.");
        }
      }
      //no need to handle unconditional instruction.
    }

    void Slicer::handleCmpInst(CmpInst* CI, AuxiliaryInfo& auxInfo)
    {
      Instruction *cmpInst = dyn_cast<Instruction>(CI);
      //find reference to CI. CI is a local variable.
      InsSet::iterator it = auxInfo.outLocal.find(cmpInst);
      if(auxInfo.outLocal.end() != it)
      {
        //replace cmpInst with its non-constant operands
        auxInfo.outLocal.erase(it);

        if(!isConstantValue(CI->getOperand(0)))
        {
          auxInfo.outLocal.insert(dyn_cast<Instruction>(CI->getOperand(0)));
        }

        if(!isConstantValue(CI->getOperand(1)))
        {
          auxInfo.outLocal.insert(dyn_cast<Instruction>(CI->getOperand(1)));
        }
      }
    }

    void Slicer::handleSextInst(SExtInst *sext, AuxiliaryInfo& auxInfo)
    {
      InsSet::iterator it = auxInfo.outLocal.find(sext);
      if(auxInfo.outLocal.end() != it)
      {
        auxInfo.outLocal.erase(it);
      }

      if(!isConstantValue(sext->getOperand(0)))
      {
        auxInfo.outLocal.insert(dyn_cast<Instruction>(sext->getOperand(0)));
      }
    }
    
    //the function body is a huge if statement. It is not meant to be complete. We handle the
    //instructions which appears in FFT barrier first. Other cases may be added when necessary.
    void Slicer::computeGenKillEffectForOneInst(Instruction *ins, AuxiliaryInfo& auxInfo,
                                        BasicBlock::reverse_iterator& i)
    {
      //The big if
      if(BranchInst *BI = dyn_cast<BranchInst>(ins))
      {
        handleBranchInst(BI, auxInfo);
      }
      else if(CmpInst *CI = dyn_cast<CmpInst>(ins))
      {
        handleCmpInst(CI, auxInfo);
      }
      else if(LoadInst *LI = dyn_cast<LoadInst>(ins))
      {
        handleLoadInst(LI, auxInfo, i);
      }
      else if(CallInst* call = dyn_cast<CallInst>(ins))
      {
        handleCallInst(call, auxInfo);
      }
      else if(StoreInst* SI = dyn_cast<StoreInst>(ins))
      {
        handleStoreInst(SI, auxInfo, i);  
      }
      else if(BinaryOperator *BO = dyn_cast<BinaryOperator>(ins))
      {
        handleBinaryOperator(BO, auxInfo);
      }
      else if(TruncInst *trunc = dyn_cast<TruncInst>(ins))
      {
        handleTruncInst(trunc, auxInfo);
      }
      else if(SExtInst *sext = dyn_cast<SExtInst>(ins))
      {
        handleSextInst(sext, auxInfo);
      }
//      else if(GetElementPtrInst *gep = dyn_cast<GetElementPtrInst>(ins))
//      {
//        handleGetElementPtrInst(gep, auxInfo);
//      }
      else
      {
        assert(0 && "Not implemented yet !\n");
      }//The big if
    }

#if 1   
    Instruction* Slicer::findSyncBoundary(Function &F, AuxiliaryMap &auxiliaryMap, Instruction *readSideCriteria, Sync &sync)
    {
      assert(readSideCriteria != NULL && "read-side slicing criteria should not be empty\n");

      //Get its parent Basic Block.
      //starting from read side loop.
      BasicBlock *readCriteriaBB = readSideCriteria->getParent();
      LoopBBSet readLoopBBSet = sync.readLoopBBSet;
      std::vector<BasicBlock *> workList;
      for(LoopBBSet::iterator it=readLoopBBSet.begin(), ie=readLoopBBSet.end(); it != ie; ++it)
      {
        BasicBlock *loopBB = *it;
        workList.push_back(loopBB);
      }

      Instruction *boundaryInst = NULL;
      bool changed;
      do
      {
        //Initialize auxInfo to empty for all the BBs in current workList.
        initializeSCCAuxInfo(workList, auxiliaryMap);
        
        do
        {
          changed = false;
          for(std::vector<BasicBlock*>::const_iterator I = workList.begin(),
              E = workList.end(); I != E; ++I)
          {
            BasicBlock *bb = *I;
            sync.bbSet.insert(bb);

            //retrieve auxInfo for bb
            AuxiliaryInfo auxInfo = auxiliaryMap[bb];
            AuxiliaryInfo oldAuxInfo = auxInfo;

            //recompute auxInfo.inLocal and auxInfo.inGlobal
            //nextSCC.In = Union(successor(BBs).In)
            computeAuxInfoOut(bb, auxInfo, workList, auxiliaryMap, readCriteriaBB);
                
            //compute the effect of gen and kill.
            //computeGenKillEffectForOneBB(bb, auxInfo);
            for(BasicBlock::reverse_iterator i = bb->rbegin(), e = bb->rend(); i != e; ++i)
            {
              Instruction &ins = *i;
              computeGenKillEffectForOneInst(&ins, auxInfo, i);
            
              if(workList.size() == 1)
              {
                //check whether boundary is found.
                //Boundary condition: only global vars are unknown.
                //Condition: auxInfo.outLocal == empty && auxInfo.outGlobal != empty
                //Assumption: only appear in workList whose size is 1(only contains 1 BB, not in a loop.)
                //Timing: after handling each instruction's gen-kill effect.
                if(auxInfo.outLocal.size() == 0 && auxInfo.outGlobal.size() != 0)
                {
                  //since auxInfo is updated for every instruction, we have a precise boundary.
                  boundaryInst = &ins;
                  return boundaryInst;
                }
              }
            }

            //if oldAuxInfo != AuxInfo
            //auxInfo is always >= oldAuxInfo
            if(workList.size() > 1)
            {
              changed |= computeChanges(auxInfo, oldAuxInfo);

              if(changed)
              {
                //initialize inLocal and inGlobal for next iteration.
                auxInfo.inLocal.clear();
                auxInfo.inGlobal.clear();

                //only update auxInfo when it is changed.
                auxiliaryMap[bb] = auxInfo;
              }
            }
            else
            {
              auxiliaryMap[bb] = auxInfo;
            }
          }
        }while(changed);

        //update workList: the predecessor whose successors have all been visited.
        std::vector<BasicBlock *> tempList;
        //workList.clear();
        
        for(std::vector<BasicBlock*>::const_iterator IW = workList.begin(),
            EW = workList.end(); IW != EW; ++IW)
        {
          BasicBlock *currentBB = *IW;

          //for all predecessors.
          for(pred_iterator ic = pred_begin(currentBB), ec = pred_end(currentBB); ic != ec; ++ic)
          {
            BasicBlock *pred = *ic;
            
            //for all its successors. if all successors have been visited.
            bool bready = true;
            for (succ_iterator is = succ_begin(pred), es = succ_end(pred); is != es; is++)
            {
              //if it can be found in auxiliarymap, it has been visited.
              AuxiliaryMap::iterator it = auxiliaryMap.find(*is);
              if(it == auxiliaryMap.end())
              {
                bready = false;
                break;
              }
            }

            if(bready)
            {
              bool bInWorkList = false;

              for(std::vector<BasicBlock*>::const_iterator I = workList.begin(),
                  E = workList.end(); I != E; ++I)
              {
                if(*I == pred)
                {
                  bInWorkList = true;
                }
              }

              if(!bInWorkList)
              {
                tempList.push_back(pred);
              }
            }
          }
          
          //Firstly, a heuristic is applied:
          //if there is only one predecessor of the only one BB in workList, we always add it
          //to workList without any further testing. (The heuristic can be further improved to
          //a general criteria: if the predecessor's certain successor is in the same loop as the
          //predecessor, then this successor is not considered as part of BBs that should be visited
          //before the predecessor is visited.)
          if(tempList.size() == 0 && workList.size() == 1)
          {
            BasicBlock *uniqPred = currentBB->getUniquePredecessor();
            if(uniqPred != NULL)
            {
              LoopInfo *LI = &getAnalysis<LoopInfoWrapperPass>(F).getLoopInfo();
              Loop *loop = LI->getLoopFor(uniqPred);
              if(loop != NULL)
              {
                const vector<BasicBlock*>& loopBBs = loop->getBlocks();
                for(vector<BasicBlock*>::const_iterator i = loopBBs.begin(), e = loopBBs.end(); i != e; ++i)
                {
                  tempList.push_back(*i);
                }

                break;
              }
            }
          }
          
        }

        //remove items processed.
        workList.clear();
        
        //copy items to workList.
        for(std::vector<BasicBlock*>::const_iterator I = tempList.begin(),
            E = tempList.end(); I != E; ++I)
        {
          workList.push_back(*I);
        }

        tempList.clear();

      }while(!workList.empty());

      return NULL;
    }
#else
    Instruction* Slicer::findSyncBoundary(Function &F, AuxiliaryMap &auxiliaryMap, Instruction *readSideCriteria, Sync &sync)
    {
      assert(readSideCriteria != NULL && "read-side slicing criteria should not be empty\n");

      //Get its parent Basic Block.
      BasicBlock *readCriteriaBB = readSideCriteria->getParent();

      //Post-order traversal of SCC in F's CFG.
      bool bProcessing = false;
      Instruction *boundaryInst = NULL;
      for (scc_iterator<Function*> SCCI = scc_begin(&F); !SCCI.isAtEnd(); ++SCCI) 
      {
        const std::vector<BasicBlock *> &nextSCC = *SCCI;
        if(!bProcessing)
        {
          for (std::vector<BasicBlock*>::const_iterator I = nextSCC.begin(),
              E = nextSCC.end(); I != E; ++I)
          {
            BasicBlock *bb = *I;
            if(bb == readCriteriaBB)
            {
              //switch mode to processing mode: beginning with next scc, detect boundary condition.
              bProcessing = true;
            }
          }
        }
        else
        {
          //Inside each SCC, apply worklist algorithm.
          //a. Heuristic: if there is only 1 BB in the current SCC, no need to apply the worklist/iterative
          //algorithm. Otherwise, In/Out set for each BB must be computed locally beforehand.
          //
          //b. Gen/Kill set is implicit, i.e., there is no Gen/Kill set. The effect of Gen/Kill is computed
          //by reversely iterating the BB and applying corresponding effect of its instructions.
          std::vector<BasicBlock*>::const_iterator I = nextSCC.begin();
          BasicBlock *bb = *I;
          
          //Initialize auxInfo to empty for all the BBs in current SCC.
          initializeSCCAuxInfo(nextSCC, auxiliaryMap);
          if(nextSCC.size() == 1)
          {
            AuxiliaryInfo auxInfo = auxiliaryMap[bb];
            sync.bbSet.insert(bb);

            //nextSCC.In = Union(successor(BBs).In)
            computeAuxInfoOut(bb, auxInfo, nextSCC, auxiliaryMap, readCriteriaBB);

            //check whether boundary is found. 
            //Boundary condition: only global vars are unknown.
            //Condition: auxInfo.outLocal == empty && auxInfo.outGlobal != empty
            //Assumption: only appear in SCC whose size is 1(only contains 1 BB)
            //Timing: at the beginning of handling each instruction's gen-kill effect.
            if(auxInfo.outLocal.size() == 0 && auxInfo.outGlobal.size() != 0)
            {
              //one of the successor BB's beginning is the boundary.
              //Find it.
              for (succ_iterator I = succ_begin(bb), E = succ_end(bb); I != E; I++)
              {
                BasicBlock *succ = *I;
                if(readCriteriaBB == succ)
                {
                  continue;
                }

                AuxiliaryInfo succAuxInfo = auxiliaryMap[succ];
                if(succAuxInfo.outLocal.size() == 0 && succAuxInfo.outGlobal.size() != 0)
                {
                  //Found it. Take its first instruction as the location (the boundary is
                  //before it).
                  boundaryInst = &succ->front();

                  break;
                }
              }
            }

            if(boundaryInst != NULL)
            {
              break;
            }

            for(BasicBlock::reverse_iterator i = bb->rbegin(), e = bb->rend(); i != e; ++i)
            {
              //compute the effect of gen and kill.
              Instruction &ins = *i;
              computeGenKillEffectForOneInst(&ins, auxInfo, i);

              //check boundary condition
              if(auxInfo.outLocal.size() == 0 && auxInfo.outGlobal.size() != 0)
              {
                boundaryInst = &(*i);
                break;
              }
            }

            //update the auxInfo map entry.
            auxiliaryMap[bb] = auxInfo;

            if(boundaryInst != NULL)
            {
              break;
            }
          }
          else
          {
            bool changed;
            do
            {
              changed = false;

              for (std::vector<BasicBlock*>::const_iterator I = nextSCC.begin(),
                  E = nextSCC.end(); I != E; ++I)
              {
                //there are more than 1 BB in the current SCC. Iterative algorithm is implemented.
                BasicBlock *bb = *I;
                sync.bbSet.insert(bb);

                //retrieve auxInfo for bb
                AuxiliaryInfo auxInfo = auxiliaryMap[bb];
                AuxiliaryInfo oldAuxInfo = auxInfo;

                //recompute auxInfo.inLocal and auxInfo.inGlobal
                //nextSCC.In = Union(successor(BBs).In)
                computeAuxInfoOut(bb, auxInfo, nextSCC, auxiliaryMap, readCriteriaBB);

                //compute the effect of gen and kill.
                computeGenKillEffectForOneBB(bb, auxInfo);

                //if oldAuxInfo != AuxInfo
                //auxInfo is always >= oldAuxInfo
                changed |= computeChanges(auxInfo, oldAuxInfo);

                if(changed)
                {
                  //initialize inLocal and inGlobal for next iteration.
                  auxInfo.inLocal.clear();
                  auxInfo.inGlobal.clear();

                  //only update auxInfo when it is changed.
                  auxiliaryMap[bb] = auxInfo;
                }
              }
            }while(changed);
          }
        }
      }

      return boundaryInst;
    }
#endif
    /*
     * a. Extract boundaryInst, exposed variables (syncVars).
     * b. Populate bbSet with BBs of corresponding sync.
     * */
    void Slicer::detectSyncBoundary(void)
    {
      for(SyncSetIt i = syncSet.begin(), e = syncSet.end(); i != e; ++i)
      {
        AuxiliaryMap auxiliaryMap;
        Sync sync = i->second;
        unsigned int id = sync.id; 

        Instruction *readSideCriteria = sync.readCriteria;
        assert(sync.bInSameFunction && "Read-Side and write-side should be in the same function.\n");
        Function *F = sync.readSideFunction;
        Instruction *boundaryInst = findSyncBoundary(*F, auxiliaryMap, readSideCriteria, sync);
        assert(boundaryInst != NULL && "Boundary Instruction should not be empty.\n");

        BasicBlock* boundaryBB = boundaryInst->getParent();
        SetOfDRC syncVars = auxiliaryMap[boundaryBB].outGlobal;

        sync.begin = boundaryInst;
        sync.syncVars = syncVars;
        syncSet[id] = sync;
      }
    }

    void Slicer::freeDRCSet()
    {
      freeDRCSet(drcSet);
    }

    void Slicer::freeDRCSet(DRCSet& drcSet)
    {
      if(drcSet.size() == 0)
        return;

      for(DRCSet::iterator I=drcSet.begin(), E=drcSet.end(); I != E; ++I)
      {
        DRC *temp = (DRC*)(*I);
        assert(temp != NULL && "Should not be NULL");
        delete temp;
      }
    }
  
    bool Slicer::insertDRCSet(DRC *drc, bool insertAlways)
    {
      insertDRCSet(drc, drcSet, insertAlways);
    }
    
    bool Slicer::insertDRCSet(DRC *drc, DRCSet& drcSet, bool insertAlways)
    {
      if(drcSet.size() == 0)
      {
        drcSet.push_back(drc);
        return true;
      }

      if(insertAlways)
      {
        drcSet.push_back(drc);
        return true;
      }
      else
      {
        for(DRCSet::iterator I=drcSet.begin(), E=drcSet.end(); I != E; ++I)
        {
          DRC *temp = (DRC*)(*I);
          if(*temp == *drc)
          {
            return false;
          }
        }
        drcSet.push_back(drc);
        return true;
      }
    }
    
    void Slicer::dumpDRCSet(DRCSet& drcSet)
    {
      if(drcSet.size() == 0)
        return;

      for(DRCSet::iterator I=drcSet.begin(), E=drcSet.end(); I != E; ++I)
      {
        DRC *temp = (DRC*)(*I);
        temp->dump();
      }
    }

    void Slicer::dumpDRCSet()
    {
      dumpDRCSet(drcSet);
    }

    Slicer::DRCSet& Slicer::IdentifyDRCSet(vector<BasicBlock*>& bbSet, DRCSet& drcSet, bool insertAlways, Instruction *callContext)
    {
      for(vector<BasicBlock*>::iterator SI = bbSet.begin(), SE = bbSet.end(); SI != SE; ++SI)
      {
        //The instruction prior to the instruction being inspected.
        Instruction * prev = NULL;
        BasicBlock *bb = *SI;

        //When start is true, it means that we have already been in the process of drc 
        //recognization.
        bool start = false;
        DRC *drc = NULL;

        for (BasicBlock::iterator I = bb->begin(), E = bb->end(); I != E; ++I)
        {
          Instruction *ins = I;

          //A DRC begins with a loadInst dereferencing a global pointer.
          if(LoadInst *load = dyn_cast<LoadInst>(ins))
          {
            //Check whether it refers to stack, heap or global memory.
            //case 1. Stack. value created by alloc instruction.
            //case 2. Heap. Global pointer, or a pointer field of a global object.
            //E.g., A struct type has a pointer field and an instance is in global scope, then
            //if its pointer field is dereferenced, it must be initialized by malloc-like
            //functions at runtime.
            //case 3. Global varialbes. Pointer to global variable.
            //Now, we only care about global variable or global pointer case-by-case.
            //Global pointer case is introduced by FFT barrier.
            Value *value = load->getPointerOperand();
            using namespace ptr;
            const PTSet &ptSet = getPointsToSet(value, *PS);

            //code for debugging only.
            if(ptSet.size() < 0)
            {
              dumpPointsToSet(ptSet);
            }

            bool globalOrHeapVar = false;
            GlobalVariable *gv = dyn_cast<GlobalVariable>(value);
            globalOrHeapVar = ((gv != NULL) || pointsToHeapVariable(value, *PS)); 

            if(globalOrHeapVar && !start)
            {
              //gv must be a Global pointer.
              //If its value type is not a pointer, then gv is a pointer 
              //to global value in global memory.
              //Otherwise, it is a global pointer to a heap region.

              //It is load *a, load from a global variable directly.
              //The simple load is a DRC of length 1.
              if(load->getType()->isIntegerTy())
              {
                //disable scheduling point for global variable: P
#if 1
                drc = new DRC;   
                drc->push_back(gv);
                drc->setAccessType(true); //Read
                drc->setInsContext(ins);
                drc->setCallContext(callContext);

                //Put it into drcSet.
                //A variable may be deferenced several times, 
                //but should appear in the drcSet only once.
                insertDRCSet(drc, drcSet, insertAlways);
#endif
                drc = NULL;
                continue;
              }
              else
              {
                //load **a;
                //This is a start of dereference chain if gv is a pointer to
                //an aggregate type, e.g., struct, array, etc. And we track the
                //dereference chain(DRC) until it reaches a primitive type (a pointer to
                //int, char, etc). The DRC is in form: load @->(GEP)*|(load %)*->load %primitive *
                //A DRC may or not complete in one BB. A DRC may or not be continuous.
                //Assumption: DRC is complete in one BB and continuous.
                //A complete DRC corresponds to load a field of struct.
                //Load, gep, gep, Load.
                //gv is the starting point of a DRC.
                
                //A new drc ends the previous drc.
                if(drc != NULL)
                {
                  insertDRCSet(drc, drcSet, insertAlways);
                  drc = NULL;
                }
                
                drc = new DRC;   
                drc->setInsContext(ins);
                drc->setCallContext(callContext);
                start = true;
                drc->push_back(gv);

                //Record the current instruction as previous instruction, 
                //in order to facilitate the "Continuous in One BB" checking.
                prev = I;
              }
            }//if(GlobalVariable
            else if(start)
            {
              //the last load.
              //Only need to make sure it is the last load, no need to push into the
              //drc.
              Value *addr = load->getOperand(0);
              if(Instruction *ins = dyn_cast<Instruction>(addr))
              {
                //make sure the DRC is still continuous.
                if(prev != ins)
                {
                  errs() << "The DRC is not continuous !\n";
                  start = false;//The DRC cannot not be complete and should be discarded.
                  if(drc != NULL)
                  {
                    drc->clear();
                  }
                }
                else
                {
                  drc->setAccessType(true);//this DRC is a Read.
                  drc->setInsContext(load);
                  drc->setCallContext(callContext);
                  start = false; //this load is last instruction in the current DRC.

                  //bool or int, but cannot be pointer type.
                  //TODO: support the following drc
                  //%33 = load i32* %i, align 4
                  //%idxprom = sext i32 %33 to i64
                  //%34 = load double** @umain, align 8
                  //%arrayidx = getelementptr inbounds double* %34, i64 %idxprom
                  //%35 = load double* %arrayidx, align 8

                  //assert(load->getType()->isIntegerTy() && "The type of last load must not be an integer !");

                  //Put it into drcSet.
                  insertDRCSet(drc, drcSet, insertAlways);
                  drc = NULL;
                }
              }//if(Instruction *ins
              else
              {
                errs() << "The DRC cannot be complete and should be discarded!";
                delete drc;
                drc = NULL;
                start = false;
              }
            }//else if(start)
          }//if(LoadInst
          else if(GetElementPtrInst *gep = dyn_cast<GetElementPtrInst>(ins))
          {
            if(start)
            {
              //it is in a DRC recognition process.
              //A gep instruction.
              //Only need to record its indexes(offsets) in current DRC.
              Value * op0 = gep->getOperand(0);

              //make sure the drc is continuous. The gep's operand 0 should be the
              //same as the last instruction, load or gep.
              assert(op0 == prev && "The DRC is not continuous !");

              User::const_op_iterator opIter = gep->op_begin();
              ++opIter; //skip operand 0, it is a pseudo register.

              //push offsets into drc.
              for(User::const_op_iterator End = gep->op_end(); opIter != End; ++opIter){
                drc->push_back(*opIter);
              }

              //Record the current instruction as previous instruction, 
              //in order to facilitate the "Continuous in One BB" checking.
              prev = I;
            }//if(start)
          }//if(GetElementPtrInst *gep
          else if(CallInst *callInst = dyn_cast<CallInst>(ins))
          {
            //TODO: inter-procedural analysis
            //continue;
            //A call instruction ends the previous drc, if existing.
            if(start)
            {
              if(drc)
              {
                insertDRCSet(drc, drcSet, insertAlways);
                drc = NULL;
              }

              start = false;
            }

            Function *callee = callInst->getCalledFunction();

            //check if callee has already been in funcSet. If true, callee is recursively calling
            //itself and we do not want to process it again, so we simply skip it.
            //if(callee && callee->getName() == "atomic_cmpxchg")
            if(callee && (funcSet.end() == funcSet.find(callee)))
            {
              //insert callee into funcSet before interprocedurally analyzing it.
              funcSet.insert(callee);

              vector<BasicBlock*> funcBBSet;
              for (Function::iterator FI = callee->begin(), FE = callee->end(); FI != FE; ++FI)
              {
                BasicBlock *temp = FI;
                funcBBSet.push_back(temp);
              }

              //set up call context.
              if(callContext == NULL)
              {
                IdentifyDRCSet(funcBBSet, drcSet, insertAlways, ins);
              }
              else
              {
                IdentifyDRCSet(funcBBSet, drcSet, insertAlways, callContext);
              }

              //remove callee from funcSet after interprocedurally analyzing it.
              set<Function*>::iterator it = funcSet.find(callee);
              funcSet.erase(it);
            }
          } //else if(CallInst *
          else if(StoreInst *storeInst = dyn_cast<StoreInst>(ins))
          {
            //Input: load, gep, gep, store.
            //The last store
            //Only need to make sure it is the last load, no need to push into the drc.
            if(start)
            {          
              const Value *op = elimConstExpr(storeInst->getPointerOperand());
              Instruction *addr = dyn_cast<Instruction>(const_cast<Value*>(op));

              //make sure the DRC is still continuous.
              if(prev != addr)
              {
                errs() << "The DRC is not continuous !\n";
                if(drc != NULL)
                {
                  drc->clear();
                }
              }
              else
              {
                drc->setAccessType(false);//this DRC is a write.
                drc->setInsContext(ins);
                drc->setCallContext(callContext);

                //Put it into drcSet.
                insertDRCSet(drc, drcSet, insertAlways);
                drc = NULL;
              }

              start = false;
            }
          }
          else
          {
            //Need to release drc allocated.
            if(drc != NULL)
            {
              delete drc;
              drc = NULL;
              start = false;
            }
          }
        }//for (BasicBlock
      }//for (Function
    }

    /*
     * For each sync, detect all the scheduling points and their type.
     * */
    void Slicer::detectSyncSchedulePoint(void)
    {
      for(SyncSetIt i = syncSet.begin(), e = syncSet.end(); i != e; ++i)
      {
        Sync sync = i->second;
        unsigned int id = sync.id;
        Instruction *boundaryInst = sync.begin;

        //Identify DRCs.
        DRCSet regionDRCSet;
        vector<BasicBlock*> regionBBSet; 
        for(set<BasicBlock*>::iterator I = sync.bbSet.begin(), E = sync.bbSet.end(); I != E; ++I)
        {
          BasicBlock *temp = *I;
          regionBBSet.push_back(temp);
        }

        IdentifyDRCSet(regionBBSet, regionDRCSet, true, NULL);

        //Only the DRCs which happens after boundaryInst belong to sync's schedule point.
        for(DRCSet::iterator I=regionDRCSet.begin(), E=regionDRCSet.end(); I != E; ++I)
        {
          DRC *drc = (DRC*)(*I);

          //whether DRC occurs before boundaryInst ?
          bool afterBoundaryInst = false;
          BasicBlock *boundaryBB = boundaryInst->getParent();
          Instruction *insContext = const_cast<Instruction*>(drc->getInsContext());
          Instruction *callContext = const_cast<Instruction*>(drc->getCallContext());
          Instruction *context = NULL;
          if(callContext != NULL)
          {
            //drc is inside another function, context should be
            //the root call-site instruction.
            context = callContext;
          }
          else
          {
            //drc is in the same function as the current sync.
            context = insContext;
          }

          BasicBlock * contextBB = context->getParent();
          if(boundaryBB == contextBB)
          {
            for(BasicBlock::reverse_iterator i = boundaryBB->rbegin(), e = boundaryBB->rend(); i != e; ++i)
            {
              Instruction* ins = &(*i);
              if(ins == boundaryInst)
              {
                break;
              }

              if(ins == context)
              {
                afterBoundaryInst = true;
                break;
              }
            }
          }
          else
          {
            afterBoundaryInst = true;
          }

          //skip this drc because it is before boundary instruction.
          if(!afterBoundaryInst)
          {
            continue;
          }

          //a scheduling point
          SchedulePoint schedulePoint;
          schedulePoint.context = const_cast<Instruction*>(drc->getInsContext());

          //determine its type
          BasicBlock *bb = schedulePoint.context->getParent();
          LoopInfo *loopInfo = &getAnalysis<LoopInfoWrapperPass>(*(sync.readSideFunction)).getLoopInfo();
          Loop *loop = loopInfo->getLoopFor(bb);
          LoopBBSet bbSet;
          if(loop != NULL)
          {
            const vector<BasicBlock*>& loopBBs = loop->getBlocks();
            for(vector<BasicBlock*>::const_iterator i = loopBBs.begin(), e = loopBBs.end(); i != e; ++i)
            {
              BasicBlock *bb = *i;
              bbSet.push_back(bb);
            }
          }

          if(bbSet == sync.readLoopBBSet)
          {
            schedulePoint.type = schedule_read;
          }
          else
          {
            Instruction * nextInst = schedulePoint.context->getNextNode();
            if(nextInst == sync.writeCriteria)
            {
              schedulePoint.type = schedule_write;
            }
            else
            {
              if(drc->getAccessType())
              {
                schedulePoint.type = schedule_ordinary_read;
              }
              else
              {
                schedulePoint.type = schedule_ordinary_write;
              }
            }
          }

          //insert into schedulePointSet.
          sync.schedulePointSet.push_back(schedulePoint);
        }

        freeDRCSet(regionDRCSet);
        syncSet[id] = sync;
      }  
    }

    //step 3. detect the set of all sync variables for all the syncs.
    //Input: a sync.
    //Ouput: a set of variables, <global, heap> X <drc-1, drc-4>;
    //       its definitions(malloc for heap, definition for globals),
    //       de-allocation for heap variable.
    //Forward parsing: loop through all the BBs forwardly, test & add.
    //Note: It doesn't matter whether the local variable(defined by Alloc) all appears in 
    //function entry block.
    Slicer::DRCSet& Slicer::IdentifyDRCSet(Sync &sync)
    {
      Function *func = sync.begin->getParent()->getParent();
      typedef set<BasicBlock*> SyncBBSet;
      SyncBBSet& bbSet = sync.bbSet;
      SchedulePointSet& schedulePointSet = sync.schedulePointSet;
      for (SyncBBSet::iterator SI = bbSet.begin(), SE = bbSet.end(); SI != SE; ++SI)
      {
        //The instruction prior to the instruction being inspected.
        Instruction * prev = NULL;
        BasicBlock *bb = *SI;

        //When start is true, it means that we have already been in the process of drc 
        //recognization.
        bool start = false;
        DRC *drc = NULL;

        for (BasicBlock::iterator I = bb->begin(), E = bb->end(); I != E; ++I)
        {
          Instruction *ins = I;

          //A DRC begins with a loadInst dereferencing a global pointer.
          if(LoadInst *load = dyn_cast<LoadInst>(ins))
          {
            //Check whether it refers to stack, heap or global memory.
            //case 1. Stack. value created by alloc instruction.
            //case 2. Heap. Global pointer, or a pointer field of a global object.
            //E.g., A struct type has a pointer field and an instance is in global scope, then
            //if its pointer field is dereferenced, it must be initialized by malloc-like
            //functions at runtime.
            //case 3. Global varialbes. Pointer to global variable.
            //Now, we only care about global variable or global pointer case-by-case.
            //Global pointer case is introduced by FFT barrier.
            Value *value = load->getPointerOperand();
            if(GlobalVariable *gv = dyn_cast<GlobalVariable>(value))
            {
              //gv must be a Global pointer.
              //If its value type is not a pointer, then gv is a pointer 
              //to global value in global memory.
              //Otherwise, it is a global pointer to a heap region.

              //It is load *a, load from a global variable directly.
              //The simple load is a DRC of length 1.
              if(load->getType()->isIntegerTy())
              {
                drc = new DRC;   
                drc->push_back(gv);
                drc->setAccessType(true); //Read

                //Put it into drcSet.
                //A variable may be deferenced several times, 
                //but should appear in the drcSet only once.
                insertDRCSet(drc);

                //if the BB does not contains noScheduling(), we insert scheduling
                //points for shared memory read/write inside it.
                //insertSchedulePointForOrdinary(func->getParent(), load->getNextNode()); 

                drc = NULL;
                continue;
              }
              else
              {
                //load **a;
                //This is a start of dereference chain if gv is a pointer to
                //an aggregate type, e.g., struct, array, etc. And we track the
                //dereference chain(DRC) until it reaches a primitive type (a pointer to
                //int, char, etc). The DRC is in form: load @->(GEP)*|(load %)*->load %primitive *
                //A DRC may or not complete in one BB. A DRC may or not be continuous.
                //Assumption: DRC is complete in one BB and continuous.
                //A complete DRC corresponds to load a field of struct.
                //Load, gep, gep, Load.
                //gv is the starting point of a DRC.
                drc = new DRC;   
                start = true;
                drc->push_back(gv);

                //Record the current instruction as previous instruction, 
                //in order to facilitate the "Continuous in One BB" checking.
                prev = I;
              }
            }//if(GlobalVariable
            else if(start)
            {
              //the last load.
              //Only need to make sure it is the last load, no need to push into the
              //drc.
              Value *addr = load->getOperand(0);
              if(Instruction *ins = dyn_cast<Instruction>(addr))
              {
                //make sure the DRC is still continuous.
                if(prev != ins)
                {
                  errs() << "The DRC is not continuous !\n";
                  start = false;//The DRC cannot not be complete and should be discarded.
                  if(drc != NULL)
                  {
                    drc->clear();
                  }
                }
                else
                {
                  drc->setAccessType(true);//this DRC is a Read.
                  start = false; //this load is last instruction in the current DRC.

                  //bool or int, but cannot be pointer type.
                  assert(load->getType()->isIntegerTy() && "The type of last load must not be an integer !");

                  //Put it into drcSet.
                  insertDRCSet(drc);
                  //if the BB does not contains noScheduling(), we insert scheduling
                  //points for shared memory read/write inside it.
                  //insertSchedulePointForOrdinary(func->getParent(), load->getNextNode()); 

                  drc = NULL;
                }
              }//if(Instruction *ins
              else
              {
                assert(false && "The DRC cannot be complete and should be discarded!");
              }
            }//else if(start)
          }//if(LoadInst
          else if(GetElementPtrInst *gep = dyn_cast<GetElementPtrInst>(ins))
          {
            if(start)
            {
              //it is in a DRC recognition process.
              //A gep instruction.
              //Only need to record its indexes(offsets) in current DRC.
              Value * op0 = gep->getOperand(0);

              //make sure the drc is continuous. The gep's operand 0 should be the
              //same as the last instruction, load or gep.
              assert(op0 == prev && "The DRC is not continuous !");

              User::const_op_iterator opIter = gep->op_begin();
              ++opIter; //skip operand 0, it is a pseudo register.

              //push offsets into drc.
              for(User::const_op_iterator End = gep->op_end(); opIter != End; ++opIter){
                drc->push_back(*opIter);
              }

              //Record the current instruction as previous instruction, 
              //in order to facilitate the "Continuous in One BB" checking.
              prev = I;
            }//if(start)
          }//if(GetElementPtrInst *gep
          else if(CallInst *callInst = dyn_cast<CallInst>(ins))
          {

            if(callInst->getCalledFunction ()->getName() == __ATOMIC_FUN__
                || callInst->getCalledFunction ()->getName() == __ATOMIC_FUN_1__ )
            {
              SchedulePoint schedulePoint;
              schedulePoint.context = callInst;
              schedulePoint.type = schedule_ordinary_write;

              //insert into schedulePointSet.
              sync.schedulePointSet.push_back(schedulePoint);
              //insertSchedulePointForOrdinary(func->getParent(), callInst->getNextNode());
            }
          }
          else
          {
            //Input: load, gep, gep, store.
            //Need to release drc allocated.
            if(drc != NULL)
            {
              delete drc;
              drc = NULL;
            }
          }
        }//for (BasicBlock
      }//for (Function

      //update syncSet.
      syncSet[sync.id] = sync;
      //So far, there should be only read drc-1 or drc-4 in drcSet.
    }
        
    //step 4. inter-slice.
    //Reuse LLVMSlicer's inter-modSet, inter-pointTo, inter-callGraph, and 
    //inter-slice framework, intra-slice.

    /*
     * Assumptions: 
     * 1. Each of sync is a fft barrier, read-side and write-side are in the same function.
     * 2. Different syncs do not need to reside in the same function. (interprocedurally handling.)
     * */
    bool Slicer::findAllCriteria(vector<CallSite> &calls, Module &M)
    {
      Function *pCriteria = M.getFunction(__SLICING_FUN__);
      if(pCriteria)
      {
        //Find all the invocation incurred by CallInst.
        //Do not consider InvokeInst at this time.
        for(User *U: pCriteria->users())
        {
          if (Instruction *Inst = dyn_cast<Instruction>(U))
          {
            if(CallInst *call = dyn_cast<CallInst>(U))
            {
              CallSite CS(call);
              calls.push_back(CS);
              collectSyncInfo(call);
            }
            else if(InvokeInst *call = dyn_cast<InvokeInst>(U))
            {
              assert(0 && "InvokeInst: Not implemented yet !");
            }
          }
        }
      }
      else
      {
        assert(0 && "No slicing criteria in the program\n");
      }
      
      //Sanity check.
      int size = calls.size();
      assert( (size%2 == 0) && "There should be even number of criteria.");

      //Calculate whether sync Pairs are in the same function.
      return isSyncPairsInSameFunction();
    }
    
    /*
     * Collect information about pthread_create.
     * a. how many invocations ? (the return value)
     * b. whether inside a loop ?
     * c. loop level.
     * d. the entry function.
     *
     * TODO: the path constraints.
     * */
    unsigned Slicer::analyzePthread_Create(Module &M)
    {
      //Get the Function pointer to pthread_create.
      StringRef funcName = "pthread_create";
      Function *pfuncPthread_Create = M.getFunction(funcName);
      Function *main = M.getFunction("main");
      if(pfuncPthread_Create)
      {
        errs() << "pthread_create\n";
        pfuncPthread_Create->dump();
      }
      else
      {
        assert(0 && "Cannot find pthread_create in the module !");
      }

      //Find all the invocation to pthread_create.
      for (User *U : pfuncPthread_Create->users()) 
      {
        if (Instruction *Inst = dyn_cast<Instruction>(U)) 
        {
          if(CallInst *call = dyn_cast<CallInst>(U)) 
          {
            pthreadCreateInfo pTCInfo;
            pTCInfo.callInst = call;

            //Check if pthread_create is inside a loop.
            BasicBlock *parentBB = call->getParent();
            assert(parentBB && "parentBB for pthread_create cannot be NULL !");
            LoopInfo *LI = &getAnalysis<LoopInfoWrapperPass>(*parentBB->getParent()).getLoopInfo();

            //Get Loop nest level.
            unsigned Level = LI->getLoopDepth(parentBB);
            pTCInfo.level = Level;
            if(Level > 0)
            {
              pTCInfo.bInLoop = true;
              pTCInfo.PthreadCreateLoop = LI->getLoopFor(parentBB);
            }
            else
            {
              pTCInfo.bInLoop = false;
              pTCInfo.PthreadCreateLoop = NULL;
            }

            //Extract the entry function.
            Function *entryFunction = dyn_cast<Function>(call->getOperand(2)->stripPointerCasts());
            assert(entryFunction != NULL && "pthread_create function should not be empty.");
            pTCInfo.entryFunction = entryFunction;

            vecPthreadCreate.push_back(pTCInfo);
          }
          else
          {
            errs() << "pthread_create: abnormal usage\n";
            errs() << *Inst << "\n";
            assert(0);
          }
        }
        else
        {
          assert(0 && "pthread_create cannot be address-taken.");
        }
      }

      return vecPthreadCreate.size();
    }

    /*
     * Find the last constant assignment to a variable(stack) in bb.
     * If the last assignment to IndVar is not a constant, return NULL;
     * Otherwise, return the pointer to the constant.
     * */
    ConstantInt * Slicer::FindLastAssigment(vector<BasicBlock*>& bbSet, Instruction * IndVar)
    {
      vector<BasicBlock*>::iterator vi = bbSet.begin();
      vector<BasicBlock*>::iterator ve = bbSet.end();
      for(; vi != ve; ++vi)
      {
        BasicBlock *bb = *vi;
        BasicBlock::reverse_iterator ri = bb->rbegin();
        BasicBlock::reverse_iterator re = bb->rend();
        StoreInst *store = NULL;
        for(; ri != re; ++ri)
        {
          if((store = dyn_cast<StoreInst>(&(*ri)))
              && (store->getPointerOperand() == IndVar)
            )
          {
            //extract the constant assigned to IndVar if possible.
            if(ConstantInt *constVal = dyn_cast<ConstantInt>(store->getOperand(0)))
            {
              return constVal;
            }
          }
        }
      }

      return NULL;
    }

    void Slicer::FixNumOfThreads(Loop *pthreadCreateLoop)
    {
      assert(pthreadCreateLoop != NULL && "pthread_create loop cannot be NULL.\n");
      BasicBlock *loopHeader = pthreadCreateLoop->getHeader();
      
      //This is essentially a pattern-matching process. The algorithm has no general power to
      //figure out IV, step size, trip count and start value. It should be replaced with Scalar-evolution.
      BasicBlock::iterator i = loopHeader->begin();
      BasicBlock::iterator e = loopHeader->end();
      for(; i != e; ++i)
      {
        //Find load instruction.
        if(LoadInst *load = dyn_cast<LoadInst>(i))
        {
          if(GlobalVariable *gv = dyn_cast<GlobalVariable>(load->getPointerOperand()))
          {
            //It is highly possible a variable like P: a global variable used as the loop upper bound.
            //Look for the instruction pattern
            // load %i
            //  load @P
            //  %cmp icmp P, var
            //  br %cmp true %loop_body, false %loop_exit
            Instruction *afterLoad = load->getNextNode();
            if(ICmpInst *icmp = dyn_cast<ICmpInst>(afterLoad))
            {
              if(icmp->getOperand(1) == load && icmp->getPredicate() == ICmpInst::ICMP_SLT)
              {
                Instruction *afterICmp = icmp->getNextNode();

                //False branch is pthreadCreateLoop's exit bb.
                BranchInst *brInst = NULL;
                if( (brInst = dyn_cast<BranchInst>(afterICmp))
                    && (brInst->getCondition() == icmp)
                    && brInst->getOperand(1) == pthreadCreateLoop->getExitBlock()
                  )
                {
                  //i < P must be true for the loop body to be executed.

                  //Now, try to figure out i's value.
                  //Steps:
                  //1. Get i.
                  //2. Find last constant assignment to i in loop header and preheader.

                  //1. Get i.
                  LoadInst *loadIndVar = dyn_cast<LoadInst>(icmp->getOperand(0));
                  Instruction * IndVar = dyn_cast<Instruction>(loadIndVar->getPointerOperand()); // induction variable.
                  BasicBlock *preHeader = pthreadCreateLoop->getLoopPreheader();

                  //2. Find last constant assignment to i in loop header and preheader.
                  vector<BasicBlock*> bbSet;
                  bbSet.push_back(loopHeader);
                  bbSet.push_back(preHeader);
                  ConstantInt *constVal = FindLastAssigment(bbSet, IndVar);

                  //Increment constVal by 1.
                  //Reference: http://stackoverflow.com/questions/9196009/set-value-for-llvmconstantint
                  constVal = ConstantInt::get(constVal->getContext(), constVal->getValue()+1);

                  //constVal is P's base, i.e., P >= constVal
                  //Since P is integer with half-open range to positive infinity, it may be interesting if
                  //we generate a list of P. Now, we can record P is a range.
                  Instruction &front = preHeader->front();
                  StoreInst *store = new StoreInst(constVal, gv, false, &front);

                  return;
                }
              }
            }
          }
          else if(&(loopHeader->front()) != load)
          {
            if(GetElementPtrInst *gep = dyn_cast<GetElementPtrInst>(load->getPrevNode()))
            {
              //the second pattern: loop upper-bound is a 1-level indirect field of a struct.
              //E.g. gm->nprocs
              //The translation is as following:
              //%1 = load %struct.gmem** @gm, align 8
              //%nprocs = getelementptr inbounds %struct.gmem* %1, i32 0, i32 0
              //%2 = load i64* %nprocs, align 8
              //It is a drc-2: load, gep, load.
              //It will be transformed into: load, %addr = gep, (store %addr, 1), load as
              //%1 = load %struct.gmem** @gm, align 8
              //%nprocs = getelementptr inbounds %struct.gmem* %1, i32 0, i32 0
              //store i64* %nprocs, i32 2
              //%2 = load i64* %nprocs, align 8
              if(gep == load->getPointerOperand())
              {
                if(LoadInst *firstLoad = dyn_cast<LoadInst>(gep->getOperand(0)))
                {
                  IntegerType * type;
                  if(gep->getType()->getPointerElementType()->getScalarSizeInBits() == 32)
                  {
                    type = IntegerType::getInt32Ty(load->getContext());
                  }
                  else if(gep->getType()->getPointerElementType()->getScalarSizeInBits() == 64)
                  {
                    type = IntegerType::getInt64Ty(load->getContext());
                  }
                  else
                  {
                    assert(0 && "UnSupported now !\n");
                  }

                  ConstantInt *constVal = ConstantInt::get(type, 2);
                  StoreInst *store = new StoreInst(constVal, gep, false, load);

                  return;
                }
              }
            }
          }
        }
      }
   
      assert(0 && "Pattern matching fails.\n");
    }

    void Slicer::insertLoopID(Module *mod, Instruction *insertBefore)
    {
      BasicBlock *regionEntryBB = insertBefore->getParent();
      Function *regionResideFunction = regionEntryBB->getParent();
      LoopInfo *loopInfo = &getAnalysis<LoopInfoWrapperPass>(*regionResideFunction).getLoopInfo();
      Loop *resideLoop = loopInfo->getLoopFor(regionEntryBB);

      if(resideLoop != NULL)
      {
        BasicBlock *exitBlock = resideLoop->getUniqueExitBlock();
        
        //exitBlock is the unique exit of the resideLoop. If a loop
        //has more than 1 exit Block, exitBlock would be NULL.
        if(exitBlock != NULL)
        {
          Instruction *first = &(exitBlock->front());
          CallInst *call = dyn_cast<CallInst>(first);
          
          if(NULL == call || call->getCalledFunction()->getName() != "loopExit")
          {
            //currentLoopID [0~9]
            ostringstream oss;
            oss << currentLoopID;
            string loopIDString = oss.str();
#if 0 
            //insert loopCurrent(loopID) in the entry of current sync region.
            insertLoopCurrent(mod, insertBefore, StringRef(loopIDString));
            
            //insert loopExit in the unique loop exit block.
            insertLoopExit(mod, first, StringRef(loopIDString));
#endif
            currentLoopID++;
          }
          else// if(call->getCalledFunction()->getName() == "loopExit")
          {
            //currentLoopID [0~9]
            ConstantInt *constID = dyn_cast<ConstantInt>(call->getOperand(0));
            int loopID = constID->getSExtValue(); 
            ostringstream oss;
            oss << loopID;
            string loopIDString = oss.str();
            
            //insert loopCurrent(loopID) in the entry of current sync region.
             insertLoopCurrent(mod, insertBefore, StringRef(loopIDString));
          }
        }
        else
        {
          assert(0 && "The loop has more than 1 exit Block.");
        }
      }
    }
    
    void Slicer::insertSyncID(Module &mod)
    {
      for(SyncSet::iterator it=syncSet.begin(), ie=syncSet.end(); it != ie; ++it)
      {
        Sync sync = it->second;
        Instruction *insertBefore = sync.begin;
        ostringstream oss;
        unsigned int id = sync.id;
        oss << id;
        string idString = oss.str();
        unsigned int size = idString.size();

        //instrument current Loop ID.
        //It will be thread-specific in Cloud9. Loop ID of the thread establishing fixed-point
        //is used for early-termination.
        insertLoopID(&mod, insertBefore);

        //insert Initialization for switches and counter, control flags for
        //interleavingEnumeration and sync variable recording.
        //Sync ID is used as a key to index syncData, which is inside Cloud9.
        insertInitialization(&mod, insertBefore, StringRef(idString.c_str()));
        
        //insert Increment.
        insertIncrement(&mod, insertBefore);
        
        for(int i=0; i<size; i++)
        {
          int ch = (int)idString[i];
          string s = to_string(ch);
          insertPrintChar(&mod, insertBefore, StringRef(s));
        }
      }
    }

    void Slicer::insertSyncBeginString(Module& mod)
    {
      for(SyncSet::iterator it=syncSet.begin(), ie=syncSet.end(); it != ie; ++it)
      {
        Sync sync = it->second;
        Instruction *insertBefore = sync.begin;
        int ch = 'Z';
        string s = to_string(ch);
        insertPrintChar(&mod, insertBefore, StringRef(s));
      }
    }

    /*
     * The current approach to distinguish read-side and write-side is tailored for FFT 1st barrier. We
     * may need significant modification later to accomodate other barriers.
     * Instrumentation for Scheduling consists of four parts:
     *   1. read-side instrumentation, sleep(2), at the same time as to instrument printY.
     *   2. write-side instrumentation, sleep(3), at the same time as to instrument printX.
     *   3. ordinary shared memory read/write, sleep(1), at the same time as to analyze DRCs in the
     *      current ad hoc sync. More precisely, it should be after recognizing and before inserting
     *      a drc into drcSet.
     *   4. noScheduling for atomic section, a special case to handle in 3.
     *
     * In order for better modularity, we design the following APIs.
     *   a. insertPrint(X|Y), for tracing.
     *   b. insertSchedulePointForReadSide (for 1), invoking insertSleep(2) 
     *      insertSchedulePointForWriteSide (for 2), invoking insertSleep(3)
     *      insertSchedulePointForOrdinary (for 3 and 4), invoking insertSleep(1) and skip the drc prior
     *      to placeholder noScheduling().
     *   c. insertSleep(1|2|3), similar to insertPrintf, parameterized. The parameter (1|2|3) are specified
     *      as interfaces between SynCat frontend and Cloud9. To understand them, please read design note
     *      in Cloud9 for exhaustive interleaving enumeration(scheduling).
     * */
    void Slicer::insertSchedulePointForReadSide(Module *mod, Instruction *insertBefore)
    {
      insertSleep(mod, StringRef("2"), insertBefore);
    }

    void Slicer::insertSchedulePointForWriteSide(Module *mod, Instruction *insertBefore)
    {
      insertSleep(mod, StringRef("3"), insertBefore);
    }

    bool Slicer::isInsideReadSideLoop(BasicBlock *bb)
    {
      for(SyncSetIt i = syncSet.begin(), e = syncSet.end(); i != e; ++i)
      {
        Sync sync = i->second;
        LoopBBSet readLoopBBSet = sync.readLoopBBSet;

        for(LoopBBSet::iterator it=readLoopBBSet.begin(), ie=readLoopBBSet.end(); it != ie; ++it)
        {
          BasicBlock *loopBB = *it;
          if(bb == loopBB)
          {
            return true;
          }
        }
      }

      return false;
    }
    
    void Slicer::insertSchedulePointForOrdinary(Module *mod, Instruction *insertBefore)
    {
      //for read-side loop, do not insert sleep(1).
      BasicBlock *currentBB = insertBefore->getParent();

      bool bInsideReadLoop = isInsideReadSideLoop(currentBB);
      if(!bInsideReadLoop)
      {
        insertSleep(mod, StringRef("1"), insertBefore);
      }
    }

    void Slicer::insertSchedulePointBetweenSyncRegions(Module *mod, Instruction *insertBefore)
    {
      insertSleep(mod, StringRef("4"), insertBefore); //SYNC_OUTSIDE
    }

    //Specialized instrumentslice for allAB.
    //1. No snap shot points are needed.
    //2. schedule points and trace point are needed.
    void Slicer::instrumentSlice_allAB(Module &mod, Function *F)
    {
      for(SyncSetIt i = syncSet.begin(), e = syncSet.end(); i != e; ++i)
      {
        Sync sync = i->second;

        //read side
        insertPrintY(&mod, sync.readCriteria);
        insertSchedulePointForReadSide(&mod, sync.loopLatchBB->getTerminator());
        //insertSchedulePointForReadSide(&mod, sync.readLoopExitBranch->getParent()->getFirstNonPHI());

        //write side
        //insertSchedulePointForOrdinary(&mod,sync.writeInst); 
        insertPrintX(&mod, sync.writeInst);
        insertSchedulePointForWriteSide(&mod, sync.writeCriteria);
      }
    }

    /*
     * Note: this function has no assumption on whether read-side and write-side are in the same function.
     * 1. read-side: replace Criteria with printf("Y")
     * 2. write-side: remove Criteria; insert printf("X") just before write(before "load, gep, gep, store",
     *                in the same BB as write-side).
     * */
    void Slicer::instrumentSlice(Module &mod, Function *F)
    {
      //insert print(syncID) for all the syncs.
      insertSyncID(mod);

      //insert print('Z')
      insertSyncBeginString(mod);

      //insert scheduling points
      for(SyncSetIt i = syncSet.begin(), e = syncSet.end(); i != e; ++i)
      {
        Sync sync = i->second;
        SchedulePointSet& schedulePointSet = sync.schedulePointSet;
        int snapshot_index = 0;
        SchedulePointSet::iterator I = schedulePointSet.begin(), E = schedulePointSet.end();
        for(; I != E; ++I)
        {
          SchedulePoint schedulePoint = *I;
          switch(schedulePoint.type)
          {
            case schedule_ordinary_read:
              //if schedulePoint is inside "atomic_cmpxchg", do not insert scheduling point.
              if(!(schedulePoint.context->getParent()->getParent()->getName() == __ATOMIC_FUN__)
                  && !(schedulePoint.context->getParent()->getParent()->getName() == __ATOMIC_FUN_1__)
                )
              {
                insertSchedulePointForOrdinary(&mod, schedulePoint.context->getNextNode());
              }

              break;
            case schedule_ordinary_write:
              {
                if(!(schedulePoint.context->getParent()->getParent()->getName() == __ATOMIC_FUN__)
                    && !(schedulePoint.context->getParent()->getParent()->getName() == __ATOMIC_FUN_1__))
                {
                  insertSchedulePointForOrdinary(&mod, schedulePoint.context->getNextNode());
                }

                if(!bSnapshot)
                {
                  //insert snapshot point.
                  //TODO: Different store(write) to the same sync variable should share the same gSyncVar index.
                  //Therefore, there should be a map from store to gSyncVar index.
                  //But, for our current purpose, the two writes refer to different sync variables. So the
                  //current implementation is a short-cut for current datasets.
                  ostringstream oss;
                  oss << snapshot_index;
                  insertSnapShot(&mod, schedulePoint.context, StringRef(oss.str()), false);
                  bSnapshot = true;

                  insertRecordSyncVariables(&mod, schedulePoint.context);
                  
                  //insertSnapShot(&mod, schedulePoint.context, StringRef(oss.str()), true);
                }

                //although we do not insert the snapshot call, we still need to increment its index to
                //indicate there is a snapshot.
                snapshot_index++;
                break;
              }
            case schedule_read:
              insertPrintY(&mod, sync.readCriteria);
              insertSchedulePointForReadSide(&mod, sync.loopLatchBB->getTerminator()); 

              //insert a schedule point between two syncs.
              //TODO: for the last sync, this schedule point is redundant. But
              //it is not easy to detect it. Now, we just ignore this.
              //insertSchedulePointForOrdinary(&mod, sync.readCriteria);
              insertSchedulePointBetweenSyncRegions(&mod, sync.readCriteria);
              break;
            case schedule_write:
              {
                //insert snapshot point.
                ostringstream oss;
                oss << snapshot_index;
                insertSnapShot(&mod, sync.writeInst, StringRef(oss.str()), false);
                snapshot_index++;

                insertPrintX(&mod, sync.writeInst);
                insertSchedulePointForWriteSide(&mod, sync.writeCriteria);

                insertRecordSyncVariables(&mod, sync.writeInst);
                
                //invariant derivation point before the first write in write-side.
                //insertSnapShot(&mod, sync.writeInst, StringRef(oss.str()), true);
                //insertDeriveInvariant(&mod, sync.writeInst);
                break;
              }
            default:
              assert(0 && "No such scheduling point.\n");
          }
        }
      }

      //instrument waitForAll: main thread should wait until all children have exited.
      //Two special basic blocks: UnifiedUnreachableBlock and UnifiedReturnBlock
      Function *main = mod.getFunction("main");
      for (Function::iterator I = main->begin(), E = main->end(); I != E; ++I) 
      {
        BasicBlock &bb = *I;
        if(bb.getName() == "UnifiedReturnBlock" || bb.getName() == "UnifiedUnreachableBlock")
        {
          Instruction *terminator = bb.getTerminator();
          insertWaitForAll(&mod, terminator);
        }
      }

      //the UnifiedReturnBlock or UnifiedUnreachableBlock may not appear.
      std::vector<BasicBlock*> ReturningBlocks;
      std::vector<BasicBlock*> UnreachableBlocks;
      for (BasicBlock &I : *main)
        if (isa<ReturnInst>(I.getTerminator()))
          ReturningBlocks.push_back(&I);
        else if (isa<UnreachableInst>(I.getTerminator()))
          UnreachableBlocks.push_back(&I);

      if (UnreachableBlocks.size() == 1)
      {
        BasicBlock *UnreachableBlock = UnreachableBlocks.front();
        Instruction *terminator = UnreachableBlock->getTerminator();
        insertWaitForAll(&mod, terminator);
      }

      if (ReturningBlocks.size() == 1)
      {
        BasicBlock *ReturningBlock = ReturningBlocks.front();
        Instruction *terminator = ReturningBlock->getTerminator();
        insertWaitForAll(&mod, terminator);
      }
      
    }

    //step 7. remove slicing criteria.
    void Slicer::removeAuxilaryFunction(StringRef funcName)
    {
      Function *pFunc = module->getFunction(funcName);

      for(User *U: pFunc->users())
      {
        if(CallInst *call = dyn_cast<CallInst>(U))
        {
          call->eraseFromParent();
        }
      }
    }


  }
}
