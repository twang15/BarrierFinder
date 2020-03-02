//===-- SpecialFunctionHandler.cpp ----------------------------------------===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "Memory.h"
#include "SpecialFunctionHandler.h"
#include "TimingSolver.h"

#include "klee/ExecutionState.h"
#include "klee/util/ExprPPrinter.h"
#include "klee/data/ExprSerializer.h"

#include "klee/Internal/Module/KInstruction.h"
#include "klee/Internal/Module/InstructionInfoTable.h"
#include "klee/Internal/Module/KModule.h"

#include "klee/Executor.h"
#include "MemoryManager.h"

#include "llvm/Module.h"
#include "llvm/ADT/Twine.h"
#include "llvm/Type.h"
#include "llvm/DerivedTypes.h"
#include "llvm/InstrTypes.h"
#include "llvm/LLVMContext.h"
#include "llvm/Support/InstIterator.h"
#include "llvm/Constants.h"

#include <glog/logging.h>

#include <errno.h>
#include <stdarg.h>
#include <sys/syscall.h>

using namespace llvm;
using namespace klee;

/// \todo Almost all of the demands in this file should be replaced
/// with terminateState calls.

///

struct HandlerInfo {
  const char *name;
  SpecialFunctionHandler::Handler handler;
  bool doesNotReturn; /// Intrinsic terminates the process
  bool hasReturnValue; /// Intrinsic has a return value
  bool doNotOverride; /// Intrinsic should not be used if already defined
};

// FIXME: We are more or less committed to requiring an intrinsic
// library these days. We can move some of this stuff there,
// especially things like realloc which have complicated semantics
// w.r.t. forking. Among other things this makes delayed query
// dispatch easier to implement.
HandlerInfo handlerInfo[] = {
#define add(name, handler, ret) { name, \
                                  &SpecialFunctionHandler::handler, \
                                  false, ret, false }
#define addDNR(name, handler) { name, \
                                &SpecialFunctionHandler::handler, \
                                true, false, false }
  addDNR("__assert_rtn", handleAssertFail),
  addDNR("__assert_fail", handleAssertFail),
  addDNR("_assert", handleAssert),
  addDNR("abort", handleAbort),
  addDNR("klee_abort", handleAbort),
  addDNR("klee_silent_exit", handleSilentExit),  
  addDNR("klee_report_error", handleReportError),
  addDNR("klee_thread_terminate", handleThreadTerminate),
  addDNR("klee_process_terminate", handleProcessTerminate),

  add("calloc", handleCalloc, true),
  add("free", handleFree, false),
  add("klee_assume", handleAssume, false),
#if 0
  add("klee_shadow_check", handleShadowCheck, false),
#endif
  add("klee_record_expr", handleRecordExpr, false),
  add("klee_event", handleEvent, false),
  add("klee_check_memory_access", handleCheckMemoryAccess, false),
  add("klee_get_valuef", handleGetValue, true),
  add("klee_get_valued", handleGetValue, true),
  add("klee_get_valuel", handleGetValue, true),
  add("klee_get_valuell", handleGetValue, true),
  add("klee_get_value_i32", handleGetValue, true),
  add("klee_get_value_i64", handleGetValue, true),
  add("klee_define_fixed_object", handleDefineFixedObject, false),
  add("klee_get_obj_size", handleGetObjSize, true),
  add("klee_get_errno", handleGetErrno, true),
  add("klee_is_symbolic", handleIsSymbolic, true),
  add("klee_make_symbolic", handleMakeSymbolic, false),
  add("klee_mark_global", handleMarkGlobal, false),
  add("klee_merge", handleMerge, false),
  add("klee_prefer_cex", handlePreferCex, false),
  add("klee_print_expr", handlePrintExpr, false),
  add("klee_print_range", handlePrintRange, false),
  add("klee_set_forking", handleSetForking, false),
  add("klee_stack_trace", handleStackTrace, false),
  add("klee_make_shared", handleMakeShared, false),
  add("klee_get_context", handleGetContext, false),
  add("klee_get_wlist", handleGetWList, true),
  add("klee_thread_preempt", handleThreadPreempt, false),
  add("klee_thread_sleep", handleThreadSleep, false),
  add("klee_thread_notify", handleThreadNotify, false),
  add("klee_warning", handleWarning, false),
  add("klee_warning_once", handleWarningOnce, false),
  add("klee_alias_function", handleAliasFunction, false),

  add("klee_thread_create", handleThreadCreate, false),
  add("klee_process_fork", handleProcessFork, true),

  add("klee_branch", handleBranch, true),
  add("klee_fork", handleFork, true),

  add("klee_debug", handleDebug, false),

  add("klee_get_time", handleGetTime, true),
  add("klee_set_time", handleSetTime, false),

  add("klee_begin_checked", handleBeginChecked, false),
  add("klee_end_checked", handleEndChecked, false),
  add("klee_memcmp", handleMemCmp, true),

  add("malloc", handleMalloc, true),
  add("realloc", handleRealloc, true),
  add("valloc", handleValloc, true),

  // operator delete[](void*)
  add("_ZdaPv", handleDeleteArray, false),
  // operator delete(void*)
  add("_ZdlPv", handleDelete, false),

  // operator new[](unsigned int)
  add("_Znaj", handleNewArray, true),
  // operator new(unsigned int)
  add("_Znwj", handleNew, true),
  add("_ZnamRKSt9nothrow_t", handleNew, true),

  // FIXME-64: This is wrong for 64-bit long...

  // operator new[](unsigned long)
  add("_Znam", handleNewArray, true),
  // operator new(unsigned long)
  add("_Znwm", handleNew, true),
  add("_ZnwmRKSt9nothrow_t", handleNew, true),

  add("syscall", handleSyscall, true),

  // add by Tao Wang for synCat.
  add("sync_region_end", handleSyncRegionEnd, true),
  add("DeriveInvariant", handleDeriveInvariant, true),
  add("RecordSyncVariable", handleRecordSyncVariable, true),
  add("InitializeSwitchesAndCounter", handleInitializeSwitchesAndCounter, true),
  add("CheckInvariant", handleCheckInvariant, true),
  add("loopCurrent", handleloopCurrent, true)

#undef addDNR
#undef add  
};

SpecialFunctionHandler::SpecialFunctionHandler(Executor &_executor) 
  : executor(_executor) {}


void SpecialFunctionHandler::prepare() {
  unsigned N = sizeof(handlerInfo)/sizeof(handlerInfo[0]);

  for (unsigned i=0; i<N; ++i) {
    HandlerInfo &hi = handlerInfo[i];
    Function *f = executor.kmodule->module->getFunction(hi.name);
    
    // No need to create if the function doesn't exist, since it cannot
    // be called in that case.
  
    if (f && (!hi.doNotOverride || f->isDeclaration())) {
      // Make sure NoReturn attribute is set, for optimization and
      // coverage counting.
      if (hi.doesNotReturn)
        f->addFnAttr(Attribute::NoReturn);

      // Change to a declaration since we handle internally (simplifies
      // module and allows deleting dead code).
      if (!f->isDeclaration())
        f->deleteBody();
    }
  }
}

