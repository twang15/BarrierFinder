#include "Instrumenter.h"

void insertCodeWrapping(Module *mod, Instruction *insertBefore)
{
  // Type Definitions
  std::vector<Type*>FuncTy_0_args;
  FunctionType* FuncTy_0 = FunctionType::get(
      /*Result=*/IntegerType::get(mod->getContext(), 32),
      /*Params=*/FuncTy_0_args,
      /*isVarArg=*/false);

  std::vector<Type*>FuncTy_2_args;
  FunctionType* FuncTy_2 = FunctionType::get(
      /*Result=*/Type::getVoidTy(mod->getContext()),
      /*Params=*/FuncTy_2_args,
      /*isVarArg=*/false);
  Function* func_codeWrapping = mod->getFunction("codeWrapping");

  if (!func_codeWrapping) {
    func_codeWrapping = Function::Create(
        /*Type=*/FuncTy_2,
        /*Linkage=*/GlobalValue::ExternalLinkage,
        /*Name=*/"codeWrapping", mod); // (external, no body)
    func_codeWrapping->setCallingConv(CallingConv::C);
  }

  AttributeSet func_codeWrapping_PAL;
  {
    SmallVector<AttributeSet, 4> Attrs;
    AttributeSet PAS;
    {
      AttrBuilder B;
      PAS = AttributeSet::get(mod->getContext(), ~0U, B);
    }

    Attrs.push_back(PAS);
    func_codeWrapping_PAL = AttributeSet::get(mod->getContext(), Attrs);

  }
  func_codeWrapping->setAttributes(func_codeWrapping_PAL);

  CallInst* void_4 = CallInst::Create(func_codeWrapping, "", insertBefore);
  void_4->setCallingConv(CallingConv::C);
  void_4->setTailCall(false);
  AttributeSet void_4_PAL;
  void_4->setAttributes(void_4_PAL);

}

void insertPrintf(Module *mod, StringRef initializer, Instruction *insertBefore)
{
  Function* func_printf = mod->getFunction("printf");

  // Type Definitions
  ArrayType* ArrayTy_0 = ArrayType::get(IntegerType::get(mod->getContext(), 8), 2);
  PointerType* PointerTy_4 = PointerType::get(IntegerType::get(mod->getContext(), 8), 0);

  std::vector<Type*>FuncTy_6_args;
  FuncTy_6_args.push_back(PointerTy_4);
  FunctionType* FuncTy_6 = FunctionType::get(
      /*Result=*/IntegerType::get(mod->getContext(), 32),
      /*Params=*/FuncTy_6_args,
      /*isVarArg=*/true);

  PointerType* PointerTy_5 = PointerType::get(FuncTy_6, 0);

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
  Constant *const_array_7 = ConstantDataArray::getString(mod->getContext(), initializer, true);
  std::vector<Constant*> const_ptr_10_indices;
  ConstantInt* const_int32_11 = ConstantInt::get(mod->getContext(), APInt(32, StringRef("0"), 10));
  const_ptr_10_indices.push_back(const_int32_11);
  const_ptr_10_indices.push_back(const_int32_11);

  //Reference: http://llvm.org/docs/doxygen/html/Constants_8cpp_source.html#l01964
  //llvm3.7 modifies getGetElementPtr prototype by adding the first "Type *" argument,
  //base on the latest implementation, we can see Ty may be not critical. So, nullptr
  //may be OK. If not, we just need copy their type creation code.

  //The code:
  //
  //01967   if (!Ty)
  //01968     Ty = cast<PointerType>(C->getType()->getScalarType())->getElementType(); //For nullptr
  //01969   else
  //01970     assert(
  //01971         Ty ==
  //01972         cast<PointerType>(C->getType()->getScalarType())->getContainedType(0u)); //For not nullptr.

  Constant* const_ptr_10 = ConstantExpr::getGetElementPtr(nullptr, gvar_array__str, const_ptr_10_indices);

  // Global Variable Definitions
  gvar_array__str->setInitializer(const_array_7);


  CallInst* int32_call = CallInst::Create(func_printf, const_ptr_10, "call", insertBefore);
  int32_call->setCallingConv(CallingConv::C);
  int32_call->setTailCall(false);
  AttributeSet int32_call_PAL;
  int32_call->setAttributes(int32_call_PAL);

}

void insertPrintX(Module *mod, Instruction *insertBefore)
{
  // Type Definitions
  std::vector<Type*>FuncTy_0_args;
  FunctionType* FuncTy_0 = FunctionType::get(
      /*Result=*/Type::getVoidTy(mod->getContext()),
      /*Params=*/FuncTy_0_args,
      /*isVarArg=*/false);

  Function* func_printX = mod->getFunction("printX");
  if (!func_printX) {
    func_printX = Function::Create(
        /*Type=*/FuncTy_0,
        /*Linkage=*/GlobalValue::ExternalLinkage,
        /*Name=*/"printX", mod); // (external, no body)
    func_printX->setCallingConv(CallingConv::C);
  }
  AttributeSet func_printX_PAL;
  {
    SmallVector<AttributeSet, 4> Attrs;
    AttributeSet PAS;
    {
      AttrBuilder B;
      PAS = AttributeSet::get(mod->getContext(), ~0U, B);
    }

    Attrs.push_back(PAS);
    func_printX_PAL = AttributeSet::get(mod->getContext(), Attrs);

  }
  func_printX->setAttributes(func_printX_PAL);

  CallInst* void_2 = CallInst::Create(func_printX, "", insertBefore);
  void_2->setCallingConv(CallingConv::C);
  void_2->setTailCall(false);
  AttributeSet void_2_PAL;
  void_2->setAttributes(void_2_PAL);
}

