//===-- SpecialFunctionHandler.h --------------------------------*- C++ -*-===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef KLEE_SPECIALFUNCTIONHANDLER_H
#define KLEE_SPECIALFUNCTIONHANDLER_H

#include <map>
#include <vector>
#include <string>
//#include "syncat/syncs.h"
//using namespace syncat;
namespace syncat
{
  struct ExecutionContext;
}

#define __G_SYNCVAR_TOTAL_NUM__ "gSyncVarsTotalNum"
#define __G_SYNCVAR_0__ "gSyncVar_0"
#define __G_SYNCVAR_1__ "gSyncVar_1"
#define __G_SYNCVAR_2__ "gSyncVar_2"
#define __G_SYNCVAR_3__ "gSyncVar_3"

namespace llvm {
  class Function;
}

namespace klee {
  class Executor;
  class Expr;
  class ExecutionState;
  struct KInstruction;
  template<typename T> class ref;
  
  class SpecialFunctionHandler {
  public:
    typedef void (SpecialFunctionHandler::*Handler)(ExecutionState &state,
                                                    KInstruction *target, 
                                                    std::vector<ref<Expr> > 
                                                      &arguments);
    typedef std::map<const llvm::Function*, 
                     std::pair<Handler,bool> > handlers_ty;
    typedef std::vector< std::pair<std::pair<const MemoryObject*, const ObjectState*>,
        ExecutionState*> > resolutions_ty;

    handlers_ty handlers;
    class Executor &executor;

  public:
    SpecialFunctionHandler(Executor &_executor);

    /// Perform any modifications on the LLVM module before it is
    /// prepared for execution. At the moment this involves deleting
    /// unused function bodies and marking intrinsics with appropriate
    /// flags for use in optimizations.
    void prepare();

    /// Initialize the internal handler map after the module has been
    /// prepared for execution.
    void bind();

    bool handle(ExecutionState &state, 
                llvm::Function *f,
                KInstruction *target,
                std::vector< ref<Expr> > &arguments);

    /* Convenience routines */

    void processMemoryLocation(ExecutionState &state,
        ref<Expr> address, ref<Expr> size,
        const std::string &name, resolutions_ty &resList);

    void makeSymbolic(ExecutionState &state, std::vector<ref<Expr> > &arguments);

    bool writeConcreteValue(ExecutionState &state,
        ref<Expr> address, uint64_t value, Expr::Width width);

    std::string readStringAtAddress(ExecutionState &state, ref<Expr> address);

    BasicBlock *findLoopExitBlock(Function *F, int loopID);
    bool isRegionInLoop(syncat::ExecutionContext &context);
    bool isBasicBlockInLoop(BasicBlock *bb);

    /// Jump from current program point to the exit of 
    /// the loop where the current sync region resides.
    /// Code reference: Executor::transferToBasicBlock
    void earlyTerminateFixedPointLoop(BasicBlock *loopExitBlock, 
                                      BasicBlock *currentBlock, 
                                      ExecutionState &state,
                                      Executor* executor);
    
    /* Handlers */

#define HANDLER(name) void name(ExecutionState &state, \
                                KInstruction *target, \
                                std::vector< ref<Expr> > &arguments)

    HANDLER(handleAbort);
    HANDLER(handleAliasFunction);
    HANDLER(handleAssert);
    HANDLER(handleAssertFail);
    HANDLER(handleAssume);
    HANDLER(handleBeginChecked);
    HANDLER(handleBranch);
    HANDLER(handleCalloc);
    HANDLER(handleCheckMemoryAccess);
    HANDLER(handleDebug);
    HANDLER(handleDefineFixedObject);
    HANDLER(handleDelete);    
    HANDLER(handleDeleteArray);
    HANDLER(handleEndChecked);
    HANDLER(handleEvent);
    HANDLER(handleFork);
    HANDLER(handleFree);
    HANDLER(handleGetContext);
    HANDLER(handleGetErrno);
    HANDLER(handleGetObjSize);
    HANDLER(handleGetTime);
    HANDLER(handleGetValue);
    HANDLER(handleGetWList);
    HANDLER(handleIsSymbolic);
    HANDLER(handleMakeShared);
    HANDLER(handleMakeSymbolic);
    HANDLER(handleMalloc);
    HANDLER(handleMarkGlobal);
    HANDLER(handleMemCmp);
    HANDLER(handleMerge);
    HANDLER(handleNew);
    HANDLER(handleNewArray);
    HANDLER(handlePreferCex);
    HANDLER(handlePrintExpr);
    HANDLER(handlePrintRange);
    HANDLER(handleProcessFork);
    HANDLER(handleProcessTerminate);
    HANDLER(handleRange);
    HANDLER(handleRealloc);
    HANDLER(handleRecordExpr);
    HANDLER(handleReportError);
    HANDLER(handleRevirtObjects);
    HANDLER(handleSetForking);
    HANDLER(handleSetTime);
    HANDLER(handleSilentExit);
    HANDLER(handleStackTrace);
    HANDLER(handleSyscall);
    HANDLER(handleThreadCreate);
    HANDLER(handleThreadNotify);
    HANDLER(handleThreadPreempt);
    HANDLER(handleThreadSleep);
    HANDLER(handleThreadTerminate);
    HANDLER(handleUnderConstrained);
    HANDLER(handleValloc);
    HANDLER(handleWarning);
    HANDLER(handleWarningOnce);
    HANDLER(handleSyncRegionEnd);
    HANDLER(handleDeriveInvariant);
    HANDLER(handleRecordSyncVariable);
    HANDLER(handleInitializeSwitchesAndCounter);
    HANDLER(handleCheckInvariant);
    HANDLER(handleloopCurrent);
#undef HANDLER
  };
} // End klee namespace

#endif
