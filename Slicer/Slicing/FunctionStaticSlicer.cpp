//===- Hello.cpp - Example code from "Writing an LLVM Pass" ---------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
// Details are in a white paper by F. Tip called:
// A survey of program slicing techniques
//===----------------------------------------------------------------------===//

#include <ctype.h>
#include <map>
#include <vector>
#include <list>
#include <queue>
#include<sstream>

#include "llvm/IR/Constants.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Module.h"
#include "llvm/Pass.h"
#include "llvm/IR/TypeBuilder.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Analysis/PostDominators.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
#include "llvm/IR/CallSite.h"
#include "llvm/ADT/SCCIterator.h"
#include "llvm/Analysis/CallGraph.h"
#include "PostDominanceFrontier.h"
#include "llvm/ADT/SetVector.h"
//#include "../../../IR/ConstantsContext.h"

#include "../Callgraph/Callgraph.h"
#include "../Modifies/Modifies.h"
#include "../PointsTo/PointsTo.h"
#include "../Languages/LLVMSupport.h"
#include "../Languages/ConstantsContext.h"

#include "FunctionStaticSlicer.h"
#include "utility.h"
#include "ValueRangePropagation.h"
#include "Instrumenter.h"
#include "BoundaryDetection.h"

using namespace llvm::slicing;
using namespace Util;
using namespace llvm;
using namespace vrp;

static uint64_t getSizeOfMem(const Value *val) {

  if (const ConstantInt *CI = dyn_cast<ConstantInt>(val)) {
    return CI->getLimitedValue();
  } else if (const Constant *C = dyn_cast<Constant>(val)) {
    if (C->isNullValue())
      return 0;
    assert(0 && "unknown constant");
  }

  /* This sucks indeed, it is only a wild guess... */
  return 64;
}

/* dump the content of DEF for the current instruction */
void InsInfo::dumpDEF()
{
  //Format: <instruction, BB>
  for (ValSet::const_iterator I = DEF_begin(), E = DEF_end(); I != E ; I++)
  {
    const Pointee &DEFi = *I;
    DEFi.first->dump();
  }
}

void InsInfo::dumpREF()
{
  for (ValSet::const_iterator I = REF_begin(), E = REF_end(); I != E ; I++)
  {
    const Pointee &REFi = *I;
    REFi.first->dump();
  }
}

void InsInfo::dumpRC()
{
  for (ValSet::const_iterator I = RC_begin(), E = RC_end(); I != E ; I++)
  {
    const Pointee &RCi = *I;
    RCi.first->dump();
  }
}

#if 0
void InsInfo::dumpBB()
{
  //dump info(DEF, REF, RC, SC, BC) for a BB.
}
#endif

void InsInfo::dump()
{
  errs() << "Ins: ";
  ins->dump();
  errs() << "-------------------\n";

  if(isSliced())
  {
    errs() <<"Sliced\n";
  }
  else
  {
    errs() << "Unsliced\n";
  }	
  errs() << "-------------------\n";

  errs() << "DEF: ";
  dumpDEF();
  errs() << "-------------------\n";

  errs() << "REF: ";
  dumpREF();
  errs() << "-------------------\n";

  errs() << "RC: ";
  dumpRC();
  errs() << "-------------------\n";
}

void InsInfo::addDEFArray(const ptr::PointsToSets &PS, const Value *V,
    uint64_t lenConst) {
  if (isPointerValue(V)) {
    typedef ptr::PointsToSets::PointsToSet PTSet;

    const PTSet &L = getPointsToSet(V, PS);
    for (PTSet::const_iterator p = L.begin(); p != L.end(); ++p)
      for (uint64_t i = 0; i < lenConst; i++)
        addDEF(Pointee(p->first, p->second + i));
  }
}

void InsInfo::handleVariousFuns(const ptr::PointsToSets &PS, const CallInst *C,
    const Function *F) {
  if (!F->hasName())
    return;

  StringRef fName = F->getName();

  if (fName.equals("klee_make_symbolic")) {
    const Value *l = elimConstExpr(C->getArgOperand(0));
    const Value *len = elimConstExpr(C->getArgOperand(1));
    uint64_t lenConst = getSizeOfMem(len);

    addREF(Pointee(l, -1));
    addDEFArray(PS, l, lenConst);
    if (!isConstantValue(len))
      addREF(Pointee(len, -1));
  }
  else if(fName.equals("sqrt"))
  {
    //A function is handled slightly different than other instructions.
    //ModSet is always added into DEF
    //But, the arguments of a function are not added to REF immediately.
    //The decision is made when inter-procedural slicing happens in the form of DOWN and UP
    //operations. This is also the reason why a function with all its arguments as undefine
    //can be in the final slice, because its arguments are not relevant.
    for(llvm::User::const_op_iterator I = C->op_begin(), E = C->op_end()-1; I != E; ++I)
    {
      //Add the use into REF.
      const Value *operand = *I;
      addREF(Pointee(operand, -1));
    }
  }
}

void InsInfo::addREFArray(const ptr::PointsToSets &PS, const Value *V,
    uint64_t lenConst) {
  if (isPointerValue(V)) {
    typedef ptr::PointsToSets::PointsToSet PTSet;

    const PTSet &R = getPointsToSet(V, PS);
    for (PTSet::const_iterator p = R.begin(); p != R.end(); ++p)
      for (uint64_t i = 0; i < lenConst; i++)
        addREF(Pointee(p->first, p->second + i));
  }
}

//Check whether its poll-loop side or write-side.
//If Criteria() is the first instruction in its BB, it's poll-loop side;
//Otherwise, it's write side.
bool InsInfo::isWriteSide(CallInst const* const C)
{
  //Get its parent BB.
  const BasicBlock *parentBB = C->getParent();

  //Get the first instruction in parentBB.
  const Instruction& firstInst = parentBB->front();
  return !(C == &firstInst);
}

//What we should find is the instruction just before Criteria.
//For poll-loop side, it should be the branch instruction in the loop's exit BB.
//For write side, it should be the write instruction(store) just before Criteria().
const Instruction* InsInfo::findSlicingInst(CallInst const* const C, bool isWriteSide)
{

  const Instruction *ins = NULL;

  //The instruction before write-side Criteria should be store.
  if(isWriteSide)
  {
    //Get the instruction before the Criteria.
    const StoreInst* write = dyn_cast<StoreInst>(C->getParent()->getInstList().getPrev(C));
    assert(write != NULL && "The previous instruction is not a write !");

    ins = write;
  }
  else
  {

    //Find its parent BB: parentBB
    const BasicBlock *parentBB = C->getParent();

    //Find parentBB's predecessor: predBB.
    //Because we instrument just behind the while-loop, there must 
    //be only one edge from the loop exit BB to Criteria BB.
    const BasicBlock *predBB = parentBB->getSinglePredecessor();
    assert(predBB != NULL && "More than one predecessor for Criteria BB !");

    //Find the last branch instruction in predBB. This is the slicing criteria: sc.
    //For a well-formed predBB, the last instruction should be a terminator instrution
    //and the terminator should be a branch instruction.
    const TerminatorInst *termInst = predBB->getTerminator();
    assert(termInst != NULL && "The predBB is not well-formed !");

    const BranchInst *BI = dyn_cast<BranchInst>(termInst);
    assert(BI != NULL && "The terminator is not a branch instruction !");

    assert(BI->isConditional() && "BI is not conditional branch inst !");
    assert(!isConstantValue(BI->getCondition()) && "BI is unconditional !");

    ins = BI;
  }

  return ins;
}

//add parameter to REF only if it is not constant.
bool InsInfo::addParameterToREF(Value *parameter)
{
  if(!isConstantValue(elimConstExpr(parameter)))
  {
    addREF(Pointee(parameter, -1));
    return true;
  }

  return false;
}