void insertPrintY(Module *mod, Instruction *insertBefore)
{
  // Type Definitions
  std::vector<Type*>FuncTy_0_args;
  FunctionType* FuncTy_0 = FunctionType::get(
      /*Result=*/Type::getVoidTy(mod->getContext()),
      /*Params=*/FuncTy_0_args,
      /*isVarArg=*/false);

  Function* func_printY = mod->getFunction("printY");
  if (!func_printY) {
    func_printY = Function::Create(
        /*Type=*/FuncTy_0,
        /*Linkage=*/GlobalValue::ExternalLinkage,
        /*Name=*/"printY", mod); // (external, no body)
    func_printY->setCallingConv(CallingConv::C);
  }
  AttributeSet func_printY_PAL;
  {
    SmallVector<AttributeSet, 4> Attrs;
    AttributeSet PAS;
    {
      AttrBuilder B;
      PAS = AttributeSet::get(mod->getContext(), ~0U, B);
    }

    Attrs.push_back(PAS);
    func_printY_PAL = AttributeSet::get(mod->getContext(), Attrs);

  }
  func_printY->setAttributes(func_printY_PAL);

  CallInst* void_2 = CallInst::Create(func_printY, "", insertBefore);
  void_2->setCallingConv(CallingConv::C);
  void_2->setTailCall(false);
  AttributeSet void_2_PAL;
  void_2->setAttributes(void_2_PAL);
}

/*
 * schedule.c, schedule.cpp
 * for inserting sleep(1), sleep(2), sleep(3).
 * 
 * */
void insertSleep(Module *mod, StringRef initializer, Instruction *insertBefore)
{
 // Type Definitions
 std::vector<Type*>FuncTy_2_args;
 FuncTy_2_args.push_back(IntegerType::get(mod->getContext(), 32));
 FunctionType* FuncTy_2 = FunctionType::get(
  /*Result=*/IntegerType::get(mod->getContext(), 32),
  /*Params=*/FuncTy_2_args,
  /*isVarArg=*/false);
 
 Function* func_sleep = mod->getFunction("sleep");
 if (!func_sleep) {
 func_sleep = Function::Create(
  /*Type=*/FuncTy_2,
  /*Linkage=*/GlobalValue::ExternalLinkage,
  /*Name=*/"sleep", mod); // (external, no body)
 func_sleep->setCallingConv(CallingConv::C);
 }
 AttributeSet func_sleep_PAL;
 {
  SmallVector<AttributeSet, 4> Attrs;
  AttributeSet PAS;
   {
    AttrBuilder B;
    PAS = AttributeSet::get(mod->getContext(), ~0U, B);
   }
  
  Attrs.push_back(PAS);
  func_sleep_PAL = AttributeSet::get(mod->getContext(), Attrs);
  
 }
 func_sleep->setAttributes(func_sleep_PAL);
  ConstantInt* const_int32_3 = ConstantInt::get(mod->getContext(), APInt(32, initializer, 10));
  
  CallInst* int32_call = CallInst::Create(func_sleep, const_int32_3, "call", insertBefore);
  int32_call->setCallingConv(CallingConv::C);
  int32_call->setTailCall(false);
  AttributeSet int32_call_PAL;
  int32_call->setAttributes(int32_call_PAL);
}

void insertWaitForAll(Module *mod, Instruction *insertBefore)
{
  // Type Definitions
  std::vector<Type*>FuncTy_0_args;
  FunctionType* FuncTy_0 = FunctionType::get(
      /*Result=*/Type::getVoidTy(mod->getContext()),
      /*Params=*/FuncTy_0_args,
      /*isVarArg=*/false);

  Function* func_waitForAll = mod->getFunction("waitForAll");
  if (!func_waitForAll) {
    func_waitForAll = Function::Create(
        /*Type=*/FuncTy_0,
        /*Linkage=*/GlobalValue::ExternalLinkage,
        /*Name=*/"waitForAll", mod); // (external, no body)
    func_waitForAll->setCallingConv(CallingConv::C);
  }
  AttributeSet func_waitForAll_PAL;
  {
    SmallVector<AttributeSet, 4> Attrs;
    AttributeSet PAS;
    {
      AttrBuilder B;
      PAS = AttributeSet::get(mod->getContext(), ~0U, B);
    }

    Attrs.push_back(PAS);
    func_waitForAll_PAL = AttributeSet::get(mod->getContext(), Attrs);

  }
  func_waitForAll->setAttributes(func_waitForAll_PAL);

  CallInst* void_2 = CallInst::Create(func_waitForAll, "", insertBefore);
  void_2->setCallingConv(CallingConv::C);
  void_2->setTailCall(false);
  AttributeSet void_2_PAL;
  void_2->setAttributes(void_2_PAL);
}