void SpecialFunctionHandler::bind() {
  unsigned N = sizeof(handlerInfo)/sizeof(handlerInfo[0]);

  for (unsigned i=0; i<N; ++i) {
    HandlerInfo &hi = handlerInfo[i];
    Function *f = executor.kmodule->module->getFunction(hi.name);
    
    if (f && (!hi.doNotOverride || f->isDeclaration()))
      handlers[f] = std::make_pair(hi.handler, hi.hasReturnValue);
  }
}


bool SpecialFunctionHandler::handle(ExecutionState &state, 
                                    Function *f,
                                    KInstruction *target,
                                    std::vector< ref<Expr> > &arguments) {
  handlers_ty::iterator it = handlers.find(f);
  if (it != handlers.end()) {    
    Handler h = it->second.first;
    bool hasReturnValue = it->second.second;
     // FIXME: Check this... add test?
    if (!hasReturnValue && !target->inst->use_empty()) {
      executor.terminateStateOnExecError(state, 
                                         "expected return value from void special function");
    } else {
      (this->*h)(state, target, arguments);
    }
    return true;
  } else {
    return false;
  }
}

void SpecialFunctionHandler::processMemoryLocation(ExecutionState &state,
    ref<Expr> address, ref<Expr> size,
    const std::string &name, resolutions_ty &resList) {
  Executor::ExactResolutionList rl;
  executor.resolveExact(state, address, rl, name);

  for (Executor::ExactResolutionList::iterator it = rl.begin(),
         ie = rl.end(); it != ie; ++it) {
    const MemoryObject *mo = it->first.first;
    const ObjectState *os = it->first.second;
    ExecutionState *s = it->second;

    // FIXME: Type coercion should be done consistently somewhere.
    bool res;
    bool success =
      executor.solver->mustBeTrue(data::OTHER, *s,
                                  EqExpr::create(ZExtExpr::create(size,
                                                                  Context::get().getPointerWidth()),
                                                 mo->getSizeExpr()),
                                  res);
    assert(success && "FIXME: Unhandled solver failure");

    if (res) {
      resList.push_back(std::make_pair(std::make_pair(mo, os), s));
    } else {
      executor.terminateStateOnError(*s,
                                     "wrong size given to memory operation",
                                     "user.err");
    }
  }
}

bool SpecialFunctionHandler::writeConcreteValue(ExecutionState &state,
        ref<Expr> address, uint64_t value, Expr::Width width) {
  ObjectPair op;

  if (!state.addressSpace().resolveOne(cast<ConstantExpr>(address), op)) {
    executor.terminateStateOnError(state, "invalid pointer for writing concrete value into", "user.err");
    return false;
  }

  ObjectState *os = state.addressSpace().getWriteable(op.first, op.second);

  os->write(op.first->getOffsetExpr(address), ConstantExpr::create(value, width));

  return true;
}

/****/

// reads a concrete string from memory
std::string 
SpecialFunctionHandler::readStringAtAddress(ExecutionState &state, 
                                            ref<Expr> addressExpr) {
  ObjectPair op;
  addressExpr = executor.toUnique(state, addressExpr);
  if (!isa<ConstantExpr>(addressExpr))
    return std::string("<KLEE<symaddr>>");

  ref<ConstantExpr> address = cast<ConstantExpr>(addressExpr);
  if (!state.addressSpace().resolveOne(address, op))
    return std::string("<KLEE<multires>>");

  const MemoryObject *mo = op.first;
  const ObjectState *os = op.second;

  char *buf = new char[mo->size];
  unsigned ioffset = 0;

  ref<Expr> offset_expr = SubExpr::create(address, op.first->getBaseExpr());
  if (isa<ConstantExpr>(offset_expr)) {
    ref<ConstantExpr> value = cast<ConstantExpr>(offset_expr.get());
      ioffset = value.get()->getZExtValue();
  } else
    return std::string("<KLEE<invalstring>>");

  assert(ioffset < mo->size);

  unsigned i;
  for (i = 0; i < mo->size - ioffset - 1; i++) {
    ref<Expr> cur = os->read8(i + ioffset);
    cur = executor.toUnique(state, cur);
    if (!isa<ConstantExpr>(cur)) //XXX: Should actually concretize the value...
           return std::string("<KLEE<symchar>>");
    buf[i] = cast<ConstantExpr>(cur)->getZExtValue(8);
  }
  buf[i] = 0;
  
  std::string result(buf);
  delete[] buf;
  return result;
}

/****/

void SpecialFunctionHandler::handleAbort(ExecutionState &state,
                           KInstruction *target,
                           std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==0 && "invalid number of arguments to abort");


  executor.terminateStateOnError(state, "abort failure", "abort.err");
}

void SpecialFunctionHandler::handleSilentExit(ExecutionState &state,
                                              KInstruction *target,
                                              std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 && "invalid number of arguments to exit");

  executor.terminateState(state, true);
}

void SpecialFunctionHandler::handleAliasFunction(ExecutionState &state,
             KInstruction *target,
             std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==2 && 
         "invalid number of arguments to klee_alias_function");
  std::string old_fn = readStringAtAddress(state, arguments[0]);
  std::string new_fn = readStringAtAddress(state, arguments[1]);
  //std::cerr << "Replacing " << old_fn << "() with " << new_fn << "()\n";
  if (old_fn == new_fn)
    state.removeFnAlias(old_fn);
  else state.addFnAlias(old_fn, new_fn);
}

void SpecialFunctionHandler::handleAssert(ExecutionState &state,
                                          KInstruction *target,
                                          std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==3 && "invalid number of arguments to _assert");  
  

  executor.terminateStateOnError(state,
                                 "ASSERTION FAIL: " + readStringAtAddress(state, arguments[0]),
                                 "assert.err");
}

void SpecialFunctionHandler::handleAssertFail(ExecutionState &state,
                                              KInstruction *target,
                                              std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==4 && "invalid number of arguments to __assert_fail");
  

  executor.terminateStateOnError(state,
                                 "ASSERTION FAIL: " + readStringAtAddress(state, arguments[0]),
                                 "assert.err");
}

void SpecialFunctionHandler::handleReportError(ExecutionState &state,
                                               KInstruction *target,
                                               std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==4 && "invalid number of arguments to klee_report_error");
  
  // arguments[0], arguments[1] are file, line
  
  executor.terminateStateOnError(state,
                                 readStringAtAddress(state, arguments[2]),
                                 readStringAtAddress(state, arguments[3]).c_str());
}

void SpecialFunctionHandler::handleMerge(ExecutionState &state,
                           KInstruction *target,
                           std::vector<ref<Expr> > &arguments) {
  // nop
}

void SpecialFunctionHandler::handleNew(ExecutionState &state,
                         KInstruction *target,
                         std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()>=1 && "invalid number of arguments to new");

  executor.executeAlloc(state, arguments[0], false, target);
}

void SpecialFunctionHandler::handleDelete(ExecutionState &state,
                            KInstruction *target,
                            std::vector<ref<Expr> > &arguments) {
  // FIXME: Should check proper pairing with allocation type (malloc/free,
  // new/delete, new[]/delete[]).

  // XXX should type check args
  assert(arguments.size()==1 && "invalid number of arguments to delete");
  executor.executeFree(state, arguments[0]);
}

void SpecialFunctionHandler::handleNewArray(ExecutionState &state,
                              KInstruction *target,
                              std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==1 && "invalid number of arguments to new[]");
  executor.executeAlloc(state, arguments[0], false, target);
}

