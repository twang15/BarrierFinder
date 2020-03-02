#include "BoundaryDetection.h"
void initializeSCCAuxInfo(const std::vector<BasicBlock*>& scc, AuxiliaryMap& auxiliaryMap)
{
  for (std::vector<BasicBlock*>::const_iterator I = scc.begin(),
      E = scc.end(); I != E; ++I)
  {
    BasicBlock *bb = *I;

    //Create bb to auxInfo mapping entry.
    AuxiliaryInfo auxInfo;
    auxInfo.inLocal.clear();
    auxInfo.outLocal.clear();
    auxInfo.inGlobal.clear();
    auxInfo.outGlobal.clear();

    //Insert into <bb, auxInfo> map.
    auxiliaryMap.insert(itemPair(bb, auxInfo));
  }
}

void computeAuxInfoOut(BasicBlock *bb, AuxiliaryInfo& auxInfo, 
                       const vector<BasicBlock*>& nextSCC, AuxiliaryMap& auxiliaryMap,
                       BasicBlock * readCriteriaBB)
{
  for (succ_iterator I = succ_begin(bb), E = succ_end(bb); I != E; I++)
  {
    BasicBlock *succ = *I;

    //test whether the successor is in current SCC.
    //The BB containing read-side criteria should be handled differently: skip it.
    if(readCriteriaBB == succ)
    {
      continue;
    }

    AuxiliaryInfo succAuxInfo = auxiliaryMap[succ];

    set_union(auxInfo.inLocal, succAuxInfo.outLocal);

    //set_union(auxInfo.inGlobal, succAuxInfo.outGlobal);
    //because DRC's equality is not based on its address, set_union cannot be used.
    for(SetOfDRC::iterator iSucc=succAuxInfo.outGlobal.begin(), eSucc=succAuxInfo.outGlobal.end();
        iSucc != eSucc; ++iSucc)
    {
      DRC *drcSucc = *iSucc;
      bool bInGlobal = false;
      for(SetOfDRC::iterator i=auxInfo.inGlobal.begin(), e=auxInfo.inGlobal.end();
          i != e; ++i)
      {
        DRC *tmp = *i;
        if(*drcSucc == *tmp)
        {
          bInGlobal = true;
          break;
        }
      }

      if(!bInGlobal)
      {
        auxInfo.inGlobal.insert(drcSucc);
      }
    }
  }

  //propagate in to out.
  auxInfo.outLocal = auxInfo.inLocal;
  auxInfo.outGlobal = auxInfo.inGlobal;
}
