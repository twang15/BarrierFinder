





/*************************************************************************/
/*                                                                       */
/*  Copyright (c) 1994 Stanford University                               */
/*                                                                       */
/*  All rights reserved.                                                 */
/*                                                                       */
/*  Permission is given to use, copy, and modify this software for any   */
/*  non-commercial purpose as long as this copyright notice is not       */
/*  removed.  All other uses, including redistribution in whole or in    */
/*  part, are forbidden without prior written permission.                */
/*                                                                       */
/*  This software is provided with absolutely no warranty and no         */
/*  support.                                                             */
/*                                                                       */
/*************************************************************************/

/*************************************************************************/
/*                                                                       */
/*  Perform 1D fast Fourier transform using six-step FFT method          */
/*                                                                       */
/*  1) Performs staggered, blocked transposes for cache-line reuse       */
/*  2) Roots of unity rearranged and distributed for only local          */
/*     accesses during application of roots of unity                     */
/*  3) Small set of roots of unity elements replicated locally for       */
/*     1D FFTs (less than root N elements replicated at each node)       */
/*  4) Matrix data structures are padded to reduce cache mapping         */
/*     conflicts                                                         */
/*                                                                       */
/*  Command line options:                                                */
/*                                                                       */
/*  -mM : M = even integer; 2**M total complex data points transformed.  */
/*  -pP : P = number of processors; Must be a power of 2.                */
/*  -nN : N = number of cache lines.                                     */
/*  -lL : L = Log base 2 of cache line length in bytes.                  */
/*  -s  : Print individual processor timing statistics.                  */
/*  -t  : Perform FFT and inverse FFT.  Test output by comparing the     */
/*        integral of the original data to the integral of the data      */
/*        that results from performing the FFT and inverse FFT.          */
/*  -o  : Print out complex data points.                                 */
/*  -h  : Print out command line options.                                */
/*                                                                       */
/*  Note: This version works under both the FORK and SPROC models        */
/*                                                                       */
/*************************************************************************/

#include <stdio.h>
#include <math.h>
#define PAGE_SIZE               4096
#define NUM_CACHE_LINES        65536 
#define LOG2_LINE_SIZE             4
#define PI                         3.1416
#define DEFAULT_M                 10
#define DEFAULT_P                  1


#include <pthread.h>
//#include "libittnotify.h"
#ifndef BARRIER_T
#define BARRIER_T
typedef struct {
  volatile int gsense;
  volatile long count;    /* the count of entered processors */
} barrier_t;
#endif


#define SWAP(a,b) {double tmp; tmp=a; a=b; b=tmp;}

struct GlobalMemory {
  int id;
  pthread_mutex_t (idlock);
  barrier_t (start);
  int *transtimes;
  int *totaltimes;
  int starttime;
  int finishtime;
  int initdonetime;
} *Global;


int P = DEFAULT_P;

void SlaveStart();

main(argc, argv)

  int argc;
  char **argv;

{
  int i; 
  int j; 
  int c;
  extern char *optarg;
  int m1;
  int factor;
  int pages;
  unsigned int start;


  Global = (struct GlobalMemory *) malloc(sizeof(struct GlobalMemory));;

  {
    (Global->start).gsense=1;
    (Global->start).count=0;
  };

  //pthread_t t;
  /* fire off P processes */
  for (i=1; i<P; i++) {
    {
      pthread_t t;
      pthread_create(&t, NULL, (SlaveStart), NULL);
      //pthread_detach(t);
    };
  }
  SlaveStart();
  //  pthread_exit(0);
  //  pthread_join(0, 0);
  //  codeWrapping();


  {exit(0);};
}

//atomic_section_begin();
int atomic_cmpxchg(int oldcount, int newcount)
{

  int temp, updatedcount;
  temp = (Global->start).count;
  //noScheduling(); 
  if(oldcount == temp)
  {
    (Global->start).count = newcount;
    //noScheduling(); 
    updatedcount = oldcount;// updatedcount == oldcount, update succeeds.
  }
  else
  {
    updatedcount = (Global->start).count; // updatedcount != oldcount, update fails.
    //noScheduling(); 
  }
  return updatedcount;
}

void foo(int id)
{
  if(id > 2)
    printf("id > 2\n");
}

//atomic_section_end();
void Criteria(int id);
void SlaveStart()
{
  int i;
  int j;
  int MyNum;
  double error;
  double *upriv;
  int initdone; 
  int finish; 
  int l_transtime=0;
  int MyFirst; 
  int MyLast;
  printf("%d\n", pthread_self());
  {pthread_mutex_lock(&(Global->idlock));};
  MyNum = Global->id;
  Global->id++;
  {pthread_mutex_unlock(&(Global->idlock));};

 foo(Global->id); 

  /* POSSIBLE ENHANCEMENT:  Here is where one might pin processes to
     processors to avoid migration */

  {
#if 0
    asm("sfence");
#endif
    int lsense = (Global->start).gsense;
    while (1) {
      int oldcount = (Global->start).count;
      int newcount = oldcount + lsense;
      int updatedcount, retVal;

      //atomic_section_begin();
      updatedcount = atomic_cmpxchg(oldcount, newcount);
      //atomic_section_end();

      if (updatedcount == oldcount) {
        if ((newcount == (P) && lsense == 1) || (newcount == 0 && lsense == -1))
        {
          (Global->start).gsense = -lsense;
          Criteria(1);
        }
        break;
      }
    }
    while ((Global->start).gsense == lsense)
      ;
    Criteria(1);
#if 0
    asm("lfence");
#endif
  }
  ;
}


