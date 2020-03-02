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
int sleep(int);

struct ThreadNdb pThreads[10];
//struct ThreadNdb* pThreads = NULL; // Pointer to thread data array
int  P = 2;
void Criteria(int id);
void barrier();
void snapshot(int gvar, int index);
void snapshot64(long gvar, int index);
void InitializeSwitchesAndCounter(int id);
void IncrementCounter(void);

int gsense = 1;
int counter = 0;

//atomic_section_begin();
int atomic_cmpxchg(int oldcount, int newcount)
{

  int temp, updatedcount;
  temp = counter;
  //noScheduling(); 
  if(oldcount == temp)
  {
    counter = newcount;
    snapshot64(counter, 0);
    //noScheduling(); 
    updatedcount = oldcount;// updatedcount == oldcount, update succeeds.
  }
  else
  {
    updatedcount = counter; // updatedcount != oldcount, update fails.
    //noScheduling(); 
  }
  return updatedcount;
}

void* flexHammerThread(void* pArg)
{
  struct ThreadNdb* pThreadData = (struct ThreadNdb*)pArg;
  {
    InitializeSwitchesAndCounter(1);
    IncrementCounter();
    int lsense = 1;
    lsense = 1 - lsense;
    sleep(1);
    while (1) {
      int oldcount = counter;
      sleep(1);
      int newcount = oldcount + 1;
      int updatedcount, retVal;

      //atomic_section_begin();
      updatedcount = atomic_cmpxchg(oldcount, newcount);
      //atomic_section_end();
      sleep(1);

      if (updatedcount == oldcount) {
        if ((newcount == P))
        {
          counter = 0;
          snapshot(counter, 0);
          sleep(1);
          gsense = lsense;
          Criteria(1);
          snapshot(gsense, 1);
        }
        break;
      }
    }
    while (gsense != lsense)
      ;
    Criteria(1);
    sleep(4);
  }
  
  {
    InitializeSwitchesAndCounter(2);
    IncrementCounter();
    int lsense = 1;
    lsense = 1 - lsense;
    while (1) {
      int oldcount = counter;
      sleep(1);
      int newcount = oldcount + 1;
      int updatedcount, retVal;

      //atomic_section_begin();
      updatedcount = atomic_cmpxchg(oldcount, newcount);
      //atomic_section_end();
      sleep(1);

      if (updatedcount == oldcount) {
        if ((newcount == P))
        {
          counter = 0;
          snapshot(counter, 0);
          sleep(1);
          gsense = lsense;
          Criteria(2);
          snapshot(gsense, 1);
        }
        break;
      }
    }
    while (gsense != lsense)
      ;
    Criteria(2);
    sleep(4);
  }
}


int main(int argc, char** argv)
{
  // Create threads.                                           *
  for (int i = 1; i < P ; i++) {  
    //pThreads[i].threadNo = i;
    pthread_t t;
    pthread_create(&t,
        NULL,
        (flexHammerThread),
        (void**)&pThreads[i]);
  } // for

  sleep(1);
  flexHammerThread(NULL);

  return 0;
}

