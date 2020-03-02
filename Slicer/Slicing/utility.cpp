#include "utility.h"
using namespace Util;

void __attribute__ ((noinline)) DRC::dump()
{
  //dump the DRC
  errs() << "============================\n";
  errs() << "====DRC dump================\n"; 
  errs() << "============================\n";
  errs() << "DRC Type: ";
  if(bRead){
    errs() <<"Read\n";
  }
  else{
    errs() <<"Write\n";
  }

  errs() << "DRC size: " << size() << "\n";
  errs() << "DRC context: ";
  if(getInsContext())
  {
    getInsContext()->dump();
  }

  SmallVector<Pointer, 10>::iterator I = drc.begin(); 
  SmallVector<Pointer, 10>::iterator E = drc.end(); 
  for(; I != E; ++I){
    Value *value = (Value*)(*I);
    value->dump();
  }
  errs() << "============================\n";
}

void DRC::clear(){
  drc.clear();
}

/*
 * If a variable is a global variable, it is allocated statically on Global
 * memory. It is accessed by load or store to its address directly. The 
 * corresponding DRC length is 1.
 * If a variable is a global pointer, its value(the value being pointed to), 
 * if not NULL, must be allocated on Heap. The access cannot be done with only
 * 1 load or store, there must be gep instruction in between, making its DRC length
 * greater than 1.
 * */
bool DRC::isOnHeap()
{
  int size = drc.size();
  assert(size >= 1 && "DRC cannot be empty !");

  if(1 == drc.size()){
    return false;//Global memory.
  }
  else
  {
    return true; //On Heap
  }
}

//For a write drc. Whether it stores a constant.
bool DRC::isConstant()
{
  assert(!bRead && "DRC must be a write !");
  return value != NULL;
}

//For a write drc. Return its constant value.
const ConstantInt * DRC::getValue()
{
  assert(!bRead && "DRC must be a write !");
  return value;
}

void DRC::setValue(const ConstantInt * cv)
{
  value = cv;
}

void DRC::setInsContext(const Instruction *ins)
{
  insContext = ins;
}

const Instruction* DRC::getInsContext()
{
  return insContext; 
}

void DRC::setCallContext(const Instruction *call)
{
  callContext = call;
}

const Instruction * DRC::getCallContext()
{
  return callContext;
}

void bbData::dump()
{
  errs() << "------bbData-------\n";
  errs() << "-------------------\n";
  
  errs() << "Value: \n";
  if(Gen)
  {
    Gen->dump();
  }
  else
  {
    errs() << "Undecided variable !\n";
  }

  switch(Kill)
  {
    case KILL_EMPTY:
      errs() <<"KILL_EMPTY\n";
      break;
    case KILL_OTHERS:
      errs() <<"KILL_OTHERS\n";
      break;
    default:
      errs() <<"UNKNOWN\n";
      break;
  }

  errs() << "In: ";
  dumpSet(In);
  errs() << "Out: ";
  dumpSet(Out);

  errs() << "===================\n";
}


void bbData::dumpSet(bdSet& set)
{
  if(set.size() == 0)
  {
    errs() <<"{}\n";
  }
  else
  {
    for(bdSet::iterator I=set.begin(), E=set.end(); I != E; ++I)
    {
      ConstantInt *temp = (ConstantInt*)(*I);
      if(temp)
      {
        temp->dump();
      }
    }
  }
}