void SpecialFunctionHandler::handleDeleteArray(ExecutionState &state,
                                 KInstruction *target,
                                 std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==1 && "invalid number of arguments to delete[]");
  executor.executeFree(state, arguments[0]);
}

void SpecialFunctionHandler::handleMalloc(ExecutionState &state,
                                  KInstruction *target,
                                  std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==1 && "invalid number of arguments to malloc");
  executor.executeAlloc(state, arguments[0], false, target);
}


void SpecialFunctionHandler::handleValloc(ExecutionState &state, 
            KInstruction *target, 
            std::vector<ref<Expr> > &arguments) {
  
  // XXX ignoring for now the "multiple of page size " requirement 
  //- executing the regular alloc
  // XXX should type check args
  assert(arguments.size() == 1 && "invalid number of arguments to valloc");
  executor.executeAlloc(state, arguments[0], false, target);
}

void SpecialFunctionHandler::handleAssume(ExecutionState &state,
                            KInstruction *target,
                            std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 && "invalid number of arguments to klee_assume");
  
  ref<Expr> e = arguments[0];
  
  if (e->getWidth() != Expr::Bool)
    e = NeExpr::create(e, ConstantExpr::create(0, e->getWidth()));
  
  bool res;
  bool success = executor.solver->mustBeFalse(data::CHECK_ASSUMPTION, state, e, res);
  assert(success && "FIXME: Unhandled solver failure");
  if (res) {
    executor.terminateStateOnError(state, 
                                   "invalid klee_assume call (provably false)",
                                   "user.err");
  } else {
    executor.addConstraint(state, e);
  }
}

void SpecialFunctionHandler::handleIsSymbolic(ExecutionState &state,
                                KInstruction *target,
                                std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 && "invalid number of arguments to klee_is_symbolic");

  //arguments[0]->print(std::cerr);

  executor.bindLocal(target, state, 
                     ConstantExpr::create(!isa<ConstantExpr>(arguments[0]),
                                          Expr::Int32));
}

void SpecialFunctionHandler::handlePreferCex(ExecutionState &state,
                                             KInstruction *target,
                                             std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==2 &&
         "invalid number of arguments to klee_prefex_cex");

  ref<Expr> cond = arguments[1];
  if (cond->getWidth() != Expr::Bool)
    cond = NeExpr::create(cond, ConstantExpr::alloc(0, cond->getWidth()));

  Executor::ExactResolutionList rl;
  executor.resolveExact(state, arguments[0], rl, "prefex_cex");
  
  assert(rl.size() == 1 &&
         "prefer_cex target must resolve to precisely one object");

  rl[0].first.first->cexPreferences.push_back(cond);
}

void SpecialFunctionHandler::handlePrintExpr(ExecutionState &state,
                                  KInstruction *target,
                                  std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==2 &&
         "invalid number of arguments to klee_print_expr");

  std::string msg_str = readStringAtAddress(state, arguments[0]);
  std::cerr << msg_str << ":" << arguments[1] << std::endl;

  for (ConstraintManager::constraint_iterator it = state.constraints().begin();
      it != state.constraints().end(); it++) {
    std::cerr << *it << std::endl;
  }
}

void SpecialFunctionHandler::handleSetForking(ExecutionState &state,
                                              KInstruction *target,
                                              std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 &&
         "invalid number of arguments to klee_set_forking");
  ref<Expr> value = executor.toUnique(state, arguments[0]);
  
  if (ConstantExpr *CE = dyn_cast<ConstantExpr>(value)) {
    state.forkDisabled = CE->isZero();
  } else {
    executor.terminateStateOnError(state, 
                                   "klee_set_forking requires a constant arg",
                                   "user.err");
  }
}

void SpecialFunctionHandler::handleStackTrace(ExecutionState &state,
                                              KInstruction *target,
                                              std::vector<ref<Expr> > &arguments) {
  state.getStackTrace().dump(std::cout);
}

void SpecialFunctionHandler::handleWarning(ExecutionState &state,
                                           KInstruction *target,
                                           std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 && "invalid number of arguments to klee_warning");

  std::string msg_str = readStringAtAddress(state, arguments[0]);
  LOG(WARNING) << state.stack().back().kf->function->getName().data() << ": " <<
               msg_str.c_str();
}

void SpecialFunctionHandler::handleDebug(ExecutionState &state,
                                           KInstruction *target,
                                           std::vector<ref<Expr> > &arguments) {
  assert(arguments.size() >= 1 && "invalid number of arguments to klee_debug");

  std::string formatStr = readStringAtAddress(state, arguments[0]);

  // XXX Ugly hack, need to use libffi here... Ashamed of myself

  if (arguments.size() == 2 && arguments[1]->getWidth() == sizeof(long)*8) {
    // Special case for displaying strings

    std::string paramStr = readStringAtAddress(state, arguments[1]);

    fprintf(stderr, formatStr.c_str(), paramStr.c_str());
    return;
  }

  std::vector<int> args;

  for (unsigned int i = 1; i < arguments.size(); i++) {
    if (!isa<ConstantExpr>(arguments[i])) {
      fprintf(stderr, "%s: %s\n", formatStr.c_str(), "<nonconst args>");
      return;
    }

    ref<ConstantExpr> arg = cast<ConstantExpr>(arguments[i]);

    if (arg->getWidth() != sizeof(int)*8) {
      fprintf(stderr, "%s: %s\n", formatStr.c_str(), "<non-32-bit args>");
      return;
    }

    args.push_back((int)arg->getZExtValue());
  }

  switch (args.size()) {
  case 0:
    fprintf(stderr, "%s", formatStr.c_str());
    break;
  case 1:
    fprintf(stderr, formatStr.c_str(), args[0]);
    break;
  case 2:
    fprintf(stderr, formatStr.c_str(), args[0], args[1]);
    break;
  case 3:
    fprintf(stderr, formatStr.c_str(), args[0], args[1], args[2]);
    break;
  default:
    executor.terminateStateOnError(state, "klee_debug allows up to 3 arguments", "user.err");
    return;
  }
}

void SpecialFunctionHandler::handleWarningOnce(ExecutionState &state,
                                               KInstruction *target,
                                               std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 &&
         "invalid number of arguments to klee_warning_once");

  std::string msg_str = readStringAtAddress(state, arguments[0]);
  LOG_EVERY_N(WARNING, 1)
      << state.stack().back().kf->function->getName().data() << ": "
      << msg_str.c_str();
}

void SpecialFunctionHandler::handlePrintRange(ExecutionState &state,
                                  KInstruction *target,
                                  std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==2 &&
         "invalid number of arguments to klee_print_range");

  std::string msg_str = readStringAtAddress(state, arguments[0]);
  std::cerr << msg_str << ":" << arguments[1];
  if (!isa<ConstantExpr>(arguments[1])) {
    // FIXME: Pull into a unique value method?
    ref<ConstantExpr> value;
    bool success = executor.solver->getValue(data::OTHER, state, arguments[1], value);
    assert(success && "FIXME: Unhandled solver failure");
    bool res;
    success = executor.solver->mustBeTrue(data::OTHER, state,
                                          EqExpr::create(arguments[1], value), 
                                          res);
    assert(success && "FIXME: Unhandled solver failure");
    if (res) {
      std::cerr << " == " << value;
    } else { 
      std::cerr << " ~= " << value;
      std::pair< ref<Expr>, ref<Expr> > res =
        executor.solver->getRange(data::OTHER, state, arguments[1]);
      std::cerr << " (in [" << res.first << ", " << res.second <<"])";
    }
  }
  std::cerr << "\n";
}

