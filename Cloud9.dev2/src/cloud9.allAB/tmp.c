strcmp(os->object->allocSite->getName ().data(), mystring)

for (MemoryMap::iterator it = objects.begin(), ie = objects.end();
    it != ie; ++it) 
{
  const MemoryObject *mo = it->first;
  if(mo->isGlobal)
  {
    if(GlobalVariable *gv = dyn_cast<GlobalVariable>(mo->allocSite))
    {
      //gv is global output string we are looking for.
      if(gv->getName() == "outputString")
      {
        //Retrieve its value.
        ObjectState *os = it->second;
        return os->concreteStore;
        //os->concreteStore, base address
        //mo->size, size.
      }
    }
  }
}