InsInfo::InsInfo(const Instruction *i, const ptr::PointsToSets &PS,
    const mods::Modifies &MOD, FunctionStaticSlicer& fss) : ins(i), sliced(true) 
{
  typedef ptr::PointsToSets::PointsToSet PTSet;

  if (const LoadInst *LI = dyn_cast<const LoadInst>(i)) 
  {
    addDEF(Pointee(i, -1));

    const Value *op = elimConstExpr(LI->getPointerOperand());
    if (isa<ConstantPointerNull>(op)) 
    {
      errs() << "ERROR in analysed code -- reading from address 0 at " <<
        i->getParent()->getParent()->getName() << ":\n";
      i->print(errs());
    }
    else if (isa<ConstantInt>(op)) 
    {
    }
    else 
    {
      addREF(Pointee(op, -1));
      if (hasExtraReference(op)) 
      {
        addREF(Pointee(op, 0));
      }
      else 
      {
        const PTSet &S = getPointsToSet(op,PS);
        for (PTSet::const_iterator I = S.begin(), E = S.end(); I != E; ++I)
          addREF(*I);
      }
    }
  } 
  else if (const StoreInst *SI = dyn_cast<const StoreInst>(i)) 
  {
    const Value *op = SI->getPointerOperand();
    const Value *l = elimConstExpr(op);
#if 0
    if(GetElementPtrConstantExpr *gep = dyn_cast<GetElementPtrConstantExpr>(op))
    {
      //Record all its fields operands.
      //These operands will be used later in relevant statement calculation. The calculation
      //will compare each operands to detect whether two expression are the same or not.
      //
    }
    else
#endif
    {
      if (isa<ConstantPointerNull>(l)) 
      {
        errs() << "ERROR in analysed code -- writing to address 0 at " <<
          i->getParent()->getParent()->getName() << ":\n";
        i->print(errs());
      }
      else if (isa<ConstantInt>(l)) 
      {
      }
      else 
      {
        if (hasExtraReference(l)) 
        {
          addDEF(Pointee(l, 0));
        }
        else 
        {
          const PTSet &S = getPointsToSet(l, PS);

          for (PTSet::const_iterator I = S.begin(), E = S.end(); I != E; ++I)
            addDEF(*I);
        }

        if (!l->getType()->isIntegerTy())
          addREF(Pointee(l, -1));
        const Value *r = elimConstExpr(SI->getValueOperand());
        if (!hasExtraReference(r) && !isConstantValue(r))
          addREF(Pointee(r, -1));
      }
    }
  } 
  else if (const GetElementPtrInst *gep = dyn_cast<const GetElementPtrInst>(i)) 
  {
    addDEF(Pointee(i, -1));
    addREF(Pointee(gep->getPointerOperand(), -1));

    for (unsigned i = 1, e = gep->getNumOperands(); i != e; ++i) 
    {
      Value *op = gep->getOperand(i);

      if (!isConstantValue(op))
        addREF(Pointee(op, -1));
    }
  }
  else if (CallInst const* const C = dyn_cast<const CallInst>(i)) 
  {
    const Value *cv = C->getCalledValue();

    if (isInlineAssembly(C)) 
    {
      errs() << "ERROR: Inline assembler detected in " <<
        i->getParent()->getParent()->getName() << ", ignoring\n";

      //We always want to keep inline assembly. 
      //TODO: We can do better by examing the variables referenced by the inline assembly
      //      to decide whether to keep it in the finalSlice. Heuristically, inline
      //      assembly used operands "close" to it, it should be fine if we just leave
      //      it in the final slice. If there is counter-example, we will analyze it.
      //      Otherwise, leaving it as it is decreases engineering effort.
      //It seems, we have to analyze it because it is treated as function call. Without
      //analyze it, its referenced parameters are sliced away.
      for(llvm::User::const_op_iterator I = C->op_begin(), E = C->op_end()-1; I != E; ++I)
      {
        //Add the use into REF.
        const Value *operand = *I;
        addREF(Pointee(operand, -1)); //load inst
      }

      //It also defines an variable.
      addDEF(Pointee(i, -1));
    }
    else if (isMemoryAllocation(cv)) 
    {
      if (!isConstantValue(C->getArgOperand(0)))
        addREF(Pointee(C->getArgOperand(0), -1));

      addDEF(Pointee(i, -1));
    }
    else if (isMemoryDeallocation(cv)) 
    {
    }
    else if (isMemoryCopy(cv) || isMemoryMove(cv) || isMemorySet(cv))
    {
      const Value *len = elimConstExpr(C->getArgOperand(2));
      uint64_t lenConst = getSizeOfMem(len);

      const Value *l = elimConstExpr(C->getOperand(0));
      addDEFArray(PS, l, lenConst);
      addREF(Pointee(l, -1));

      const Value *r = elimConstExpr(C->getOperand(1));
      /* memset has a constant/variable there */
      if (isMemoryCopy(cv) || isMemoryMove(cv))
        addREFArray(PS, r, lenConst);
      addREF(Pointee(r, -1));

      /* memcpy/memset wouldn't work with len being 'undef' */
      if (!isConstantValue(len))
        addREF(Pointee(len, -1));
    }
    else
    {
      typedef std::vector<const llvm::Function *> CalledVec;

      /* did we miss something? */
      assert(!memoryManStuff(cv));

      //Somehow, the llvm generates different codes for calling an undefined function
      //on m32 and m64. Previously, LLVMSlicer was extended on m32; however, since it
      //constantly fails to compile on a m32 machine due to limited memory addressing
      //capability, we migrate to m64 machine. Thus, the assumption of the input has
      //been changed as well. The previous bitcast is no longer needed on m64. An elegant
      //solution would be detected m32 and m64 dynamically and goes through different
      //code paths. However, we take a shortcut here because we are just prototyping
      //our research idea.
      StringRef fName;
      if (const Function *F = dyn_cast<Function>(cv))
      {
        fName = F->getName();
        if(fName.equals(__WRAPPING_FUN__))
        {
          //const Value *lastOperand = &*(C->op_end()-1); //Equivaluent
          //const Value * lastOperand = C->getOperand(C->getNumOperands()-1);
          //fName = lastOperand->stripPointerCasts()->getName();

          //Find the instruction prior to codeWrapping() and its InsInfo.
          Instruction *prev = dyn_cast<Instruction>(const_cast<Instruction*>(C->getPrevNode()));
          InsInfo *insInfo = fss.getInsInfo(prev);
          assert(insInfo != NULL && "insInfo has not been initialized ! ");

          //Add all the uses(arguments of function call) to REF(because they are dependent source
          //operands) and RC(because the wrapping function is slice criteria, all operands in REF
          //are in initial criteria).
          //LLVM favors const iteration and pre-Increment.
          for(llvm::User::const_op_iterator I = prev->op_begin(), E = prev->op_end()-1; I != E; ++I)
          {
            //Add the use into REF.
            const Value *operand = *I;

            //skip NULL pointers.
            Value *operandVar = const_cast<Value*>(operand);
            ConstantPointerNull *nullPTR = dyn_cast<ConstantPointerNull>(operandVar);
            if(!nullPTR)
            {
              insInfo->addREF(Pointee(operand, -1));
              insInfo->addRC(Pointee(operand, -1));
            }
          }

          insInfo->deslice();
          deslice();  
        }
        else if(fName.equals(__SLICING_FUN__))
        {
          //C->op_end() is the next position to the last operand's iterator.
          //C->op_end()-1 is the iterator to the last operand.
          //We don't want process the last operand of a call instruction, it is the function being called.

          // More details: 
          // %call = call i32 bitcast (i32 (...)* @Criteria to i32 (i32, i32)*)(i32 %4, i32 %5), !dbg !26
          // %4 is operand 0, accessible by getOperand(0) or getArgOperand(0) because this is a call inst.
          // %5 is operand 1, accessible by getOperand(1) or getArgOperand(1) because this is a call inst.
          // i32 (i32, i32)* bitcast (i32 (...)* @Criteria to i32 (i32, i32)*) is operand 2. It is
          // the function being called.
          // %call is a name for the instruction's defined value(def). Internally, there is no such name; an
          // instruction's def is the instruction itself, an pointer to the instruction.
          bool bWriteSide = isWriteSide(C);
          const Instruction* SI = findSlicingInst(C, bWriteSide);
          InsInfo* insInfo = fss.getInsInfo(SI);
          assert(insInfo != NULL && "insInfo has not been initialized ! ");

          //Add RC and desliced.
          if(bWriteSide)
          {
            //add REF into RC.
            for (ValSet::const_iterator I = insInfo->REF_begin(), E = insInfo->REF_end(); I != E ; I++)
            {
              const Pointee &REFi = *I;
              insInfo->addRC(REFi);
            }
          }
          else
          {
            //Add RC and desliced.  
            const BranchInst *BI = dyn_cast<BranchInst>(SI);
            // REF has already been computed, we only need to add REF to RC.
            //insInfo->addREF(Pointee(BI->getCondition(), -1));
            insInfo->addRC(Pointee(BI->getCondition(), -1)); //Initial RC.
          }

          insInfo->deslice();

          //Always keep Criteria() for instrumentation purpose.
          deslice();
        }
        else if(fName.equals(__ATOMIC_FUN__) || fName.equals(__WAIT_FOR_ALL_FUN__) 
            ||fName.equals(__ATOMIC_FUN_1__)
            || fName.equals(__FSCANF__) ||fName.equals(__SSCANF__)
            || fName.equals(__STRCMP__)
            || fName.equals(__GETC__)
              )
        {
          //Design Note for scheduling point marking:
          //Place-holder. Mark the atomic section corresponding to inline "asm cmpxchg", so that
          //there will be no scheduling points inserted for shared memory read/write in the atomic
          //section. 
          //Goal: instruct the slicer not to insert scheduling points into the atomic section.
          //Design 1: A general approach and algorithm is as following:
          //  a. identify B0(atomic_section_begin resides in this BB) and B1(atomic section_end here).
          //  b. compute the set of BBs dominated by B0(denoted as dom(B0)); compute the set of BBs
          //     post-dominates by B1(denoted as pdom(B1)).
          //  c. compute intersection of dom(B0) and pdom(B1), denoted as atomic(B0, B1). The BBs in this
          //     set should not be inserted with any scheduling points if there were any shared memory
          //     read/write in it.
          //
          //Design 2: a heuristic approach based on the following facts
          //  a. if Bi is the unique predecessor of Bj, then Bi must dominate Bj.
          //  b. if Bk is the unique successor of Bj, then Bk must post-dominate Bj.
          //  c. if (Bi dom Bj) && (Bk pdom Bj), Bj is in the atomic region.
          //
          //Design 3: ad hoc solution(specialized for FFT barrier). The two successor BBs should be skipped
          //  when performing instrumentation for scheduling points.
          //
          //Design 4: In fact, we can even make it simpler to directly put a place-holder following
          //the shared memory read/write in the atomic section. The atomic section itself is also
          //implicit because of no atomic_section_begin/atomic_section_end is manually inserted into
          //the source code. However, the difficulty for this approach is that it is unclear how to 
          //mark a shared memory load happening in if condition expression. The solution is to modify
          //the atomic section code to introduce a temp variable. The code now is like:

          /*
          //atomic_section_begin();
          int temp;
          temp = (Global->start).count; 
          noScheduling();
          if(oldcount == temp)
          {
          (Global->start).count = newcount;
          noScheduling();
          updatedcount = oldcount;// updatedcount == oldcount, update succeeds.
          }
          else
          {
          updatedcount = (Global->start).count; // updatedcount != oldcount, update fails.
          noScheduling();
          }
          //atomic_section_end();
          */

          //Design 5: design 4 introduces challenges to insert scheduling point after the atomic section.
          //we put the atomic section in a function atomic_cmpxchg. Because the instrumenter does not perform
          //interprocedural analysis, there will be no scheduling point inserted after shared memory accesses
          //in atomic_cmpxchg. Meanwhile, the instrumenter inserts sleep(3) after it very easily.

          for(llvm::User::const_op_iterator I = C->op_begin(), E = C->op_end()-1; I != E; ++I)
          {
            //Add the use into REF.
            const Value *operand = *I;
            addREF(Pointee(operand, -1)); //load inst
          }

          deslice();
        }
        else if(fName.equals(__PTHREAD_CREATE__))
        {
          //Treat pthread_create(p0, p1, p2, p3) as p2(p0, p1, p3).
          //add pthread_creat's parameters to REF, skip constants and p1
          addParameterToREF(C->getOperand(0));
          addParameterToREF(C->getOperand(1));
          addParameterToREF(C->getOperand(3));
          deslice();
        }
        else if(fName.equals(__READ_ENV_FILE__))
        {
          addParameterToREF(C->getOperand(0));
        }
        else if(fName.equals(__FOPEN__))
        {
          addParameterToREF(C->getOperand(0));
        }
        else
        {
          handleVariousFuns(PS, C, F);
        }
      }
      else if(const Function *func = dyn_cast<const Function>(cv->stripPointerCasts()))
      {
        for(llvm::User::const_op_iterator I = C->op_begin(), E = C->op_end()-1; I != E; ++I)
        {
          //Add the use into REF.
          const Value *operand = *I;
          addREF(Pointee(operand, -1));
        }
      }
      else
      {
        addREF(Pointee(cv, -1));
      }


      //ModSet of a function is added to the callsite instruction's DEF.
      CalledVec CV;
      getCalledFunctions(C, PS, std::back_inserter(CV));
      for (CalledVec::const_iterator f = CV.begin(); f != CV.end(); ++f) 
      {
        //special handling for pthread_create.
        const Function *function = *f;
        if(fName.equals(__PTHREAD_CREATE__))
        {
          function = (const Function*)C->getOperand(2)->stripPointerCasts();
        }

        mods::Modifies::mapped_type const& M = getModSet(function, MOD);
        mods::Modifies::mapped_type::const_iterator v = M.begin();

        //Just for debugging.
        if(CV.size() < 0)
        {
          mods::dumpFunModifies(M, function);
        }

        for (; v != M.end(); ++v)
          addDEF(*v);
      }

      //Criteria is only a function invocation, which gets instrumented
      //into the source code. Without any declaration, LLVM assumes its
      //declaration as int (...), a var-arg function returning an int
      //value. When calling such Criteria, call inst firstly converts(bitcast)
      //it into the call-site prototype. If there are multiple call-sites with
      //different argument lists, then we have to assign a suffix to Criteria,
      //making it be Criteria[0-9]*. Currently, we do not need to do this.
      if (!callToVoidFunction(C) && !fName.equals(__SLICING_FUN__))
        addDEF(Pointee(C, -1));
    }
  } 
  else if (isa<const ReturnInst>(i)) 
  {
  }
  else if (const BinaryOperator *BO = dyn_cast<const BinaryOperator>(i)) 
  {
    addDEF(Pointee(i, -1));

    if (!isConstantValue(BO->getOperand(0)))
      addREF(Pointee(BO->getOperand(0), -1));
    if (!isConstantValue(BO->getOperand(1)))
      addREF(Pointee(BO->getOperand(1), -1));
  }
  else if (const CastInst *CI = dyn_cast<const CastInst>(i)) 
  {
    addDEF(Pointee(i, -1));

    if (!hasExtraReference(CI->getOperand(0)))
      addREF(Pointee(CI->getOperand(0), -1));
  }
  else if (const AllocaInst *AI = dyn_cast<const AllocaInst>(i)) 
  {
    addDEF(Pointee(AI, -1));
    if (!isConstantValue(AI->getArraySize()))
      addREF(Pointee(AI->getArraySize(), -1));
  }
  else if (const CmpInst *CI = dyn_cast<const CmpInst>(i)) 
  {
    addDEF(Pointee(i, -1));

    if (!isConstantValue(CI->getOperand(0)))
      addREF(Pointee(CI->getOperand(0), -1));
    if (!isConstantValue(CI->getOperand(1)))
      addREF(Pointee(CI->getOperand(1), -1));
  } 
  else if (const BranchInst *BI = dyn_cast<const BranchInst>(i)) 
  {
    if (BI->isConditional() && !isConstantValue(BI->getCondition()))
      addREF(Pointee(BI->getCondition(), -1));
  } 
  else if (const PHINode *phi = dyn_cast<const PHINode>(i)) 
  {
    addDEF(Pointee(i, -1));

    for (unsigned k = 0; k < phi->getNumIncomingValues(); ++k)
      if (!isConstantValue(phi->getIncomingValue(k)))
        addREF(Pointee(phi->getIncomingValue(k), -1));
  }
  else if (const SwitchInst *SI = dyn_cast<SwitchInst>(i)) 
  {
    if (!isConstantValue(SI->getCondition()))
      addREF(Pointee(SI->getCondition(), -1));
  }
  else if (const SelectInst *SI = dyn_cast<const SelectInst>(i)) 
  {
    // TODO: THE FOLLOWING CODE HAS NOT BEEN TESTED YET

    addDEF(Pointee(i, -1));

    if (!isConstantValue(SI->getCondition()))
      addREF(Pointee(SI->getCondition(), -1));
    if (!isConstantValue(SI->getTrueValue()))
      addREF(Pointee(SI->getTrueValue(), -1));
    if (!isConstantValue(SI->getFalseValue()))
      addREF(Pointee(SI->getFalseValue(), -1));
  }
  else if (isa<const UnreachableInst>(i)) 
  {
  }
  else if (const ExtractValueInst *EV = dyn_cast<const ExtractValueInst>(i)) 
  {
    addDEF(Pointee(i, -1));
    addREF(Pointee(EV->getAggregateOperand(), -1));
  }
  else if (const InsertValueInst *IV = dyn_cast<const InsertValueInst>(i)) 
  {
    //      TODO THE FOLLOWING CODE HAS NOT BEEN TESTED YET

    const Value *r = IV->getInsertedValueOperand();
    addDEF(Pointee(IV->getAggregateOperand(), -1));
    if (!isConstantValue(r))
      addREF(Pointee(r, -1));
  }
  else 
  {
    errs() << "ERROR: Unsupported instruction reached\n";
    i->print(errs());
  }
}

  namespace {
    class FunctionSlicer : public ModulePass {

      public:
        typedef std::pair<const BasicBlock*, bbData*> bType;
        typedef std::map<const BasicBlock *, bbData*> BBMap;
        typedef SetVector<const BasicBlock*> WorkList;
        typedef SmallVector<Pointer, 10> DRCSet;
        struct pthreadCreateInfo
        {
          CallInst *callInst; //the call instruction
          bool bInLoop; //whether it's inside a loop.
          unsigned level; //loop nest level. 0 if not inside a loop.
          Function *entryFunction; //the thread entry function.
        };

        vector<pthreadCreateInfo> vecPthreadCreate;
        typedef map<unsigned int, Sync> SyncSet;
        typedef map<unsigned int, Sync>::iterator SyncSetIt;
        SyncSet syncSet;
        void collectSyncInfo(CallInst *call);
        void isSyncPairsInSameFunction();
        
        DRCSet drcSet;
        DRCSet extraSP; //extra scheduling point
        map<const DRC*, Ranges> rangeMap;

        DRCSet & IdentifyDRCSet(Sync& sync);
        DRCSet& IdentifyDRCSet(vector<BasicBlock*>& bbSet, DRCSet& drcSet, bool insertAlways = false);
        bool isLoopInvariant(Instruction *ins, DRC* drc, Loop *loop);
        void findWriteDRCsForExtraSP(Instruction *boundaryInst);
        void detectSyncSchedulePoint(bool bCodeWrapping);
        void freeDRCSet();
        void dumpDRCSet();
        void dumpDRCSet(DRCSet& drcSet);
        void dumpRangeMap();
        bool insertDRCSet(DRC *drc, bool insertAlways = false);
        bool insertDRCSet(DRC *drc, DRCSet& drcSet, bool insertAlways = false);
        void freeDRCSet(DRCSet& drcSet);
        unsigned analyzePthread_Create(Module &M);

      public:
        struct CallerInfo
        {
          bool bInLoop; //whether it is in a loop of the caller.
          bool bPthreadCreate; //whether the caller is pthread_create.
          bool bThreadFunction; //whether it is the thread entry function.
          unsigned loopLevel; // loop nest level, 0 if not inside a loop.
          unsigned callerLevel; // the distance to the sliced function.
          CallInst *callInst; //the call instruction
          Function *caller; //the caller
          Function *callee; //the current callee.
        };
        map<Function*, vector<CallerInfo> > nodeSetTwo; //All the functions(nodes) belonging to segment two.
        map<Function*, vector<CallerInfo> > nodeSetOne; //All the functions(nodes) belonging to segment two.
        vector<CallerInfo> boundaryOfSegments;
        void collectCallerInfo(CallerInfo *info, CallInst *call, 
            int callerLevel, bool bPthreadCreate, Module &M);
        bool getValueRange(Function *fun, DRC *drc, BasicBlock *referenceBB);
        unsigned findSegmentTwo(Module &M, Function &F);
        unsigned findSegmentOne(Module &M);
        ConstantInt *FindLastAssigment(vector<BasicBlock*>& bbSet, Instruction * IndVar);
        bool getValueRangeWithPredicate(Function *func, DRC *drc, BasicBlock *referenceBB, Loop *pthreadCreateLoop);
        void insertSyncID(Module& mod);
        void insertSyncBeginString(Module& mod);

      public:
        bool isReadSideCriteria(CallInst *callInst);

      public:
        vector<CallSite> calls;

        //whether snapshot has already done for atomic_cmpxchg.
        //Only need insert snapshot once.
        bool bSnapshot;

        void instrumentSlice(Module& mod, Function *F);
        void instrumentForCodeWrapping(Module& mod);
        void addExposedDRCForWrapping(bool bCodeWrapping, FunctionStaticSlicer& ss);
        void markReadSyncVarRelevant(bool bCodeWrapping, FunctionStaticSlicer& ss, Function& F);
        void detectSyncBoundary(bool bCodeWrapping, FunctionStaticSlicer& ss, Function& F);
        void addReadSyncVarInLoop(Instruction *boundaryInst, SetOfDRC& syncVars, FunctionStaticSlicer& ss);
        void fixValueRanges(BasicBlock* referenceBB);
        void removeAuxilaryFunction(StringRef funcName);
        
        //interface between frontend and cloud9 scheduler.
        void insertSchedulePointForReadSide(Module *mod, Instruction *insertBefore);
        void insertSchedulePointForWriteSide(Module *mod, Instruction *insertBefore);
        void insertSchedulePointForOrdinary(Module *mod, Instruction *insertBefore);

      public:
        static char ID;
        Module* module;

        FunctionSlicer() : ModulePass(ID)
      {
        initializeFunctionSlicerPass(*PassRegistry::getPassRegistry());
        bSnapshot = false;
      }

        virtual bool runOnModule(Module &M);

        void getAnalysisUsage(AnalysisUsage &AU) const {
          AU.addRequired<DominatorTreeWrapperPass>();
          AU.addRequired<PostDominanceFrontier>();
          AU.addRequired<CallGraphWrapperPass>();
          AU.addRequired<LoopInfoWrapperPass>();
        }

        Instruction* getReadSideCriteria();
        Loop* getReadSideLoop(Instruction *readSideCriteria);
        bool isInsideReadSideLoop(BasicBlock *bb);
        bool isBusyWaitLoop(Loop *loop);
        bool isBusyWaitLoop(Loop *loop, SetOfDRC& setofDRC);
        bool findAllCriteria(std::vector<CallSite> &calls, Module& M);

        virtual ~FunctionSlicer()
        {
          freeDRCSet();
          freeDRCSet(extraSP);
        }

      private:
        bool runOnFunction(Function &F, const ptr::PointsToSets &PS,
            const mods::Modifies &MOD, bool bCodeWrapping);
    };
  }

#if 1
  //The Slicer serves as the front end of our framework.
  //It will look the call graph as well, not only CFG.
  //It will do the instrumentation and code wrapping, not decided yet.
  INITIALIZE_PASS_BEGIN(FunctionSlicer, "slice-intra", "Slices the code intraprocedurally", false, false)
    INITIALIZE_PASS_DEPENDENCY(DominatorTreeWrapperPass)
    INITIALIZE_PASS_DEPENDENCY(PostDominanceFrontier)
    INITIALIZE_PASS_DEPENDENCY(CallGraphWrapperPass)
    INITIALIZE_PASS_DEPENDENCY(LoopInfoWrapperPass)
    INITIALIZE_PASS_END(FunctionSlicer, "slice-intra", "Slices the code intraprocedurally", false, false)
    ModulePass* createFunctionSlicerPass(void)
    {
      return new FunctionSlicer();
    }
#else
  static RegisterPass<FunctionSlicer> X("slice-intra", "Slices the code intraprocedurally");
#endif
  char FunctionSlicer::ID;

  FunctionStaticSlicer::~FunctionStaticSlicer() {
    for (InsInfoMap::const_iterator I = insInfoMap.begin(), E = insInfoMap.end();
        I != E; I++)
      delete I->second;
  }

#if 0
  void FunctionStaticSlicer::dump()
  {
    //dump info(DEF, REF, RC, SC, BC) for the function.
  }
