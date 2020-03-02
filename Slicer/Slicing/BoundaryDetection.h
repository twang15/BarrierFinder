#ifndef __BOUNDARY_DETECTION_H__
#define __BOUNDARY_DETECTION_H__

#include <vector>
#include "utility.h"
using namespace Util;

typedef set<Instruction*> InsSet;
typedef set<DRC*> SetOfDRC;
struct AuxiliaryInfo
{
  InsSet inLocal;
  InsSet outLocal;
  SetOfDRC inGlobal;
  SetOfDRC outGlobal;
};
typedef std::pair<const BasicBlock *, AuxiliaryInfo> itemPair;
typedef std::map<const BasicBlock *, AuxiliaryInfo> AuxiliaryMap;
void initializeSCCAuxInfo(const std::vector<BasicBlock*> &scc, AuxiliaryMap& auxiliaryMap);
void computeAuxInfoOut(BasicBlock *bb, AuxiliaryInfo& auxInfo, const vector<BasicBlock*>& nextSCC, 
                       AuxiliaryMap& auxiliaryMap,
                       BasicBlock *readCriteriaBB);
#endif