void SpecialFunctionHandler::handleGetObjSize(ExecutionState &state,
                                  KInstruction *target,
                                  std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==1 &&
         "invalid number of arguments to klee_get_obj_size");
  Executor::ExactResolutionList rl;
  executor.resolveExact(state, arguments[0], rl, "klee_get_obj_size");
  for (Executor::ExactResolutionList::iterator it = rl.begin(), 
         ie = rl.end(); it != ie; ++it) {
    executor.bindLocal(target, *it->second, 
                       ConstantExpr::create(it->first.first->size, Expr::Int32));
  }
}

void SpecialFunctionHandler::handleGetErrno(ExecutionState &state,
                                            KInstruction *target,
                                            std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==0 &&
         "invalid number of arguments to klee_get_obj_size");
  executor.bindLocal(target, state,
                     ConstantExpr::create(errno, Expr::Int32));
}

void SpecialFunctionHandler::handleCalloc(ExecutionState &state,
                            KInstruction *target,
                            std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==2 &&
         "invalid number of arguments to calloc");

  ref<Expr> size = MulExpr::create(arguments[0],
                                   arguments[1]);
  executor.executeAlloc(state, size, false, target, true);
}

void SpecialFunctionHandler::handleRealloc(ExecutionState &state,
                            KInstruction *target,
                            std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==2 &&
         "invalid number of arguments to realloc");
  ref<Expr> address = arguments[0];
  ref<Expr> size = arguments[1];

  Executor::StatePair zeroSize = executor.fork(state, 
                                               Expr::createIsZero(size), 
                                               true, KLEE_FORK_INTERNAL);
  
  if (zeroSize.first) { // size == 0
    executor.executeFree(*zeroSize.first, address, target);   
  }
  if (zeroSize.second) { // size != 0
    Executor::StatePair zeroPointer = executor.fork(*zeroSize.second, 
                                                    Expr::createIsZero(address), 
                                                    true, KLEE_FORK_INTERNAL);
    
    if (zeroPointer.first) { // address == 0
      executor.executeAlloc(*zeroPointer.first, size, false, target);
    } 
    if (zeroPointer.second) { // address != 0
      Executor::ExactResolutionList rl;
      executor.resolveExact(*zeroPointer.second, address, rl, "realloc");
      
      for (Executor::ExactResolutionList::iterator it = rl.begin(), 
             ie = rl.end(); it != ie; ++it) {
        executor.executeAlloc(*it->second, size, false, target, false, 
                              it->first.second);
      }
    }
  }
}

void SpecialFunctionHandler::handleFree(ExecutionState &state,
                          KInstruction *target,
                          std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==1 &&
         "invalid number of arguments to free");
  executor.executeFree(state, arguments[0]);
}

void SpecialFunctionHandler::handleMakeShared(ExecutionState &state,
                          KInstruction *target,
                          std::vector<ref<Expr> > &arguments) {

  assert(arguments.size() == 2 &&
        "invalid number of arguments to klee_make_shared");

  resolutions_ty resList;

  processMemoryLocation(state, arguments[0], arguments[1], "make_shared", resList);

  for (resolutions_ty::iterator it = resList.begin(); it != resList.end();
      it++) {
    const MemoryObject *mo = it->first.first;
    const ObjectState *os = it->first.second;
    ExecutionState *s = it->second;

    if (mo->isLocal) {
      executor.terminateStateOnError(*s,
                                     "cannot share local object",
                                     "user.err");
      continue;
    }

    unsigned int bindCount = 0;
    for (ExecutionState::processes_ty::iterator pit = s->processes.begin();
        pit != s->processes.end(); pit++) {
      if (pit->second.addressSpace.findObject(mo) != NULL)
        bindCount++;
    }

    if (bindCount != 1) {
      executor.terminateStateOnError(*s, "cannot shared already forked object",
           "user.err");
      continue;
    }

    ObjectState *newOS = state.addressSpace().getWriteable(mo, os);
    newOS->isShared = true;

    // Now bind this object in the other address spaces
    for (ExecutionState::processes_ty::iterator pit = s->processes.begin();
        pit != s->processes.end(); pit++) {
      if (pit == s->crtProcessIt)
        continue; // Skip the current process

      pit->second.addressSpace.bindSharedObject(mo, newOS);
    }
  }
}

void SpecialFunctionHandler::handleGetContext(ExecutionState &state,
                          KInstruction *target,
                          std::vector<ref<Expr> > &arguments) {
  assert(arguments.size() == 2 &&
      "invalid number of arguments to klee_get_context");

  ref<Expr> tidAddr = executor.toUnique(state, arguments[0]);
  ref<Expr> pidAddr = executor.toUnique(state, arguments[1]);

  if (!isa<ConstantExpr>(tidAddr) || !isa<ConstantExpr>(pidAddr)) {
    executor.terminateStateOnError(state,
                                   "klee_get_context requires constant args",
                                   "user.err");
    return;
  }

  if (!tidAddr->isZero()) {
    if (!writeConcreteValue(state, tidAddr, state.crtThread().getTid(),
        executor.getWidthForLLVMType(Type::getInt64Ty(getGlobalContext()))))
      return;
  }

  if (!pidAddr->isZero()) {
    if (!writeConcreteValue(state, pidAddr, state.crtProcess().pid,
        executor.getWidthForLLVMType(Type::getInt32Ty(getGlobalContext()))))
      return;
  }
}

void SpecialFunctionHandler::handleGetTime(ExecutionState &state,
                    KInstruction *target,
                    std::vector<ref<Expr> > &arguments) {
  assert(arguments.empty() && "invalid number of arguments to klee_get_time");

  executor.bindLocal(target, state, ConstantExpr::create(state.stateTime,
      executor.getWidthForLLVMType(target->inst->getType())));
}

void SpecialFunctionHandler::handleSetTime(ExecutionState &state,
                    KInstruction *target,
                    std::vector<ref<Expr> > &arguments) {
  assert(arguments.size() == 1 && "invalid number of arguments to klee_set_time");

  if (!isa<ConstantExpr>(arguments[0])) {
    executor.terminateStateOnError(state, "klee_set_time requires a constant argument", "user.err");
    return;
  }

  state.stateTime = cast<ConstantExpr>(arguments[0])->getZExtValue();
}

void SpecialFunctionHandler::handleGetWList(ExecutionState &state,
                    KInstruction *target,
                    std::vector<ref<Expr> > &arguments) {
  assert(arguments.empty() && "invalid number of arguments to klee_get_wlist");

  wlist_id_t id = state.getWaitingList();

  executor.bindLocal(target, state, ConstantExpr::create(id,
      executor.getWidthForLLVMType(target->inst->getType())));
}

void SpecialFunctionHandler::handleThreadPreempt(ExecutionState &state,
                    KInstruction *target,
                    std::vector<ref<Expr> > &arguments) {
  assert(arguments.size() == 1 && "invalid number of arguments to klee_thread_preempt");

  if (!isa<ConstantExpr>(arguments[0])) {
    executor.terminateStateOnError(state, "klee_thread_preempt", "user.err");
  }
#if 0
  executor.schedule(state, !arguments[0]->isZero());
#else
  executor.schedule(state, !arguments[0]->isZero(), (schedule_point_type)((klee::ConstantExpr *)arguments[0].get())->getSExtValue());
#endif
}