#endif

  typedef llvm::SmallVector<const Instruction *, 10> SuccList;

  static SuccList getSuccList(const Instruction *i) {
    SuccList succList;
    const BasicBlock *bb = i->getParent();
    if (i != &bb->back()) {
      BasicBlock::const_iterator I(i);
      I++;
      succList.push_back(&*I);
    } else {
      for (succ_const_iterator I = succ_begin(bb), E = succ_end(bb); I != E; I++)
        succList.push_back(&(*I)->front());
    }
    return succList;
  }

  bool FunctionStaticSlicer::sameValues(const Pointee &val1, const Pointee &val2)
  {
    return val1.first == val2.first && val1.second == val2.second;
  }

  /*
   * RC(i)=RC(i) \cup
   *   {v| v \in RC(j), v \notin DEF(i)} \cup
   *   {v| v \in REF(i), DEF(i) \cap RC(j) \neq \emptyset}
   */
  bool FunctionStaticSlicer::computeRCi(InsInfo *insInfoi, InsInfo *insInfoj) {
    bool changed = false;

    /* {v| v \in RC(j), v \notin DEF(i)} */
    for (ValSet::const_iterator I = insInfoj->RC_begin(),
        E = insInfoj->RC_end(); I != E; I++) {
      const Pointee &RCj = *I;
      bool in_DEF = false;
      for (ValSet::const_iterator II = insInfoi->DEF_begin(),
          EE = insInfoi->DEF_end(); II != EE; II++)
        if (sameValues(*II, RCj)) {
          in_DEF = true;
          break;
        }
      if (!in_DEF)
      {
        if (insInfoi->addRC(RCj))
          changed = true;
      }
      else
      {
        //temporary fix for radix. See more explanation in
        //FunctionStaticSlicer.h
        const Instruction *ins = insInfoi->getIns();

        if(const StoreInst *SI = dyn_cast<const StoreInst>(ins))
        {
          const Value *op = SI->getPointerOperand();

          //The following two implementation are both correct.
#if 1
          const GetElementPtrConstantExpr *gep = dyn_cast<GetElementPtrConstantExpr>(op);
          if(gep)
          {
            insInfoi->addRC(RCj);
          }
#else
          if(const ConstantExpr *CE = dyn_cast<ConstantExpr>(op))
          {
            //an array element extraction.
            string opcodeName = CE->getOpcodeName();
            string gep = "getelementptr";
            if(gep == opcodeName)
            {
              insInfoi->addRC(RCj);
            }
          }
#endif
        }
      }
    }
    /* DEF(i) \cap RC(j) \neq \emptyset */
    bool isect_nonempty = false;
    for (ValSet::const_iterator I = insInfoi->DEF_begin(),
        E = insInfoi->DEF_end(); I != E && !isect_nonempty; I++) {
      const Pointee &DEFi = *I;
      for (ValSet::const_iterator II = insInfoj->RC_begin(),
          EE = insInfoj->RC_end(); II != EE; II++) {
        if (sameValues(DEFi, *II)) {
          isect_nonempty = true;
          break;
        }
      }
    }

    /* {v| v \in REF(i), ...} */
    if (isect_nonempty)
      for (ValSet::const_iterator I = insInfoi->REF_begin(),
          E = insInfoi->REF_end(); I != E; I++)
        if (insInfoi->addRC(*I))
          changed = true;
#ifdef DEBUG_RC
    errs() << "  " << __func__ << "2 END";
    if (changed)
      errs() << " ----------CHANGED";
    errs() << '\n';
#endif
    return changed;
  }

  bool FunctionStaticSlicer::computeRCi(InsInfo *insInfoi) {
    const Instruction *i = insInfoi->getIns();
    bool changed = false;
#ifdef DEBUG_RC
    errs() << "  " << __func__ << ": " << i->getOpcodeName();
    if (i->hasName())
      errs() << " (" << i->getName() << ")";
    errs() << '\n';
    errs() << "    DUMP: ";
    i->print(errs());
    errs() << '\n';
#endif
    SuccList succList = getSuccList(i);
    for (SuccList::const_iterator I = succList.begin(), E = succList.end();
        I != E; I++)
      changed |= computeRCi(insInfoi, getInsInfo(*I));

    return changed;
  }

  void FunctionStaticSlicer::computeRC() {
    bool changed;
#ifdef DEBUG_RC
    int it = 1;
#endif
    do {
      changed = false;
#ifdef DEBUG_RC
      errs() << __func__ << ": ============== Iteration " << it++ << '\n';
#endif
      typedef std::reverse_iterator<Function::iterator> revFun;
      for (revFun I = revFun(fun.end()), E = revFun(fun.begin()); I != E; I++) {
        typedef std::reverse_iterator<BasicBlock::iterator> rev;
        InsInfo *past = NULL;
        for (rev II = rev(I->end()), EE = rev(I->begin()); II != EE; ++II) {
          InsInfo *insInfo = getInsInfo(&*II);
          if (!past)
            changed |= computeRCi(insInfo);
          else
            changed |= computeRCi(insInfo, past);
          past = insInfo;
        }
      }
    } while (changed);
  }

  /*
   * SC(i)={i| DEF(i) \cap RC(j) \neq \emptyset}
   */
  void FunctionStaticSlicer::computeSCi(const Instruction *i, const Instruction *j) {
    InsInfo *insInfoi = getInsInfo(i), *insInfoj = getInsInfo(j);

    bool isect_nonempty = false;
    for (ValSet::const_iterator I = insInfoi->DEF_begin(),
        E = insInfoi->DEF_end(); I != E && !isect_nonempty; I++) {
      const Pointee &DEFi = *I;
      for (ValSet::const_iterator II = insInfoj->RC_begin(),
          EE = insInfoj->RC_end(); II != EE; II++) {
        if (sameValues(DEFi, *II)) 
        {
          isect_nonempty = true;

          //update DefRcChain
          insInfoi->addDefRcChain(make_pair(DEFi, *II));
          break;
        }
      }
    }

    if (isect_nonempty) {
      insInfoi->deslice();
#ifdef DEBUG_SLICING
      errs() << "XXXXXXXXXXXXXY ";
      i->print(errs());
      errs() << '\n';
#endif
    }
  }

  void FunctionStaticSlicer::computeSC() {
    for (inst_iterator I = inst_begin(fun), E = inst_end(fun); I != E; I++) {
      const Instruction *i = &*I;
      SuccList succList = getSuccList(i);
      for (SuccList::const_iterator II = succList.begin(), EE = succList.end();
          II != EE; II++)
        computeSCi(i, *II);
    }
  }

  bool FunctionStaticSlicer::computeBC() {
    bool changed = false;
#ifdef DEBUG_BC
    errs() << __func__ << " ============ BEG\n";
#endif
    PostDominanceFrontier &PDF = MP->getAnalysis<PostDominanceFrontier>(fun);
    for (inst_iterator I = inst_begin(fun), E = inst_end(fun); I != E; I++) {
      Instruction *i = &*I;
      const InsInfo *ii = getInsInfo(i);
      if (ii->isSliced())
        continue;
      BasicBlock *BB = i->getParent();
#ifdef DEBUG_BC
      errs() << "  ";
      i->print(errs());
      errs() << " -> bb=" << BB->getName() << '\n';
#endif
      PostDominanceFrontier::const_iterator frontier = PDF.find(BB);
      if (frontier == PDF.end())
        continue;
      changed |= updateRCSC(frontier->second.begin(), frontier->second.end());
    }
#ifdef DEBUG_BC
    errs() << __func__ << " ============ END\n";
#endif
    return changed;
  }

  bool FunctionStaticSlicer::updateRCSC(
      PostDominanceFrontier::DomSetType::const_iterator start,
      PostDominanceFrontier::DomSetType::const_iterator end) {
    bool changed = false;
#ifdef DEBUG_RC
    errs() << __func__ << " ============ BEG\n";
#endif
    for (; start != end; start++) {
      const BasicBlock *BB = *start;
      const Instruction &i = BB->back();
      InsInfo *ii = getInsInfo(&i);
      /* SC = BC \cup ... */
#ifdef DEBUG_SLICING
      errs() << "XXXXXXXXXXXXXX " << BB->getName() << " ";
      i.print(errs());
      errs() << '\n';
#endif
      ii->deslice();
      /* RC = ... \cup \cup(b \in BC) RB */
      for (ValSet::const_iterator II = ii->REF_begin(), EE = ii->REF_end();
          II != EE; II++)
        if (ii->addRC(*II)) {
          changed = true;
#ifdef DEBUG_RC
          errs() << "  added " << (*II)->getName() << "\n";
#endif
        }
    }
#ifdef DEBUG_RC
    errs() << __func__ << " ============ END: changed=" << changed << "\n";
#endif
    return changed;
  }

  static bool canSlice(const Instruction &i) {
    switch (i.getOpcode()) {
      case Instruction::Alloca:
      case Instruction::Ret:
      case Instruction::Unreachable:
        return false;
      case Instruction::Br:
      case Instruction::Switch:
        return false;
    }
    return true;
  }

  void FunctionStaticSlicer::dumpContext(const llvm::Value *val)
{
  if(const Instruction *inst = dyn_cast<Instruction>(val))
  {
    //dump both function name and inst address.
    errs() << inst->getParent()->getParent()->getName() << ", Instruction * " << inst << "\n";
  }
  else if(const GlobalVariable *gv = dyn_cast<GlobalVariable>(val))
  {
    errs() << "GlobalVariable *" << gv << "\n";
  }
  else if(const Argument * arg = dyn_cast<Argument>(val))
  {
    errs() << arg->getParent()->getName() << ", \t" <<  "Argument * "<< arg << "\n";
  }
  else
  {
    //assert(0);
  }
}

  void FunctionStaticSlicer::dump() {
    //#define DEBUG_DUMP
    //#ifdef DEBUG_DUMP
#if 1
    for (inst_iterator I = inst_begin(fun), E = inst_end(fun); I != E; I++) {
      const Instruction &i = *I;
      const InsInfo *ii = getInsInfo(&i);
      i.print(errs());
      errs() << "\n    ";
      errs() << "-------------------\n";
#if 0		
      if (!ii->isSliced() || !canSlice(i))
        errs() << "UN";
      errs() << "SLICED\n    DEF:\n";
#else
      if(!ii->isSliced())
        errs() << "UNSliced, ";
      else
        errs() << "Sliced, ";

      if(!canSlice(i))
        errs() << "Cannot be sliced\n";
      else
        errs() << "Can be sliced\n";

      errs() << "    DEF:\n";
#endif      

      for (ValSet::const_iterator II = ii->DEF_begin(), EE = ii->DEF_end();
          II != EE; II++) {
        errs() << "      OFF=" << II->second << " ";
        II->first->dump();
        dumpContext(II->first);
      }
      errs() << "-------------------\n";

      errs() << "    DEF-RC chain:\n";
      for (DefRcChainSet::const_iterator II = ii->DefRcChain_begin(), EE = ii->DefRcChain_end();
         II != EE; II++)
      {
        errs() <<"      Def:" << " ";
        II->first.first->dump();

        errs() <<"\tRC ";
        II->second.first->dump();
      } 

      errs() << "-------------------\n";

      errs() << "    REF:\n";
      for (ValSet::const_iterator II = ii->REF_begin(), EE = ii->REF_end();
          II != EE; II++) {
        errs() << "      OFF=" << II->second << " ";
        II->first->dump();
        dumpContext(II->first);
      }
      errs() << "-------------------\n";

      errs() << "    RC:\n";
      for (ValSet::const_iterator II = ii->RC_begin(), EE = ii->RC_end();
          II != EE; II++) {
        errs() << "      OFF=" << II->second << " ";
        II->first->dump();

        dumpContext(II->first);
      }
      errs() << "-------------------\n";
    }
#endif
  }

  /**
   * this method calculates the static slice for the CFG
   */
  void FunctionStaticSlicer::calculateStaticSlice() {
#ifdef DEBUG_SLICE
    errs() << __func__ << " ============ BEG\n";
#endif
    do {
#ifdef DEBUG_SLICE
      errs() << __func__ << " ======= compute RC\n";
#endif
      computeRC();
#ifdef DEBUG_SLICE
      errs() << __func__ << " ======= compute SC\n";
#endif
      computeSC();

#ifdef DEBUG_SLICE
      errs() << __func__ << " ======= compute BC\n";
#endif
    } while (computeBC());

#if 0
    dump();
#endif

#ifdef DEBUG_SLICE
    errs() << __func__ << " ============ END\n";
#endif
  }

  bool FunctionStaticSlicer::slice() {
#ifdef DEBUG_SLICE
    errs() << __func__ << " ============ BEG\n";
#endif
    bool removed = false;
    for (inst_iterator I = inst_begin(fun), E = inst_end(fun); I != E;) {
      Instruction &i = *I;
      InsInfoMap::iterator ii_iter = insInfoMap.find(&i);
      assert(ii_iter != insInfoMap.end());
      const InsInfo *ii = ii_iter->second;
      ++I;
      if (ii->isSliced() && canSlice(i)) {
#ifdef DEBUG_SLICE
        errs() << "  removing:";
        i.print(errs());
        errs() << " from " << i.getParent()->getName() << '\n';
#endif
        i.replaceAllUsesWith(UndefValue::get(i.getType()));
        i.eraseFromParent();
        insInfoMap.erase(ii_iter);
        delete ii;

        removed = true;
      }
    }
    return removed;
  }

  /**
   * removeUndefBranches -- remove branches with undef condition
   *
   * These are irrelevant to the code, so may be removed completely with their
   * bodies.
   */
  void FunctionStaticSlicer::removeUndefBranches(ModulePass *MP, Function &F) {
#ifdef DEBUG_SLICE
    errs() << __func__ << " ============ Removing unused branches\n";
#endif
    PostDominatorTree &PDT = MP->getAnalysis<PostDominatorTree>(F);
    typedef llvm::SmallVector<const BasicBlock *, 10> Unsafe;
    Unsafe unsafe;

    for (Function::iterator I = F.begin(), E = F.end(); I != E; ++I) {
      BasicBlock &bb = *I;
      if (std::distance(succ_begin(&bb), succ_end(&bb)) <= 1)
        continue;
      Instruction &back = bb.back();
      if (back.getOpcode() != Instruction::Br &&
          back.getOpcode() != Instruction::Switch)
        continue;
      const Value *cond = back.getOperand(0);
      if (cond->getValueID() != Value::UndefValueVal)
        continue;
      DomTreeNode *node = PDT.getNode(&bb);
      if (!node) /* this bb is unreachable */
        continue;
      DomTreeNode *idom = node->getIDom();
      assert(idom);
      /*    if (!idom)
            continue;*/
      BasicBlock *dest = idom->getBlock();
      if (!dest) /* TODO when there are nodes with noreturn calls */
        continue;
#ifdef DEBUG_SLICE
      errs() << "  considering branch: " << bb.getName() << '\n';
      errs() << "  dest=" << dest->getName() << "\n";
#endif
      if (PHINode *PHI = dyn_cast<PHINode>(&dest->front()))
        if (PHI->getBasicBlockIndex(&bb) == -1) {
          /* TODO this is unsafe! */
          unsafe.push_back(&bb);
          PHI->addIncoming(Constant::getNullValue(PHI->getType()), &bb);
        }
      BasicBlock::iterator ii(back);
      Instruction *newI = BranchInst::Create(dest);
      ReplaceInstWithInst(bb.getInstList(), ii, newI);
    }
    for (Unsafe::const_iterator I = unsafe.begin(), E = unsafe.end();
        I != E; ++I) {
      const BasicBlock *bb = *I;
      if (std::distance(pred_begin(bb), pred_end(bb)) > 1)
        errs() << "WARNING: PHI node with added value which is zero\n";
    }
#ifdef DEBUG_SLICE
    errs() << __func__ << " ============ END\n";
#endif
  }

bool FunctionStaticSlicer::isAllParametersUndefs(CallInst *callInst)
{
  assert(callInst != NULL && "Call instruction must be non-NULL.\n");

  //unsigned int numOfOperands = callInst->getNumOperands();
  //Ignore the last operand, because it is the called function.
  for(llvm::User::const_op_iterator I = callInst->op_begin(), E = callInst->op_end()-1; I != E; ++I)
  {
    if(!isa<UndefValue>(*I))
    {
      return false;
    }
  }

  if(callInst->getNumOperands() == 1)
  {
    return false;
  }

  return true;
}
  /**
   * removeUndefCalls -- remove calls with undef function
   *
   * These are irrelevant to the code, so may be removed completely.
   */
  void FunctionStaticSlicer::removeUndefCalls(ModulePass *MP, Function &F) {
    for (inst_iterator I = inst_begin(F), E = inst_end(F); I != E;) {
      CallInst *CI = dyn_cast<CallInst>(&*I);
      ++I;
      //if (CI && (isAllParametersUndefs(CI) || isa<UndefValue>(CI->getCalledValue())))
      if (CI && isa<UndefValue>(CI->getCalledValue()))
      {
        CI->replaceAllUsesWith(UndefValue::get(CI->getType()));
        CI->eraseFromParent();
      }
    }
  }

  void FunctionStaticSlicer::removeUndefs(ModulePass *MP, Function &F)
  {
    removeUndefBranches(MP, F);
    removeUndefCalls(MP, F);
  }

  static bool handleAssert(Function &F, FunctionStaticSlicer &ss,
      const CallInst *CI) {

    const char *ass_file = getenv("SLICE_ASSERT_FILE");
    const char *ass_line = getenv("SLICE_ASSERT_LINE");
    const ConstantExpr *fileArg = dyn_cast<ConstantExpr>(CI->getArgOperand(1));
    const ConstantInt *lineArg = dyn_cast<ConstantInt>(CI->getArgOperand(2));

    if (ass_file && ass_line) {
      if (fileArg && fileArg->getOpcode() == Instruction::GetElementPtr &&
          lineArg) {
        const GlobalVariable *strVar =
          dyn_cast<GlobalVariable>(fileArg->getOperand(0));
        assert(strVar && strVar->hasInitializer());
        const ConstantDataArray *str =
          dyn_cast<ConstantDataArray>(strVar->getInitializer());
        assert(str && str->isCString());
        /* trim the NUL terminator */
        StringRef fileArgStr = str->getAsString().drop_back(1);
        const int ass_line_int = atoi(ass_line);

        errs() << "ASSERT at " << fileArgStr << ":" << lineArg->getValue() << "\n";

        if (fileArgStr.equals(ass_file) && lineArg->equalsInt(ass_line_int)) {
          errs() << "\tMATCH\n";
          goto count;
        }
      }
      ss.addSkipAssert(CI);
      return false;
    }

count:
#ifdef DEBUG_INITCRIT
    errs() << "    adding\n";
#endif

    const Value *aif = F.getParent()->getGlobalVariable("__ai_init_functions",
        true);
    ss.addInitialCriterion(CI, ptr::PointsToSets::Pointee(aif, -1));

    return true;
  }

  bool llvm::slicing::findInitialCriterion(Function &F,
      FunctionStaticSlicer &ss,
      bool starting)
{
    bool added = false;
#ifdef DEBUG_INITCRIT
    errs() << __func__ << " ============ BEGIN\n";
#endif
    const Function *Fklee_assume = F.getParent()->getFunction("klee_assume");
#if 0
    const Function *F__assert_fail = F.getParent()->getFunction("__assert_fail");
    if (!F__assert_fail) /* no cookies in this module */
      return false;
#else
    const Function *F_criteria = F.getParent()->getFunction(__SLICING_FUN__);
    if(! F_criteria)
    {
      errs() << "Cannot find slicing criteria in Function: "
        << F.getName().str()
        << "\n";

      return false;
    }
    const Function *F__assert_fail = F_criteria; //maximize the reuse.
#endif

    for (inst_iterator I = inst_begin(F), E = inst_end(F); I != E; ++I) 
    {
      const Instruction *i = &*I;
      if (const StoreInst *SI = dyn_cast<StoreInst>(i))
      {
        const Value *LHS = SI->getPointerOperand();
        if (LHS->hasName() && LHS->getName().startswith("__ai_state_"))
        {
#ifdef DEBUG_INITCRIT
          errs() << "    adding\n";
#endif
          ss.addInitialCriterion(SI, ptr::PointsToSets::Pointee(LHS, -1));
        }
      } 
      else if (const CallInst *CI = dyn_cast<CallInst>(i)) 
      {
#if 0
        Function *callie = CI->getCalledFunction();
#else
        //This is more general than Function *callie = CI->getCalledFunction();
        Value *callie = CI->getOperand(CI->getNumOperands()-1)->stripPointerCasts();
#endif
        if (callie == F__assert_fail) 
        {
          //added = handleAssert(F, ss, CI);
        } 
        else if (callie == Fklee_assume) 
        { // this is kind of hack
          const Value *l = elimConstExpr(CI->getArgOperand(0));
          ss.addInitialCriterion(CI, ptr::PointsToSets::Pointee(l, -1));
        }
      }
      else if (const ReturnInst *RI = dyn_cast<ReturnInst>(i)) 
      {
        //special handling only for program entry function.
        if (starting) 
        {
          const Module *M = F.getParent();
          for (Module::const_global_iterator II = M->global_begin(),
              EE = M->global_end(); II != EE; ++II) 
          {
            const GlobalVariable &GV = *II;
            if (!GV.hasName() || !GV.getName().startswith("__ai_state_"))
              continue;
#ifdef DEBUG_INITCRIT
            errs() << "adding " << GV.getName() << " into " << F.getName() <<
              " to \n";
            RI->dump();
#endif
            ss.addInitialCriterion(RI, ptr::PointsToSets::Pointee(&GV, -1),
                false);
          }
        }
      }
      else if (const BranchInst *BI = dyn_cast<BranchInst>(i))
      {
        //the branch instruction whose RC is not empty is the initial slicing stmt.
        if(!ss.isRCEmpty(BI))
        {
          ss.deslice(BI);
          return true;
        }
      }
    }
#ifdef DEBUG_INITCRIT
    errs() << __func__ << " ============ END\n";
#endif
    return added;
  }

/*In code-wrapping mode, the exposed variables in drcSet are added into initial slicing criteria.
  Three options:
  a. mark all exposed vars defs into RC set. This includes unnecessary defs which do not reach 
  codeWrapping().
  b. mark drc chains into RC set. This requires too much manual tracking of drc chains and has
  the same issues as a.
  c. mark all exposed vars into codeWrapping()'s RC set. Minimal work and precise semantics.

  C is the right option.
  */