#if 0
void insertPrintZ(Module *mod, Instruction *insertBefore)
{
  // Type Definitions
  std::vector<Type*>FuncTy_0_args;
  FunctionType* FuncTy_0 = FunctionType::get(
      /*Result=*/Type::getVoidTy(mod->getContext()),
      /*Params=*/FuncTy_0_args,
      /*isVarArg=*/false);

  Function* func_printZ = mod->getFunction("printZ");
  if (!func_printZ) {
    func_printZ = Function::Create(
        /*Type=*/FuncTy_0,
        /*Linkage=*/GlobalValue::ExternalLinkage,
        /*Name=*/"printZ", mod); // (external, no body)
    func_printZ->setCallingConv(CallingConv::C);
  }
  AttributeSet func_printZ_PAL;
  {
    SmallVector<AttributeSet, 4> Attrs;
    AttributeSet PAS;
    {
      AttrBuilder B;
      PAS = AttributeSet::get(mod->getContext(), ~0U, B);
    }

    Attrs.push_back(PAS);
    func_printZ_PAL = AttributeSet::get(mod->getContext(), Attrs);

  }
  func_printZ->setAttributes(func_printZ_PAL);

  CallInst* void_2 = CallInst::Create(func_printZ, "", insertBefore);
  void_2->setCallingConv(CallingConv::C);
  void_2->setTailCall(false);
  AttributeSet void_2_PAL;
  void_2->setAttributes(void_2_PAL);
}

void insertPrint0(Module *mod, Instruction *insertBefore)
{
  // Type Definitions
  std::vector<Type*>FuncTy_0_args;
  FunctionType* FuncTy_0 = FunctionType::get(
      /*Result=*/Type::getVoidTy(mod->getContext()),
      /*Params=*/FuncTy_0_args,
      /*isVarArg=*/false);

  Function* func_print0 = mod->getFunction("print0");
  if (!func_print0) {
    func_print0 = Function::Create(
        /*Type=*/FuncTy_0,
        /*Linkage=*/GlobalValue::ExternalLinkage,
        /*Name=*/"print0", mod); // (external, no body)
    func_print0->setCallingConv(CallingConv::C);
  }
  AttributeSet func_print0_PAL;
  {
    SmallVector<AttributeSet, 4> Attrs;
    AttributeSet PAS;
    {
      AttrBuilder B;
      PAS = AttributeSet::get(mod->getContext(), ~0U, B);
    }

    Attrs.push_back(PAS);
    func_print0_PAL = AttributeSet::get(mod->getContext(), Attrs);

  }
  func_print0->setAttributes(func_print0_PAL);

  CallInst* void_2 = CallInst::Create(func_print0, "", insertBefore);
  void_2->setCallingConv(CallingConv::C);
  void_2->setTailCall(false);
  AttributeSet void_2_PAL;
  void_2->setAttributes(void_2_PAL);
}

void insertPrint1(Module *mod, Instruction *insertBefore)
{
  // Type Definitions
  std::vector<Type*>FuncTy_0_args;
  FunctionType* FuncTy_0 = FunctionType::get(
      /*Result=*/Type::getVoidTy(mod->getContext()),
      /*Params=*/FuncTy_0_args,
      /*isVarArg=*/false);

  Function* func_print1 = mod->getFunction("print1");
  if (!func_print1) {
    func_print1 = Function::Create(
        /*Type=*/FuncTy_0,
        /*Linkage=*/GlobalValue::ExternalLinkage,
        /*Name=*/"print1", mod); // (external, no body)
    func_print1->setCallingConv(CallingConv::C);
  }
  AttributeSet func_print1_PAL;
  {
    SmallVector<AttributeSet, 4> Attrs;
    AttributeSet PAS;
    {
      AttrBuilder B;
      PAS = AttributeSet::get(mod->getContext(), ~0U, B);
    }

    Attrs.push_back(PAS);
    func_print1_PAL = AttributeSet::get(mod->getContext(), Attrs);

  }
  func_print1->setAttributes(func_print1_PAL);

  CallInst* void_2 = CallInst::Create(func_print1, "", insertBefore);
  void_2->setCallingConv(CallingConv::C);
  void_2->setTailCall(false);
  AttributeSet void_2_PAL;
  void_2->setAttributes(void_2_PAL);
}

void insertPrint2(Module *mod, Instruction *insertBefore)
{
  // Type Definitions
  std::vector<Type*>FuncTy_0_args;
  FunctionType* FuncTy_0 = FunctionType::get(
      /*Result=*/Type::getVoidTy(mod->getContext()),
      /*Params=*/FuncTy_0_args,
      /*isVarArg=*/false);

  Function* func_print2 = mod->getFunction("print2");
  if (!func_print2) {
    func_print2 = Function::Create(
        /*Type=*/FuncTy_0,
        /*Linkage=*/GlobalValue::ExternalLinkage,
        /*Name=*/"print2", mod); // (external, no body)
    func_print2->setCallingConv(CallingConv::C);
  }
  AttributeSet func_print2_PAL;
  {
    SmallVector<AttributeSet, 4> Attrs;
    AttributeSet PAS;
    {
      AttrBuilder B;
      PAS = AttributeSet::get(mod->getContext(), ~0U, B);
    }

    Attrs.push_back(PAS);
    func_print2_PAL = AttributeSet::get(mod->getContext(), Attrs);

  }
  func_print2->setAttributes(func_print2_PAL);

  CallInst* void_2 = CallInst::Create(func_print2, "", insertBefore);
  void_2->setCallingConv(CallingConv::C);
  void_2->setTailCall(false);
  AttributeSet void_2_PAL;
  void_2->setAttributes(void_2_PAL);
}

