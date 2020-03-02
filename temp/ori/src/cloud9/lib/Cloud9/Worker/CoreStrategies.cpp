/*
 * Cloud9 Parallel Symbolic Execution Engine
 *
 * Copyright (c) 2011, Dependable Systems Laboratory, EPFL
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the Dependable Systems Laboratory, EPFL nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE DEPENDABLE SYSTEMS LABORATORY, EPFL BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * All contributors are listed in CLOUD9-AUTHORS file.
 *
*/

#include "cloud9/worker/CoreStrategies.h"
#include "cloud9/worker/TreeObjects.h"
#include "cloud9/worker/TreeNodeInfo.h"
#include "cloud9/worker/WorkerCommon.h"
#include "cloud9/worker/SymbolicEngine.h"
#include "cloud9/worker/JobManager.h"

#include "klee/CoreStats.h"
#include "klee/Internal/ADT/RNG.h"
#include "klee/Searcher.h"
#include "klee/Statistics.h"
#include "klee/Executor.h"
#include "klee/ExecutionState.h"
#include "klee/Internal/Module/KInstruction.h"
#include "klee/Internal/Module/InstructionInfoTable.h"
///XXX: ugly, remove this dependency
#include "../../Core/CallPathManager.h"
#include "../../Core/StatsTracker.h"


using namespace klee;

