/* This test case is to drive inter-slice(r)'s development. 
 * It contains 2 slicing criteria in 2 functions.
 * c1 in f1, c2 in f2.
 * TC1:
 * main->f1 (c1)
 * main->f2 (c2)
 * 
 * TC2:
 * main->f1(c1)->f2(c2)
 *
 * TC3:
 * main->pthread_create(f1(c1))
 * main->f2(c2)
 *
 * TC4:
 * main->for->pthread_create(f1(c1))
 * main->f2(c2)
 *
 * Other factors: 
 * a. parameter
 * b. pointer
 *
 * Assumptions:
 * 1. FFT barrier in each function.
 * */
#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

#ifndef THREADS
#define THREADS 2
#endif

typedef struct {
  volatile int gsense;
  volatile long count;    /* the count of entered processors */
} barrier_t;

struct GlobalMemory {
  barrier_t start;
} *Global;

int P;

void Criteria(int id);
void f1(void);
void f2(void);

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
//atomic_section_end();

//atomic_section_begin();
int atomic_cmpxchg1(int oldcount, int newcount)
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
//atomic_section_end();

int main()
{
  int a, b;
  Global = (struct GlobalMemory *) malloc(sizeof(struct GlobalMemory));
  (Global->start).gsense = 1;
  (Global->start).count = 0;  
  P = THREADS;

  f1();
  
  //irrelevant code.
  if(a+b)
  {
    exit(0);
  }

  while(b)
  {
    a++;
  }

  f2();

  //more irrelevant code.
  a = a+b;
  if(a > 2)
  {
    printf("a is greater than 2\n");
    a=3;
  }
  else
  {
    printf("less than 2\n");
  }

  return 0;
}

void f1(void)
{
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


void f2(void)
{
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
      updatedcount = atomic_cmpxchg1(oldcount, newcount);
      //atomic_section_end();

      if (updatedcount == oldcount) {
        if ((newcount == (P) && lsense == 1) || (newcount == 0 && lsense == -1))
        {
          (Global->start).gsense = -lsense;
          Criteria(2);
        }
        break;
      }
    }
    while ((Global->start).gsense == lsense)
      ;
   Criteria(2);
#if 0
    asm("lfence");
#endif
  }
  ;
}