void insertPrint3(Module *mod, Instruction *insertBefore)
{
  // Type Definitions
  std::vector<Type*>FuncTy_0_args;
  FunctionType* FuncTy_0 = FunctionType::get(
      /*Result=*/Type::getVoidTy(mod->getContext()),
      /*Params=*/FuncTy_0_args,
      /*isVarArg=*/false);

  Function* func_print3 = mod->getFunction("print3");
  if (!func_print3) {
    func_print3 = Function::Create(
        /*Type=*/FuncTy_0,
        /*Linkage=*/GlobalValue::ExternalLinkage,
        /*Name=*/"print3", mod); // (external, no body)
    func_print3->setCallingConv(CallingConv::C);
  }
  AttributeSet func_print3_PAL;
  {
    SmallVector<AttributeSet, 4> Attrs;
    AttributeSet PAS;
    {
      AttrBuilder B;
      PAS = AttributeSet::get(mod->getContext(), ~0U, B);
    }

    Attrs.push_back(PAS);
    func_print3_PAL = AttributeSet::get(mod->getContext(), Attrs);

  }
  func_print3->setAttributes(func_print3_PAL);

  CallInst* void_2 = CallInst::Create(func_print3, "", insertBefore);
  void_2->setCallingConv(CallingConv::C);
  void_2->setTailCall(false);
  AttributeSet void_2_PAL;
  void_2->setAttributes(void_2_PAL);
}

void insertPrint4(Module *mod, Instruction *insertBefore)
{
  // Type Definitions
  std::vector<Type*>FuncTy_0_args;
  FunctionType* FuncTy_0 = FunctionType::get(
      /*Result=*/Type::getVoidTy(mod->getContext()),
      /*Params=*/FuncTy_0_args,
      /*isVarArg=*/false);

  Function* func_print4 = mod->getFunction("print4");
  if (!func_print4) {
    func_print4 = Function::Create(
        /*Type=*/FuncTy_0,
        /*Linkage=*/GlobalValue::ExternalLinkage,
        /*Name=*/"print4", mod); // (external, no body)
    func_print4->setCallingConv(CallingConv::C);
  }
  AttributeSet func_print4_PAL;
  {
    SmallVector<AttributeSet, 4> Attrs;
    AttributeSet PAS;
    {
      AttrBuilder B;
      PAS = AttributeSet::get(mod->getContext(), ~0U, B);
    }

    Attrs.push_back(PAS);
    func_print4_PAL = AttributeSet::get(mod->getContext(), Attrs);

  }
  func_print4->setAttributes(func_print4_PAL);

  CallInst* void_2 = CallInst::Create(func_print4, "", insertBefore);
  void_2->setCallingConv(CallingConv::C);
  void_2->setTailCall(false);
  AttributeSet void_2_PAL;
  void_2->setAttributes(void_2_PAL);
}

void insertPrint5(Module *mod, Instruction *insertBefore)
{
  // Type Definitions
  std::vector<Type*>FuncTy_0_args;
  FunctionType* FuncTy_0 = FunctionType::get(
      /*Result=*/Type::getVoidTy(mod->getContext()),
      /*Params=*/FuncTy_0_args,
      /*isVarArg=*/false);

  Function* func_print5 = mod->getFunction("print5");
  if (!func_print5) {
    func_print5 = Function::Create(
        /*Type=*/FuncTy_0,
        /*Linkage=*/GlobalValue::ExternalLinkage,
        /*Name=*/"print5", mod); // (external, no body)
    func_print5->setCallingConv(CallingConv::C);
  }
  AttributeSet func_print5_PAL;
  {
    SmallVector<AttributeSet, 4> Attrs;
    AttributeSet PAS;
    {
      AttrBuilder B;
      PAS = AttributeSet::get(mod->getContext(), ~0U, B);
    }

    Attrs.push_back(PAS);
    func_print5_PAL = AttributeSet::get(mod->getContext(), Attrs);

  }
  func_print5->setAttributes(func_print5_PAL);

  CallInst* void_2 = CallInst::Create(func_print5, "", insertBefore);
  void_2->setCallingConv(CallingConv::C);
  void_2->setTailCall(false);
  AttributeSet void_2_PAL;
  void_2->setAttributes(void_2_PAL);
}