void SpecialFunctionHandler::handleThreadSleep(ExecutionState &state,
                    KInstruction *target,
                    std::vector<ref<Expr> > &arguments) {

  assert(arguments.size() == 1 && "invalid number of arguments to klee_thread_sleep");

  ref<Expr> wlistExpr = executor.toUnique(state, arguments[0]);

  if (!isa<ConstantExpr>(wlistExpr)) {
    executor.terminateStateOnError(state, "klee_thread_sleep", "user.err");
    return;
  }

  //The current pthread_join(0, 0)'s semantics is different from POSIX standard.
  //In the stand, pthread_join is a blocking call; but in our case, it is not.
  if(state.isCurrentThreadEnabled())
  {
    state.sleepThread(cast<ConstantExpr>(wlistExpr)->getZExtValue());
    executor.schedule(state, false);
  }
}

/*
 * Add by Tao for SynCat. Marking the boundary between adjacent ad hoc syncs.
 *
 * */
void SpecialFunctionHandler::handleSyncRegionEnd(ExecutionState &state,
                      KInstruction *target,
                      std::vector<ref<Expr> > &arguments)
{
  assert(arguments.size() == 0 && "invalid number of arguments to sync_region_end");
  executor.schedule(state, true, SYNC_REGION_END);
}

/*
 * Added by Tao for SynCat.
 * Derive the invariant for current ExecutionState.
 * */
void SpecialFunctionHandler::handleDeriveInvariant(ExecutionState &state,
                      KInstruction *target,
                      std::vector<ref<Expr> > &arguments)
{
  int *gSyncVar0 = NULL;
  int *gSyncVar1 = NULL;
  int *gSyncVar2 = NULL;
  int *gSyncVar3 = NULL;
  AddressSpace &addressSpace = state.addressSpace();
  assert(arguments.size() == 0 && "invalid number of arguments to sync_region_end");
  //executor.schedule(state, true, SYNC_REGION_END);
  
  //Extract the invariants from the snapshots.
  Invariant invariant;
  StringRef gSyncVarsTotalNum = __G_SYNCVAR_TOTAL_NUM__;
  unsigned int *totalValid = (unsigned int*)addressSpace.findGlobalVariable(gSyncVarsTotalNum);
  if(state.executor->getTotalValid() == 0xDEADBEEF)
  {
    //first time: record
    state.executor->setTotalValid(*totalValid);
  }
  else
  {
    //other time: check
    assert(*totalValid == state.executor->getTotalValid() && 
        "For one sync, there should always the same number of sync vars.\n");
  }
 
  //really ugly code. what else ?
  if(*totalValid == 1)
  {
    StringRef gSyncVarName0 = __G_SYNCVAR_0__;
    gSyncVar0 = (int*)addressSpace.findGlobalVariable(gSyncVarName0);
    invariant.gSyncVar_0 = *gSyncVar0;
  }
  else if(*totalValid == 2)
  {
    StringRef gSyncVarName0 = __G_SYNCVAR_0__;
    StringRef gSyncVarName1 = __G_SYNCVAR_1__;
    gSyncVar0 = (int*)addressSpace.findGlobalVariable(gSyncVarName0);
    gSyncVar1 = (int*)addressSpace.findGlobalVariable(gSyncVarName1);

    invariant.gSyncVar_0 = *gSyncVar0;
    invariant.gSyncVar_1 = *gSyncVar1;
  }
  else if(*totalValid == 3)
  {
    StringRef gSyncVarName0 = __G_SYNCVAR_0__;
    StringRef gSyncVarName1 = __G_SYNCVAR_1__;
    StringRef gSyncVarName2 = __G_SYNCVAR_2__;
    gSyncVar0 = (int*)addressSpace.findGlobalVariable(gSyncVarName0);
    gSyncVar1 = (int*)addressSpace.findGlobalVariable(gSyncVarName1);
    gSyncVar2 = (int*)addressSpace.findGlobalVariable(gSyncVarName2);
    
    invariant.gSyncVar_0 = *gSyncVar0;
    invariant.gSyncVar_1 = *gSyncVar1;
    invariant.gSyncVar_2 = *gSyncVar2;
  }
  else if(*totalValid == 4)
  {
    StringRef gSyncVarName0 = __G_SYNCVAR_0__;
    StringRef gSyncVarName1 = __G_SYNCVAR_1__;
    StringRef gSyncVarName2 = __G_SYNCVAR_2__;
    StringRef gSyncVarName3 = __G_SYNCVAR_3__;
    gSyncVar0 = (int*)addressSpace.findGlobalVariable(gSyncVarName0);
    gSyncVar1 = (int*)addressSpace.findGlobalVariable(gSyncVarName1);
    gSyncVar2 = (int*)addressSpace.findGlobalVariable(gSyncVarName2);
    gSyncVar3 = (int*)addressSpace.findGlobalVariable(gSyncVarName3);
    
    invariant.gSyncVar_0 = *gSyncVar0;
    invariant.gSyncVar_1 = *gSyncVar1;
    invariant.gSyncVar_2 = *gSyncVar2;
    invariant.gSyncVar_3 = *gSyncVar3;
  }
  else
  {
    assert(0 && "Unsupported number of sync Varialbes.\n");
  }

  invariant.state = &state;

  //find the extracted invariant.
  //the update steps are contained in findInvariant.
  state.executor->findInvariant(invariant);
}

/*
 * Added by Tao for SynCat.
 * Notify Cloud9 to record address and value for the very next store instruction.
 * */
void SpecialFunctionHandler::handleRecordSyncVariable(ExecutionState &state,
                      KInstruction *target,
                      std::vector<ref<Expr> > &arguments)
{
  assert(arguments.size() == 0 && "invalid number of arguments to RecordSyncVariable");
  state.bRecording = true;
}

/*
 * Added by Tao for SynCat.
 * Extract thread-specific sync region ID.
 * */
void SpecialFunctionHandler::handleInitializeSwitchesAndCounter(ExecutionState &state,
                                                                KInstruction *target,
                                                                std::vector<ref<Expr> > &arguments)
{
  assert(arguments.size() == 1 && "invalid number of arguments to RecordSyncVariable");
  
  //Extract and save thread-specific sync region ID: different threads may be
  //at different sync region at the same time point.
  ref<Expr> syncRegionID = executor.toUnique(state, arguments[0]);
  ConstantExpr *CE = dyn_cast<ConstantExpr>(syncRegionID);
  state.crtThread().setSyncRegionID(CE->getSExtValue());
  state.currentSyncRegionID = CE->getSExtValue();
  state.bRecording = false;

  //Record <syncRegionID, executionContext, ExecutionState*> if it is the first time
  //to explore this sync region. Otherwise, Record <syncRegionID, executionContext, 
  //ExecutionState*, sync var initial values> if it cannot be found in global cache.
}

BasicBlock *SpecialFunctionHandler::findLoopExitBlock(Function *F, int loopID)
{
  for (inst_iterator I = inst_begin(F), E = inst_end(F); I != E; ++I)
  {
    if(CallInst *call = dyn_cast<CallInst>(&*I))
    {
      if(call->getCalledFunction()->getName() == "loopExit")
      {
        ConstantInt *constID = dyn_cast<ConstantInt>(call->getOperand(0));
        int exitLoopID = constID->getSExtValue();
        if(exitLoopID == loopID)
        {
          return call->getParent();
        }
      }
    }
  }

  return NULL;
}

