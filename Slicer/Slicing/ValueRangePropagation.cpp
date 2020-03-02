#include "ValueRangePropagation.h"

using namespace vrp;

/*Identify a gep instruction. 
 * If it is part of the current DRC, return true; 
 * otherwise, false.
 * */
bool valueRange::IdentifyGep(const Instruction *ins, DRC *drc)
{
  if(const GetElementPtrInst *gep = dyn_cast<GetElementPtrInst>(ins))
  {
    //The DRC is really a pattern. The code is really stupid.
    User::const_op_iterator opIter = gep->op_begin();
    ++opIter; //skip operand 0, it is a pseudo register.

    //push offsets into drc.
    for(User::const_op_iterator End = gep->op_end(); opIter != End; ++opIter)
    {
      drc->push_back(*opIter);
    }

    return true;
  }
  else
  {
    return false;
  }
}

void valueRange::dumpBBMap(BBMap &bbMap)
{
  for(BBMap::iterator I=bbMap.begin(), E=bbMap.end(); I != E; ++I)
  {
    const BasicBlock* bb = I->first;
    bbData *temp = (bbData *)I->second;

    //BB name
    errs() << "BB: " << bb->getName().str() <<"\n";

    //bbData
    if(temp)
    {
      temp->dump();
    }

    errs() <<"\n";
  }
}

void valueRange::dumpDRCSet(DRCSet &drcSet)
{
  for(DRCSet::iterator I=drcSet.begin(), E=drcSet.end(); I != E; ++I)
  {
    DRC *temp = (DRC*)(*I);
    temp->dump();
  }
}

