//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.

#ifndef POST_DOMINANCE_FRONTIER
#define POST_DOMINANCE_FRONTIER

#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/DominanceFrontier.h"
#include "llvm/Analysis/DominanceFrontierImpl.h"
#include "llvm/Analysis/PostDominators.h"
#include "llvm/Transforms/Utils/UnifyFunctionExitNodes.h"

namespace llvm {

  struct CreateHammockCFG : public FunctionPass {
    static char ID;

    CreateHammockCFG() : FunctionPass(ID) { 
      initializeCreateHammockCFGPass(*PassRegistry::getPassRegistry());
    }

    virtual bool runOnFunction(Function &F);

    virtual void getAnalysisUsage(AnalysisUsage &AU) const {
      AU.addRequired<LoopInfoWrapperPass>();
    }
  };

  /*
   * Implement PostDominanceFrontier class by Tao for LLVM3.7
   * The DominanceFrontier is implemented in llvm/Analysis/DominanceFrontier.h, 
   * however, PostDominanceFrontier is implemented in this file of LLMVSlicer.
   * Moreover, PostDominanceFrontier also only implemented following member functions:
   * 1. void getAnalysisUsage(AnalysisUsage &UI) override; //public
   * 2. bool runOnFunction(Function &F) override; //public
   * 3. const DomSetType &calculate(const PostDominatorTree &DT, 
   *                                const DomTreeNode *Node); //private
   * 4. void releaseMemory() override;
   * 5. void print(raw_ostream &OS, const Module *) const;
   * 6. void dump() const;
   *
   * It also directly inherits FunctionPass as public base, and takes the new template
   * class InverseDominanceFrontier in llvm/Analysis/DominanceFrontier.h as member
   * object.
   * 
   * In this way, the interface of PostDominanceFrontier is kept unchanged, being
   * able to work with its client with modification to client code.
   * 
   * This design is essentially the same as class DominanceFrontier in 
   * llvm/Analysis/DominanceFrontier.h, different from the previous implementation in
   * LLVM3.4.
   * 
   * */

  struct PostDominanceFrontier: public FunctionPass
  {
    public:
      typedef DominatorTreeBase<BasicBlock> DomTreeT;
      typedef DomTreeNodeBase<BasicBlock> DomTreeNodeT;
      typedef DominanceFrontierBase<BasicBlock>::DomSetType DomSetType;
      typedef DominanceFrontierBase<BasicBlock>::iterator iterator;
      typedef DominanceFrontierBase<BasicBlock>::const_iterator const_iterator;
    
    public:
      PostDominanceFrontier();
      virtual ~PostDominanceFrontier() { }
      bool isPostDominator() const { return Base.isPostDominator(); }
      
      //See for override.
      //http://en.cppreference.com/w/cpp/language/override
      void getAnalysisUsage(AnalysisUsage &AU) const override
      {
        AU.setPreservesAll();
        //AU.addRequired<CreateHammockCFG>();
        AU.addRequired<PostDominatorTree>();
        //AU.addRequired<UnifyFunctionExitNodes>();
      }

      bool runOnFunction(Function &) override;
      void releaseMemory() override;
      void print(raw_ostream &OS, const Module * = nullptr) const override;
      void dump() const;

    public:      
      iterator begin() { return Base.begin(); }
      const_iterator begin() const { return Base.begin(); }
      
      iterator end() { return Base.end(); }
      const_iterator end() const { return Base.end(); } 
      
      iterator find(BasicBlock *B) { return Base.find(B); }
      const_iterator find(BasicBlock *B) const { return Base.find(B); }
      
    public:
      static char ID;
      InverseDominanceFrontierBase<BasicBlock> Base;
      
    private:
      const DomSetType &calculate(const PostDominatorTree &DT, const DomTreeNode *Node)
      {
        DomTreeT &postDomTree = *(DT.DT);
        return Base.calculate(postDomTree, Node);
      }
  };

}

#if 0  
  /// PostDominanceFrontier Class - Concrete subclass of DominanceFrontier that is
  /// used to compute the a post-dominance frontier.
  ///
  struct PostDominanceFrontier : public DominanceFrontierBase {
    static char ID;
    PostDominanceFrontier()
      : DominanceFrontierBase(ID, true) { }

    virtual bool runOnFunction(Function &F) {
      Frontiers.clear();
      PostDominatorTree &DT = getAnalysis<PostDominatorTree>();
#ifdef CONTROL_DEPENDENCE_GRAPH
      calculate(DT, F);
#else
      Roots = DT.getRoots();
      if (const DomTreeNode *Root = DT.getRootNode()) {
        calculate(DT, Root);
#ifdef PDF_DUMP
	errs() << "=== DUMP:\n";
	dump();
	errs() << "=== EOD\n";
#endif
      }
#endif
      return false;
    }

    virtual void getAnalysisUsage(AnalysisUsage &AU) const {
      AU.setPreservesAll();
      AU.addRequired<PostDominatorTree>();
    }

  private:
#ifdef CONTROL_DEPENDENCE_GRAPH
    typedef std::pair<DomTreeNode *, DomTreeNode *> Ssubtype;
    typedef std::set<Ssubtype> Stype;

    void calculate(const PostDominatorTree &DT, Function &F);
    void constructS(const PostDominatorTree &DT, Function &F, Stype &S);
    const DomTreeNode *findNearestCommonDominator(const PostDominatorTree &DT,
		    DomTreeNode *A, DomTreeNode *B);
#else
    const DomSetType &calculate(const PostDominatorTree &DT,
                                const DomTreeNode *Node);
#endif
  };
}
#endif
#endif