bool SpecialFunctionHandler::isBasicBlockInLoop(BasicBlock *bb)
{
  for(BasicBlock::iterator I=bb->begin(), E=bb->end(); I != E; ++I)
  {
    if(CallInst *call = dyn_cast<CallInst>(&*I))
    {
      if(call->getCalledFunction()->getName() == "loopCurrent")
      {
        return true;
      }
    }
  }

  return false;
}

bool SpecialFunctionHandler::isRegionInLoop(ExecutionContext &context)
{
  return isBasicBlockInLoop(context.curCallStack[1].second->inst->getParent());
}

void SpecialFunctionHandler::earlyTerminateFixedPointLoop(BasicBlock *loopExitBlock, 
    BasicBlock *currentBlock, 
    ExecutionState &state,
    Executor* executor)
{
  for(ExecutionState::threads_ty::iterator it = state.threads.begin();
      it != state.threads.end();  it++)
  {
    if(&(state.crtThread()) == &(it->second))
    {
      //Pop 1 stack frame
      state.popFrame(); //equivalent to state.popFrame(it->second);

      // Handle current thread: control transfer to the found loop exit block.
      executor->transferToBasicBlock(loopExitBlock, currentBlock, state);
    }
    else
    {
      //all the others threads must be in a schedule point.
      //The stack configuration is as followings:
      //#0 __thread_preempt** void
      //#1 mySleep void
      //#2 sleep int
      //#3 lu or other function in a benchmark.

      //klee::StatsTracker *statsTracker = executor->getStatsTracker();
      //Pop 3 times
      
      //Pop __thread_preempt
      state.popFrame(it->second);
      //if (statsTracker)
      //  statsTracker->framePopped(state);

      //pop mySleep
      state.popFrame(it->second);
      //if (statsTracker)
      //  statsTracker->framePopped(state);

      //Pop sleep
      KInstIterator kcaller = it->second.getStack().back().caller;
      state.popFrame(it->second);
      //if (statsTracker)
      //  statsTracker->framePopped(state);

      //control transfer to loopExitBlock.
      Instruction *inst = &(*(kcaller)->inst);
      BasicBlock *currentBlock = inst->getParent();
      KFunction *kf = it->second.getStack().back().kf;
      unsigned entry = kf->basicBlockEntry[loopExitBlock];
      it->second.setPC(&kf->instructions[entry]);
      
      if (kf->instructions[entry]->inst->getOpcode() == Instruction::PHI) {
        PHINode *first = static_cast<PHINode*>(kf->instructions[entry]->inst);
        it->second.setIncomingBBIndex(first->getBasicBlockIndex(currentBlock));
      }
    }    
  }

}

/*
 * Added by Tao for SynCat.
 * Check whether the current ExecutionState has been seen before.
 * If not, record it. 
 * Note: first iteration seeing is handled different from later iterations.
 * */
void SpecialFunctionHandler::handleCheckInvariant(ExecutionState &state,
                                                                KInstruction *target,
                                                                std::vector<ref<Expr> > &arguments)
{
  assert(arguments.size() == 0 && "invalid number of arguments to RecordSyncVariable");
  
  //Record <syncRegionID, executionContext, ExecutionState*> if it is the first time
  //to explore this sync region. Otherwise, Record <syncRegionID, executionContext, 
  //ExecutionState*, sync var initial values> if it cannot be found in global cache.
  int syncRegionID = state.crtThread().getSyncRegionID();
  Executor* executor = state.executor;

  //Only for debugging.
  if(arguments.size() > 10)
  {
    executor->DumpStates();
  }

  //bFirstTime should be part of an ExecutionState, because multiple ExecutionState can co-exist
  //in a sync region simultaneously and should not have interference with each other.
  //
  //In later iterations, although a state may have not been seen before,
  //the sync region must have already been explore in the 1st iteration,
  //at this time, bFirstTime is true, but it should be false.
  //How to handle this ?
  bool bFirstTime = executor->isRegionFirstTimeExplored(syncRegionID);

  //This state has executed CheckInvariant.
  state.bRoot = false;

  //Check whether it has been seen before or not with equivalent context and sync variable
  //initial values.
  
  //The region has not been explored before.
  if(state.bInvariantState && bFirstTime)
  {
    //Record ExecutionContext and sync var address separately.
    //Extract ExecutionContext for current state.
    ExecutionContext context = state.getExecutionContext();
    state.bFirstTimeExplored = true;

    //Record ExecutionContext within the current ExecutionState.
    //state.executionContext = context;
    SyncRecord syncRecord;
    syncRecord.state = &state;
    syncRecord.syncRegionID = syncRegionID;
    syncRecord.bKilled = false;
    syncRecord.executionContext = context;
    syncRecord.bDone = false;
    executor->RecordSync(&state, syncRecord);

    //After recording executionContext for the current ExecutionState, set its bInvariantState to
    //false to avoid recording new executionContext before all thread exit the current region. Then,
    //the timing to put the complete record to global cache is 'before the state is killed due to not
    //being an invariant state (in the state enumerating sense).' But, this will incur other changes to
    //the current design, i.e., make sync var addr/value record as ExecutionState-specific field.
    //Instead, we stick to current design and incrementally update the record. In addition, setting
    //bInvariantState to false is beneficial, because there will be no recording for states that
    //are killed due to interleaving reduction.
    state.bInvariantState = false;
    state.bDirectDescendent = false;
  }
  else if(state.bInvariantState && !bFirstTime)
  {
    //check whether <SyncRegionID, ExecutionContext, sync var initial values> has 
    //been explored before. If not explored, record it. Otherwise, set its bEnumerating
    //to false.
    bool earlyTerminated = false;
    ExecutionContext context = state.getExecutionContext();
    SyncRecord syncRecord;
    syncRecord.state = &state;
    syncRecord.syncRegionID = syncRegionID;
    syncRecord.executionContext = context;
    syncRecord.bDone = true;
    syncRecord.bKilled = false;
    executor->FillValuesToSyncRecord(syncRecord);

    //If the current syncRecord is a fixed point which has been explored 
    //with exactly the same execution context and sync variable initial values,
    //disable state's interleaving enumeration.
    if(executor->isAFixedPoint(syncRecord))
    {
      state.bEnumerating = false;
      state.bDumpTrace = false;
#if 1   
      //record the sync region ID when it is the first one to reach fixed-point.
      if(executor->firstRegionReachFixedPoint == -1 
        || executor->allRegionReachFixedPoint == false)
      {
        if(isRegionInLoop(context))
        {
          //this is the first region reaching its fixed point.
          executor->firstRegionReachFixedPoint = syncRegionID;
          executor->allRegionReachFixedPoint = true;
        }
      }
      else if(executor->firstRegionReachFixedPoint == syncRegionID
          && executor->allRegionReachFixedPoint)
      {
        //firstRegionReachFixedPoint equals to the first sync region which reaches its
        //fixed-point and allRegionReachFixedPoint is true.
        
        //Time to do early-termination fixed point. All sync region experienced in the
        //last iteration reach their fixed point.
        //Steps:
        //1. find the corresponding loop exit block.
        int loopID = state.crtThread().getCurrentLoopID();
        Function * F = context.curCallStack[1].first->function;
        BasicBlock *currentBlock = context.curCallStack[1].second->inst->getParent();
        BasicBlock *loopExitBlock = findLoopExitBlock(F, loopID);

        //2. control transfer to the found loop exit block.
#if 1
#define __EARLY_TERMINATION__
#ifdef __EARLY_TERMINATION__        
        earlyTerminateFixedPointLoop(loopExitBlock, currentBlock, state, executor);
        earlyTerminated = true;
#endif
#endif
      }
#endif      
      //Early termination of a fixed point.
      if(executor->getSizeOfStates() > 1)
      {
        executor->terminateStateOnError(state, 
            "killed due to being a fixed point.",
            "syncat.fixed.point");

        return;
      }
    }
    else
    {
      //Otherwise, insert syncRecord into global cache.
      executor->InsertSyncRecord(syncRecord);

      if(executor->allRegionReachFixedPoint)
        executor->allRegionReachFixedPoint = false;
    }

    if(!earlyTerminated)
    {
      state.bInvariantState = false;
      state.bDirectDescendent = false;
    }
    else
    {
      state.bInvariantState = true;
      state.bFirstTimeExplored = false;
      state.bDirectDescendent = true;
      state.bOutSideSyncRegion = false;
      state.bDumpTrace = true;
      state.bEnumerating = true;
      earlyTerminated = false;
    }
  }
}