void insertPrint6(Module *mod, Instruction *insertBefore)
{
  // Type Definitions
  std::vector<Type*>FuncTy_0_args;
  FunctionType* FuncTy_0 = FunctionType::get(
      /*Result=*/Type::getVoidTy(mod->getContext()),
      /*Params=*/FuncTy_0_args,
      /*isVarArg=*/false);

  Function* func_print6 = mod->getFunction("print6");
  if (!func_print6) {
    func_print6 = Function::Create(
        /*Type=*/FuncTy_0,
        /*Linkage=*/GlobalValue::ExternalLinkage,
        /*Name=*/"print6", mod); // (external, no body)
    func_print6->setCallingConv(CallingConv::C);
  }
  AttributeSet func_print6_PAL;
  {
    SmallVector<AttributeSet, 4> Attrs;
    AttributeSet PAS;
    {
      AttrBuilder B;
      PAS = AttributeSet::get(mod->getContext(), ~0U, B);
    }

    Attrs.push_back(PAS);
    func_print6_PAL = AttributeSet::get(mod->getContext(), Attrs);

  }
  func_print6->setAttributes(func_print6_PAL);

  CallInst* void_2 = CallInst::Create(func_print6, "", insertBefore);
  void_2->setCallingConv(CallingConv::C);
  void_2->setTailCall(false);
  AttributeSet void_2_PAL;
  void_2->setAttributes(void_2_PAL);
}

void insertPrint7(Module *mod, Instruction *insertBefore)
{
  // Type Definitions
  std::vector<Type*>FuncTy_0_args;
  FunctionType* FuncTy_0 = FunctionType::get(
      /*Result=*/Type::getVoidTy(mod->getContext()),
      /*Params=*/FuncTy_0_args,
      /*isVarArg=*/false);

  Function* func_print7 = mod->getFunction("print7");
  if (!func_print7) {
    func_print7 = Function::Create(
        /*Type=*/FuncTy_0,
        /*Linkage=*/GlobalValue::ExternalLinkage,
        /*Name=*/"print7", mod); // (external, no body)
    func_print7->setCallingConv(CallingConv::C);
  }
  AttributeSet func_print7_PAL;
  {
    SmallVector<AttributeSet, 4> Attrs;
    AttributeSet PAS;
    {
      AttrBuilder B;
      PAS = AttributeSet::get(mod->getContext(), ~0U, B);
    }

    Attrs.push_back(PAS);
    func_print7_PAL = AttributeSet::get(mod->getContext(), Attrs);

  }
  func_print7->setAttributes(func_print7_PAL);

  CallInst* void_2 = CallInst::Create(func_print7, "", insertBefore);
  void_2->setCallingConv(CallingConv::C);
  void_2->setTailCall(false);
  AttributeSet void_2_PAL;
  void_2->setAttributes(void_2_PAL);
}

void insertPrint8(Module *mod, Instruction *insertBefore)
{
  // Type Definitions
  std::vector<Type*>FuncTy_0_args;
  FunctionType* FuncTy_0 = FunctionType::get(
      /*Result=*/Type::getVoidTy(mod->getContext()),
      /*Params=*/FuncTy_0_args,
      /*isVarArg=*/false);

  Function* func_print8 = mod->getFunction("print8");
  if (!func_print8) {
    func_print8 = Function::Create(
        /*Type=*/FuncTy_0,
        /*Linkage=*/GlobalValue::ExternalLinkage,
        /*Name=*/"print8", mod); // (external, no body)
    func_print8->setCallingConv(CallingConv::C);
  }
  AttributeSet func_print8_PAL;
  {
    SmallVector<AttributeSet, 4> Attrs;
    AttributeSet PAS;
    {
      AttrBuilder B;
      PAS = AttributeSet::get(mod->getContext(), ~0U, B);
    }

    Attrs.push_back(PAS);
    func_print8_PAL = AttributeSet::get(mod->getContext(), Attrs);

  }
  func_print8->setAttributes(func_print8_PAL);

  CallInst* void_2 = CallInst::Create(func_print8, "", insertBefore);
  void_2->setCallingConv(CallingConv::C);
  void_2->setTailCall(false);
  AttributeSet void_2_PAL;
  void_2->setAttributes(void_2_PAL);
}