void FunctionSlicer::addExposedDRCForWrapping(bool bCodeWrapping, FunctionStaticSlicer& ss)
{
  if(bCodeWrapping)
  {
    //Steps:
    //1. Find callInst to codeWrapping().
    //2. Add drcSet into its RC set.

    Function *wrappingFunc = module->getFunction(__WRAPPING_FUN__);
    for(User *U: wrappingFunc->users())
    {
      if(CallInst *call = dyn_cast<CallInst>(U))
      {
        for(DRCSet::iterator I=drcSet.begin(), E=drcSet.end(); I != E; ++I)
        {
          DRC *tempDRC = (DRC*)(*I);
          if(tempDRC->size() == 1)//drc-1, P
          {
            //1. Find callInst to codeWrapping().
            InsInfo *insInfo = ss.getInsInfo(call);
            assert(insInfo != NULL && "insInfo has not been initialized ! ");

            //2. Add drcSet into its RC set.
            Value *operand = (Value*)(*tempDRC)[0];
            insInfo->addRC(ptr::PointsToSets::Pointee(operand, -1));
            insInfo->deslice();
          }
          else if(tempDRC->size() == 5) //drc-4, gsense/count
          {
            //It is not trivial to add drc-4 into RC set because drc-4 is composed by a sequence of multiple
            //instructions(load1, gep2, gep3, load4). If we use option a, it may introduce unnecessary 
            //instructions; if we use option c, it is not clear which instruction should be added into RC.
            //Even if we conservatively add all instructions into RC, the present intra-slicer cannot work
            //properly to identify(load1, gep2, gep3, store4). The answer is to use intra-vrp for more
            //precise RC set. The insight is, if a drc-4 is relevant at program point P, then its def must be
            //able to reach P. The limitation of this approach is shown below.
            //The following code sequence cannot be detected by intra-vrp
            //
            //Sequence 1:
            //load, gep, gep, load #load 
            //op1, op2             #modify
            //store                #store
            //
            //However, I conjecture that there is no such case in reality because Clang is translating literally.
            //It is impossible for me to imagine any source code sequence would be translated into the above code.
            //This result assures me that intra-vrp is necessarily and sufficiently capable.
            //
            //Therefore, we perform intra-vrp first while collecting the instruction context(the def instruction).
            //Then, we mark the last instruction(store4) in drc-4 as relevant. The first three instructions(load1,
            //gep2, gep3) will be automatically tracked by intra-slicer. The malloc of the global pointer Global
            //can also be tracked automatically.
            
            //get the instruction context for drc-4.
            const StoreInst *store = dyn_cast<const StoreInst>(tempDRC->getInsContext());
            Value *operand = (Value*)store->getPointerOperand();
            InsInfo *insInfo = ss.getInsInfo(store);

            //mark store as relevant: add store to RC set.
            insInfo->addRC(ptr::PointsToSets::Pointee(operand, -1));
            insInfo->deslice();
          }
          else
          {
            assert(0 && "Not implemented yet.");
          }
        }
      }
    }
  }
}

/*
 * In the current architecture, it is difficult to generate more than 1 bc as executable to backend.
 * We rely on gold to do finish the linkage process. By design, the linkage process can take only one
 * module in one linking process. This means it is impossible to generate multiple bc files and make
 * them go through the linkage process one by one.
 *
 * How to solve this problem ?
 * 1. Generate exactly 1 bc files. This solution is simple. For variables have a half-opened range,
 *    we can fix the variables's value to the smallest([c, +inf) ) or largest ( (-inf, c] ). However,
 *    we lose the chance to verify a wider range.
 *
 * 2. Generate multiple bc files and then rely on an external script to invoke the linker multiple times
 *    to generate the final bc file. The *.opt.bc file can be generated conveniently in our frontend. The
 *    external script can also include controls over our frontend. This approach seems simpler though a
 *    little uglier.
 *
 * If there is more than one var with a half-opened range, then a combinatorial list generator is to be
 * implemented. E.g., a={1,2}, b={3,4}. Then (a, b) = { (1,3), (1, 4), (2, 3), (2, 4) }. Since the number
 * of such variables is unknown, the generic algorithm seems inevitable. But, for our current purpose, we
 * know only 1 such variable, which is P, so we skip the generator's implementation now.
 * TODO: a generic combinatorial list generator. *
 * */
void FunctionSlicer::fixValueRanges(BasicBlock* referenceBB)
{
    map<const DRC*, Ranges>::iterator i=rangeMap.begin();
    map<const DRC*, Ranges>::iterator e=rangeMap.end();
    //BasicBlock *predecessor = referenceBB->getUniquePredecessor();
    for(; i != e; ++i)
    {
      switch(i->second.type)
      {
        case HALF_POSITIVE:
          {
            bdSet::iterator it = i->second.values.begin();
            ConstantInt *temp = (ConstantInt*)(*it);
            DRC *drc = const_cast<DRC*>(i->first);
            GlobalVariable * gvar = (GlobalVariable*)((*drc)[0]);
            Instruction &front = referenceBB->front();
            StoreInst *store = new StoreInst(temp, gvar, false, &front);
            
#if 0
            //Insert a store instruction before entering referenceBB.
            if(predecessor)
            {
              //If the referenceBB has only one predecessor, insert at the end of its 
              //predecessor(before terminator instruction)
              const DRC *drc = i->first;
              //GlobalVariable * gvar = (GlobalVariable*)(*drc)[0];
              //StoreInst *store = new StoreInst(temp, gvar, false, predecessor);
            }
            else
            {
              //If the referenceBB has more than one predecessors, create a new BB between
              //referenceBB and its predecessors;insert the instruct in the new BB.
              assert(0 && "Not implemented yet.\n");
            }
#endif
          }
          break;
 
        default:
          break;
      }
    }
}

/*
 * remove Criteria() and codeWrapping() from module.
 * 
 * */
void FunctionSlicer::removeAuxilaryFunction(StringRef funcName)
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

  /*
   * A possible design is to assume there is always one sync pair, with each side
   * marked as either write-side or read-side, so that
   * 1) we can test whether the two sides are in the same function or different 
   *    functions. Then, we decide whether the write-side dominates the read-side,
   *    or the write-side conditionally dominates the read-side, or any side is
   *    on the critical path, dominates the exit BB, or whether the read-side dominates
   *    the write-side(this will be a potential deadlock), etc.
   * 2) simplify the current implementation, because we only consider one pair at a time.
   * 3) if the write-side conditionally dominates(more precisely, conditionally reachable
   *    to) the read-side (of course, they are in the same function), then we know the 
   *    conditions are of interest and should be kept in the final slice. For the read-side,
   *    the loop will be kept as a whole; for the write-side, the slice continues until only
   *    global variables are unknown and need to decide their initial values(bounds). Then,
   *    we need perform interprocedural analysis or simple global domain analysis(for simple
   *    synchronization variables, this is very easy, just to find out all the assignment to
   *    the sync variable and kept those assignment satisfying the exit condition of the 
   *    read-side. In fact, syncFinder already provides such information). The interprocedural
   *    analysis is essentially value range propagation from main entry point to the stop point
   *    of write-side. We do not need to consider the stop point of read-side, because a meaningful
   *    pair can only be formed by read-side being conditionally dominated by write-side
   *    (fft barrier case). If read-side dominates write-side, then there will be potential
   *    deadlocks. We tend to assume the program is deadlock-free, and thus do not consider
   *    this read-side dominating write-side case's possibility. Similarly, we can argue that
   *    the case that write-side unconditionally dominates read-side is not interesting, either.
   *    Because, that will be a trival sequential case where, without the ad hoc sync, the program
   *    loses no synchronization semantics. Apparently, for interprocedural value range analysis,
   *    it is important to distinguish sequential region and concurrent region, from main to 
   *    pthread_create and from pthread_create to the write-side stop point. The sequential
   *    region is easy to analyze; for the concurrent region, we can assume all the threads runs
   *    parallel to the stop point, meaning that if there is no assignment to a sync variable
   *    in the concurrent region, we consider the value at the end of the sequential region
   *    is the value propagated to the stop point for all the threads involved, namely, the
   *    initial values of sync variables. Currently, we do not need to do this, because fft
   *    barrier does not involve this complexity. The concurrent region from pthread_create
   *    to Slave_start do not have much complexity. It seems this argument is ungrounded and
   *    thus we do need have that assignment-free analysis in the concurrent region.
   * 4) One big concern of all the analysis we employ is they are ad hoc and tailed to our
   *    dataset. In order to eliminate such concerns, we do need have a verification datasets.
   *    Otherwise, the concern will be valid and a big minus. I speculate that this concern
   *    will be valid even we have a verification dataset because ad hoc syncs are just too
   *    diverse, to analyze each point or each category, we have to design specific analysis.
   *    If that is true, it would be too bad.     
   * 5) The allAB detection. Whether syncFinder can find out allAB in MySql is a problem. If it
   *    cannot, then it will be meaningless for our classfication. To detect it, it is easy to
   *    notice that the array involved is a loop-invariant. Further analysis can find out it is
   *    a heap variable. Point-to analysis can find out it is shared between the main thread and
   *    children threads. But, without point-to analysis, there is no chance to discover it. 
   *    There are efforts of interprocedural pointer alias analysis in syncFinder. Moreover,
   *    we can implement such alias analysis if we have syncFinder's code base. Thus, it is
   *    reasonable to assume syncFinder can detect allAB in MySql. synCat has to find the array
   *    is loop invariant and part of the exit dependent variables. It also has to find out the
   *    shared pattern between the children threads and main thread, which is each child only 
   *    writes to an element of the array and the main thread depends on all the array elements.
   * 6) How to slice allAB ? The read-side is the while loop in function waitForThreads, but 
   *    waitForThreads is invoked multiple times in main. We don't want to handle all of them,
   *    because they are redundant. But, currently, we don't want to implement clone detection.
   *    Thus, my decision is to only consider the waitForThreads in main. We will have to 
   *    enumerate all the call-sites of waitForThreads, and then find the "first one". We can
   *    also argue that waitForThreads is only reachable by main thread, thus at any time point,
   *    there is only one call-site is in effect. Then, we only need to consider any one of them.
   *    What we want to show is the two pair is able to enforce allAB order by instrumentation.
   *    It is possible that they are not enforcing allAB; it is also possible that they are doing
   *    sth else. We only want to show one of the possibilities. In this sense, the analysis result
   *    is neither sound nor complete. But it is fine, because we are just trying to facilitate
   *    the understanding of the code, we are not going to transform the program which will require
   *    the soundness of analysis, or if soundness cannot be guaranteed by the analysis, it will
   *    be obtained by conservative assumptions that are always correct, alike the data dependency 
   *    analysis(if we cannot prove there is no dependency, then we assume there is).
   * 7) The initial condition for allAB can be directly inferred from read-side and write-side, because
   *    they only involves one-value condition. This is also true to other sync Pairs as well. That
  *    said, the value range propagation is specific to FFT barrier. This ad hoc aspect greatly 
    *    decrease the value of this project. At the worst case, this project will yield sth for written
    *    exam because of its engineering effort and research value(although maybe very little).
    * 8) (FFT barrier -> allAB -> Others -> More) * (slice -> instrument -> wrap -> dump)
    * */
    
template <class type> void dumpSet(set<type>& Set)
{
  if(Set.size() == 0)
  {
    errs() <<"{}\n";
  }
}

void handleBranchInst(BranchInst *BI, AuxiliaryInfo& auxInfo)
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

void handleCmpInst(CmpInst* CI, AuxiliaryInfo& auxInfo)
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

bool handleStoreInst(StoreInst *SI, AuxiliaryInfo& auxInfo, BasicBlock::reverse_iterator &i)
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
      
      if(!isConstantValue(SI->getOperand(0)))
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
                if(GlobalVariable *gAddr = dyn_cast<GlobalVariable>(firstLoad->getPointerOperand()))
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

bool handleLoadInst(LoadInst *LI, AuxiliaryInfo& auxInfo, BasicBlock::reverse_iterator &i)
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

      //Find drc-1 before insertion.
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
      //the source addr is on stack, thus it is a load from local variable.
      //it will be killed by store to the same source address.
      auxInfo.outLocal.insert(addr);

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
              if(GlobalVariable *gAddr = dyn_cast<GlobalVariable>(firstLoad->getPointerOperand()))
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

                //Find drc before insertion.
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

                //Advance iterator 3 times
                ++i; //gep
                ++i; //gep2
                ++i; //firstLoad
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

void handleBinaryOperator(BinaryOperator *BO, AuxiliaryInfo& auxInfo)
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

void handleCallInst(CallInst *call, AuxiliaryInfo& auxInfo)
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

void handleTruncInst(TruncInst *trunc, AuxiliaryInfo& auxInfo)
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

//the function body is a huge if statement. It is not meant to be complete. We handle the
//instructions which appears in FFT barrier first. Other cases may be added when necessary.
void computeGenKillEffectForOneInst(Instruction *ins, AuxiliaryInfo& auxInfo,
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
    else
    {
      assert(0 && "Not implemented yet !\n");
    }//The big if
}

void computeGenKillEffectForOneBB(BasicBlock *bb, AuxiliaryInfo& auxInfo)
{
  for(BasicBlock::reverse_iterator i = bb->rbegin(), e = bb->rend(); i != e; ++i)
  {
    Instruction &ins = *i;
    computeGenKillEffectForOneInst(&ins, auxInfo, i);
  }
}
            
bool computeChanges(AuxiliaryInfo& auxInfo, AuxiliaryInfo& oldAuxInfo)
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

//Extract sync ID from readside criteria.
unsigned int extractID(Instruction *readSideCriteria)
{
  return 1;
}

Instruction *findSyncBoundary(Function &F, AuxiliaryMap& auxiliaryMap, Instruction *readSideCriteria,
                             Sync& sync)
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

void releaseSyncVarsDRC(SetOfDRC& syncVars)
{
  for(SetOfDRC::iterator i = syncVars.begin(), e = syncVars.end(); i != e; ++i)
  {
    DRC *element = *i;
    delete element;
    element = NULL;
  }
}

bool findDRCinSyncVars(DRC *drc, SetOfDRC& syncVars)
{
  bool bFound = false;
  for(SetOfDRC::iterator i = syncVars.begin(), e = syncVars.end(); i != e; ++i)
  {
    DRC *element = *i;

    if(*element == *drc)
    {
      bFound = true;
      break;
    }
  }

  return bFound;
}

//add (read to syncVars & in Loop & reachable to boundaryBB).
void FunctionSlicer::addReadSyncVarInLoop(Instruction *boundaryInst, SetOfDRC& syncVars, FunctionStaticSlicer& ss)
{
  assert(boundaryInst != NULL && "Boundary Inst should not be empty.\n");
  BasicBlock* boundaryBB = boundaryInst->getParent();
  typedef queue<BasicBlock*> WorkSet;
  typedef set<BasicBlock*> HandledBBs;
  WorkSet workSet;
  HandledBBs handledBBs;
  workSet.push(boundaryBB);
  handledBBs.insert(boundaryBB);

  //handle boundaryBB firstly.
  LoopInfo *loopInfo = &getAnalysis<LoopInfoWrapperPass>(*boundaryBB->getParent()).getLoopInfo();
  if(loopInfo->getLoopDepth(boundaryBB) > 0)
  {
    assert(0 && "Sync boundary BB should not reside inside a loop");
  }
  else
  {
    //pop the front.
    while(!workSet.empty())
    {
      BasicBlock *currentBB = workSet.front();
      if(loopInfo->getLoopDepth(currentBB) > 0)
      {
        for(BasicBlock::reverse_iterator i = currentBB->rbegin(), e = currentBB->rend(); i != e; ++i)
        {
          Instruction *ins = &(*i);
          //Identify drc. The code is redundant in several places, it is for DRC identification in a given
          //BB.
          if(LoadInst *LI = dyn_cast<LoadInst>(ins))
          {
            const Value *op = elimConstExpr(LI->getPointerOperand());
            Instruction *addr = dyn_cast<Instruction>(const_cast<Value*>(op));
       
            if(GlobalVariable *gAddr = dyn_cast<GlobalVariable>(const_cast<Value*>(op)))
            {
              //DRC-1, load @p
              DRC* drc = new DRC;
              drc->push_back(gAddr);
              drc->setAccessType(true); // Read
              drc->setInsContext(ins);

              //Find drc in syncVars.
              if(findDRCinSyncVars(drc, syncVars))
              {
                InsInfo *insInfo = ss.getInsInfo(LI);
                assert(insInfo != NULL && "insInfo has not been initialized ! ");

                insInfo->deslice();
                insInfo->addRC(ptr::PointsToSets::Pointee(op, -1));
                
                Loop *loop = loopInfo->getLoopFor(currentBB);
                //Is there function call ? Does it contain a write-drc corresponding to the read-drc ?
                if(isLoopInvariant(ins, drc, loop))
                {
                  insertDRCSet(drc, extraSP, true);
                  continue;
                }
              }

              delete drc;
              drc = NULL;
            }
            else if(GetElementPtrInst *gep = dyn_cast<GetElementPtrInst>(addr)) //drc-4
            {
              if(LI->getPrevNode() == gep)
              {
                if(GetElementPtrInst *gep2 = dyn_cast<GetElementPtrInst>(gep->getOperand(0)))
                {
                  if(LoadInst *firstLoad = dyn_cast<LoadInst>(gep2->getOperand(0)))
                  {
                    if(gep2->getPrevNode() == firstLoad)
                    {
                      if(GlobalVariable *gAddr = dyn_cast<GlobalVariable>(firstLoad->getPointerOperand()))
                      {
                        //successfully identify a drc-4.
                        //firstLoad, gep2, gep, LI

                        //Create the DRC
                        DRC *drc = new DRC;

                        //firstLoad
                        drc->push_back(gAddr);
                        drc->setAccessType(true);//this DRC is a Read.
                        drc->setInsContext(ins);

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

                        if(findDRCinSyncVars(drc, syncVars))
                        {
                          InsInfo *insInfo = ss.getInsInfo(LI);
                          assert(insInfo != NULL && "insInfo has not been initialized ! ");

                          insInfo->deslice();
                          insInfo->addRC(ptr::PointsToSets::Pointee(op, -1));

                          //skip the next 3 instructions.
                          ++i;
                          ++i;
                          ++i;
                          
                          //Get loop for current drc and test whether it is busy-wait. A solution
                          //is to develop an iterative algorithm. But, it is more complex than 
                          //to answer the following two questions:
                          //a. whether the current drc is loop invariant ? 
                          //b. whether it is EDV(Exit Dependent Variable) ?
                          //Only when a & b are both true, the loop is a busy-wait loop. It seems a&b is
                          //a necessary and sufficient condition for busy-wait loop. But, it is not. It
                          //is a necessary condition but not sufficient condition. However, this heuristic
                          //makes much more sense than the following, which are merely implementation-oriented
                          //simplifications for the iterative algorithm. There are bad heuristic to answer
                          //whether a loop is busy-wait or not.
                          //1. #BBs in the loop.
                          //2. whether containing function calls.
                          //EDV test is not trivial to implement. Thus, we only implement loop invariant test now.
                          Loop *loop = loopInfo->getLoopFor(currentBB);
                          //Is there function call ? Does it contain a write-drc corresponding to the read-drc ?
                          if(isLoopInvariant(ins, drc, loop))
                          {
                            insertDRCSet(drc, extraSP, true);
                            continue;
                          }
                        }
                        
                        delete drc;
                        drc = NULL;
                      }
                    }
                  }
                }
              }
            }
          }
          else if(StoreInst *SI = dyn_cast<StoreInst>(ins))
          {
            //assert(0 && "Not implemented yet.\n");
          }
        }
      }

      workSet.pop();

      //push predecessors
      for(pred_iterator I = pred_begin(currentBB), E = pred_end(currentBB); I != E; ++I)
      {
        BasicBlock *pred = *I;
        
        //if pred has not been handled before, add it to workSet.
        HandledBBs::iterator it = handledBBs.find(pred);
        if(it == handledBBs.end())
        { 
          handledBBs.insert(pred);
          workSet.push(pred);
        }
      }
    }
  }
}