void SpecialFunctionHandler::handleloopCurrent(ExecutionState &state, KInstruction *target, 
                                               std::vector<ref<Expr> > &arguments)
{
  assert(arguments.size() == 1 && "invalid number of arguments to loopCurrent.");
  ref<Expr> loopID = executor.toUnique(state, arguments[0]);

  ConstantExpr * CE = dyn_cast<ConstantExpr>(loopID);
  state.crtThread().setCurrentLoopID(CE->getSExtValue());
}

void SpecialFunctionHandler::handleThreadNotify(ExecutionState &state,
                    KInstruction *target,
                    std::vector<ref<Expr> > &arguments) {
  assert(arguments.size() == 2 && "invalid number of arguments to klee_thread_notify");

  ref<Expr> wlist = executor.toUnique(state, arguments[0]);
  ref<Expr> all = executor.toUnique(state, arguments[1]);

  if (!isa<ConstantExpr>(wlist) || !isa<ConstantExpr>(all)) {
    executor.terminateStateOnError(state, "klee_thread_notify", "user.err");
    return;
  }

  if (all->isZero()) {
    executor.executeThreadNotifyOne(state, cast<ConstantExpr>(wlist)->getZExtValue());
  } else {
    // It's simple enough such that it can be handled by the state class itself
    state.notifyAll(cast<ConstantExpr>(wlist)->getZExtValue(), cast<ConstantExpr>(all)->getZExtValue());
  }
}

void SpecialFunctionHandler::handleThreadCreate(ExecutionState &state,
                    KInstruction *target,
                    std::vector<ref<Expr> > &arguments) {
  assert(arguments.size() == 3 && "invalid number of arguments to klee_thread_create");

  ref<Expr> tid = executor.toUnique(state, arguments[0]);

  if (!isa<ConstantExpr>(tid)) {
    executor.terminateStateOnError(state, "klee_thread_create", "user.err");
    return;
  }

  executor.executeThreadCreate(state, cast<ConstantExpr>(tid)->getZExtValue(),
      arguments[1], arguments[2]);
}

void SpecialFunctionHandler::handleThreadTerminate(ExecutionState &state,
                    KInstruction *target,
                    std::vector<ref<Expr> > &arguments) {
  assert(arguments.empty() && "invalid number of arguments to klee_thread_terminate");

  executor.executeThreadExit(state);
}

void SpecialFunctionHandler::handleBranch(ExecutionState &state,
                    KInstruction *target,
                    std::vector<ref<Expr> > &arguments) {
  assert(arguments.size() == 2 && "invalid number of arguments to klee_branch");

  if (!isa<ConstantExpr>(arguments[1])) {
    executor.terminateStateOnError(state, "symbolic reason in klee_branch", "user.err");
    return;
  }

  // We must check that klee_branch is correctly used - the use case of the
  // return value must be a comparison instruction
  Instruction *inst = target->inst;

  if (!inst->hasOneUse()) {
    executor.terminateStateOnError(state, "klee_branch must be used once", "user.err");
    return;
  }

  User *user = *inst->use_begin();

  if (!isa<CmpInst>(user) || inst->getParent() != cast<Instruction>(user)->getParent()) {
    executor.terminateStateOnError(state, "klee_branch must be used together with a comparison", "user.err");
    return;
  }

  // We just bind the result to the first argument, and mark the reason

  state.crtForkReason = cast<ConstantExpr>(arguments[1])->getZExtValue();
  state.crtSpecialFork = cast<Instruction>(user);

  executor.bindLocal(target, state, arguments[0]);
}

void SpecialFunctionHandler::handleFork(ExecutionState &state,
                    KInstruction *target,
                    std::vector<ref<Expr> > &arguments) {
  assert(arguments.size() == 1 && "invalid number of arguments to klee_fork");

  if (!isa<ConstantExpr>(arguments[0])) {
    executor.terminateStateOnError(state, "symbolic reason in klee_fork", "user.err");
    return;
  }

  uint64_t reason = cast<ConstantExpr>(arguments[0])->getZExtValue();

  executor.executeFork(state, target, reason);
}

void SpecialFunctionHandler::handleProcessFork(ExecutionState &state,
                    KInstruction *target,
                    std::vector<ref<Expr> > &arguments) {
  assert(arguments.size() == 1 && "invalid number of arguments to klee_process_fork");

  ref<Expr> pid = executor.toUnique(state, arguments[0]);

  if (!isa<ConstantExpr>(pid)) {
    executor.terminateStateOnError(state, "klee_process_fork", "user.err");
    return;
  }

  executor.executeProcessFork(state, target,
      cast<ConstantExpr>(pid)->getZExtValue());
}

void SpecialFunctionHandler::handleProcessTerminate(ExecutionState &state,
                    KInstruction *target,
                    std::vector<ref<Expr> > &arguments) {
  assert(arguments.empty() && "invalid number of arguments to klee_process_terminate");

  executor.executeProcessExit(state);
}



void SpecialFunctionHandler::handleCheckMemoryAccess(ExecutionState &state,
                                                     KInstruction *target,
                                                     std::vector<ref<Expr> > 
                                                       &arguments) {
  assert(arguments.size()==2 &&
         "invalid number of arguments to klee_check_memory_access");

  ref<Expr> address = executor.toUnique(state, arguments[0]);
  ref<Expr> size = executor.toUnique(state, arguments[1]);
  if (!isa<ConstantExpr>(address) || !isa<ConstantExpr>(size)) {
    executor.terminateStateOnError(state, 
                                   "check_memory_access requires constant args",
                                   "user.err");
  } else {
    ObjectPair op;

    if (!state.addressSpace().resolveOne(cast<ConstantExpr>(address), op)) {
      executor.terminateStateOnError(state,
                                     "check_memory_access: memory error",
                                     "ptr.err",
                                     executor.getAddressInfo(state, address));
    } else {
      ref<Expr> chk = 
        op.first->getBoundsCheckPointer(address, 
                                        cast<ConstantExpr>(size)->getZExtValue());
      if (!chk->isTrue()) {
        executor.terminateStateOnError(state,
                                       "check_memory_access: memory error",
                                       "ptr.err",
                                       executor.getAddressInfo(state, address));
      }
    }
  }
}

