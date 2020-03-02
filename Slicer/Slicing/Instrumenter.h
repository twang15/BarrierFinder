#ifndef __INSTRUMENTER__
#define  __INSTRUMENTER__

#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/CallingConv.h>
#include <llvm/IR/Constants.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/GlobalVariable.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Instructions.h>
#include <llvm/ADT/SmallVector.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/IRBuilder.h>

#include <vector>
using namespace llvm;
using namespace std;

void insertCodeWrapping(Module *mod, Instruction *insertBefore);
void insertPrintX(Module *mod, Instruction *insertBefore);
void insertPrintY(Module *mod, Instruction *insertBefore);
void insertPrintf(Module *mod, StringRef initializer, Instruction *insertBefore);
void insertSleep(Module *mod, StringRef initializer, Instruction *insertBefore);
void insertWaitForAll(Module *mod, Instruction *insertBefore);
void insertPrintChar(Module *mod, Instruction *insertBefore, StringRef initializer);
void insertSnapShot(Module *mod, Instruction *storeInst, StringRef index, bool beforeUpdate);
void insertIncrement(Module *mod, Instruction *insertBefore);
void insertInitialization(Module *mod, Instruction *insertBefore, StringRef initializer);
void insertRecordSyncVariables(Module *mod, Instruction *insertBefore);
void insertDeriveInvariant(Module *mod, Instruction *insertBefore);
void insertLoopExit(Module *mod, Instruction *insertBefore, StringRef initializer);
void insertLoopCurrent(Module *mod, Instruction *insertBefore, StringRef initializer);
#endif
