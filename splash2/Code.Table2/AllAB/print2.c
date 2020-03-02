#include <stdio.h>
#include <stdbool.h>

#define LEN 200
#define NUM_OF_THREADS 3
#define NUM_OF_SYNC_VARS 2
int index_out = 0;
char mystring[LEN];
//int gSyncVar[NUM_OF_SYNC_VARS];
int gSyncVar_0 = 0;
int gSyncVar_1 = 0;
int gSyncVar_2 = 0;
int gSyncVarsTotalNum = 0; //how many gSyncVars are meaningful.
bool switches[NUM_OF_THREADS];
int counter0 = 0;
int counter1 = 0;
int syncID[NUM_OF_THREADS];
bool firstSync = true;

void IncrementCounter(void);
void DecrementCounter(void);
void DeriveInvariant(void);
void CheckInvariant(void);
void RecordSyncVariable(void);
void appendY(void);

void DeriveInvariant(void)
{
}

void CheckInvariant(void)
{
}

void RecordSyncVariable(void)
{
}

#if 0
int Criteria(int id)
{
  return id;
}
#endif

void printX()
{
  mystring[index_out] = 'X';
  index_out++;
}

void appendY()
{
  mystring[index_out] = 'Y';
  index_out++;
}

void printY()
{
  appendY();
  //1. There is no invariant to derive
  //2. There is no snapshot to take
  //3. No counter needs re-initialization
  //DecrementCounter();
}

void flushAll()
{
  mystring[index_out] = '\0';
}

void printChar(char ch)
{
#if 0
  unsigned int idx = pthread_self();
  char thread_id = idx + '0';
  mystring[index_out] = thread_id;
  index_out++;
#endif
  mystring[index_out] = ch;
  index_out++;
}

void waitForAll(void)
{
  pthread_join(0, 0);
  flushAll();
}

void snapshot(int gvar, int index)
{
  unsigned int idx = pthread_self();

  if(switches[idx])
  {
    switch(index)
    {
      case 0:
        gSyncVar_0 = gvar;
        break;
      case 1:
        gSyncVar_1 = gvar;
        break;
      case 2:
        gSyncVar_2 = gvar;
      default:
        break;
    }
    
    //update gSyncVarsTotalNum number of meaningful syncVars.
    if((index+1) > gSyncVarsTotalNum)
    {
      gSyncVarsTotalNum = index + 1;
    }
  }
}

void snapshot64(long gvar, int index)
{
  snapshot((int)gvar, index);
}

void InitializeSwitchesAndCounter(int id)
{
}

void IncrementCounter(void)
{
  unsigned int idx = pthread_self();
  if(syncID[idx] == 0)
  {
    counter0++;

    if(counter0 == 1)
    {
      //time to check whether the current state has been seen before with
      //exactly the same context.
      CheckInvariant();
    }

    //only the 1st invocation of IncrementCounter initializes snapshot switches.
    //the other timing for snapshot initialization is at the end of DecrementCounter when
    //last Ya has just happened.
    if(firstSync)
    {
      int i;

      for(i=0; i<NUM_OF_THREADS; i++)
      {
        switches[i] = true;
      }

      firstSync = false;
    }
  }
  else
  {
    counter1++;
    if(counter1 == 1)
    {
      //time to check whether the current state has been seen before with
      //exactly the same context.
      CheckInvariant();
    }
  }
}

void DecrementCounter(void)
{
  unsigned int idx = pthread_self();
  switches[idx] = false;

  if(syncID[idx] == 0)
  {
    counter0--;
    //when the counter equals 0, it means last Ya has just happened.
    //it is the time to derive the invariant.
    if(counter0 == 0)
    {
      DeriveInvariant();
      int i;

      //re-initialize snapshot switches when last Ya has just happened.
      for(i=0; i<NUM_OF_THREADS; i++)
      {
        switches[i] = true;
      }
    }
   
    //indicate the next sync is ready to start. 
    syncID[idx] = 1;
  }
  else
  {
    counter1--;
    
    //when the counter equals 0, it means last Ya has just happened.
    //it is the time to derive the invariant.
    if(counter1 == 0)
    {
      DeriveInvariant();
      
      //re-initialize snapshot switches when last Ya has just happened.
      int i;

      for(i=0; i<NUM_OF_THREADS; i++)
      {
        switches[i] = true;
      }
    }
    
    //indicate the next sync is ready to start. 
    syncID[idx] = 0;
  }
}