/*
 * For each sync, detect all the scheduling points and their type.
 * */
void FunctionSlicer::detectSyncSchedulePoint(bool bCodeWrapping)
{
  if(bCodeWrapping)
    return;

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

    IdentifyDRCSet(regionBBSet, regionDRCSet, true);

    //Only the DRCs which happens after boundaryInst belong to sync's schedule point.
    for(DRCSet::iterator I=regionDRCSet.begin(), E=regionDRCSet.end(); I != E; ++I)
    {
      DRC *drc = (DRC*)(*I);

      //whether DRC occurs before boundaryInst ?
      bool afterBoundaryInst = false;
      BasicBlock *boundaryBB = boundaryInst->getParent();
      Instruction* context = const_cast<Instruction*>(drc->getInsContext());
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

/*
 * a. Extract boundaryInst, exposed variables (syncVars).
 * b. Populate bbSet with BBs of corresponding sync.
 * */
void FunctionSlicer::detectSyncBoundary(bool bCodeWrapping, FunctionStaticSlicer& ss, Function& F)
{
  if(!bCodeWrapping)
  {
    for(SyncSetIt i = syncSet.begin(), e = syncSet.end(); i != e; ++i)
    {
      AuxiliaryMap auxiliaryMap;
      Sync sync = i->second;
      unsigned int id = sync.id; 

      Instruction *readSideCriteria = sync.readCriteria;
      Instruction *boundaryInst = findSyncBoundary(F, auxiliaryMap, readSideCriteria, sync);
      assert(boundaryInst != NULL && "Boundary Instruction should not be empty.\n");

      BasicBlock* boundaryBB = boundaryInst->getParent();
      SetOfDRC syncVars = auxiliaryMap[boundaryBB].outGlobal;
      
      sync.begin = boundaryInst;
      sync.syncVars = syncVars;
      syncSet[id] = sync;
    }
  }
}

void FunctionSlicer::markReadSyncVarRelevant(bool bCodeWrapping, FunctionStaticSlicer& ss, Function& F)
{
  if(!bCodeWrapping)
  {
    AuxiliaryMap auxiliaryMap;
    Sync sync = syncSet[1];

    //Get read side criteria.
    Instruction *readSideCriteria = getReadSideCriteria();
    Instruction *boundaryInst = findSyncBoundary(F, auxiliaryMap, readSideCriteria, sync);
    assert(boundaryInst != NULL && "Boundary Instruction should not be empty.\n");

    BasicBlock* boundaryBB = boundaryInst->getParent();
    SetOfDRC syncVars = auxiliaryMap[boundaryBB].outGlobal;
    
    sync.begin = boundaryInst;
    sync.syncVars = syncVars;
    syncSet[1] = sync;

    //Identify DRC-1 and DRC-4 backwardly, beginning with boundaryInst.
    addReadSyncVarInLoop(boundaryInst, syncVars, ss);

    //Find write DRC-1 and DRC-4 whose corresponding read DRC is in extraSP.
    findWriteDRCsForExtraSP(boundaryInst); 
  }
}

void FunctionSlicer::findWriteDRCsForExtraSP(Instruction *boundaryInst)
{
  assert(boundaryInst != NULL && "Boundary Inst should not be empty.\n");
  BasicBlock* boundaryBB = boundaryInst->getParent();
  typedef queue<BasicBlock*> WorkSet;
  typedef set<BasicBlock*> HandledBBs;
  WorkSet workSet;
  HandledBBs handledBBs;
  workSet.push(boundaryBB);
  handledBBs.insert(boundaryBB);

  //gather all the BBs before the 2nd barrier, including boundaryBB.
  while(!workSet.empty())
  {
    BasicBlock *currentBB = workSet.front();
    workSet.pop();
    for(pred_iterator I = pred_begin(currentBB), E = pred_end(currentBB); I != E; ++I)
    {
      BasicBlock *pred = *I;

      //if pred has not been handled before, add it to workSet.
      HandledBBs::iterator it = handledBBs.find(pred);
      if(it == handledBBs.end())
      { 
        handledBBs.insert(pred);
        workSet.push(pred);
      }
    }
  }

  DRCSet regionDRCSet;
  vector<BasicBlock*> regionBBSet; 
  for(set<BasicBlock*>::iterator I = handledBBs.begin(), E = handledBBs.end(); I != E; ++I)
  {
    BasicBlock *temp = *I;
    regionBBSet.push_back(temp);
  }
  IdentifyDRCSet(regionBBSet, regionDRCSet, true);

  //Only the write DRCs whose corresponding read DRCs in extraSP will be added into extraSP.
  for(DRCSet::iterator I=regionDRCSet.begin(), E=regionDRCSet.end(); I != E; ++I)
  {
    DRC *writeDRC = (DRC*)(*I);

    //whether writeDRC occurs before boundaryInst ?
    bool afterBoundaryInst = false;
    Instruction* context = const_cast<Instruction*>(writeDRC->getInsContext());
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

    //skip this drc because it is after boundary instruction.
    if(afterBoundaryInst)
    {
      continue;
    }

    for(DRCSet::iterator RI=extraSP.begin(), RE=extraSP.end(); RI != RE; ++RI)
    {
      DRC *readDRC = (DRC *)(*RI);
      if(*writeDRC == *readDRC && !writeDRC->getAccessType())
      {
        DRC *drc = new DRC(*writeDRC);
        insertDRCSet(drc, extraSP, true);
      }
    }
  }

  freeDRCSet(regionDRCSet);
}

bool FunctionSlicer::isBusyWaitLoop(Loop *loop)
{
  SetOfDRC setOfDRC;

  return isBusyWaitLoop(loop, setOfDRC);
}

bool FunctionSlicer::isBusyWaitLoop(Loop *loop, SetOfDRC& setofDRC)
{
}


bool FunctionSlicer::runOnFunction(Function &F, const ptr::PointsToSets &PS,
                                   const mods::Modifies &MOD,
                                   bool bCodeWrapping = false) 
{
  FunctionStaticSlicer ss(F, this, PS, MOD);
  
  //Mark var (in syncVars && in loop & read) relevant intra-procedurally.
#if 0
  markReadSyncVarRelevant(bCodeWrapping, ss, F);
#else
  detectSyncBoundary(bCodeWrapping, ss, F);
  detectSyncSchedulePoint(bCodeWrapping); 
#endif
  
  addExposedDRCForWrapping(bCodeWrapping, ss);

  findInitialCriterion(F, ss);

  ss.calculateStaticSlice();

  bool sliced = ss.slice();
  if (sliced)
    FunctionStaticSlicer::removeUndefs(this, F);

  return sliced;
}

//findAllCriteria must be called before this function, otherwise,
//calls is not initialized and NULL will be returned.
Instruction* FunctionSlicer::getReadSideCriteria()
{
  if(calls.size() == 0)
  {
    //findAllCriteria has not yet been called.
    return NULL;
  }
  
  //Handle read-side first.
  //Get read-Side call Instruction.
  Instruction *call = calls[0].getInstruction();
  Instruction *readSideCriteria = call;
  BasicBlock* parentBB = call->getParent();

  //get the first instruction in parentBB
  Instruction& firstInst = parentBB->front();

  //Because we put Criteria just behind the loop(read-side),
  //Criteria() should be the first instruction in its BB.
  bool bReadSide = (&firstInst == call);
  if(!bReadSide)
  {
    readSideCriteria = calls[1].getInstruction();
  }

  return readSideCriteria;
}

bool FunctionSlicer::isReadSideCriteria(CallInst *callInst)
{
  //Get its parent BB.
  BasicBlock *parentBB = callInst->getParent();

  //Get the first instruction in parentBB.
  Instruction& firstInst = parentBB->front();
  return (callInst == &firstInst);
}

void FunctionSlicer::collectSyncInfo(CallInst *call)
{
  //read-side or write-side ?
  bool bReadSideCriteria = isReadSideCriteria(call);
  ConstantInt *syncId = dyn_cast<ConstantInt>(call->getOperand(0));
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
    sync.readCriteria = call;
    sync.end = call;

    //readLoopExitBranch
    BasicBlock *parentBB = call->getParent();
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
  }
  else
  {
    sync.writeCriteria = call;

    //writeInst
    StoreInst* write = dyn_cast<StoreInst>(call->getPrevNode());
    assert(write != NULL && "The previous instruction is not a write !");
    sync.writeInst = write;

    //writeSideFunction
    sync.writeSideFunction = call->getParent()->getParent();
  }

  //update syncSet
  syncSet[id] = sync;
}

/*
 * 1. compute whether read and write in the same function for each sync.
 * */
void FunctionSlicer::isSyncPairsInSameFunction()
{
  for(SyncSetIt i=syncSet.begin(), e=syncSet.end(); i != e; ++i)
  {
    Sync sync = i->second;
    unsigned int id = sync.id;
    sync.bInSameFunction = (sync.readSideFunction == sync.writeSideFunction);

    syncSet[id] = sync;
  }
}
//We assume there is only one sync pair in the program at any time. This simplifies
  //our implementation. We only need to analyze one or two functions. If read-side
  //and write-side are in the same function, we know it is FFT barrier or other similar
  //cases; otherwise, the read-side and write-side must be in two different functions.
  //we only need to find all the call-sites of Criteria and then test whether the two
  //call-sites are in the same function.

 //Change: now we want to handle 2(n) barriers in one function simultaneously.
 //The Criteria function now has an int parameter to mark the id of barrier. This value will
 //be extracted and used to correlate traces to barriers.
  /*
   * Return Value: true, if the write-side and read-side are in the same function;
   *               false, otherwise.
   * */
  bool FunctionSlicer::findAllCriteria(std::vector<CallSite> &calls, Module& M)
  {
    //1. Get the Function pointer to Criteria()
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

    //Calculate whether sync Pairs are in the same function.
    isSyncPairsInSameFunction();
    
    //Sanity check.
    int size = calls.size();
    assert( (size%2 == 0) && "There should be even number of criteria.");

    //Test whether all the call sites are in the same function.
    BasicBlock *bb1 = calls[0].getParent();
    Function *f1 = bb1->getParent();
    vector<CallSite>::iterator I = calls.begin();
    ++I;
    for(vector<CallSite>::iterator E = calls.end(); I != E; ++I)
    {
      BasicBlock *bb2 = (*I).getParent();
      Function *f2 = bb2->getParent();
      if(f1 != f2)
      {
        return false;
      }
    }

    return true;
  }

bool FunctionSlicer::insertDRCSet(DRC *drc, DRCSet& drcSet, bool insertAlways)
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

  bool FunctionSlicer::insertDRCSet(DRC *drc, bool insertAlways)
  {
    insertDRCSet(drc, drcSet, insertAlways);
  }

bool FunctionSlicer::isLoopInvariant(Instruction *ins, DRC* drc, Loop *loop)
{
  bool retVal = true;

  DRCSet loopDrcSet;
  vector<BasicBlock*> loopBBSet;
  for (Loop::block_iterator BI = loop->block_begin(), BE = loop->block_end();
      BI != BE; ++BI)
  {
    BasicBlock *temp = *BI;
    loopBBSet.push_back(temp);
  }
  
  //recursively identify DRC.
  IdentifyDRCSet(loopBBSet, loopDrcSet, true);
  
  for(DRCSet::iterator I=loopDrcSet.begin(), E=loopDrcSet.end(); I != E; ++I)
  {
    DRC *temp = (DRC*)(*I);
    if(*temp == *drc && !temp->getAccessType())
    {
      retVal = false;
    }
  }

  freeDRCSet(loopDrcSet);

  return retVal;
}

FunctionSlicer::DRCSet& FunctionSlicer::IdentifyDRCSet(vector<BasicBlock*>& bbSet, DRCSet& drcSet, bool insertAlways)
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
            drc->setInsContext(ins);

            //Put it into drcSet.
            //A variable may be deferenced several times, 
            //but should appear in the drcSet only once.
            insertDRCSet(drc, drcSet, insertAlways);

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
              drc->setInsContext(load);
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
        //TODO: inter-procedural analysis
        //continue;

        Function *callee = callInst->getCalledFunction();
        //if(callee && callee->getName() == "atomic_cmpxchg")
        if(callee)
        {
          vector<BasicBlock*> funcBBSet;
          for (Function::iterator FI = callee->begin(), FE = callee->end(); FI != FE; ++FI)
          {
            BasicBlock *temp = FI;
            funcBBSet.push_back(temp);
          }

          IdentifyDRCSet(funcBBSet, drcSet, insertAlways);
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
        }
      }
    }//for (BasicBlock
  }//for (Function
}
  //Input: the sliced function F.
  //Ouput: a set of variables, <global, heap> X <drc-1, drc-4>;
  //       its definitions(malloc for heap, definition for globals),
  //       de-allocation for heap variable.
  //Forward parsing: loop through all the BBs forwardly, test & add.
  //Note: It doesn't matter whether the local variable(defined by Alloc) all appears in 
  //function entry block.
  FunctionSlicer::DRCSet& FunctionSlicer::IdentifyDRCSet(Sync &sync)
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
  
  void FunctionSlicer::dumpDRCSet(DRCSet& drcSet)
  {
    if(drcSet.size() == 0)
      return;

    for(DRCSet::iterator I=drcSet.begin(), E=drcSet.end(); I != E; ++I)
    {
      DRC *temp = (DRC*)(*I);
      temp->dump();
    }
  }
  
void FunctionSlicer::dumpDRCSet()
  {
    dumpDRCSet(drcSet);
  }

  void FunctionSlicer::dumpRangeMap()
  {
    map<const DRC*, Ranges>::iterator i=rangeMap.begin();
    map<const DRC*, Ranges>::iterator e=rangeMap.end();
    for(; i != e; ++i)
    {
      DRC *drc = const_cast<DRC*>(i->first);
      drc->dump();

      switch(i->second.type)
      {
        case SINGLE:
          errs() << "Unique constant value: \n";
          {
            bdSet::iterator it = i->second.values.begin();
            ConstantInt *temp = (ConstantInt*)(*it);
            if(temp)
            {
              temp->dump();
            }
          }

          break;

        case HALF_POSITIVE:
          errs() << "Greater than a positive constant value:\n";
          {
            bdSet::iterator it = i->second.values.begin();
            ConstantInt *temp = (ConstantInt*)(*it);
            if(temp)
            {
              temp->dump();
            }
          }

          break;

        case WILD_GUESS:
          errs() << "Wild guess: no explicit ranges \n";
          break;

        default:
          errs() << "Not implement yet !\n";
          break;
      }
    }
  }

void FunctionSlicer::freeDRCSet()
{
  freeDRCSet(drcSet);
}