void insertPrint9(Module *mod, Instruction *insertBefore)
{
  // Type Definitions
  std::vector<Type*>FuncTy_0_args;
  FunctionType* FuncTy_0 = FunctionType::get(
      /*Result=*/Type::getVoidTy(mod->getContext()),
      /*Params=*/FuncTy_0_args,
      /*isVarArg=*/false);

  Function* func_print9 = mod->getFunction("print9");
  if (!func_print9) {
    func_print9 = Function::Create(
        /*Type=*/FuncTy_0,
        /*Linkage=*/GlobalValue::ExternalLinkage,
        /*Name=*/"print9", mod); // (external, no body)
    func_print9->setCallingConv(CallingConv::C);
  }
  AttributeSet func_print9_PAL;
  {
    SmallVector<AttributeSet, 4> Attrs;
    AttributeSet PAS;
    {
      AttrBuilder B;
      PAS = AttributeSet::get(mod->getContext(), ~0U, B);
    }

    Attrs.push_back(PAS);
    func_print9_PAL = AttributeSet::get(mod->getContext(), Attrs);

  }
  func_print9->setAttributes(func_print9_PAL);

  CallInst* void_2 = CallInst::Create(func_print9, "", insertBefore);
  void_2->setCallingConv(CallingConv::C);
  void_2->setTailCall(false);
  AttributeSet void_2_PAL;
  void_2->setAttributes(void_2_PAL);
}
#else
void insertPrintChar(Module *mod, Instruction *insertBefore, StringRef initializer)
{
  std::vector<Type*>FuncTy_2_args;
  FuncTy_2_args.push_back(IntegerType::get(mod->getContext(), 8));
  FunctionType* FuncTy_2 = FunctionType::get(
      /*Result=*/Type::getVoidTy(mod->getContext()),
      /*Params=*/FuncTy_2_args,
      /*isVarArg=*/false);

  Function* func_printChar = mod->getFunction("printChar");
  if (!func_printChar) {
    func_printChar = Function::Create(
        /*Type=*/FuncTy_2,
        /*Linkage=*/GlobalValue::ExternalLinkage,
        /*Name=*/"printChar", mod); // (external, no body)
    func_printChar->setCallingConv(CallingConv::C);
  }
  AttributeSet func_printChar_PAL;
  {
    SmallVector<AttributeSet, 4> Attrs;
    AttributeSet PAS;
    {
      AttrBuilder B;
      B.addAttribute(Attribute::SExt);
      PAS = AttributeSet::get(mod->getContext(), 1U, B);
    }

    Attrs.push_back(PAS);
    {
      AttrBuilder B;
      PAS = AttributeSet::get(mod->getContext(), ~0U, B);
    }

    Attrs.push_back(PAS);
    func_printChar_PAL = AttributeSet::get(mod->getContext(), Attrs);

  }
  func_printChar->setAttributes(func_printChar_PAL);

  ConstantInt* const_int8_3 = ConstantInt::get(mod->getContext(), APInt(8, initializer, 10));
  CallInst* void_4 = CallInst::Create(func_printChar, const_int8_3, "", insertBefore);
  void_4->setCallingConv(CallingConv::C);
  void_4->setTailCall(false);
  AttributeSet void_4_PAL;
  {
    SmallVector<AttributeSet, 4> Attrs;
    AttributeSet PAS;
    {
      AttrBuilder B;
      B.addAttribute(Attribute::SExt);
      PAS = AttributeSet::get(mod->getContext(), 1U, B);
    }

    Attrs.push_back(PAS);
    void_4_PAL = AttributeSet::get(mod->getContext(), Attrs);

  }
  void_4->setAttributes(void_4_PAL);

}
#endif

void insertSnapShot(Module *mod, Instruction *storeInst, StringRef index, bool beforeUpdate)
{
  vector<Value*> ArgsV;
  Value *syncVar;

  if(StoreInst *store = dyn_cast<StoreInst>(storeInst))
  {
    if(beforeUpdate)
    {
      LoadInst *load = new LoadInst(store->getOperand(1), "", false, storeInst);
      syncVar = load;
    }
    else
    {
      syncVar = storeInst->getOperand(0);
    }
  }
  else if(CallInst *callInst = dyn_cast<CallInst>(storeInst))
  {
    if(callInst->getCalledFunction()->getName() == "atomic_cmpxchg")
    {
      syncVar = callInst;    
    }
    else
    {
      assert(0 && "Unsupported function.\n");
    }
  }
  else
  {
    assert(0 && "Unsupported instruction.\n");
  }

  ArgsV.push_back(syncVar);
  ConstantInt* idx = ConstantInt::get(mod->getContext(), APInt(32, index, 10));
  ArgsV.push_back(idx);
  
  Function* func_snapshot;
  if(syncVar->getType() == llvm::Type::getInt32Ty(mod->getContext()))
  {
    func_snapshot = mod->getFunction("snapshot");
  }
  else if(syncVar->getType() == llvm::Type::getInt64Ty(mod->getContext()))
  {
    func_snapshot = mod->getFunction("snapshot64");
  }
  else
  {
    assert(0 && "Unsupported snapshot syncVar type.\n");
  }

  if(beforeUpdate)
  {
    IRBuilder<> Builder(storeInst);
    CallInst* snapshot = Builder.CreateCall(func_snapshot, ArgsV, "");
  }
  else
  {
    IRBuilder<> Builder(storeInst->getNextNode());
    CallInst* snapshot = Builder.CreateCall(func_snapshot, ArgsV, "");
  }
}

void insertIncrement(Module *mod, Instruction *insertBefore)
{
  // Type Definitions
  std::vector<Type*>FuncTy_0_args;
  FunctionType* FuncTy_0 = FunctionType::get(
      /*Result=*/Type::getVoidTy(mod->getContext()),
      /*Params=*/FuncTy_0_args,
      /*isVarArg=*/false);

  Function* func_Increment = mod->getFunction("IncrementCounter");
  if (!func_Increment) {
    func_Increment = Function::Create(
        /*Type=*/FuncTy_0,
        /*Linkage=*/GlobalValue::ExternalLinkage,
        /*Name=*/"IncrementCounter", mod); // (external, no body)
    func_Increment->setCallingConv(CallingConv::C);
  }
  AttributeSet func_Increment_PAL;
  {
    SmallVector<AttributeSet, 4> Attrs;
    AttributeSet PAS;
    {
      AttrBuilder B;
      PAS = AttributeSet::get(mod->getContext(), ~0U, B);
    }

    Attrs.push_back(PAS);
    func_Increment_PAL = AttributeSet::get(mod->getContext(), Attrs);

  }
  func_Increment->setAttributes(func_Increment_PAL);

  CallInst* void_2 = CallInst::Create(func_Increment, "", insertBefore);
  void_2->setCallingConv(CallingConv::C);
  void_2->setTailCall(false);
  AttributeSet void_2_PAL;
  void_2->setAttributes(void_2_PAL);
}

