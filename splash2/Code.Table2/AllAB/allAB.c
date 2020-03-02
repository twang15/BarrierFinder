//This will be the minimum file.
//1. No inlcude header files, no library dependency, no global variables
//2. translate to C file, without new/delete if compilation cannot succeed.
//3. 
//
//
#include <pthread.h>
struct ThreadNdb {
  int threadReady;
};

  struct ThreadNdb pThreads[3];
  //struct ThreadNdb* pThreads = NULL; // Pointer to thread data array
int  tNoOfThreads = 3;
void Criteria(int id);

void* flexHammerThread(void* pArg)
{
  struct ThreadNdb* pThreadData = (struct ThreadNdb*)pArg;
  pThreadData->threadReady = 1; // Signalling ready to main
  //pThreads.threadReady = 1;
  Criteria(1);
}

// Initialise thread data
void 
resetThreads(struct ThreadNdb *threadArrayP) {

  for (int i = 0; i < tNoOfThreads ; i++)
    {
      //threadArrayP[i].threadReady = 2;
      pThreads[i].threadReady = 0;
      //threadArrayP[i].threadResult = 0;
      //threadArrayP[i].threadStart = stIdle;
    }
} // resetThreads

void 
waitForThreads(struct ThreadNdb *threadArrayP)
{
  int cont = 1;

  while (cont) {
    //NdbSleep_MilliSleep(100);
    cont = 0;
    for (int i = 0; i < tNoOfThreads ; i++) {
      //if (threadArrayP[i].threadReady == 0) {
      if (pThreads[i].threadReady == 0) {
        // Found one thread not yet ready, continue waiting
	      cont = 1;
        break;
      } // if
    } // for
  } // while
  Criteria(1);
} // waitForThreads


int main(int argc, char** argv)
{
  //pThreads = (ThreadNdb*) malloc(sizeof(ThreadNdb)*tNoOfThreads);
  // Create thread data array
  //pThreads = new ThreadNdb[tNoOfThreads];
  
  // Create threads.                                           *
  resetThreads(pThreads);
  
  for (int i = 0; i < tNoOfThreads ; i++) {  
    //pThreads[i].threadNo = i;
    pthread_t t;
    pthread_create(&t,
        NULL,
        (flexHammerThread),
        (void**)&pThreads[i]);
  } // for

  // And wait until they are ready
  waitForThreads(pThreads);

  //release resources
  //delete [] pThreads;

  return 0;
}