void FunctionSlicer::freeDRCSet(DRCSet& drcSet)
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

  
  /*
   * Collect information about pthread_create.
   * a. how many invocations ? (the return value)
   * b. whether inside a loop ?
   * c. loop level.
   * d. the entry function.
   *
   * TODO: the path constraints.
   * */
  unsigned FunctionSlicer::analyzePthread_Create(Module &M)
  {
    //Get the Function pointer to pthread_create.
    StringRef funcName = "pthread_create";
    Function *pfuncPthread_Create = M.getFunction(funcName);
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
          }
          else
          {
            pTCInfo.bInLoop = false;
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
   * Auxiliary function: collect caller's information.
   * */
  void FunctionSlicer::collectCallerInfo(CallerInfo *info, CallInst *call, 
      int callerLevel, bool bPthreadCreate, Module &M)
  {
    //collect caller information
    info->callInst = call;
    info->caller = call->getParent()->getParent();
    info->callee = call->getCalledFunction();
    info->callerLevel = callerLevel;
    info->bThreadFunction = (info->callee == vecPthreadCreate[0].entryFunction);

    //Loop info
    LoopInfo *LI = &getAnalysis<LoopInfoWrapperPass>(*(info->caller)).getLoopInfo();
    info->loopLevel = LI->getLoopDepth(call->getParent());
    if(info->loopLevel > 0)
    {
      info->bInLoop = true;
    }
    else
    {
      info->bInLoop = false;
    }

    //pthread_create ? Pthread_create does not call any function directly.
    //No need to check here.
    info->bPthreadCreate = bPthreadCreate;

    //Check whether pthread_create is called.
    if(bPthreadCreate)
    {
      StringRef funcName = "pthread_create";
      Function *pfuncPthread_Create = M.getFunction(funcName);

      //analyze the call instruction.
      Function *calledFunction = call->getCalledFunction();
      assert(calledFunction == pfuncPthread_Create && "The called function must be pthread_create.");
    }
  }

  /*
   * A work list algorithm.
   * 1. collect all the functions belonging to segment 2 into nodeSetTwo. Also, collect basic 
   *    information about the function(node). 
   *    TODO: Extension, if we include the side-effects of all
   *    the nodes, then we can determine the net effect of segment 2, i.e., whether this code
   *    region(network) modify the exposed variables.
   * 2. set the starting point for segment 1: a set of functions and the call instruction, in
   *    boundaryOfSegments.
   * */
  unsigned FunctionSlicer::findSegmentTwo(Module &M, Function &F)
  {
    //Because there may be such case: f2->f1->f0, f2->f0. If we begin with f0, f2 may be
    //add the nodeSet twice. To solve this problem, the final nodeSet must be a set in
    //mathematical sense, each element showing in the set only once.
    //*********************************************************************
    //****The boundary between segment 1 and segment 2 has two cases:******
    //*********************************************************************
    //a. pthread_create. the call-site of pthread_create is a boundary point.
    //b. pthread_create's thread entry function. The caller of thread entry function,
    //   under our slave-master or work-crew threading model, must be in main thread.
    unsigned callerLevel = 0;
    list<Function *> worklist;
    worklist.push_back(&F);
    
    //Only for debug purpose.
    //The code will not be run
    if(&F == NULL)
    {
      F.viewCFG();
    }

    while(!worklist.empty())
    {
      Function *currentCallee = worklist.front();
      worklist.pop_front(); //remove from worklist.

      CallerInfo info;
      vector<CallerInfo>  callerSet;
      //TODO:This is problematic, this map is not a lossless representation of call-graph.
      //It is unable to show the calling relationship precisely as it is.
      //For example, f3->f1->f2->f1, the internal representation will be
      //f1, {f2, f3}
      //f2, {f1}
      //f3, {}
      //It may not affect the interprocedural analysis of segment 2, because we only care
      //the net side-effect of the functions in segment 2, whether they can modify the sync
      //variables of interest.

      for(User *U : currentCallee->users())
      {
        if(Instruction *inst = dyn_cast<Instruction>(U))
        {
          if(CallInst *call = dyn_cast<CallInst>(inst))
          {
            callerLevel++;
            collectCallerInfo(&info, call, callerLevel, false, M);
          }
          else
          {
            //If the code reach here, that means there are other function pointers
            //usage in the code. That is currently contradicting to our assumption.
            inst->dump();
            assert(0 && "Invalid instruction.");
          }

          //boundary between segment 1 and 2, case b.
          if(!info.bThreadFunction)
          {
            worklist.push_back(info.caller);
          }
          else
          {
            //boundary between segment 1 and 2, case b.
            boundaryOfSegments.push_back(info);
          }
        }
        else
        {
          //This branch is specifically for pthread_create.
          //whenever we hit this branch, it is the time to stop, because it indicates the
          //boundary between segment 1 and segment 2 is reached.
          for(User *UU: U->users())
          {
            //the user of pthread_create entry function is an expression for FFT(may be 
            //others thread creation function as well), whose user is pthread_create. If
            //there are more than one pthread_create as the expression user, then we are
            //in trouble.
            if(CallInst *call = dyn_cast<CallInst>(UU))
            {
              callerLevel++;
              collectCallerInfo(&info, call, callerLevel, true, M);
            }
            else
            {
              inst->dump();
              assert(0 && "Invalid instruction.");
            }

            //Boundary between segment 1 and 2, case a.
            if(!info.bPthreadCreate)
            {
              assert(0 && "bPthreadCreate must be true.");
            }
            else
            {
              //Boundary between segment 1 and 2, case a.
              boundaryOfSegments.push_back(info);
            }
          }//for(User *UU
        }//if(Instruction *inst

        //update callerSet
        callerSet.push_back(info);
      }//for(User *U

      //update <callee, caller> map

      nodeSetTwo.insert(pair<Function*, vector<CallerInfo> >(currentCallee, callerSet));
      callerSet.clear();
    }//while(!worklist

    return nodeSetTwo.size();
  }

  /*
   * Find functions in segment 1. 
   * Design Analysis A: 
   * 0. There are two interprocedural analysis happen. 
   *    a. interprocedural vrp in segment 1. (currently, it's intraprocedural).
   *    b. interprocedural modification analysis in segment 2. (currently, we choose "do-nothing".
   *       A little more, we have collected the nodes in segment 2.)
   *
   * 1. The goal of b is to determine whether segment 2 modifies and thus invalidates the value 
   *    ranges(initial values or predicates) propagated by a.
   *    
   *    The goal of a is to determine the initial values of exposed variables in segment 1, because
   *    segment 1 is a sequential region(there is only main thread, pthread_create has not been called
   *    yet).
   * 
   * 2. To extend them into interprocedural ones:
   *    a. Whole program DEF/MOD analysis. This part can reuse llvm or LLVMSlicer's code, or write
   *       our own. The goal is to determine the net side-effect of each function, so to facilitate
   *       b and c. As people did in interprocedural slicing, this analysis cannot be precise. So,
   *       neither 2.b nor 2.c can be precise.
   *    b. for 0.a, relying on 2.a's result. We also need to know the path constraint of main thread
   *       and pthread_create, to determine whether they can happen concurrently. This information is
   *       vital in the final code wrapping. How to code the path constraints ?
   *    c. for 0.b, relying on 2.a's result. Even we assume there is no function/data pointer alias,
   *       the analysis is still no precise. Conservatively assume a function has side-effect on the
   *       sync variables are over-killer.
   *
   * 3. Alternative: discard interprocedural analysis completely, just based on wild trial-and-error.
   *    a. Analyze the whole program to obtain the set of operations performed on the sync variables.
   *       The operations may be decrement, increment, assignment, inversion, etc. Then, guess the possible
   *       values that may occur. Use them as the initial values taken by the final slice.
   *    b. The advantage is apparent, no interprocedural analysis. But, the challenge is how to narrow
   *       down the errorneous guess.
   *    c. No matter what heuristic or analysis is applied, there are still errorneous case in the final
   *       values. The ultimate effect is the code generated may run infinitely long or generate meaningless
   *       traces.
   *    d. For some simple case, we can apply this approach.
   *
   * 4. The two approaches are not mutual-exclusive. For example,
   *    a. It is possible for the first analytical approach to figure out the initial conditions precisely,
   *       for FFT's first barrier.
   *    b. It is impossible for analytical approach to know the initial conditions for FFT's second barrier.
   *       Because, the first barrier has very complicated operations on the sync variables. I do not expect
   *       any analysis figure it out.
   *    c. To make sense out of FFT's second barrier and other barriers, we can take one of the following ways
   *      c.1 Code clone detection. This is more difficult than thought. First, too much engineering work.
   *          Second, too much learning work. Third, unknow how final effects would be, etc.
   *      c.2 Interleaving based on schedulings enumerations. It has similar problem, the most prominent one is
   *          too much engineering work. However, it may be another interesting idea to work on. But, not in
   *          this project.
   *      c.3 Slice all the others away and pay attention to a single one at one time. This is more desirable
   *          than c.1 and c.2 because of little engineering effort. The challenge is to know the inital
   *          conditions. Here, we can reuse the initial values of the first barrier. Specifically, we really
   *          don't know the relationship between this barrier and the first barrier. What we know is it exposes
   *          the same set of sync variables. Then, we GUESS the previous initial variables is also relevant to
   *          this one.
   * 
   * Design analysis B: segment 1.
   *
   * 1. we need to know the relation between the starting points(there are two for FFT barrier 1).
   *    a. Can they execute concurrently ? This can be answer to encode their path constraints. If the constraints
   *       are the same, then they can execute concurrently. But, how to encode it or do we really need to encode
   *       it ? At least for FFT barrier, we don't need to encode it. If we treat the whole loop where the 
   *       pthread_create resides as one unit, then, there are no extra conditions added to reach the main thread's
   *       function. Therefore, we can use certain heuristics to simplify this test. If they happens in the same
   *       function, then we test whether one can reach another without adding extra predicates(conditional branch
   *       instructions in effect). To facilitate this test, we need b.
   *    b. Which one comes first ? Even if the two does not happen in one function, such as allAB case, finally they
   *       still can be projected into two points in main function. Then, the question is transformed into "given two
   *       instruction in main, how to test which happens before another or exclusively ?"
   *    c. The solution to b. If the two points(instructions) are in the same BB, then the order is defined by the
   *       control flow order; Otherwise, if inst1's BB(BB1) is dominator of inst2's BB(BB2), then inst1 happens before
   *       inst2; or if the inst1(pthread_create) loop's exit BB is the dominator of inst2'BB, then inst2 happens before
   *       inst2; otherwise, they are exclusive. The dominator relationship test can be more precise as to: test whether
   *       BB1 or BB1's exit BB is in the dominator set of BB2, vice visa.
   *    d. To encode the path constraints in general involves collect all the branch predicates on the path leading to
   *       the instruction of interest. After encoding, constraints are to be solved before answering whether the two
   *       instructions can happen concurrently. If the constraints have at least one same solution, then inst1 and inst2
   *       can happen concurrently or one after another in one run; Otherwise, they cannot be executed in the same run.
   *    e. How to project the two starting points into main ? The purpose of projection is to determine the answer to b.
   *       The projection point is simply the instruction in main that leads to the sliced function, which indicates when
   *       the caller is "main", the callInst in CallerInfo is the projection point.
   *
   * 2. The projection point and vrp scope.
   *    a. From main to p1.
   *    b. From p1 to pthread_create loop(inst1).
   *    c. From p1 to p2.
   *    d. From p2 to inst2 (in work-crew threading model, e.g. FFT, it is main's invokation to thread entry function;
   *       in allAB, it is the read-side loop).
   * TODO: in the meeting (02/17/2016), we decide to skip the interprocedural analysis and move on to the instrumentation
   *       and wrapping step. So the code only works for the FFT's 1st barrier. The reason we cannot simply apply inter-vrp
   *       to propagate the initial conditions is that after p1 and into the thread entry functions, the program is no
   *       long single-threaded. The concurrent nature makes precise propagation impossible.
   *
   *       For the other barrier, we want to run the code to get their initial conditions. There are many considerations:
   *       a. how to know which sync is the first one ? In general, it is impossible to know this. Perhaphs, the best way
   *          is to keep all the sync in the final slice. When we encounter one (we can mark the begin and end of a certain
   *          sync pair), we schedule all its possible interleaving, reduce the values of the sync variables and pass these
   *          variables into the next encountered sync pair as initial condition.
   *       
   *
   * */
  unsigned FunctionSlicer::findSegmentOne(Module &M)
  {
    //The boundary between segment 1 and 2 have been populated into boundaryOfSegments
    //in findSegmentTwo as starting points for segment 1. It is possible there are several projection points in main,
    //leading to each starting point. nodeSetOne and nodeSetTwo contains callee to caller mapping. But, in 
    //interprocedural vrp, we need caller to callee mapping as well. Because this information is critical to guide the
    //the value propagation. Given a caller and the callee context(called at which BB's which instruction), we know
    //it is OK to stop the propagation in the callee after the propagation reaches all the callee context in the caller.
    //Then, we need go to the next caller-callee level to propagate the values. This interprocedural propagation is 
    //quite complex. Essentially, it is propagation in the call-graph.
    //TODO: we decide not to implement interprocedural-vrp now. We will reconsider it later. (So the caller-callee map
    //      is not implemented; the propagation is not implemented; nodeSetOne is not populated, essentially the 
    //      algorithm is the same as that of findSegmentTwo, re-design and re-implementation is inevitable. For current
    //      purpose, we apply a simple heuristic for FFT 1st barrier.)
    
    //If the projection point in nodeSetTwo is already in main, we don't need to populate nodeSetOne because it should
    //be empty, nothing to be populated. But, it should be noted as the vrp stop point. The intra-vrp should stop until
    //it propagates the values to pass all the stop points. It may be even more convenient to propagate until the end
    //of the current caller. Then, the stop points obtain the corresponding values by propagating from the beginning of
    //their BBs to themselves.
    //
    //TODO: concurrency test.
    //For the concurrency test of different calls to the thread-entry function, as discussed before, the general solution
    //is to collect and solve their path constraints. But, for current purpose, we apply the heuristic for FFT 1st 
    //barrier: if the two thread-entry function calls are in the same function, we just check the constraint on the path
    //from one to the other, specifically, from the 1st to the 2nd. Moreover, if the 1st one is inside a loop, we just 
    //check the constraint from the loop exit BB to the 2nd. Before this, we want to check whether loop exit BB is 
    //dominating the 2nd. If so, we know there is a path from the exit BB to the 2nd; Otherwise, there may be no
    //such a path, e.g., if 1st and 2nd are in exclusive branches of if-statement.

    Function *main = M.getFunction("main");
    for(auto it=begin(boundaryOfSegments); it != end(boundaryOfSegments); ++it)
    {
      //if(*it.caller == main), do not need to populate its caller into nodeSetOne.
      if(it->caller != main)
      {
        //trace back until the caller reaches main and collect caller-callee mapping
        //as well as callee-caller mapping.
      }
    }

    return nodeSetOne.size();
  }
   
   bool FunctionSlicer::getValueRange(Function *fun, DRC *drc, BasicBlock *referenceBB)
   {
     valueRange intraVRP;
     bdSet values = intraVRP.propagateDRC(fun, drc, referenceBB);

     if(values.size() == 1)
     {
       if((*values.begin()) != NULL)
       {
         Ranges range;
         range.values = values;
         range.num = 1;
         range.type = SINGLE;

         rangeMap[drc] = range;
         return true;
       }
       else
       {
         return false;
       }
     }
     else
     {
       assert(0 && "Other cases: 0 or more than 1 range exists.");
     }
   }

   //Prediction with predicates.
   //Design analysis:
   //1. scope: where to perform the predicate analysis ? We want to constrain the scope to a BasicBlock.
   //   Typically, a predicate is formed by load from a global value into a virtual register, then compare
   //   it with another constant or variable. After the load, the value may also be processed before used
   //   in the comparison. Precise analysis is impossible, so we want to figure out meaningful heuristic
   //   which also has certain generality.
   //   By observing FFT, we may have the following heuristics:
   //   a. if it is an integer, and is used as upper bound of a loop, then it must be positive.
   //   b. if it is used as a parameter to a function which only takes positive input, then it must be 
   //      positive
   //   c. if it is used as a comparator to another constant, and the branch instruction depending on it 
   //      can lead to an unreachable BB, then it must make the branch take another reachable BB.
   //
   //2. How to extract them ?
   //   2.a since the scope is one BB, finding the candidate BBs is the first step.
   //   2.b since it is a global var or heap variable, we assume it is a global var and has drc-1. This is
   //       simpler for implementation purpose. It can be heap variable and drc-N(N>=1), too.
   //   2.c under assumption of 2.b, it must be loaded from memory before any usage happens. So, the candidate
   //       BBs are identified by find loading reference to it. Then, the load instruction will be the analysis
   //       starting point in the BBs. 
   //   2.4 The ending point is the terminator of the BB or malloc and any other function call using the value as
   //       a parameter or part of parameter.
   //   2.5 If it is loop upper bound, it must be greater than the lower bound, which often has an explicit value
   //       assignement. For it to be loop bound, it must appear in a loop's header and used in the branch
   //       instruction leading to body or exit. The loop induction variable's initial value can be found by
   //       use-def chain.
   //   2.6 It seems difficult to implement the function-parameter heuristic. Since branch predicate is sufficient
   //       for FFT 1st barrier, I will not implement function-parameter heuristic in the first round.
   //
   //3. What if it fails ?
   //   If all the above heuristic fails, we just assign a small set of values [-1, 0, 1, 2] to an integer.
   //   or we assign [true or false] to a boolean variable. Let's call it wild-guess.
   //
   //4. None of vrp, predicates and wild-guess is precise. Even vrp is enhanced to be inter-vrp, it is still not
   //   sound because of function alias, data pointer alias and complex operations, such as FFT barriers. Either are
   //   due to the well-known difficulty(for alias analysis) or high complexity(for FFT barrier operations on sync
   //   variable). This analysis shows that all these approaches are trying to figure out a meaningful initial
   //   condition for sync variables with less confidence moving from inter-vrp to intra-vrp, to predicates and
   //   wild-guess. Their implementation complexities also decrease in such a spectrum. When one does not work out,
   //   the next one in the spectrum is tried. Since wild-guess never fails, we are guaranteed to have certain values
   //   to generate the code. However, whether the code is meaningful is another issue.
   //
   //5. Interface design. Intra-vrp populates rangeMap with ConstantInt. At least for P in FFT 1st barrier, we should
   //   also populate rangeMap with ConstantInt. However, let's try a set of ConstantInt for P, ranging from 2 to 3.
   //   Then, in the code generation phase(wrapping up), for each combination, we will generate one bitcode file.
   //
   //6. In this iteration, I will try to figure out how to merge information from two predicates, one says "P>=1"
   //   while the other says "P>=2". This should be considered as general as possible. In general, both the constant
   //   involved in the comparison and the comparison operator are important, the general approach should conceptually
   //   build a number axis to merge them. How to achieve this ? Essentially, this is automatic inequality equation
   //   solver.
   //
   //7. How to justify when "P>=2", we choose P=2, P=3(as small as possible), not P=1000000(as big as possible) ? The
   //   apparent heuristic is P is the loop trip count which pthread_create resides. We don't want to create too many
   //   threads, because this will overload the scheduler.
   //
   //=====Decision after discussion and investigation======
   //a. Path constraints should also be propagated in CFG. The simulataneous inequalities formed by previous proposal
   //   is not as rigid as possible due to the fact it tries to combines the constraints of all the predicates without
   //   considering reference point, which may introduce unnecessary predicates. Moreover, the justification to which
   //   side to pick up is not logically but merely heuristically reasonable. E.g., if(P<1) {exit(-1);}. which side of
   //   P should we pick ? Heuristically, we can test if P < 1 holds, it will lead to an unreachable BB; otherwise, it
   //   will proceed. But, it would be more reasonable if we propagate P < 1 along true branch and P >= 1 along the 
   //   false branch and we discard P < 1 and retain P >=1 as a side-effect of the propagation. It will not introduce
   //   unnecessary predicates other than those on the path, either.
   //
   //b. However, after inspecting the code, we see that the propagation does not introduce significant benefit. Because,
   //   the propagation is done in a pattern-matching fashion as following:
   //     %1 = load @P
   //     %cmp = icmp slt %1, const_val
   //     br %cmp b1, b2
   //   But there is a instruction sequence,
   //     %1 = load @P
   //     %cmp = icmp slt %1, %i  ## %i is unknown but can be decided if we utilize the fact that %i is 
   //                             ## assigned to 1 in the loop preheader.
   //     br %cmp br1, br2
   //   Without the heuristic, propagation fails to extract the information "P > 1".
   //   So, at least for FFT, we can simply test whether P is loop upper bound. If it is and it is an
   //   integer, we simply set it to an positive integer. Then, we further try to figure out loop 
   //   lower bound and set it as the lower bound of P.
   //
   //c. P is in loop header; P is loop exit dependent variable (one branch is from P's predicate to exit BB directly);
   //   the other comparator is a variable, try to find its assignment in header and Preheader; if found, give P's range,
   //   other return NULL. For NULL, generate a set of P's values. For FFT barrier, it works; for others, unknown. In
   //   the paper, we can discuss these design decisions. But, in the implementation, we want this simplest one. It
   //   seems scalar-evoluation can be used to identify the loop induction variable, but I don't want to be trapped
   //   by more technical details now (the current implementation may have dependence on the shape of the code, while
   //   loop transformation may break this dependent code shape. Though, I did not have a try, I just don't want to
   //   spend more time here now.)
   //
   //d. With loop normalization, scalar evolution and induction variable analysis, it is easy to verify that i is the 
   //   induction variable. mem2reg is necessary to transform loops into ssa form, after normalization, scev and iva,
   //   we can obtain i's initial value in the header's first PHI node. Then, we perform predicates analysis. Afterwards,
   //   reg2mem is necessary to transform code into normal(unssa) form for wrapping and interpretation. This process is
   //   a little bit more complex, we will consider it in the future if the heuristic does not work on any real occasions.
   //   
   //   Reference: 
   //   1. http://llvm.org/devmtg/2009-10/ScalarEvolutionAndLoopOptimization.pdf
   //   2. http://stackoverflow.com/questions/23726726/llvm-fails-to-detect-very-simple-loop-trip-count
   //   3. http://stackoverflow.com/questions/13794877/how-to-get-the-loop-induction-variables-name-in-llvm
   //   4. 02-llvm-passes.pdf, loop terminology and normalization,
   //      https://home.deib.polimi.it/scandale/?p=/get/data/cot/02-llvm-passes.pdf
   //   5. https://groups.google.com/forum/#!topic/llvm-dev/fM-Vw2hzycc

   /*
    * Find the last constant assignment to a variable(stack) in bb.
    * If the last assignment to IndVar is not a constant, return NULL;
    * Otherwise, return the pointer to the constant.
    * */
   ConstantInt * FunctionSlicer::FindLastAssigment(vector<BasicBlock*>& bbSet, Instruction * IndVar)
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

   bool FunctionSlicer::getValueRangeWithPredicate(Function *func, DRC *drc, 
                                                   BasicBlock *referenceBB, Loop *pthreadCreateLoop)
   {
     bool bFound = false;
     //Steps:
     //1. verify P is in loop header.
     //2. verify P is loop exit dependent variable.
     //3. if the other comparator is variable, try to find its unique initialization in loop's
     //   header and pre-header.
     
     //1. Verify P is in loop header. And thus is a potential loop upper bound.
     assert(func && "Function should not be NULL !");
     assert((drc && drc->size()>0) && "DRC should not be NULL !");
     GlobalVariable *gv = (GlobalVariable*) (*drc)[0];

     //P must be a global variable. For simplicity, we don't consider the possibility of heap variable as
     //loop upper bound.
     if(drc->size() == 1 && !drc->isOnHeap())
     {
       //Find the instruction load P. Since referenceBB is the loop header, it is sufficient to loop through
       //referenceBB.
       BasicBlock::iterator i = referenceBB->begin();
       BasicBlock::iterator e = referenceBB->end();
       for(; i != e; ++i)
       {
         //Find load instruction.
         if(LoadInst *load = dyn_cast<LoadInst>(i))
         {
           if(load->getPointerOperand() == gv)
           {
             //It is highly possible a variable like P: a global variable used as the loop upper bound.
             //Look for the instruction pattern
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
                   bbSet.push_back(referenceBB);
                   bbSet.push_back(preHeader);
                   ConstantInt *constVal = FindLastAssigment(bbSet, IndVar);

                   //Increment constVal by 1.
                   //Reference: http://stackoverflow.com/questions/9196009/set-value-for-llvmconstantint
                   constVal = ConstantInt::get(constVal->getContext(), constVal->getValue()+1);

                   //constVal is P's base, i.e., P >= constVal
                   //Since P is integer with half-open range to positive infinity, it may be interesting if
                   //we generate a list of P. Now, we can record P is a range.

                   bFound = true;

                   //Fill P's value into rangeMap.
                   Ranges range;
                   bdSet constSet;
                   constSet.insert(constVal);
                   range.values = constSet;
                   range.type = HALF_POSITIVE;
                   rangeMap[drc] = range;
                 }
               }
             }
           }             
         }
       }
     }
     else
     {
       errs() << "Not a global variable. Its value will be a list of discrete values.\n";
     }

     return bFound;
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
void FunctionSlicer::insertSchedulePointForReadSide(Module *mod, Instruction *insertBefore)
{
  insertSleep(mod, StringRef("2"), insertBefore);
}

