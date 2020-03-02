//===-- Executor_Threading.cpp --------------------------------------------===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "klee/Executor.h"

#include "StatsTracker.h"

#include "llvm/Function.h"
#include "llvm/Support/CommandLine.h"

#include <glog/logging.h>


using namespace llvm;

namespace {

cl::opt<bool>
DebugSchedulingHistory("debug-sched-history", cl::init(false));

cl::opt<bool>
ForkOnSchedule("fork-on-schedule",
   cl::desc("fork when various schedules are possible (defaul=disabled)"),
   cl::init(false));

cl::opt<unsigned int>
MaxPreemptions("scheduler-preemption-bound",
   cl::desc("scheduler preemption bound (default=0)"),
   cl::init(0));

}


namespace klee {

#if 0
bool Executor::schedule(ExecutionState &state, bool yield) {
#else
bool Executor::schedule(ExecutionState &state, bool yield, schedule_point_type schedule_type) {
#endif
  int enabledCount = state.numOfEnabledThreads();
  bool bOutside = false;
  bool allWritersDone = true;

  switch(schedule_type)
  {
    case SYNC_READ:
      //check whether syncWriteReached is true.
      //TODO: This may be problematic.
      //if(!state.syncWriteReached)
      //1. if enabledCount is 1, this thread is the only active thread
      //   and should not be disabled, otherwise, the system will be deadlocked.
      //2. state.crtThreadIt->second.busyWaitReached should be false to indicate
      //   that the current thread is not within a busy wait loop (for allAB).
      //if(enabledCount > 1 && !state.crtThreadIt->second.busyWaitReached
      //    && !state.crtThreadIt->second.bExitBusyWait)
      //    
#if 0
      if(enabledCount > 1)
      {
        //busy-wait loop has not entered yet, but is about to enter now
        //Initially, "busyWaitReached is false, and bExitBusyWait is true"
        //to indicate that busy-wait loop has not entered.
        //
        if(!state.crtThreadIt->second.busyWaitReached
            && state.crtThreadIt->second.bExitBusyWait)
        {
          //disable the current thread.
          state.crtThreadIt->second.enabled = false;

          //entered busy-wait loop but has not come out yet.
          state.crtThreadIt->second.busyWaitReached = true;
          state.crtThreadIt->second.bExitBusyWait = false;
        }
        //busy-wait loop entered but has not come out, and the
        //current thread is trying to context-switch but should
        //not context-switch, because the write-side signal has
        //not been read yet.
        else if(state.crtThreadIt->second.busyWaitReached
                && !state.crtThreadIt->second.bExitBusyWait)
        {
          //
          return true;
        }
      }
#endif

      //allAB: multiple writers.
      //If any writer has not reached syncWrite, read thread should be
      //disabled. The interleaving enumeration should happen only among
      //writers; after all writers perform writing, only read thread should
      //be scheduled.
      //
      //Another option: instead of always blocking reader until writers are
      //done, always switching to a writer if there is at least one is not
      //done. If all writers are done, the reader should not fork any new states,
      
      //allAB begin
      //figure out whether there is still any writer not done.
      for(ExecutionState::threads_ty::iterator it = state.threads.begin();
          it != state.threads.end();  it++)
      {
        if((state.crtThreadIt != it) && (!it->second.bSyncWriteReached))
        {
          allWritersDone = false;
          break;
        }
      }

      //entered busy-wait loop but has not come out yet.
      state.crtThreadIt->second.busyWaitReached = true;
      
      if(allWritersDone)
      {
        //continue scheduling the current reader since no writers
        //are schedulable.
        return true;
      }
      else
      {
        //disable the current reader thread, so that other writers can be 
        //scheduled.
        state.crtThreadIt->second.enabled = false;
      }
      //allAB end

      break;

    case SYNC_WRITE:
      state.syncWriteReached = true;

      //allAB begin
      //note that this writer has done.
      state.crtThreadIt->second.bSyncWriteReached = true;
      //allAB end

      //allAB begin
      //figure out whether all writers are done.
      //allAB end

      //enable threads which have been disabled because of invoking sleep(2) and
      //thus enter busyWait loop.
      for(ExecutionState::threads_ty::iterator it = state.threads.begin();
          it != state.threads.end();  it++) 
      {
        //the thread was disabled because of calling sleep(2) and reaching of
        //busy-wait loop.
        if(!it->second.enabled && it->second.busyWaitReached)
        {
          //now, since sync variable write has occured, we should enable it.
          it->second.enabled = true;

          //
          //it->second.busyWaitReached = false;
          it->second.bExitBusyWait = false;
          //state.crtThreadIt->second.bExitBusyWait = false;
        }
      }

      break;
    case SYNC_REGION_END:
      //the last thread releases all the previous threads.
      if(enabledCount == 1)
      {
        for(ExecutionState::threads_ty::iterator it = state.threads.begin();
            it != state.threads.end();  it++)
        {
          if(!it->second.enabled && it->second.syncRegionEnd)
          {
            it->second.enabled = true;
          }
          else if(!it->second.enabled && !it->second.syncRegionEnd)
          {
            assert(0 && "A thread was disabled but not because of sync_region_end");
          }
        }
      }
      else if(enabledCount > 1) //not the last one.
      {
        //disable the current thread and the fact it called sync_region_end.
        state.crtThreadIt->second.enabled = false;
        state.crtThreadIt->second.syncRegionEnd = true;
      }
      //(enabledCount == 0) is handled below.
      break;
    case SYNC_OUTSIDE:
      //Why or not have bOutside? 
      //bOutside = true;
      
      //schedule points outside of sync regions.
      state.bOutSideSyncRegion = true;
      break;

    case SCHED_NONE:
    case ORDINARY:
    default:
      break;
  }

  if (enabledCount == 0) {
    terminateStateOnError(state, " ******** hang (possible deadlock?)", "user.err");
    return false;
  }

  bool forkSchedule = false;
  bool incPreemptions = false;

  ExecutionState::threads_ty::iterator oldIt = state.crtThreadIt;

  if(!state.crtThread().enabled || yield) 
  {
    ExecutionState::threads_ty::iterator it = state.nextThread(state.crtThreadIt);

    while (!it->second.enabled)
      it = state.nextThread(it);

    state.scheduleNext(it);

    if (ForkOnSchedule && (state.bEnumerating || bOutside))
      forkSchedule = true;
  } 
  else 
  {
    if (state.preemptions < MaxPreemptions) 
    {
      forkSchedule = true;
      incPreemptions = true;
    }
  }

  if (DebugSchedulingHistory) {
    LOG(INFO) << "Context Switch: --- TID: " << state.crtThread().tuid.first <<
        " PID: " << state.crtThread().tuid.second << " -----------------------";
    unsigned int depth = state.stack().size() - 1;
    LOG(INFO) << "Call: " << std::string(depth, ' ') << state.stack().back().kf->function->getName().str();

#ifdef __STANDALONE_DEBUG__
    LOG(INFO) << "State ID: " << state.UINT_state_id <<"\t"
              << "Parent ID: " << state.UINT_parent_id << "\t"
              << "Fork ID: " << state.UINT_fork_id;
#endif
  }

  if (forkSchedule) {
    ExecutionState::threads_ty::iterator finalIt = state.crtThreadIt;
    ExecutionState::threads_ty::iterator it = state.nextThread(finalIt);
    ExecutionState *lastState = &state;

    ForkClass forkClass = KLEE_FORK_SCHEDULE;

    while (it != finalIt) {
      // Choose only enabled states, and, in the case of yielding, do not
      // reschedule the same thread
      //if (it->second.enabled && (!yield || it != oldIt)) {
      if (it->second.enabled) {
        StatePair sp = fork(*lastState, forkClass);

        if (incPreemptions)
          sp.first->preemptions = state.preemptions + 1;

        sp.first->scheduleNext(sp.first->threads.find(it->second.tuid));

        lastState = sp.first;

        //Debugging: verify different ExecutionStates have different addressSpace 
        //for writable global variables.
#if 1
        char * addr1 = (char*) lastState->getGlobalVariable();
        char * addr2 = (char*) sp.second->getGlobalVariable();
#endif

        if (forkClass == KLEE_FORK_SCHEDULE) {
          forkClass = KLEE_FORK_MULTI;   // Avoid appearing like multiple schedules
        }
      }

      it = state.nextThread(it);
    }
  }

  //DumpStateSet();

  return true;
}

void Executor::executeThreadCreate(ExecutionState &state, thread_id_t tid,
             ref<Expr> start_function, ref<Expr> arg)
{
  VLOG(1) << "Creating thread...";
  KFunction *kf = resolveFunction(start_function);
  assert(kf && "cannot resolve thread start function");

  Thread &t = state.createThread(tid, kf);

  bindArgumentToPthreadCreate(kf, 0, t.stack.back(), arg);

  if (statsTracker)
    statsTracker->framePushed(&t.stack.back(), 0);
}

void Executor::executeThreadExit(ExecutionState &state) {
  //terminate this thread and schedule another one
  VLOG(1) << "Exiting thread...";

  if (state.threads.size() == 1) {
    LOG(INFO) << "Terminating state";
    terminateStateOnExit(state);
    return;
  }

  assert(state.threads.size() > 1);

  ExecutionState::threads_ty::iterator thrIt = state.crtThreadIt;
  thrIt->second.enabled = false;

  if (!schedule(state, false))
    return;

  state.terminateThread(thrIt);
}

void Executor::executeThreadNotifyOne(ExecutionState &state, wlist_id_t wlist) {
  // Copy the waiting list
  std::set<thread_uid_t> wl = state.waitingLists[wlist];

  if (!ForkOnSchedule || wl.size() <= 1) {
    if (wl.size() == 0)
      state.waitingLists.erase(wlist);
    else
      state.notifyOne(wlist, *wl.begin()); // Deterministically pick the first thread in the queue

    return;
  }

  ExecutionState *lastState = &state;

  for (std::set<thread_uid_t>::iterator it = wl.begin(); it != wl.end();) {
    thread_uid_t tuid = *it++;

    if (it != wl.end()) {
      StatePair sp = fork(*lastState, KLEE_FORK_SCHEDULE);

      sp.second->notifyOne(wlist, tuid);

      lastState = sp.first;
    } else {
      lastState->notifyOne(wlist, tuid);
    }
  }
}

void Executor::executeProcessFork(ExecutionState &state, KInstruction *ki,
    process_id_t pid) {

  VLOG(1) << "Forking with pid " << pid;

  Thread &pThread = state.crtThread();

  Process &child = state.forkProcess(pid);

  Thread &cThread = state.threads.find(*child.threads.begin())->second;

  // Set return value in the child
  state.scheduleNext(state.threads.find(cThread.tuid));
  bindLocal(ki, state, ConstantExpr::create(0,
      getWidthForLLVMType(ki->inst->getType())));

  // Set return value in the parent
  state.scheduleNext(state.threads.find(pThread.tuid));
  bindLocal(ki, state, ConstantExpr::create(child.pid,
      getWidthForLLVMType(ki->inst->getType())));
}


void Executor::executeProcessExit(ExecutionState &state) {
  if (state.processes.size() == 1) {
    terminateStateOnExit(state);
    return;
  }

  VLOG(1) << "Terminating " << state.crtProcess().threads.size() << " threads of the current process...";

  ExecutionState::processes_ty::iterator procIt = state.crtProcessIt;

  // Disable all the threads of the current process
  for (std::set<thread_uid_t>::iterator it = procIt->second.threads.begin();
      it != procIt->second.threads.end(); it++) {
    ExecutionState::threads_ty::iterator thrIt = state.threads.find(*it);

    if (thrIt->second.enabled) {
      // Disable any enabled thread
      thrIt->second.enabled = false;
    } else {
      // If the thread is disabled, remove it from any waiting list
      wlist_id_t wlist = thrIt->second.waitingList;

      if (wlist > 0) {
        state.waitingLists[wlist].erase(thrIt->first);
        if (state.waitingLists[wlist].size() == 0)
          state.waitingLists.erase(wlist);

        thrIt->second.waitingList = 0;
      }
    }
  }

  if (!schedule(state, false))
    return;

  state.terminateProcess(procIt);
}

}