void insertInitialization(Module *mod, Instruction *insertBefore, StringRef initializer)
{
#if 1
  std::vector<Type*>FuncTy_2_args;
  FuncTy_2_args.push_back(IntegerType::get(mod->getContext(), 32));
  FunctionType* FuncTy_2 = FunctionType::get(
      /*Result=*/Type::getVoidTy(mod->getContext()),
      /*Params=*/FuncTy_2_args,
      /*isVarArg=*/false);

  Function* func_InitializeSwitchesAndCounter = mod->getFunction("InitializeSwitchesAndCounter");
  if (!func_InitializeSwitchesAndCounter) {
    func_InitializeSwitchesAndCounter = Function::Create(
        /*Type=*/FuncTy_2,
        /*Linkage=*/GlobalValue::ExternalLinkage,
        /*Name=*/"InitializeSwitchesAndCounter", mod); // (external, no body)
    func_InitializeSwitchesAndCounter->setCallingConv(CallingConv::C);
  }

  AttributeSet func_InitializeSwitchesAndCounter_PAL;
  {
    SmallVector<AttributeSet, 4> Attrs;
    AttributeSet PAS;
    {
      AttrBuilder B;
      PAS = AttributeSet::get(mod->getContext(), ~0U, B);
    }

    Attrs.push_back(PAS);
    func_InitializeSwitchesAndCounter_PAL = AttributeSet::get(mod->getContext(), Attrs);

  }
  func_InitializeSwitchesAndCounter->setAttributes(func_InitializeSwitchesAndCounter_PAL);

  ConstantInt* const_int32_3 = ConstantInt::get(mod->getContext(), APInt(32, initializer, 10));
  CallInst* void_4 = CallInst::Create(func_InitializeSwitchesAndCounter, const_int32_3, "", insertBefore);
  void_4->setCallingConv(CallingConv::C);
  void_4->setTailCall(false);
  AttributeSet void_4_PAL;
  void_4->setAttributes(void_4_PAL);

#else
  // Type Definitions
  std::vector<Type*>FuncTy_0_args;
  FunctionType* FuncTy_0 = FunctionType::get(
      /*Result=*/Type::getVoidTy(mod->getContext()),
      /*Params=*/FuncTy_0_args,
      /*isVarArg=*/false);

  Function* func_Initialization = mod->getFunction("InitializeSwitchesAndCounter");
  if (!func_Initialization) {
    func_Initialization = Function::Create(
        /*Type=*/FuncTy_0,
        /*Linkage=*/GlobalValue::ExternalLinkage,
        /*Name=*/"InitializationSwitchesAndCounter", mod); // (external, no body)
    func_Initialization->setCallingConv(CallingConv::C);
  }
  AttributeSet func_Initialization_PAL;
  {
    SmallVector<AttributeSet, 4> Attrs;
    AttributeSet PAS;
    {
      AttrBuilder B;
      PAS = AttributeSet::get(mod->getContext(), ~0U, B);
    }

    Attrs.push_back(PAS);
    func_Initialization_PAL = AttributeSet::get(mod->getContext(), Attrs);

  }
  func_Initialization->setAttributes(func_Initialization_PAL);

  CallInst* void_2 = CallInst::Create(func_Initialization, "", insertBefore);
  void_2->setCallingConv(CallingConv::C);
  void_2->setTailCall(false);
  AttributeSet void_2_PAL;
  void_2->setAttributes(void_2_PAL);
#endif
}

void insertRecordSyncVariables(Module *mod, Instruction *insertBefore)
{
  // Type Definitions
  std::vector<Type*>FuncTy_0_args;
  FunctionType* FuncTy_0 = FunctionType::get(
      /*Result=*/Type::getVoidTy(mod->getContext()),
      /*Params=*/FuncTy_0_args,
      /*isVarArg=*/false);
  
  Function* func_RecordSyncVariable = mod->getFunction("RecordSyncVariable");
  if (!func_RecordSyncVariable) {
    func_RecordSyncVariable = Function::Create(
        /*Type=*/FuncTy_0,
        /*Linkage=*/GlobalValue::ExternalLinkage,
        /*Name=*/"RecordSyncVariable", mod); // (external, no body)
    func_RecordSyncVariable->setCallingConv(CallingConv::C);
  }
  AttributeSet func_RecordSyncVariable_PAL;
  {
    SmallVector<AttributeSet, 4> Attrs;
    AttributeSet PAS;
    {
      AttrBuilder B;
      PAS = AttributeSet::get(mod->getContext(), ~0U, B);
    }

    Attrs.push_back(PAS);
    func_RecordSyncVariable_PAL = AttributeSet::get(mod->getContext(), Attrs);

  }
  func_RecordSyncVariable->setAttributes(func_RecordSyncVariable_PAL);

  CallInst* void_2 = CallInst::Create(func_RecordSyncVariable, "", insertBefore);
  void_2->setCallingConv(CallingConv::C);
  void_2->setTailCall(false);
  AttributeSet void_2_PAL;
  void_2->setAttributes(void_2_PAL);
}