void FunctionSlicer::insertSchedulePointForWriteSide(Module *mod, Instruction *insertBefore)
{
  insertSleep(mod, StringRef("3"), insertBefore);
}

bool FunctionSlicer::isInsideReadSideLoop(BasicBlock *bb)
{
#if 0
  Instruction *readSideCriteria = getReadSideCriteria();
  Loop *readSideLoop = getReadSideLoop(readSideCriteria);
  assert(readSideLoop != NULL && "Read side loop must not be empty.\n");
  for (Loop::block_iterator BI = readSideLoop->block_begin(), BE = readSideLoop->block_end();
      BI != BE; ++BI)
  {
    BasicBlock *BB = *BI;
    if(bb == BB)
    {
      return true;
    }
  }

  return false;
#endif
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

void FunctionSlicer::insertSchedulePointForOrdinary(Module *mod, Instruction *insertBefore)
{
  //for read-side loop, do not insert sleep(1).
  BasicBlock *currentBB = insertBefore->getParent();

  bool bInsideReadLoop = isInsideReadSideLoop(currentBB);
  if(!bInsideReadLoop)
  {
    insertSleep(mod, StringRef("1"), insertBefore);
  }
}

Loop* FunctionSlicer::getReadSideLoop(Instruction *readSideCriteria)
{
  //Get the function where read-side loop resides.
  BasicBlock *readSideCriteriaParentBB = readSideCriteria->getParent();
  Function *readSideFunction = readSideCriteriaParentBB->getParent();
  LoopInfo *LI = &getAnalysis<LoopInfoWrapperPass>(*readSideFunction).getLoopInfo();

  //Get exit BB for read-side loop.
  BasicBlock *readSideLoopExit = readSideCriteriaParentBB->getUniquePredecessor();
  assert((readSideLoopExit != NULL) && "The loop exit should be the unique predecessor of read-side Criteria().");
  Loop *readSideLoop = LI->getLoopFor(readSideLoopExit);

  return readSideLoop;
}
   /*
    * Note: this function has no assumption on whether read-side and write-side are in the same function.
    * 1. read-side: replace Criteria with printf("Y")
    * 2. write-side: remove Criteria; insert printf("X") just before write(before "load, gep, gep, store",
    *                in the same BB as write-side).
    * */
   void FunctionSlicer::instrumentSlice(Module &mod, Function *F)
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
             insertSchedulePointForOrdinary(&mod, sync.readCriteria);
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
               break;
             }
           default:
             assert(0 && "No such scheduling point.\n");
         }
       }
     }

#if 0
     //Handle read-side first.
     //Get read-Side call Instruction.
     Instruction *call = calls[0].getInstruction();
     Instruction *readSideCriteria = call;
     Instruction *writeSideCriteria = NULL;
     BasicBlock* parentBB = call->getParent();

     //get the first instruction in parentBB
     Instruction& firstInst = parentBB->front();

     //Because we put Criteria just behind the loop(read-side),
     //Criteria() should be the first instruction in its BB.
     bool bReadSide = (&firstInst == call);
     if(!bReadSide)
     {
       readSideCriteria = calls[1].getInstruction();
       writeSideCriteria = calls[0].getInstruction();
     }
     else
     {
       writeSideCriteria = calls[1].getInstruction();
     }

     //replace read-side Criteria with printf("Y").
     //a. Insert call to printf("Y")
#if 0
     insertPrintf(&mod, StringRef("Y"), readSideCriteria);    
#else
     insertPrintY(&mod, readSideCriteria);
#endif

     Loop *readSideLoop = getReadSideLoop(readSideCriteria);
     BasicBlock *loopLatch = readSideLoop->getLoopLatch();
     assert((loopLatch != NULL) && "Every canonical loop has a latch.");
     BasicBlock *loopPreHeader = readSideLoop->getLoopPreheader();
     assert((loopPreHeader != NULL) && "Every canonical loop has a preheader.");

     //Pre-header dominates loop header and all the BBs belonging to a loop.
     //Latch must be executed before starting a new loop iteration.
     //We have the following different scheduling point insertion strategies.
     //case 1) insert sleep(2) only at latch. The last thread will not execute latch and will go through the busy-wait
     //        loop before any other threads, which constrains the # possible interleavings. Besides, all the prior 
     //        thread are suspended forever. Unacceptable.
     //case 2) insert sleep(2) only at pre-header. The first N-1 threads will have no chance to go through the
     //        latch(even there are no useful instructions in it) and also only have one iteration in the busy-wait loop.
     //        Unacceptable.
     //case 3) insert sleep(1) only at pre-header. Similar to case 2.
     //case 4) insert sleep(1) only at latch. Similar to case 1.
     //case 5) insert sleep(2) at pre-header and insert sleep(1) at latch. Same to case 1.
     //case 6) insert sleep(1) at pre-header and insert sleep(2) at latch. The first N-1 threads will go through the 
     //        condition test twice, and latch once, which simulates the effect of busy-wait. The last thread go
     //        through the busy-wait loop once but the order of which threads reach the exit first does not get
     //        constrained. This conforms to our expectation.

     //insert sleep(2) at latch just before terminator.
     insertSchedulePointForReadSide(&mod, loopLatch->getTerminator());

     //insert sleep(1) at pre-header just before terminator.
     //insertSchedulePointForOrdinary(&mod, loopPreHeader->getTerminator());

     //Handle write-side.
     //a. Insert call to printf("X") before "load-gep-gep-store"
     //   In fact, the insertion can happen in a smarter way.
     //case 1)
     //   Before insertion: load-gep-gep-store-criteria()
     //   After  insertion: load-gep-gep-store-printf("X")-criteria()
     //case 2)
     //   Before insertion: load-store-criteria()
     //   After  insertion: load-printf("X")-store-criteria()

     StoreInst *storeToSyncVar = dyn_cast<StoreInst>(writeSideCriteria->getPrevNode());
     assert(storeToSyncVar != NULL && "The instruction prior to write-side Criteria() must be StoreInst !\n");

#if 0
     insertPrintf(&mod, StringRef("X"), storeToSyncVar);
#else
     insertPrintX(&mod, storeToSyncVar);
#endif
     //insert sleep(2) for write-side
     insertSchedulePointForWriteSide(&mod, writeSideCriteria);     

     //insert print(ID), print("Z")
     insertSyncID(mod);
     insertSyncBeginString(mod);

     //insert scheduling points for DRCs happening before the current Sync.
     //Read side: insert in loop's latch.
     //Write side: insert after instruction context.
     for(DRCSet::iterator I=extraSP.begin(), E=extraSP.end(); I != E; ++I)
     {
       DRC *drc = (DRC *)(*I);
       if(drc->getAccessType())//read
       {
         const Instruction* context = drc->getInsContext();
         const BasicBlock *readBB = context->getParent();
         LoopInfo *LI = &getAnalysis<LoopInfoWrapperPass>(*F).getLoopInfo();
         Loop *loop = LI->getLoopFor(readBB);
         BasicBlock *latch = loop->getLoopLatch();
         insertSchedulePointForReadSide(&mod, latch->getTerminator());
       }
       else //write
       {
         Instruction *insertBefore = const_cast<Instruction*>(drc->getInsContext()->getNextNode());
         insertSchedulePointForWriteSide(&mod, insertBefore);
       }
     }

#endif
     //TODO: Remove both call to Criteria(). This should be decided after we
     //      know how the schedule is performed in Cloud9.
   }

void FunctionSlicer::insertSyncID(Module& mod)
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
    for(int i=0; i<size; i++)
    {
      int ch = (int)idString[size-i-1];
      string s = to_string(ch);
      insertPrintChar(&mod, insertBefore, StringRef(s));
    }
    
    //insert Initialization for switches and counter, control flags for
    //interleavingEnumeration and sync variable recording.
    //Sync ID is used as a key to index syncData, which is inside Cloud9.
    insertInitialization(&mod, insertBefore, StringRef(idString.c_str()));
  }
}

