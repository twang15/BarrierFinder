// Generated by llvm2cpp - DO NOT MODIFY!

#include <llvm/Pass.h>
#include <llvm/ADT/SmallVector.h>
#include <llvm/Analysis/Verifier.h>
#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/CallingConv.h>
#include <llvm/IR/Constants.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/GlobalVariable.h>
#include <llvm/IR/IRPrintingPasses.h>
#include <llvm/IR/InlineAsm.h>
#include <llvm/IR/Instructions.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/LegacyPassManager.h>
#include <llvm/IR/Module.h>
#include <llvm/Support/FormattedStream.h>
#include <llvm/Support/MathExtras.h>
#include <algorithm>
using namespace llvm;

Module* makeLLVMModule();

int main(int argc, char**argv) {
  Module* Mod = makeLLVMModule();
  verifyModule(*Mod, PrintMessageAction);
  PassManager PM;
  PM.add(createPrintModulePass(&outs()));
  PM.run(*Mod);
  return 0;
}


Module* makeLLVMModule() {
 // Module Construction
 Module* mod = new Module("printf.bc", getGlobalContext());
 mod->setDataLayout("");
 mod->setTargetTriple("x86_64-unknown-linux-gnu");
 
 // Type Definitions
 ArrayType* ArrayTy_0 = ArrayType::get(IntegerType::get(mod->getContext(), 8), 2);
 
 PointerType* PointerTy_1 = PointerType::get(ArrayTy_0, 0);
 
 std::vector<Type*>FuncTy_2_args;
 FunctionType* FuncTy_2 = FunctionType::get(
  /*Result=*/Type::getVoidTy(mod->getContext()),
  /*Params=*/FuncTy_2_args,
  /*isVarArg=*/false);
 
 PointerType* PointerTy_3 = PointerType::get(IntegerType::get(mod->getContext(), 32), 0);
 
 PointerType* PointerTy_4 = PointerType::get(IntegerType::get(mod->getContext(), 8), 0);
 
 std::vector<Type*>FuncTy_6_args;
 FuncTy_6_args.push_back(PointerTy_4);
 FunctionType* FuncTy_6 = FunctionType::get(
  /*Result=*/IntegerType::get(mod->getContext(), 32),
  /*Params=*/FuncTy_6_args,
  /*isVarArg=*/true);
 
 PointerType* PointerTy_5 = PointerType::get(FuncTy_6, 0);
 
 
 // Function Declarations
 
 Function* func_foo = mod->getFunction("foo");
 if (!func_foo) {
 func_foo = Function::Create(
  /*Type=*/FuncTy_2,
  /*Linkage=*/GlobalValue::ExternalLinkage,
  /*Name=*/"foo", mod); 
 func_foo->setCallingConv(CallingConv::C);
 }
 AttributeSet func_foo_PAL;
 {
  SmallVector<AttributeSet, 4> Attrs;
  AttributeSet PAS;
   {
    AttrBuilder B;
    B.addAttribute(Attribute::NoUnwind);
    B.addAttribute(Attribute::UWTable);
    PAS = AttributeSet::get(mod->getContext(), ~0U, B);
   }
  
  Attrs.push_back(PAS);
  func_foo_PAL = AttributeSet::get(mod->getContext(), Attrs);
  
 }
 func_foo->setAttributes(func_foo_PAL);
 
 Function* func_printf = mod->getFunction("printf");
 if (!func_printf) {
 func_printf = Function::Create(
  /*Type=*/FuncTy_6,
  /*Linkage=*/GlobalValue::ExternalLinkage,
  /*Name=*/"printf", mod); // (external, no body)
 func_printf->setCallingConv(CallingConv::C);
 }
 AttributeSet func_printf_PAL;
 {
  SmallVector<AttributeSet, 4> Attrs;
  AttributeSet PAS;
   {
    AttrBuilder B;
    PAS = AttributeSet::get(mod->getContext(), ~0U, B);
   }
  
  Attrs.push_back(PAS);
  func_printf_PAL = AttributeSet::get(mod->getContext(), Attrs);
  
 }
 func_printf->setAttributes(func_printf_PAL);
 
 // Global Variable Declarations

 
 GlobalVariable* gvar_array__str = new GlobalVariable(/*Module=*/*mod, 
 /*Type=*/ArrayTy_0,
 /*isConstant=*/true,
 /*Linkage=*/GlobalValue::PrivateLinkage,
 /*Initializer=*/0, // has initializer, specified below
 /*Name=*/".str");
 gvar_array__str->setAlignment(1);
 
 // Constant Definitions
 Constant *const_array_7 = ConstantDataArray::getString(mod->getContext(), "Y", true);
 ConstantInt* const_int32_8 = ConstantInt::get(mod->getContext(), APInt(32, StringRef("1"), 10));
 ConstantInt* const_int32_9 = ConstantInt::get(mod->getContext(), APInt(32, StringRef("2"), 10));
 std::vector<Constant*> const_ptr_10_indices;
 ConstantInt* const_int32_11 = ConstantInt::get(mod->getContext(), APInt(32, StringRef("0"), 10));
 const_ptr_10_indices.push_back(const_int32_11);
 const_ptr_10_indices.push_back(const_int32_11);
 Constant* const_ptr_10 = ConstantExpr::getGetElementPtr(gvar_array__str, const_ptr_10_indices);
 
 // Global Variable Definitions
 gvar_array__str->setInitializer(const_array_7);
 
 // Function Definitions
 
 // Function: foo (func_foo)
 {
  
  BasicBlock* label_entry = BasicBlock::Create(mod->getContext(), "entry",func_foo,0);
  
  // Block entry (label_entry)
  AllocaInst* ptr_a = new AllocaInst(IntegerType::get(mod->getContext(), 32), "a", label_entry);
  ptr_a->setAlignment(4);
  AllocaInst* ptr_b = new AllocaInst(IntegerType::get(mod->getContext(), 32), "b", label_entry);
  ptr_b->setAlignment(4);
  StoreInst* void_12 = new StoreInst(const_int32_8, ptr_a, false, label_entry);
  void_12->setAlignment(4);
  StoreInst* void_13 = new StoreInst(const_int32_9, ptr_b, false, label_entry);
  void_13->setAlignment(4);
  CallInst* int32_call = CallInst::Create(func_printf, const_ptr_10, "call", label_entry);
  int32_call->setCallingConv(CallingConv::C);
  int32_call->setTailCall(false);
  AttributeSet int32_call_PAL;
  int32_call->setAttributes(int32_call_PAL);
  
  LoadInst* int32_14 = new LoadInst(ptr_b, "", false, label_entry);
  int32_14->setAlignment(4);
  LoadInst* int32_15 = new LoadInst(ptr_a, "", false, label_entry);
  int32_15->setAlignment(4);
  BinaryOperator* int32_add = BinaryOperator::Create(Instruction::Add, int32_15, int32_14, "add", label_entry);
  StoreInst* void_16 = new StoreInst(int32_add, ptr_a, false, label_entry);
  void_16->setAlignment(4);
  ReturnInst::Create(mod->getContext(), label_entry);
  
 }
 
 return mod;
}