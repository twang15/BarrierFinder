//===- llvm/Analysis/DominanceFrontier.h - Dominator Frontiers --*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This is the generic implementation of the DominanceFrontier class, which
// calculate and holds the dominance frontier for a function for.
//
// This should be considered deprecated, don't add any more uses of this data
// structure.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_ANALYSIS_DOMINANCEFRONTIERIMPL_H
#define LLVM_ANALYSIS_DOMINANCEFRONTIERIMPL_H

#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/Analysis/DominanceFrontier.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/GenericDomTree.h"

namespace llvm {

template <class BlockT>
class DFCalculateWorkObject {
public:
  typedef DomTreeNodeBase<BlockT> DomTreeNodeT;

  DFCalculateWorkObject(BlockT *B, BlockT *P, const DomTreeNodeT *N,
                        const DomTreeNodeT *PN)
      : currentBB(B), parentBB(P), Node(N), parentNode(PN) {}
  BlockT *currentBB;
  BlockT *parentBB;
  const DomTreeNodeT *Node;
  const DomTreeNodeT *parentNode;
};

template <class BlockT>
void DominanceFrontierBase<BlockT>::removeBlock(BlockT *BB) {
  assert(find(BB) != end() && "Block is not in DominanceFrontier!");
  for (iterator I = begin(), E = end(); I != E; ++I)
    I->second.erase(BB);
  Frontiers.erase(BB);
}

template <class BlockT>
void DominanceFrontierBase<BlockT>::addToFrontier(iterator I,
                                                  BlockT *Node) {
  assert(I != end() && "BB is not in DominanceFrontier!");
  assert(I->second.count(Node) && "Node is not in DominanceFrontier of BB");
  I->second.erase(Node);
}

template <class BlockT>
void DominanceFrontierBase<BlockT>::removeFromFrontier(iterator I,
                                                       BlockT *Node) {
  assert(I != end() && "BB is not in DominanceFrontier!");
  assert(I->second.count(Node) && "Node is not in DominanceFrontier of BB");
  I->second.erase(Node);
}

template <class BlockT>
bool DominanceFrontierBase<BlockT>::compareDomSet(DomSetType &DS1,
                                                  const DomSetType &DS2) const {
  std::set<BlockT *> tmpSet;
  for (BlockT *BB : DS2)
    tmpSet.insert(BB);

  for (typename DomSetType::const_iterator I = DS1.begin(), E = DS1.end();
       I != E;) {
    BlockT *Node = *I++;

    if (tmpSet.erase(Node) == 0)
      // Node is in DS1 but tnot in DS2.
      return true;
  }

  if (!tmpSet.empty()) {
    // There are nodes that are in DS2 but not in DS1.
    return true;
  }

  // DS1 and DS2 matches.
  return false;
}

template <class BlockT>
bool DominanceFrontierBase<BlockT>::compare(
    DominanceFrontierBase<BlockT> &Other) const {
  DomSetMapType tmpFrontiers;
  for (typename DomSetMapType::const_iterator I = Other.begin(),
                                              E = Other.end();
       I != E; ++I)
    tmpFrontiers.insert(std::make_pair(I->first, I->second));

  for (typename DomSetMapType::iterator I = tmpFrontiers.begin(),
                                        E = tmpFrontiers.end();
       I != E;) {
    BlockT *Node = I->first;
    const_iterator DFI = find(Node);
    if (DFI == end())
      return true;

    if (compareDomSet(I->second, DFI->second))
      return true;

    ++I;
    tmpFrontiers.erase(Node);
  }

  if (!tmpFrontiers.empty())
    return true;

  return false;
}

template <class BlockT>
void DominanceFrontierBase<BlockT>::print(raw_ostream &OS) const {
  for (const_iterator I = begin(), E = end(); I != E; ++I) {
    OS << "  DomFrontier for BB ";
    if (I->first)
      I->first->printAsOperand(OS, false);
    else
      OS << " <<exit node>>";
    OS << " is:\t";

    const std::set<BlockT *> &BBs = I->second;

    for (const BlockT *BB : BBs) {
      OS << ' ';
      if (BB)
        BB->printAsOperand(OS, false);
      else
        OS << "<<exit node>>";
    }
    OS << '\n';
  }
}

#if !defined(NDEBUG) || defined(LLVM_ENABLE_DUMP)
template <class BlockT>
void DominanceFrontierBase<BlockT>::dump() const {
  print(dbgs());
}
#endif

template <class BlockT>
const typename ForwardDominanceFrontierBase<BlockT>::DomSetType &
ForwardDominanceFrontierBase<BlockT>::calculate(const DomTreeT &DT,
                                                const DomTreeNodeT *Node) {
  BlockT *BB = Node->getBlock();
  DomSetType *Result = nullptr;

  std::vector<DFCalculateWorkObject<BlockT>> workList;
  SmallPtrSet<BlockT *, 32> visited;

  workList.push_back(DFCalculateWorkObject<BlockT>(BB, nullptr, Node, nullptr));
  do {
    DFCalculateWorkObject<BlockT> *currentW = &workList.back();
    assert(currentW && "Missing work object.");

    BlockT *currentBB = currentW->currentBB;
    BlockT *parentBB = currentW->parentBB;
    const DomTreeNodeT *currentNode = currentW->Node;
    const DomTreeNodeT *parentNode = currentW->parentNode;
    assert(currentBB && "Invalid work object. Missing current Basic Block");
    assert(currentNode && "Invalid work object. Missing current Node");
    DomSetType &S = this->Frontiers[currentBB];

    // Visit each block only once.
    if (visited.insert(currentBB).second) {
      // Loop over CFG successors to calculate DFlocal[currentNode]
      for (auto SI = BlockTraits::child_begin(currentBB),
                SE = BlockTraits::child_end(currentBB);
           SI != SE; ++SI) {
        // Does Node immediately dominate this successor?
        if (DT[*SI]->getIDom() != currentNode)
          S.insert(*SI);
      }
    }

    // At this point, S is DFlocal.  Now we union in DFup's of our children...
    // Loop through and visit the nodes that Node immediately dominates (Node's
    // children in the IDomTree)
    bool visitChild = false;
    for (typename DomTreeNodeT::const_iterator NI = currentNode->begin(),
                                               NE = currentNode->end();
         NI != NE; ++NI) {
      DomTreeNodeT *IDominee = *NI;
      BlockT *childBB = IDominee->getBlock();
      if (visited.count(childBB) == 0) {
        workList.push_back(DFCalculateWorkObject<BlockT>(
            childBB, currentBB, IDominee, currentNode));
        visitChild = true;
      }
    }

    // If all children are visited or there is any child then pop this block
    // from the workList.
    if (!visitChild) {
      if (!parentBB) {
        Result = &S;
        break;
      }

      typename DomSetType::const_iterator CDFI = S.begin(), CDFE = S.end();
      DomSetType &parentSet = this->Frontiers[parentBB];
      for (; CDFI != CDFE; ++CDFI) {
        if (!DT.properlyDominates(parentNode, DT[*CDFI]))
          parentSet.insert(*CDFI);
      }
      workList.pop_back();
    }

  } while (!workList.empty());

  return *Result;
}

/*
 * The following algorithm is in Tiger Book.
 * The implementation is originally in LLVM in the past, and borrowed by LLVMSlicer.
 * The major modification is that the following code is generic:
 * a. Type: BasicBlock -> BlockT
 * b. Iterator: pred_begin -> BlockTraits::child_begin, pred_end -> BlockTraits::child_end
 * c. typename. What is the difference between typename and class ?
 *
 * The above code is derived with implementation of DominanceFrontier::calculate in
 * LLVM3.4 and LLVM3.7, and PostDominanceFrontier::calculate in LLVM3.4. I don't understand
 * typename stuff, needing to learn more about C++ !
 *
 * Tao.
 * */
template <class BlockT>
const typename InverseDominanceFrontierBase<BlockT>::DomSetType &
InverseDominanceFrontierBase<BlockT>::calculate(const DomTreeT &DT,
                                                const DomTreeNodeT *Node) 
{
#if 0
  //What is the difference between Roots and RootNode ?
  //Does it matters if we have multiple BBs in Roots for PostDominanceFrontier ?
  //It seems there is always one RootNode. But, Roots can be multiple, including
  //both BBs with returnInst as Terminator(returnBBs), and BBs with UnreachableInst
  //as Terminator(UnreachableBBs). UnifyFunctionExitNodes Pass combines multiple BBs
  //into one returnBBs by removing their return instruction and add a new unconditional
  //branch to the new returnBBs. If necessary, insert Phi-Nodes for the return value.
  //CreateHammockCFG does less than that. It just adds a new UnreachableBB as the 
  //new end BB, and set the terminators of original UnreachableBBs as the new UnreachableBB,
  //which is also done by UnifyFunctionExitNodes. Additionally, CreateHammockCFG also
  //insert new entry "start", and split loop header, set the new end as false target of the
  //splited loop header(which is meaningless, IMO). These additional step does not do
  //anything critical to PostDominatorTree computation.
  //It is not clear to me how multiple Roots could affect the final PostDominanceFrontier
  //result. For DominanceFrontier, it is required that there is only one entry block. This
  //is trivial and always true. For PostDominanceFrontier, since there may be multiple exit
  //BBs(returnBBs), it will be problematic for postDominanceFrontier calculation, because
  //the classic algorithm in Tiger Book assumes there is only one returnBB(exitBB). With
  //UnifyFunctionExitNodes, I can guarantee this condition. But, why is there still multiple
  //roots(BB) for the PostDominatorTree ? One apparent reason is there are also UnreachableBBs
  //in a function, and that is the other root, in addition to returnBB. My question is:
  //if they are unreachable, why should we care them in the PostDominanceFrontier calculation ?
  //Why shouldn't we just ignore them in the calculation ? Or just simply remove them with dce ?
  //The UnifyFunctionExitNodes guarantees there is only one UnreachableBB and ReturnBB in any
  //given function. So, I may assume one of the root in the PostDominatorTree is UnreachableBB and
  //the other one is returnBB, and nothing else.
  //The ultimate answer lies in the PostDominatorTree construction pass. I just need more time
  //to dig it out. But, for current purpose, I don't want to do that. Let's just ignore that
  //now, if it comes again, I will consider solve it completely.
  this->Roots = DT.getRoots();
  assert(this->Roots.size() == 1 &&
         "Only one entry block for inverse domfronts!");
#endif

  // Loop over CFG successors to calculate DFlocal[Node]
  BlockT *BB = Node->getBlock();
  DomSetType &S = this->Frontiers[BB];       // The new set to fill in...
  if (DT.getRoots().empty()) return S; //Dead code due to assert in the beginning.

  if (BB)
    for (auto SI = BlockTraits::child_begin(BB),
        SE = BlockTraits::child_end(BB);
        SI != SE; ++SI) {
      BlockT *P = *SI;
      // Does Node immediately dominate this predecessor?
      DomTreeNode *SINode = DT[P];
      if (SINode && SINode->getIDom() != Node)
        S.insert(P);
    }

  // At this point, S is DFlocal.  Now we union in DFup's of our children...
  // Loop through and visit the nodes that Node immediately dominates (Node's
  // children in the IDomTree)
  //
  for (typename DomTreeNode::const_iterator
         NI = Node->begin(), NE = Node->end(); NI != NE; ++NI) {
    DomTreeNode *IDominee = *NI;
    const DomSetType &ChildDF = calculate(DT, IDominee);

    typename DomSetType::const_iterator CDFI = ChildDF.begin(), CDFE = ChildDF.end();
    for (; CDFI != CDFE; ++CDFI) {
      if (!DT.properlyDominates(Node, DT[*CDFI]))
        S.insert(*CDFI);
    }
  }

  return S;
}

} // End llvm namespace

#endif