//Input is the current drc.
//Output is its range at main's exit BB.
//Step 1. Extract the global variable or global pointer from drc[0].
//Step 2. Find its uses in main.
//Step 3. Check the uses is a write drc to the input drc. If so, put it
//in a drc set and record other useful information, (value, BB, start instruction).
//Step 4. Propagate the write drc in main as a normal worklist.
//4.1 Compute Gen, Kill for each BB.
//4.2 In[Entry] = {}; for all the other BBs, Out[BB]={}
//4.3 Initialization: WorkList = {All BB}
//4.4 For all BBs, Out[BB]=In-Kill+Gen, In=Union{Out[pred[BB]]}
bdSet valueRange::propagateDRC(Function *func, DRC *drc, BasicBlock *referenceBB){
  //Two cases: for the read drc
  //1. there are write drcs in func. Need to create function BBMap.
  //2. there is no write drc in func. No need to create function BBMap.

  //Step 1. Extract the global variable or global pointer from drc[0].
  assert(func && "Function should not be NULL !");
  assert((drc && drc->size()>0) && "DRC should not be NULL !");
  assert(referenceBB != NULL && "Reference point should not be empty !");
  GlobalVariable *gv = (GlobalVariable*) (*drc)[0];


  BBMap bbMap;
  DRCSet drcSet;
  WorkList worklist;

  //for each BB in func, create an entry in BBMap.
  for (Function::iterator FI = func->begin(), FE = func->end(); FI != FE; ++FI)
  {
    bbData* bd = new bbData;
    bd->Gen = NULL;
    bd->Kill = KILL_EMPTY;
    BasicBlock* bb = FI;

    bbMap.insert(bType(bb, bd));
    worklist.insert(bb);
  }

  //Whether a relevant write drc has already been seen so far.
  bool bFound = false;
  DRC *writeDRC = new DRC;

  for(const User* U : gv->users())
  {
    BasicBlock *parentBB = const_cast<BasicBlock*>(dyn_cast<Instruction>(U)->getParent());

    if(parentBB && parentBB->getParent() == func)
    {
      //if bFound is false, it means the writeDRC has not been successfully detected 
      //or has not been created. 
      if(!bFound)
      {
        if(writeDRC != NULL)
        {
          //has not been successfully detected.
          //Reuse the writeDRC.
          writeDRC->clear();
        }
      }
      else
      {
        //the previous writeDRC has been pushed into drcSet.
        //Create a new one.
        writeDRC = new DRC;
      }
      bFound = false;

      //Check whether it begins a write drc.
      if(const StoreInst *store = dyn_cast<StoreInst>(U))
      {
        if(drc->size() == 1)
        {
          //case 1. store *a. DRC-1
          //Extract the value.
          writeDRC->push_back(gv);
          writeDRC->setAccessType(false);

          //If value is not constant, then it must be marked.
          //Extract its value.
          Value *tv = store->getOperand(0);
          llvm::ConstantInt *constant = dyn_cast<llvm::ConstantInt>(tv);
          writeDRC->setValue(constant);
          writeDRC->setInsContext(store);
          drc->setInsContext(store);
          drcSet.push_back(writeDRC);
          writeDRC = NULL;
          bFound = true;

          //Set auxiliary information.(BB, ins, value).
          const BasicBlock *bb = store->getParent();
          bbData *bd = bbMap[bb];
          bd->Gen = constant;
          bd->Kill = KILL_OTHERS;
        }
        else //(drc.size > 1)
        {
          continue;
        }
      }
      else if(const LoadInst *load = dyn_cast<LoadInst>(U))
      {
        //case 2. load, gep, gep, store. DRC-4
        writeDRC->push_back(gv);

        //Get next instruction.
        const Instruction *next = load->getNextNode();
        const Instruction *prev = NULL;

        bool isGep = IdentifyGep(next, writeDRC);
        if(isGep)
        {
          //Make sure the writeDRC is continuous.
          Value *op0 = next->getOperand(0);
          if(op0 != load)
          {
            continue;
          }

          //Identify the second gep.
          prev = next;
          next = next->getNextNode();
          isGep = IdentifyGep(next, writeDRC);
          if(isGep)
          {
            //Make sure the writeDRC is continuous.
            Value *op0 = next->getOperand(0);
            if(op0 != prev)
            {
              continue;
            }
            //Identify the last store.
            prev = next;
            next = next->getNextNode();
            if(const StoreInst *store = dyn_cast<StoreInst>(next))
            {
              //Make sure the writeDRC is continuous.
              const Value *value = store->getPointerOperand();//operand 1.
              if(value == prev)
              {
                //It is a write drc.
                writeDRC->setAccessType(false);

                //This write drc is the definition to the same read drc.
                if(*drc == *writeDRC)
                {
                  //If value is not constant, then it must be marked.
                  //Extract its value.
                  Value *tv = store->getOperand(0);
                  llvm::ConstantInt *constant = dyn_cast<llvm::ConstantInt>(tv);
                  writeDRC->setValue(constant);
                  writeDRC->setInsContext(load);
                  drc->setInsContext(store);
                  drcSet.push_back(writeDRC);
                  writeDRC = NULL;
                  bFound = true;

                  //Set auxiliary information.(BB, ins, value).
                  const BasicBlock *bb = store->getParent();
                  bbData *bd = bbMap[bb];
                  bd->Gen = constant;
                  bd->Kill = KILL_OTHERS;

                  //Extract BB and ins. Because the user traversal is reverse in a BB,
                  //if in one BB, there are more than 1 write, only the last one should
                  //be considered and put into Gen[BB]. The Kill[BB] cannot be set at this
                  //stage, because we have not seen all the writes in the current function.
                  //Since we propagate one DRC each time, the Kill[BB] can be simplified. It
                  //is either empty for BBs which do not contain any relevant write DRCs, and
                  //thus should be empty; or it kills all the other relevant write DRCs because
                  //it contains at least 1 write drc. If one BB contains more than 1 relevant
                  //write DRC, only the last one matters, which will be traversed firstly. For
                  //all the other relevant DRCs in the same BB, we can just ignore them without
                  //assigning a sequence number to them. We can even skip their detections, if
                  //we do not consider PointTo analysis. If we do skip Point-To analysis, its
                  //Kill[BB] will be all the Other DRCs(in other BBs) which have been assigned
                  //or will be assigned a sequence number. The meet operation will be Union.

                  //Why should we assign a sequence number to a write drc ?
                  //For the convenience of Union operation ? Or else ? If the write is variable,
                  //there is no way to know its value; if it is constant, the sequence number does
                  //not matter as much as its constant value. If two drcs have the same constant
                  //value, and we assign them different sequence numbers, we are asking for
                  //complexities. Because we can simply use their constant value(the address to the
                  //constant) as their sequence number, this will simplify the union operation. A
                  //variable must have a difference address and will be NULL in our framework.



                  //Data structure: Map(BB, Data), Data=(Gen, Kill, In, Out).
                  //
                  //The scope: Map is affiliated to a function and is alive during the propagation.
                  //Assumption: do not consider function side-effect now. Assume no side effects.
                  //This assumption is too aggressive and can be wrong, needing interprocedural
                  //function summary.
                }
              }
              else
              {
                errs() << "The drc is not continuous and should be discarded !\n";
                continue;
              }
            }
          }
          else
          {
            continue;
          }
        }
        else
        {
          continue;
        }
      }
    }
  }

  //Debug code: dumpBBMap and dumpDRCSet.

  //Step 4. Propagate the write drc in main as a normal worklist.
  //4.1 Compute Gen, Kill for each BB. This is achieved by write drc detection phase.
  //4.2 In[Entry] = {}; for all the other BBs, Out[BB]={}. 
  //This is achieved by bbMap initialization.
  //4.3 Initialization: WorkList = {All BB}. Initialized when creating bbMap.
  //4.4 For all BBs, Out[BB]=In-Kill+Gen, In=Union{Out[pred[BB]]}
  while(!worklist.empty())
  {
    // a. Get a BB and its old Out, oldOut.
    WorkList::iterator it = worklist.begin();
    BasicBlock* bb = const_cast<BasicBlock*>(*it);
    bbData *bd = bbMap[bb];

    // b. Compute its new Out, newOut.
    //Compute its new In. In=Union{Out{pred{BB}}}
    bdSet newIn;
    for (pred_iterator I = pred_begin(bb), E = pred_end(bb); I != E; ++I)
    {
      BasicBlock * predBB = *I;
      bbData* predBD = bbMap[predBB];
      set_union(newIn, predBD->Out);
    }

    //update bd In. 
    if(bd->In != newIn)
    {
      bd->In = newIn;
    }

    //Out[BB] = In-Kill+Gen
    bdSet oldOut = bd->Out;
    bdSet newOut;
    switch(bd->Kill)
    {
      case KILL_EMPTY:
        //Out = newIn
        newOut = bd->In;
        break;

      case KILL_OTHERS:
        //Out = Gen
        newOut.insert(bd->Gen);
        break;

      default:
        assert(0 && "Invalid Kill Set !\n");
        break;
    }

    // c. if newOut != oldOut, add all of its successor BBs into worklist.
    //insert successors.
    if(oldOut != newOut)
    {
      bd->Out = newOut;
      worklist.insert(succ_begin(bb), succ_end(bb));
    }

    //remove current bb from worklist after processing.  
    worklist.remove(bb);
  }

  //So far, the value propagation is done from the function entry to exit.
  //To extract the value for the given drc, we need to know the projection point 
  //as a reference point. For FFT 1st barrier, pthread_create is in main(so that
  //segment 1 is 0 <=> nodeSetOne.size is 0); pthread_create is also in a loop,
  //so we should use the loop header as the reference point for gsense and count because
  //the loop header is where the children threads have not been created. Thus, from
  //the entry to the loop header, it is a sequential region. However, if we consider
  //the main thread's invokation to SlaveStart, we found this justification is no longer
  //valid because it is behind the pthread_create calls. The assumption must be even relaxed:
  //assume all the child threads are not pending and has no effect to the sync vars. This
  //is only one possible schedule in reality. The alternative is that we just propagate the 
  //values to the first project point since the main thread also invokes SlaveStart. The two
  //projection point exposed the same drcSet. 
  //(TODO: The calculation of drcSet exposed is an inter-backward propagation from slicing 
  //point to the projection point in main.) 
  //We can
  //empirically test that pthread_create and main invoke the same thread function, thus the
  //two projection points share the same drcSet exposed. We assume the loop predicate is always
  //true, thus, the pthread_create resides in is always feasible; then we try to figure out
  //the concurrency of pthread_create and the main thread's SlaveStart with dominantor relationship or
  //by successor calculation and path constraint encoding. In fact, I prefer a simpler implementation
  //as dominator relation test. If we show p1 is dominator of p2, we consider p2 and p1 can be concurrent.
  //and then we verify this by inspecting whether p2 is a successor of p1 (the work-crew model).

  //Extract the value. referenceBB's entry is the reference point to inspect the value of drc.
  bdSet retVal = bbMap[referenceBB]->In;

  /*release drcSet*/
  for(DRCSet::iterator I=drcSet.begin(), E=drcSet.end(); I != E; ++I)
  {
    DRC *temp = (DRC*)(*I);
    delete temp;
  }

  //This is necessary for the possible last unsuccessfully detected writeDRC.
  if(writeDRC)
  {
    delete writeDRC;
    writeDRC = NULL;
  }

  /*release bbMap*/
  for(BBMap::iterator I=bbMap.begin(), E=bbMap.end(); I != E; ++I)
  {
    bbData *temp = (bbData *)I->second;
    delete temp;
  }

  //Seems RPO does not make much difference.
#if 0  
  ReversePostOrderTraversal<Function *> RPOT(func);
  for (ReversePostOrderTraversal<Function *>::rpo_iterator RI = RPOT.begin(),RE = RPOT.end();
      RI != RE; ++RI)
  {
    BasicBlock *bb = *RI;
    errs() << bb->getName().str() <<"\n";
  }
#endif

  return retVal;
}