void SpecialFunctionHandler::handleGetValue(ExecutionState &state,
                                            KInstruction *target,
                                            std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 &&
         "invalid number of arguments to klee_get_value");

  executor.executeGetValue(state, arguments[0], target);
}

void SpecialFunctionHandler::handleDefineFixedObject(ExecutionState &state,
                                                     KInstruction *target,
                                                     std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==2 &&
         "invalid number of arguments to klee_define_fixed_object");
  assert(isa<ConstantExpr>(arguments[0]) &&
         "expect constant address argument to klee_define_fixed_object");
  assert(isa<ConstantExpr>(arguments[1]) &&
         "expect constant size argument to klee_define_fixed_object");
  
  uint64_t address = cast<ConstantExpr>(arguments[0])->getZExtValue();
  uint64_t size = cast<ConstantExpr>(arguments[1])->getZExtValue();
  MemoryObject *mo = executor.memory->allocateFixed(address, size, state.prevPC()->inst);
  executor.bindObjectInState(state, mo, false);
  mo->isUserSpecified = true; // XXX hack;
}

void SpecialFunctionHandler::makeSymbolic(ExecutionState &state,
    std::vector<ref<Expr> > &arguments) {
  std::string name;

  // FIXME: For backwards compatibility, we should eventually enforce the
  // correct arguments.
  if (arguments.size() == 2) {
    name = "unnamed";
  } else {
    // FIXME: Should be a user.err, not an assert.
    assert(arguments.size()==3 &&
           "invalid number of arguments to klee_make_symbolic");
    name = readStringAtAddress(state, arguments[2]);
  }

  resolutions_ty resList;

  processMemoryLocation(state, arguments[0], arguments[1],
      "make_symbolic", resList);

  for (resolutions_ty::iterator it = resList.begin(); it != resList.end();
      it++) {
    const MemoryObject *mo = it->first.first;
    const ObjectState *os = it->first.second;
    ExecutionState *s = it->second;

    mo->setName(name);

    if (os->readOnly) {
      executor.terminateStateOnError(*s,
                                     "cannot make readonly object symbolic",
                                     "user.err");
    } else {
      executor.executeMakeSymbolic(*s, mo, os->isShared);
    }
  }
}

void SpecialFunctionHandler::handleMakeSymbolic(ExecutionState &state,
                                                KInstruction *target,
                                                std::vector<ref<Expr> > &arguments) {
  makeSymbolic(state, arguments);
}

void SpecialFunctionHandler::handleEvent(ExecutionState &state,
                                                KInstruction *target,
                                                std::vector<ref<Expr> > &arguments) {
  assert(arguments.size() == 2 && "invalid number of arguments to klee_event");

  if (!isa<ConstantExpr>(arguments[0]) || !isa<ConstantExpr>(arguments[1])) {
    executor.terminateStateOnError(state, "klee_event requires a constant arg", "user.err");
    return;
  }

  ref<ConstantExpr> type = cast<ConstantExpr>(arguments[0]);
  ref<ConstantExpr> value = cast<ConstantExpr>(arguments[1]);

  executor.executeEvent(state, (unsigned int)type->getZExtValue(),
      (long int)value->getZExtValue());
}

void SpecialFunctionHandler::handleMarkGlobal(ExecutionState &state,
                                              KInstruction *target,
                                              std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 &&
         "invalid number of arguments to klee_mark_global");  

  Executor::ExactResolutionList rl;
  executor.resolveExact(state, arguments[0], rl, "mark_global");
  
  for (Executor::ExactResolutionList::iterator it = rl.begin(), 
         ie = rl.end(); it != ie; ++it) {
    const MemoryObject *mo = it->first.first;
    assert(!mo->isLocal);
    mo->isGlobal = true;
  }
}

void SpecialFunctionHandler::handleSyscall(ExecutionState &state,
                            KInstruction *target,
                            std::vector<ref<Expr> > &arguments) {
  assert(arguments.size() >= 1 && "invalid number of arguments to syscall");

  if (ConstantExpr *syscallNo = dyn_cast<ConstantExpr>(arguments[0])) {
    switch(syscallNo->getZExtValue()) {
    /* Signal syscalls */
    case SYS_rt_sigaction:
    case SYS_sigaltstack:
    case SYS_signalfd:
    case SYS_signalfd4:
    case SYS_rt_sigpending:
    case SYS_rt_sigprocmask:
    case SYS_rt_sigreturn:
    case SYS_rt_sigsuspend:
      LOG(INFO) << "Blocked syscall " << syscallNo->getZExtValue();
      executor.bindLocal(target, state, ConstantExpr::create(0,
            executor.getWidthForLLVMType(target->inst->getType())));
      break;
    default:
      executor.callUnmodelledFunction(state, target,
          executor.kmodule->module->getFunction("syscall"),
          arguments);
      break;
    }
  } else {
    executor.terminateStateOnError(state, "syscall requires a concrete syscall number", "user.err");
  }
}

void SpecialFunctionHandler::handleRecordExpr(ExecutionState &state,
                            KInstruction *target,
                            std::vector<ref<Expr> > &arguments) {
  assert(arguments.size() == 2
      && "invalid number of arguments to klee_record_expr");

  assert(isa<ConstantExpr>(arguments[0]) && "FIXME");
}

void SpecialFunctionHandler::handleBeginChecked(ExecutionState &state,
                            KInstruction *target,
                            std::vector<ref<Expr> > &arguments) {
  LOG(INFO) << "Enabling full checks on path";
}

void SpecialFunctionHandler::handleEndChecked(ExecutionState &state,
                            KInstruction *target,
                            std::vector<ref<Expr> > &arguments) {
  LOG(INFO) << "Disabling full checks on path";

}

void SpecialFunctionHandler::handleMemCmp(ExecutionState &state,
                            KInstruction *target,
                            std::vector<ref<Expr> > &arguments) {
  assert(arguments.size() == 3 && "Invalid number of args in klee_memcpy");

  assert(isa<ConstantExpr>(arguments[0]) && "FIXME");
  assert(isa<ConstantExpr>(arguments[1]) && "FIXME");
  assert(isa<ConstantExpr>(arguments[2]) && "FIXME");

  ObjectPair op1, op2;
  bool success;

  uint64_t address1 = cast<ConstantExpr>(arguments[0])->getZExtValue();
  uint64_t address2 = cast<ConstantExpr>(arguments[1])->getZExtValue();

  success = state.addressSpace().resolveOne(cast<ConstantExpr>(arguments[0]), op1);
  assert(success && "FIXME");

  success = state.addressSpace().resolveOne(cast<ConstantExpr>(arguments[1]), op2);
  assert(success && "FIXME");

  unsigned size = cast<ConstantExpr>(arguments[2])->getZExtValue();

  ref<Expr> expr1 = op1.second->read(address1 - op1.first->address, 8*size);
  ref<Expr> expr2 = op2.second->read(address2 - op2.first->address, 8*size);

  bool res;
  success = executor.solver->mustBeTrue(data::OTHER, state, EqExpr::create(expr1, expr2), res);
  assert(success && "FIXME");

  executor.bindLocal(target, state, ConstantExpr::create(res,
        executor.getWidthForLLVMType(target->inst->getType())));
}