void FunctionSlicer::insertSyncBeginString(Module& mod)
{
  for(SyncSet::iterator it=syncSet.begin(), ie=syncSet.end(); it != ie; ++it)
  {
    Sync sync = it->second;
    Instruction *insertBefore = sync.begin;
    int ch = 'Z';
    string s = to_string(ch);
    insertPrintChar(&mod, insertBefore, StringRef(s));

    //insert Increment.
    insertIncrement(&mod, insertBefore);
  }
}

   /*
    * This function insert codeWrapping() to mark the two projection points for slicing main.
    * The slicing is performed for code-wrapping purpose.
    * The two projection points for FFT 1st barrier are the call instructions in main.
    * a. pthread_create
    * b. SlaveStart
    *
    * They have already been populated into boundaryOfSegments.
    * */
   void FunctionSlicer::instrumentForCodeWrapping(Module& mod)
   {
     for(auto it=begin(boundaryOfSegments); it != end(boundaryOfSegments); ++it)
     {
       Instruction *insertBefore = it->callInst->getNextNode();
       if(vecPthreadCreate[0].entryFunction == it->callInst->getCalledFunction())
       {
         insertCodeWrapping(&mod, insertBefore);
         insertWaitForAll(&mod, insertBefore);
       }
       else
       {
         insertCodeWrapping(&mod, insertBefore);
       }
     }
   }

  bool FunctionSlicer::runOnModule(Module &M) 
  {
    module = &M;

    ptr::PointsToSets PS;
    {
      ptr::ProgramStructure P(M);
      computePointsToSets(P, PS);
    }

    callgraph::Callgraph CG(M, PS);

    mods::Modifies MOD;
    {
      mods::ProgramStructure P1(M);
      computeModifies(P1, CG, PS, MOD);
    }

    bool inSameFunction = findAllCriteria(calls, M);

    bool modified = false;
#if 0    
    for (Module::iterator I = M.begin(), E = M.end(); I != E; ++I) {
      Function &F = *I;
      if (!F.isDeclaration())
        modified |= runOnFunction(F, PS, MOD);
    }
#else
    //Two cases with three treatments:
    //1) the read-side and write-side are in the same function. For our current datasets,
    //   it means it is FFT barrier. This may be too specific, but it is ok now. If we see
    //   other data points, we will need extensions.
    //2) the read-side and write-side are not in the same function.

    //case 1. FFT barrier.
    //a. write-side. Slice the write-side until no local variable is exposed, i.e., 
    //only global variables or heap variables are exposed.
    //b. read-side. We always slice the read-side as a whole loop.
    //c. Bound variable sets. For FFT barrier, the bound variables are in two categories.
    //One is heap variable (gsense and count), the other is global variable (P).
    //For each variable, we have to decide their category first; then, query vrp module to
    //figure out their initial value.
    //d. One way to argue the stop point is: we may stop at their common dominator. The 
    //read-side and write-side may contain multiple blocks, the common dominator would be
    //the BB which dominate all the blocks. In fact, this is reasonable because it means
    //the child may or not go reach write-side, which is conditional. The left question will
    //be how to decide all the variables' initial value. But, we do not stop at this point.
    //Because, we really want to expose global variables only, which is a cleaner interface.
    //Another more important reason is that, the local variables' value, if depending on global
    //variables, are only the results of concurrent execution, which means local variables are
    //not a proper boundary of synchronization.
    //e. The effect of d is that while we are gradually extending the write-side, we test that 
    //whether only global variables' value are unknown, if true, we stop the extension.
    //f. To faciliate the instrumentation, we also need to keep Criteria() there. So that, after
    //the slicing(in fact, it is chopping for FFT barrier), it is still possible to instrument
    //the code. The code region chopped out should also be put into a BB set to help further
    //wrapping. The wrapping step needs to figure out the definition of global variables and
    //allocation of heap variables for the code's completeness. Without completeness,
    //a global variable will be used without definition; a heap variable will be used
    //without allocation. It is easy to see that slicing, instrumenting and wrapping
    //need something in common: the ability to understand a variable's category, to
    //extract the variable's definition or allocation, to know the set of BBs that are
    //currently of interest. Altogether, they mean it is not simply a slicing algorithm
    //to accomplish the goal. The algorithm is way more complex.
    //g. Considering the lack of generality of this process, we should take an iterative
    //approach to finish the implementation. We should finish FFT barrier from beginning to
    //end, from slicing, instrumenting, bound vrp, wrapping to scheduling. And then take the
    //next allAB, and then others.
    //
    //High-level algorithm design: step 1-4 will be in one module and step 5 will be in another
    //module, Cloud9. Modifications in Cloud9 will include scheduling policy (shared memory read
    //will also become a scheduling point, why ?).
    //Steps
    //Module 1.
    //1. Slicing(chopping).
    //2. vrp bound detection.
    //3. Instrumenting.
    //4. wrapping.
    //
    //Module 2.
    //5. scheduling. (Cloud9, in another pipe segment).

    //case 2. allAB. This is the second most interesting case. But it is also complicated.
    //case 3. Others.

    //Step 1. Slicing. The input is FFT barrier, with Criteria to point out the read-side loop
    //and another Citeria to point out the write-side instruction. At this point, the two Criteria
    //are in std::vector calls. (Seems I have to rewrite slice module on my own, the LLVMSlicer is
    //for reference only. This should be a lesson for me. First, reusing others code is good but
    //usually write something from scratch in research is more common. That is why people don't share
    //their code, not only because they are ugly but also it means little to others because everyone
    //have different needs. It is faster to write what they need by themselves. Second, the boss is me.
    //I am the one who makes the decision, advisors are just consultants, who you can brainstorm with,
    //and who may share their expierence, but never expect they make decision for you. Third, the 
    //reason I want to use others' code is because of lack of confidence or knowledge. Especially, it
    //indicates I don't know what I really need. It is ok to not be able reuse others code. It is also
    //ok not to be right at the first time. What really matters is to work really hard to figure out
    //what you really need and consider how much work is needed to implement it myself. It appears true
    //to me, the time measurement is really a good indication of whether I work hard enough. The reason
    //I need to work hard is that it is an iterative trial-and-error process. Harder work provides more
    //chances to iterate the whole process and thus get it right faster.)

    //a. First, slice the read-side loop. Put all the BBs of the loop in a set, readBBs.
    //   according to our stop condition, for loop "while(gsense == lsense);" in FFT barrier should be 
    //   extended, because lsense is a local variable with unknown value(and not depends on any heap or
    //   global variable) at this point. Since both sides are in the same function, if we slice read-side
    //   first, we will continue slice instructions belonging to the write-side. Our previous experience 
    //   show if we only have one Criteria for read-side, the slicing result will be the same as that of
    //   having both one read-side Criteria and one write-side Criteria(for FFT barrier). This is not
    //   incidental but inevitable, because the write-side must write the variable(s) that the read-side 
    //   depends on, otherwise, they cannot be a sync pair because of sharing nothing(the definition of
    //   sync pair necessitates the sharing between the two sides). So far, it is not clear whether this
    //   is a sufficient condition for any sync pairs that appear in the same function, for instant, other 
    //   implementations of barrier. Therefore, if we start with read-side, and stop until only global
    //   variables or heap variables are exposed, the yielding slice must include both read-side loop and
    //   write-side. On the other hand, if we start with write-side criteria, according to previous analysis
    //   (write-side should be conditionally dominating and reachable to read-side), the yielding slice will
    //   only include the write-side. For simplicity, let's denote read-side loop readSet, write-side slice
    //   writeSet, the slice beginning with read-side readSlice, the slice beginning with write-side 
    //   writeSlice, the final slice as finalSlice. Then, we have :
    //   writeSet + readSet <= readSlice = finalSlice, writeSlice = writeSet.
    //   This shows, at least for FFT barrier, we start from read-side Criteria, we can get the finalSlice.
    //   And we don't need to slice writeSlice explicitly.
    //
    //Minor steps:
    //a1. Get the loop exit BB.    
    if(inSameFunction) //FFT barrier.
    {
      //The FunctionStaticSlicer is able to slice FFT barrier, given only the read-side Criteria(). The
      //write-side Criteria(), although can be used as a slicing starting point for writeSet in general,
      //severs instrumentation purpose only. It should not be sliced away at the slicing stage. But, it
      //should be removed after instrumenting the code because it is an undefined function.

      //Get the function including both read-side and write-side.
      Instruction *call = calls[0].getInstruction();
      BasicBlock* parentBB = call->getParent();
      Function* F = parentBB->getParent();

      //Slice and return.
      //The exposed global or heap variables should be collected while slicing.
      //There are several ways to implement it, with different granularity and timing.
      //1. per instruction. While the slicing is performed, after a new instruction is
      //   included in the final slice, check whether the current exposed set satisfies
      //   the condition: only global or heap variables are exposed.
      //   This implementation requires reviewing to understand the intra-procedural
      //   slicing algorithm. Because the new implementation will modify its original
      //   implementation.
      //2. per iteration in calculateStaticSlice. After one iteration, check whether the
      //   condition satisfies. If so, stop. Since, we may already include part of extra
      //   instructions that should not be included in the final slice, we have to remove
      //   them. This requires tracking the set of newly-added instructions per iteration,
      //   the modification to the original slicing algorithm is less but understanding is
      //   unavoidable, because we have to know the timing of adding new instructions.
      //3. per slice. Until the slicing is done, check whether the condition is satisfied.
      //   If so, nothing will be done further; otherwise, we have to reslice the extra
      //   instructions away. This implementation does not modify the original implementation
      //   and thus does not need to review the algorithm; but, if the condition does not
      //   hold, the reslicing will be inevitable. The reslicing is literally a re-implementation
      //   of 1. The chances are that, the condition always holds for real-world code or
      //   should be very rare to not hold. Is it worthy of engineering effort here ?
      //Decision:
      //  a. Considering the current progress, I should skip this concern now and come back later.
      //  b. Both intraprocedural and interprocedual slicing were understood in the past. The
      //     related documents should be collected and stored for future use.
      modified |= runOnFunction(*F, PS, MOD);

      //Find heap or global variables exposed.
      //Sync sync = syncSet.begin()->second;
      for(SyncSetIt i = syncSet.begin(), e = syncSet.end(); i != e; ++i)
      {
        Sync sync = i->second;
        IdentifyDRCSet(sync);
      }

      //Identify the sequential region (segment 1).
      //Extract loop context: loops where pthread_create resides in.
      //Assumption: there is only one pthread_create and one loop surrouding the
      //            pthread_create.
      //Due to function pointers and our restrictive assumptions, call-graph cannot
      //offer the information we need, such as pthread_create invokes a function(the
      //thread entry function), whether the callee is inside a loop of the caller, etc.
      //So we do it own our own.

      //Find all the pthread_create calls in the module. We assume there is no address-taken
      //pthread_create(no alias). 
      unsigned numPthreadCreate = analyzePthread_Create(M); //number of pthread_create invokation.

      //currently, we assume there is only one pthread_create. We may relax this restriction later
      //to handle multiple pthread_create invokation.
      //a. a work-crew threading app may have multiple pthread_create for phased computation.
      //b. a work-crew threading app may have multiple pthread_create under different input.
      //c. ...
      assert(numPthreadCreate == 1 && "currently, we assume there is only one pthread_create.");


      //Trace back from function sliced to pthread_create. (segment 2).
      //Assume 1: there is only one pthread_create between main and F(the function being sliced).
      //Assume 2: the entry function is not address-taken except by pthread_create and
      //thus no other alias exists, i.e., only thread entry function's address is taken by 
      //pthread_create, because it acts as a parameter in pthread_create, which is address-taken.
      //A function may have >= 1 direct call sites as its users, each corresponds to a possible
      //call path. But, currently, we don't want to consider other complicated cases. The work-crew
      //threading model is our current assumption, under which there are at most two call sites for
      //the thread entry function, one is main, the other is pthread_create.
      //Even with these assumptions, there is still a call graph(network) in segment2. We want to
      //summarize the effect of this network, so do we want to summarize the network between main
      //and pthread_create. The goal of the summarization is to assure that there is no other 
      //assignments to sync variables in both networks. It can be achieved by analyze all the node
      //function's side-effects on sync variables. First, we put all the nodes in the network into
      //a nodeSet. Second, we scan the nodeSet to verify whether there is assignment to sync vars of
      //interest.
      //analyzeSegmentTwo(); //segment 2: pthread_create->...(network 2)->F(sliced function)
      //analyzeSegmentOne(); //segment 1: main->...(network 1)->pthread_create.
      //the stop condition of segment 2: one of its users is pthread_create. If pthread_create is
      //the only user, that means the program is master-slave threading model, because the main
      //thread does not invoke the same function as pthread_create does. Otherwise, it is work-crew
      //threading model. FFT is work-crew threading, while Mysql is master-slave threading.
      //Apparently, in work-crew threading, the path constraints for pthread_create and the other user
      //of thread entry function is important to determine whether they can execute concurrently. 
      //In fact, the other user, utimately, is main thread.
      //To analyze the node in nodeSet, interprocedural analysis is required. Because, function A can
      //invoke other functions, which may transitively modify sync vars. This interprocedural analysis
      //complicates the implementation a lot. In principle, after the slice is obtained, an interprocedural
      //function summary pass should be performed before analysis to segment 2 and segment 1 is performed.
      //This interprocedural analysis should be considered later. The LLVMSlicer and LLVM itself have
      //interprocedural function summary implementation, but it still takes time to understand and reuse
      //their extant frameworks.
      //TODO: We decide to come back to this interprocedural analysis later. The first implementation will
      //not consider this point(do nothing, do something, do interprocedurally, it seems there is no middle
      //ground to "do something"). The problem is that: if we decide "do nothing", why should we care
      //about nodeSet and network of segment 2 ? The truth is if we choose "do nothing", then we do not
      //need to care about segment 2 at all.
      //TODO: there is a similar problem in segment 1 and this problem really exists in MySql allAB case.
      //There are multiple call sites in main, even for pthread_create. which one should we consider ?
      //Apparently, the current approach is problematic. There must be a way to choose one from many. 
      //The first one ? How to get it ? The first one is the one that control flow reaches firstly. With
      //this definition, we can determine which one is the first one. Then, how to handle others ? This
      //is also a problem for FFT barriers.
      //TODO: (Important)
      //as decided before, for certain simple cases, we don't perform vrp or segment 1/2 analysis but
      //simply decide the set of possible values(image) the sync variables may take. It should be fine even
      //if some of them are invalid. If we can generalize this approach, we can aviod the interprocedural
      //vrp and segment analysis. It should be feasible to find the image, the tricky part is operations performed
      //on the sync variable. The effects of the operations may be difficult to figure out. However, the
      //difficulty is still no worse than the current interprocedural approach because the latter also has
      //such a difficulty.
      findSegmentTwo(M, *F);
      findSegmentOne(M);

      //vrp in sequential region.
      //Heuristic for FFT barrier. If nodeSetOne size is zero, we know segment 1 is zero. It also indicates
      //that the projection points are in boundaryOfSegments (boundary between segment 1 and segment 2). To
      //perform vrp in sequential region, we do the following:
      //1. perform intra-vrp in main from the beginning to end.
      //   a. The sync vars to be propagated have already been identified and collected in drcSet.
      //   b. how to handle P ? If propagation fails to obtain a concrete value for P, then it makes sense to
      //   deduce P's value from the predicates it involves. But, under what conditions does vrp fail ? Since,
      //   I didn't consider this situation in previous vrp implementation, I should not consider it here 
      //   first. After gsense and count, I will come back to P.
      //2. perform intra-BB vrp in each projection point(boundary in boundaryOfSegments). This step is 
      //   simplified as comparing the In and Out set for the referenced BasicBlock, if they are the
      //   same, there is no need to perform the intra-BB propagation again. A more aggressive 
      //   simplification is to take In as the propagated value, assuming there is no other assignment
      //   to sync vars in the loop (This is what has been implemented below).
      if(nodeSetOne.size() == 0)
      {
        //nodeSetOne size is zero, indicating segment 1 is zero. This
        //is true for FFT 1st barrier.
        //Now query VRP for initial values of sync vars in drcSet.

        //step 1. perform intra-vrp in main from the beginning to end.
        //Three cases:
        //case 1. drc that has explicit value assigned. Such as gsense and count.
        //case 2. drc that does not have explicit value assigned. Such as P, it is an input-dependent
        //        variable.
        //case 3. drc that has explicit value assigned but also experience a complicated operation, such
        //        as gsense, count in FFT's barriers other than the 1st barrier. The operation is so 
        //        complex that it is only possible to figure out a range like (0, +inf). This problem is
        //        a research problem in CGO'13 value-range propagation paper.
        
        //Let's do case 1 firstly. The difficulty is that given a drc for a sync var, we cannot know which case
        //it is belonging to beforehand. It relies on VRP. If VRP can determine a concrete value, it is case 1;
        //otherwise, it is either case 2 or 3. Then, we try predicate-analysis, we find out the predicate that
        //the sync var involved in. We also need to show the predicate is on the critical path to projection
        //point, e.g., it is the loop exit-dependent variable (upper bound of trip count); for the loop, we also
        //need figure out lower bound and upper bound for its induction variable.

        //Are they work-crew model ?
        bool bWorkCrewModel = true;
        Function *main = M.getFunction("main");
        auto itPthreadCreate = end(boundaryOfSegments);
        auto itMain = itPthreadCreate;
        for(auto it=begin(boundaryOfSegments); it != end(boundaryOfSegments); ++it)
        {
          //a. their callers are main
          if(it->caller != main)
          {
            bWorkCrewModel = false;
            break;
          }
          
          //b. they call the Same thread function
          if(!it->bPthreadCreate)
          {
            if(it->callee != vecPthreadCreate[0].entryFunction)
            {
              bWorkCrewModel = false;
              break;
            }

            itMain = it;
          }
          else
          {
            //else: bPthreadCreate is true, pthread_create must call the entryFunction.
            //c. one is pthread_create. For work-crew model, pthread_create should always comes first.
            //   pthread_create should also be in a loop.
            if(it->bInLoop)
            {
              itPthreadCreate = it;
            }
          }
        }

        //The current implementation only works for work-crew model.
        assert(bWorkCrewModel && "Non work-crew model is unsupported now.");
        assert(itPthreadCreate != end(boundaryOfSegments) && "Invalid iterator for pthread_create.");
        assert(itMain != end(boundaryOfSegments) && "Invalid itertor for main thread");

        //Make sure pthread_create comes first by dominator-relation test.
        DominatorTree *DT = &getAnalysis<DominatorTreeWrapperPass>(*main).getDomTree();
        LoopInfo *LI = &getAnalysis<LoopInfoWrapperPass>(*main).getLoopInfo();
        BasicBlock *pThreadCreateBB = itPthreadCreate->callInst->getParent();
        BasicBlock *mainThreadBB = itMain->callInst->getParent();
        
        //Get the loop containing pthread_create BB.
        //Reference code: llvm::Loop class.
        Loop *pThreadCreateLoop = LI->getLoopFor(pThreadCreateBB);
        BasicBlock *exitBB = pThreadCreateLoop->getUniqueExitBlock();
        BasicBlock *preHeader = pThreadCreateLoop->getLoopPreheader();

        //We may need invoke loopSimplify pass before slicing.
        assert(exitBB != NULL && "The pthread_create loop is complicated");

        //Test dominaince relation. Reference code: ./unittests/IR/DominatorTreeTest.cpp
        if(DT->dominates(exitBB, mainThreadBB))
        {
          //pthread_create happens before main thread.
          
          //simplification: exitBB is the only predecessor of mainThreadBB.
          if(exitBB == mainThreadBB || exitBB == mainThreadBB->getUniquePredecessor())
          {
            errs() << "Work-crew model verified\n.";

            //Now we know the code is work-crew model.
            //we also know pthread_create comes first.
            //Therefore, we want to know the values of drc exposed at the header of pthread_create's
            //loop.
            BasicBlock * referenceBB = pThreadCreateLoop->getHeader();
            
            //valueRange::propagateDRC(main, referenceBB);
            //for each DRC, query intra-vrp for their initial value.
            for(DRCSet::iterator I=drcSet.begin(), E=drcSet.end(); I != E; ++I)
            {
              DRC *tempDRC = (DRC*)(*I);
              bool bFound = false;
              
              //TODO: initial try should be inter-vrp.

              //First try: intra-vrp.
              bFound = getValueRange(main, tempDRC, referenceBB);
              if(bFound)
              {
                continue;
              }
              else
              {
                //Second try: predict with predicates.
                bFound = getValueRangeWithPredicate(main, tempDRC, referenceBB, pThreadCreateLoop);
                if(bFound)
                {
                  continue;
                }
                else
                {
                  //TODO: Third try: If failed to predict with predicates,
                  //fall back to wild guess: guess according to their data type, assignment and operations
                  //in the program. For unsigned integer [0, 2], boolean [true, false], 
                  //signed integer [-2, 2].
                  Ranges range;
                  bdSet values;
                  values.clear();

                  range.values = values;
                  range.type = WILD_GUESS;

                  rangeMap[tempDRC] = range;
                }
              }
            }//for(DRCSet::iterator I

            //dumpRangeMap();
            
            //so far, we know it is work-crew threading model and also figure out the rangeMap for all the
            //global variables involved in the slice code. Next, we want to instrument the slice code with
            //printf for trace collection.

            //Design analysis: how to instrument for trace collection and scheduling.
            //1. trace collection. A simple solution is to replace Criteria to printf with proper arguments.
            //   For the read-side, replace Criteria with printf("Y"); for the write-side, replace Criteria
            //   with printf("X"). Muller suggests we instrument more printf in the slice or we accumulate
            //   the trace in an array. Then, output it in the end. The array option and direct output option
            //   are essentially the same, while implementing the latter is easier. As for instrumenting 
            //   multiple places, I don't see any benefit to do this. Therefore, my current decision is to
            //   replace Criteria with printf.
            //   a. Replacement of Criteria with printf("Y") is sufficient for read-side.
            //   b. Replacement of Criteria with printf("X") is not sufficient. Because, after the write happens,
            //      the read-side can proceed and there is scheduling happening after the write. So, the trace may
            //      be like "YYXYYY", namely, X can be any place. The right thing to do is insert printf("X") just
            //      before the write-side. More precisely, it should be the instruction just before the write-side
            //      and should be in the same BB as the write-side.
            //   c. printf may be replaced by fprintf, output the trace directly into a file, which requires open
            //      a file and shares it among all the threads, close it after all threads exit the scheduling
            //      region. This will introduce more codes, file opening, closing, and synchronization(main thread
            //      has to wait for all the children threads), which complicates the instrumentation a lot. The
            //      right thing to do is to just insert printf("X") and rely on I/O redirection to collect the traces.
            //      There are two possibilities: Cloud9 finishes one scheduling after another, then flush the I/O
            //      buffer; or Cloud9 simultaneously launches many schedulings. We prefer the former case because
            //      that will have one line for each scheduling and the <scheduling, trace> mapping is retained
            //      automatically. In constrast, the latter may mix the trace from different scheduling, breaking the
            //      traces' atomicity. We will consider this later.
            //
            //   d. Technical details: remove a function call; insert a function call with arguments; find read-side
            //      for printf("Y") insertion; find write-side boundary for insert printf("X"). The instrumentation
            //      takes the sliced function as input, intrument it and leave it in place for code-wrapping's 
            //      further processing.
            //      
            //
            //2. scheduling. This depends on how Cloud9 schedules a multi-threaded program. The interleaving should 
            //   begin after all threads have entered a specified region, which is the sliced function. Thus, there
            //   should be a marking to instruct Cloud9 where to start and end. Similar to Marss's switch between 
            //   emulation and simulation region. The problem is quite complex and I don't have any specific idea
            //   now because I know little about Cloud9's scheduling mechanism. Thus, I leave it alone and come
            //   back to it after I finish the frontend and get some hands-on experience on Cloud9.

            //read-side, write-side identification.
            instrumentSlice(M, F);

            //code wrapping. See codeWrapping.txt for design analysis.
            //Implementation note: it may be more convenient to insert instructions to mark the slice criteria
            //for code-wrapping purpose.
            //Step 1: insert slice criteria, void codeWrapping(void);
            instrumentForCodeWrapping(M);

            //Step 2: Perform the slicing in main. 
            //Rely on slicing to keep data-dependency and control-dependency for code-wrapping purpose.
            modified |= runOnFunction(*main, PS, MOD, true);

            //Step 3: for each exposed variable, check their ranges. Fix their ranges according to their
            //range type, and generate code.
            //generateCode()
            fixValueRanges(preHeader);

            //Step 4: remove placeholder functions, Criteria() and codeWrapping().
            removeAuxilaryFunction(__SLICING_FUN__);
            removeAuxilaryFunction(__WRAPPING_FUN__);

            //Step 5: insert waitForAll to make main wait for all the children threads.
            

          }//if(exitBB == mainThreadBB
          else
          {
            assert(0 && "TODO: Further test the path constraints.");
          }
        }
        else
        {
          assert(0 && "Non-work-crew model is unsupported now.");
        }
      }
      else
      {
        assert(0 && "inter-vrp has not been implemented yet.");
      }

      //Identify the concurrent region.(segment 2)
    }
    else
    {
#if 0
      //Get readSide call Instruction.
      Instruction *call = calls[0].getInstruction();
      Instruction *readSideCriteria = call; 
      BasicBlock* parentBB = call->getParent();

      //get the first instruction in parentBB
      Instruction& firstInst = parentBB->front();

      //Because we put Criteria just behind the loop(read-side),
      //Criteria() should be the first instruction in its BB.
      bool bReadSide = (&firstInst == call);

      if(!bReadSide)
      {
        readSideCriteria = calls[1].getInstruction();
      }

      //Get the loop exit branch instruction.
      //InsInfo::findSlicingInst has the code to extract the loop exit branch instruction
      //but, how to reuse it here ? The FunctionStaticSlicer

      //Get the loop exit BB.
#endif
    }

    //a2. Get the loop. Take the loop as readBBs.

    //b. Second, slice the write-side until there is no local variables exposed. Put all the
    //   BBs in writeBBs.
    //c. Figure out the exposed set of heap variable and global variable. Put them into
    //   heapVarSet and globalVarSet respectively. These two sets will be the input to the next step,
    //   bound vrp.
#if 0
    //Now, we only slice functions containing Criteria.
    for(std::vector<CallSite>::iterator it=calls.begin(); it != calls.end(); ++it)
    {
      //Get function.
      CallSite cs = *it;
      Function *F = cs.getInstruction()->getParent()->getParent();
      modified |= runOnFunction(*F, PS, MOD);
    }
#endif
#endif
    return modified;
  }
