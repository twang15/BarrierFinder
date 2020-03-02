#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

typedef struct {
  volatile int gsense;
  volatile long count;    /* the count of entered processors */
} barrier_t;


struct GlobalMemory {
  barrier_t start;
} *Global;

#ifndef THREADS
#define THREADS 2
#endif

void init();
void barrier();
void Criteria();
int P;

int T = 0;
int trace[THREADS];

int main()
{
  //initialize the barrier parameters.
#if 0
  init();
#else
  Global = (struct GlobalMemory *) malloc(sizeof(struct GlobalMemory));
  (Global->start).gsense = 1;
  (Global->start).count = 0;  
  P = THREADS;
#endif

  pthread_t tid[THREADS];
  int i;

  for(i=1; i<THREADS; i++)
  {
    pthread_create(&tid[i], NULL, barrier, NULL);
  }

  barrier();

  //pthread_create(&tid[0], NULL, barrier, NULL);

  for(i=1; i<THREADS; i++)
  {
    pthread_join(tid[i], NULL);
  }
  //Barrier
  //barrier();

  //Destroy
  free(Global);
  Global = NULL;

  return 0;
}


void init()
{
  Global = (struct GlobalMemory *) malloc(sizeof(struct GlobalMemory));
  (Global->start).gsense = 1;
  (Global->start).count = 0;  
  P = THREADS;
}

void barrier()
{
  int lsense = (Global->start).gsense;
  while (1) 
  {
    int oldcount = (Global->start).count;
    sleep(0);
//    __thread_preempt(0);
    int newcount = oldcount + lsense;
    int updatedcount;
    int threads = P;
#if 0
    asm("lock cmpxchg %1,%2" : 
        "=a" (updatedcount) : 
        "r" (newcount), "m" ((Global->start).count), "0a" (oldcount) );
#else
    if((Global->start).count == oldcount)
    {
      (Global->start).count = newcount;
      updatedcount = oldcount;
    }
    else
    {
      updatedcount = (Global->start).count;
    }
    sleep(0);
//    __thread_preempt(0);
#endif

    if (updatedcount == oldcount) 
    {
      if ((newcount == (P) && lsense == 1) || (newcount == 0 && lsense == -1))
      {
        printf("X\n");
        (Global->start).gsense = -lsense;
        sleep(0);
    //__thread_preempt(0);
   //     Criteria();
      }
      break;
    }
  }

  while ((Global->start).gsense == lsense){sleep(1);};
  printf("Y\n");
  //Criteria();
}

void Criteria()
{
}