namespace cloud9 {

namespace worker {

static ExecutionJob *selectRandomPathJob(WorkerTree *tree) {
  WorkerTree::Node *node = tree->selectRandomLeaf(WORKER_LAYER_JOBS,
      tree->getRoot(), theRNG);
  ExecutionJob *job = (**node).getJob();

  assert(job != NULL || node == tree->getRoot());

  return job;
}

static SymbolicState *selectRandomPathState(WorkerTree *tree) {
  WorkerTree::Node *node = tree->selectRandomLeaf(WORKER_LAYER_STATES,
      tree->getRoot(), theRNG, WORKER_LAYER_JOBS);
  SymbolicState *state = (**node).getSymbolicState();

  return state;
}

ExecutionJob *BasicStrategy::selectJob(WorkerTree *tree, SymbolicState* state) {
  WorkerTree::Node *node = state->getNode().get();
  if (!node->layerExists(WORKER_LAYER_JOBS)) {
    dumpSymbolicTree(node);
  }

  assert(node->layerExists(WORKER_LAYER_JOBS));

  // Take the easy way first
  if ((**node).getJob() != NULL) {
    return (**node).getJob();
  }

  // OK, so it's an inner state - select one job at random for replay
  WorkerTree::Node *jobNode = tree->selectRandomLeaf(WORKER_LAYER_JOBS, node, theRNG);
  ExecutionJob *job = (**jobNode).getJob();

  return job;
}

void BasicStrategy::dumpSymbolicTree(WorkerTree::Node *highlight) {
  jobManager->dumpSymbolicTree(NULL,
      WorkerNodeDecorator(highlight));
}

////////////////////////////////////////////////////////////////////////////////
// Random-Job-From-State Strategy
////////////////////////////////////////////////////////////////////////////////

void RandomJobFromStateStrategy::onStateActivated(SymbolicState *state) {
  stateStrat->onStateActivated(state);
}

void RandomJobFromStateStrategy::onStateActivated(SymbolicState *newState,
                                                  SymbolicState *currentState)
{
  stateStrat->onStateActivated(newState, currentState);
}

void RandomJobFromStateStrategy::onStateUpdated(SymbolicState *state,
    WorkerTree::Node *oldNode) {
  stateStrat->onStateUpdated(state, oldNode);
}

void RandomJobFromStateStrategy::onStateDeactivated(SymbolicState *state) {
  stateStrat->onStateDeactivated(state);
}

void RandomJobFromStateStrategy::onStateStepped(SymbolicState *state) {
  stateStrat->onStateStepped(state);
}

void RandomJobFromStateStrategy::onStateScheduleDisabled(SymbolicState *state)
{
  stateStrat->onStateScheduleDisabled(state);
}

ExecutionJob* RandomJobFromStateStrategy::onNextJobSelection() {
  SymbolicState *state = stateStrat->onNextStateSelection();

  if (!state)
    return NULL;

  return selectJob(tree, state);
}

ExecutionJob* RandomJobFromStateStrategy::onNextJobSelectionEx(bool &canBatch, uint32_t &batchDest) {
  SymbolicState *state = stateStrat->onNextStateSelectionEx(canBatch, batchDest);

  if (!state)
    return NULL;

  return selectJob(tree, state);
}

////////////////////////////////////////////////////////////////////////////////
// Random Strategy
////////////////////////////////////////////////////////////////////////////////

SymbolicState* RandomStrategy::onNextStateSelection() {
  if (states.empty()) {
    Executor* executor = dynamic_cast<Executor*>(interpreter);
    std::vector<ExecutionState*> &invariantStates = executor->getInvariantStates();
    std::vector<Invariant>& invariantSet = executor->getInvariantSet();

    if(!invariantStates.empty())
    {
      //copy invariantStates to states so as to enable scheduling on them again.
      //This, in effect, implements the restart of invariant states after the
      //invariants have been derived.
      std::vector<ExecutionState*>::iterator ib = invariantStates.begin();
      std::vector<ExecutionState*>::iterator ie = invariantStates.end();
      for(; ib != ie; ++ib)
      {
        ExecutionState* executionState = *ib;
        SymbolicState *c9State = executionState->getCloud9State();
        indices[c9State] = states.size();
        states.push_back(c9State);

        //enable instruction schedule again.
        c9State->enableSchedule();
      }

      //clear invariantSet and invariantStates before starting the next sync.
      invariantStates.clear();
      invariantSet.clear();
      executor->setTotalValid(0xDEADBEEF);
    }
    else
    {
      return NULL;
    }
  }
//#define __RANDOMIZE_INDEX__ 1
#if __RANDOMIZE_INDEX__
  int index = klee::theRNG.getInt32() % states.size();
#else
  //depth-first index for depth-first scheduling.
  int index = states.size()-1;
  assert(index >=0 && "Valid index must always be >= 0");
#endif

  return states[index];
}

void RandomStrategy::onStateActivated(SymbolicState *state) {
  indices[state] = states.size();
  states.push_back(state);
}

//maintain an invariant that the current scheduled state is always
//the last element of states.
void RandomStrategy::onStateActivated(SymbolicState *newState, SymbolicState *currentState) {

  onStateActivated(newState);
  return ;
  //directly push back the first state.
  if(states.empty())
  {
    //when states is empty, there is no current scheduled state.
    //currentState is NULL and useless.
    //inlined onStateActivated(newState)
    assert(currentState == NULL && "The current scheduled state must be NULL.\n");
    indices[newState] = 0;
    states.push_back(newState);
  }
  else
  {
    assert(currentState != NULL && "The current scheduled state must not be NULL.\n");
    unsigned i = indices[currentState];
    assert(i == (states.size()-1) && "The index of currentState should alway be the last element.\n");
    indices[newState] = i; //replace current state's position.
    states[i] = newState; //put new State at the end of states.
    
    //put current state in the last position to
    //maintain the invariant.
    states.push_back(currentState);

    //update indices for currentState.
    indices[currentState] = states.size() - 1;
  }
}

void RandomStrategy::onStateDeactivated(SymbolicState *state) {
  unsigned i = indices[state];

  states[i] = states.back();
  indices[states[i]] = i;
  states.pop_back();
}

void RandomStrategy::onStateScheduleDisabled(SymbolicState *state)
{
  //remove from scheduling states.
  onStateDeactivated(state);
}

////////////////////////////////////////////////////////////////////////////////
// Random Path Strategy
////////////////////////////////////////////////////////////////////////////////

SymbolicState* RandomPathStrategy::onNextStateSelection() {
  SymbolicState *state = selectRandomPathState(tree);

  return state;
}

////////////////////////////////////////////////////////////////////////////////
// Clustered Random Path Strategy
////////////////////////////////////////////////////////////////////////////////

SymbolicState* ClusteredRandomPathStrategy::onNextStateSelection() {
  if (states.empty())
      return NULL;

  std::vector<WorkerTree::Node*> nodes;
  nodes.reserve(states.size());

  // TODO: Make this more efficient by implementing a custom iterator
  for (state_set_t::iterator it = states.begin(); it != states.end(); it++) {
    SymbolicState *state = *it;
    nodes.push_back(state->getNode().get());
  }

  WorkerTree::Node *selNode = tree->selectRandomLeaf(WORKER_LAYER_STATES,
      tree->getRoot(), theRNG, nodes.begin(), nodes.end());

  SymbolicState *state = (**selNode).getSymbolicState();

  assert(state != NULL);

  return state;
}

void ClusteredRandomPathStrategy::onStateActivated(SymbolicState *state) {
  states.insert(state);
}

void ClusteredRandomPathStrategy::onStateDeactivated(SymbolicState *state) {
  states.erase(state);
}

////////////////////////////////////////////////////////////////////////////////
// Limited Flow Strategy
////////////////////////////////////////////////////////////////////////////////

void LimitedFlowStrategy::onStateActivated(SymbolicState *state) {
  underStrat->onStateActivated(state);
}

void LimitedFlowStrategy::onStateDeactivated(SymbolicState *state) {
  underStrat->onStateDeactivated(state);

  if (activeStates.count(state) > 0) {
    workingStrat->onStateDeactivated(state);
    activeStates.erase(state);
  }
}

SymbolicState* LimitedFlowStrategy::onNextStateSelection() {
  // First, ask the underlying strategy...
  SymbolicState *candidate = underStrat->onNextStateSelection();

  if (!candidate) {
    assert(activeStates.size() == 0);
    return NULL;
  }

  if (activeStates.count(candidate) > 0)
    return candidate;

  if (activeStates.size() < maxCount) {
    activeStates.insert(candidate);
    workingStrat->onStateActivated(candidate);
    return candidate;
  }

  SymbolicState *state = workingStrat->onNextStateSelection();
  assert(state != NULL);

  return state;
}

////////////////////////////////////////////////////////////////////////////////
// Klee Imported Strategy
////////////////////////////////////////////////////////////////////////////////

KleeStrategy::KleeStrategy(WorkerTree *_tree) : tree(_tree), searcher(NULL) {

}

KleeStrategy::KleeStrategy(WorkerTree *_tree, klee::Searcher *_searcher) :
        tree(_tree), searcher(_searcher) {

}

KleeStrategy::~KleeStrategy() {

}

void KleeStrategy::onStateActivated(SymbolicState *state) {
    std::set<klee::ExecutionState*> added;
    added.insert(&(**state));

    searcher->update(NULL, added, std::set<klee::ExecutionState*>());
}

void KleeStrategy::onStateUpdated(SymbolicState *state, WorkerTree::Node *oldNode) {
    searcher->update(&(**state), std::set<klee::ExecutionState*>(), std::set<klee::ExecutionState*>());
}

void KleeStrategy::onStateDeactivated(SymbolicState *state) {
    std::set<klee::ExecutionState*> removed;
    removed.insert(&(**state));

    searcher->update(NULL, std::set<klee::ExecutionState*>(), removed);
}

SymbolicState* KleeStrategy::onNextStateSelection() {
  if (searcher->empty())
        return NULL;

  klee::ExecutionState &kState = searcher->selectState();
  SymbolicState *state = kState.getCloud9State();

  return state;
}


////////////////////////////////////////////////////////////////////////////////
// Weighted Random Strategy
////////////////////////////////////////////////////////////////////////////////

WeightedRandomStrategy::WeightedRandomStrategy(WeightType _type,
        WorkerTree *_tree, SymbolicEngine *_engine) : KleeStrategy(_tree) {

    klee::Executor *executor = dynamic_cast<klee::Executor*>(_engine); // XXX I should be ashamed of this
    searcher = new WeightedRandomSearcher(*executor,
            static_cast<klee::WeightedRandomSearcher::WeightType>(_type)); // XXX This is truly ugly

}

WeightedRandomStrategy::~WeightedRandomStrategy() {
    delete searcher;
}


}

}