void insertDeriveInvariant(Module *mod, Instruction *insertBefore)
{
  // Type Definitions
  std::vector<Type*>FuncTy_0_args;
  FunctionType* FuncTy_0 = FunctionType::get(
      /*Result=*/Type::getVoidTy(mod->getContext()),
      /*Params=*/FuncTy_0_args,
      /*isVarArg=*/false);
  
  Function* func_DeriveInvariant = mod->getFunction("DeriveInvariant");
  if (!func_DeriveInvariant) {
    func_DeriveInvariant = Function::Create(
        /*Type=*/FuncTy_0,
        /*Linkage=*/GlobalValue::ExternalLinkage,
        /*Name=*/"DeriveInvariant", mod); // (external, no body)
    func_DeriveInvariant->setCallingConv(CallingConv::C);
  }
  AttributeSet func_DeriveInvariant_PAL;
  {
    SmallVector<AttributeSet, 4> Attrs;
    AttributeSet PAS;
    {
      AttrBuilder B;
      PAS = AttributeSet::get(mod->getContext(), ~0U, B);
    }

    Attrs.push_back(PAS);
    func_DeriveInvariant_PAL = AttributeSet::get(mod->getContext(), Attrs);

  }
  func_DeriveInvariant->setAttributes(func_DeriveInvariant_PAL);

  CallInst* void_2 = CallInst::Create(func_DeriveInvariant, "", insertBefore);
  void_2->setCallingConv(CallingConv::C);
  void_2->setTailCall(false);
  AttributeSet void_2_PAL;
  void_2->setAttributes(void_2_PAL);
}

void insertLoopExit(Module *mod, Instruction *insertBefore, StringRef initializer)
{
  std::vector<Type*>FuncTy_2_args;
  FuncTy_2_args.push_back(IntegerType::get(mod->getContext(), 32));
  FunctionType* FuncTy_2 = FunctionType::get(
      /*Result=*/Type::getVoidTy(mod->getContext()),
      /*Params=*/FuncTy_2_args,
      /*isVarArg=*/false);

  Function* func_loopExit = mod->getFunction("loopExit");
  if (!func_loopExit) {
    func_loopExit = Function::Create(
        /*Type=*/FuncTy_2,
        /*Linkage=*/GlobalValue::ExternalLinkage,
        /*Name=*/"loopExit", mod); // (external, no body)
    func_loopExit->setCallingConv(CallingConv::C);
  }

  AttributeSet func_loopExit_PAL;
  {
    SmallVector<AttributeSet, 4> Attrs;
    AttributeSet PAS;
    {
      AttrBuilder B;
      PAS = AttributeSet::get(mod->getContext(), ~0U, B);
    }

    Attrs.push_back(PAS);
    func_loopExit_PAL = AttributeSet::get(mod->getContext(), Attrs);

  }
  func_loopExit->setAttributes(func_loopExit_PAL);

  ConstantInt* const_int32_3 = ConstantInt::get(mod->getContext(), APInt(32, initializer, 10));
  CallInst* void_4 = CallInst::Create(func_loopExit, const_int32_3, "", insertBefore);
  void_4->setCallingConv(CallingConv::C);
  void_4->setTailCall(false);
  AttributeSet void_4_PAL;
  void_4->setAttributes(void_4_PAL);
}

void insertLoopCurrent(Module *mod, Instruction *insertBefore, StringRef initializer)
{
  std::vector<Type*>FuncTy_2_args;
  FuncTy_2_args.push_back(IntegerType::get(mod->getContext(), 32));
  FunctionType* FuncTy_2 = FunctionType::get(
      /*Result=*/Type::getVoidTy(mod->getContext()),
      /*Params=*/FuncTy_2_args,
      /*isVarArg=*/false);

  Function* func_loopCurrent = mod->getFunction("loopCurrent");
  if (!func_loopCurrent) {
    func_loopCurrent = Function::Create(
        /*Type=*/FuncTy_2,
        /*Linkage=*/GlobalValue::ExternalLinkage,
        /*Name=*/"loopCurrent", mod); // (external, no body)
    func_loopCurrent->setCallingConv(CallingConv::C);
  }

  AttributeSet func_loopCurrent_PAL;
  {
    SmallVector<AttributeSet, 4> Attrs;
    AttributeSet PAS;
    {
      AttrBuilder B;
      PAS = AttributeSet::get(mod->getContext(), ~0U, B);
    }

    Attrs.push_back(PAS);
    func_loopCurrent_PAL = AttributeSet::get(mod->getContext(), Attrs);

  }
  func_loopCurrent->setAttributes(func_loopCurrent_PAL);

  ConstantInt* const_int32_3 = ConstantInt::get(mod->getContext(), APInt(32, initializer, 10));
  CallInst* void_4 = CallInst::Create(func_loopCurrent, const_int32_3, "", insertBefore);
  void_4->setCallingConv(CallingConv::C);
  void_4->setTailCall(false);
  AttributeSet void_4_PAL;
  void_4->setAttributes(void_4_PAL);
}
