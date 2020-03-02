 





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
/*  Integer radix sort of non-negative integers.                         */
/*                                                                       */
/*  Command line options:                                                */
/*                                                                       */
/*  -pP : P = number of processors.                                      */
/*  -rR : R = radix for sorting.  Must be power of 2.                    */
/*  -nN : N = number of keys to sort.                                    */
/*  -mM : M = maximum key value.  Integer keys k will be generated such  */
/*        that 0 <= k <= M.                                              */
/*  -s  : Print individual processor timing statistics.                  */
/*  -t  : Check to make sure all keys are sorted correctly.              */
/*  -o  : Print out sorted keys.                                         */
/*  -h  : Print out command line options.                                */
/*                                                                       */
/*  Default: RADIX -p1 -n262144 -r1024 -m524288                          */
/*                                                                       */
/*  Note: This version works under both the FORK and SPROC models        */
/*                                                                       */
/*************************************************************************/

#include <stdio.h>
#include <math.h>

#define DEFAULT_P                    2
//#define DEFAULT_P                    1
//#define DEFAULT_N               262144
#define DEFAULT_N               4
#define DEFAULT_R                 1024 
#define DEFAULT_M               524288
#define MAX_PROCESSORS              64    
#define RADIX_S                8388608.0e0
#define RADIX           70368744177664.0e0
#define SEED                 314159265.0e0
#define RATIO               1220703125.0e0
#define PAGE_SIZE                 4096
#define PAGE_MASK     (~(PAGE_SIZE-1))
#define MAX_RADIX                 4096


#include <pthread.h>
//#include "libittnotify.h"
#ifndef BARRIER_T
#define BARRIER_T
 typedef struct {
  volatile int gsense;
  volatile long count;    /* the count of entered processors */
} barrier_t;
#endif


struct prefix_node {
   int densities[MAX_RADIX];
   int ranks[MAX_RADIX];
   int (done); 
   char pad[PAGE_SIZE];
};

struct global_memory {
   int Index;                             /* process ID */
   pthread_mutex_t (lock_Index);                    /* for fetch and add to get ID */
   pthread_mutex_t (rank_lock);                     /* for fetch and add to get ID */
   pthread_mutex_t (section_lock)[(MAX_PROCESSORS)];  /* key locks */
   barrier_t (barrier_rank);                   /* for ranking process */
   barrier_t (barrier_key);                    /* for key sorting process */
   double *ranktime;
   double *sorttime;
   double *totaltime;
   int final;
   unsigned int starttime;
   unsigned int rs;
   unsigned int rf;
   struct prefix_node prefix_tree[2 * MAX_PROCESSORS];
} *global;

struct global_private {
  char pad[PAGE_SIZE];
  int *rank_ff;         /* overall processor ranks */
} gp[MAX_PROCESSORS];

int *key[2];            /* sort from one index into the other */
int **rank_me;          /* individual processor ranks */
int *key_partition;     /* keys a processor works on */
int *rank_partition;    /* ranks a processor works on */

int number_of_processors = DEFAULT_P;
int max_num_digits;
int radix = DEFAULT_R;
int num_keys = DEFAULT_N;
int max_key = DEFAULT_M;
int log2_radix;
int log2_keys;
int dostats = 0;
int test_result = 0;
int doprint = 0;

double ran_num_init(unsigned int,double,double);
double product_mod_46(double,double);
int get_max_digits(int);
int get_log2_radix(int);
int get_log2_keys(int);
void slave_sort();
int log_2(int);
void printerr(char *);
void init(int,int,int);
void test_sort(int);
void printout();

//atomic_section_begin();
int atomic_cmpxchg(int oldcount, int newcount)
{

  int temp, updatedcount;
  temp = (global->barrier_key).count;
  //noScheduling(); 
  if(oldcount == temp)
  {
    (global->barrier_key).count = newcount;
    //noScheduling(); 
    updatedcount = oldcount;// updatedcount == oldcount, update succeeds.
  }
  else
  {
    updatedcount = (global->barrier_key).count; // updatedcount != oldcount, update fails.
    //noScheduling(); 
  }
  return updatedcount;
}
//atomic_section_end();

void Criteria(int id);

main(argc, argv)

int argc;
char **argv;

{
   int i;
   int p;
   int quotient;
   int remainder;
   int sum_i; 
   int sum_f;
   int mistake=0;
   int size;
   int **temp;
   int **temp2;
   int *a;
   int c;
   int n1;
   extern char *optarg;
   double mint, maxt, avgt;
   double minrank, maxrank, avgrank;
   double minsort, maxsort, avgsort;
   unsigned int start;
   int done = 0;
   int start_p;
   int end_p;
   int level;
   int index;
   int base;
   int offset;
   int toffset;
   int *key0, *key1;

#if 0
   {long time(); (start) = time(0);}

   while ((c = getopt(argc, argv, "p:r:n:m:stoh")) != -1) {
     switch(c) {
      case 'p': number_of_processors = atoi(optarg);
                if (number_of_processors < 1) {
                  printerr("P must be >= 1\n");
                  exit(-1);
                }
                if (number_of_processors > MAX_PROCESSORS) {
                  printerr("Maximum processors (MAX_PROCESSORS) exceeded\n"); 
		  exit(-1);
		}
                break;
      case 'r': radix = atoi(optarg);
                if (radix < 1) {
                  printerr("Radix must be a power of 2 greater than 0\n");
                  exit(-1);
                }
                log2_radix = log_2(radix);
                if (log2_radix == -1) {
                  printerr("Radix must be a power of 2\n");
                  exit(-1);
                }
                break;
      case 'n': num_keys = atoi(optarg);
                if (num_keys < 1) {
                  printerr("Number of keys must be >= 1\n");
                  exit(-1);
                }
                break;
      case 'm': max_key = atoi(optarg);
                if (max_key < 1) {
                  printerr("Maximum key must be >= 1\n");
                  exit(-1);
                }
                break;
      case 's': dostats = !dostats;
                break;
      case 't': test_result = !test_result;
                break;
      case 'o': doprint = !doprint;
                break;
      case 'h': printf("Usage: RADIX <options>\n\n");
                printf("   -pP : P = number of processors.\n");
                printf("   -rR : R = radix for sorting.  Must be power of 2.\n");
                printf("   -nN : N = number of keys to sort.\n");
                printf("   -mM : M = maximum key value.  Integer keys k will be generated such\n");
                printf("         that 0 <= k <= M.\n");
                printf("   -s  : Print individual processor timing statistics.\n");
                printf("   -t  : Check to make sure all keys are sorted correctly.\n");
                printf("   -o  : Print out sorted keys.\n");
                printf("   -h  : Print out command line options.\n\n");
                printf("Default: RADIX -p%1d -n%1d -r%1d -m%1d\n",
                        DEFAULT_P,DEFAULT_N,DEFAULT_R,DEFAULT_M);
		exit(0);
     }
   }

   {;}
#endif
   //log2_radix = log_2(radix); 
   //log2_keys = log_2(num_keys);
   //global = (struct global_memory *) malloc(sizeof(struct global_memory));
   
   //key0 = (int *) malloc(num_keys*sizeof(int));;
   //key[0] = key0;
   key[0] = (int *) malloc(num_keys*sizeof(int));
   key[1] = (int *) malloc(num_keys*sizeof(int));;
#if 0
   //key1 = (int *) malloc(num_keys*sizeof(int));;
   //key[1] = key1;
   key_partition = (int *) malloc((number_of_processors+1)*sizeof(int));;
   //key_partition = (int *) malloc(num_keys*sizeof(int));;
   
   //key[0] = key_partition;
   rank_partition = (int *) malloc((number_of_processors+1)*sizeof(int));;
   global->ranktime = (double *) malloc(number_of_processors*sizeof(double));;
   global->sorttime = (double *) malloc(number_of_processors*sizeof(double));;
   global->totaltime = (double *) malloc(number_of_processors*sizeof(double));;
   size = number_of_processors*(radix*sizeof(int)+sizeof(int *));
   rank_me = (int **) malloc(size);;
#endif
#if 1
   if ((key[0] == NULL) || (key[1] == NULL)) {
     fprintf(stderr,"ERROR: Cannot malloc enough memory\n");
     exit(-1); 
   }
   global = (struct global_memory *) malloc(sizeof(struct global_memory));
//   if ((global == NULL) || (key[0] == NULL) || (key[1] == NULL) ||
//       (key_partition == NULL) || (rank_partition == NULL) || 
//       (rank_me == NULL)) {
//     fprintf(stderr,"ERROR: Cannot malloc enough memory\n");
//     exit(-1); 
//   }
#else
   if ((global == NULL)
       || (rank_me == NULL)
       || (key_partition == NULL)
       || (rank_partition == NULL)
      )
    // if((key[0] == NULL) || (key[1] == NULL)
    //  )
     //|| (key[0] == NULL) || (key[1] == NULL) ||
     //  (key_partition == NULL) || (rank_partition == NULL) || 
     //  (rank_me == NULL)) 
   {
     fprintf(stderr,"ERROR: Cannot malloc enough memory\n");
     exit(-1); 
   }
#endif

   {
		(global->barrier_key).gsense=1;
		(global->barrier_key).count=0;
		}
   
   
   for (i = 1; i < number_of_processors; i++) {
      {
pthread_t t;
pthread_create(&t, NULL, (slave_sort), NULL);
}
   }

   slave_sort();

}

void slave_sort()
{
   int i, j, k, kk, Ind;
   int MyNum;
   int this_key;
   int tmp;
   int last_key;
   int loopnum;
   double ran_num;
   double sum;
   int shiftnum;
   int bb;
   int my_key;
   int key_start;
   int key_stop;
   int rank_start;
   int rank_stop;
   int from=0;
   int to=1;
   int *key_density;       /* individual processor key densities */
   unsigned int time1;
   unsigned int time2;
   unsigned int time3;
   unsigned int time4;
   unsigned int time5;
   unsigned int time6;
   double ranktime=0;
   double sorttime=0;
   int *key_from;
   int *key_to;
   int *rank_me_mynum;
   int *rank_me_i;
   int *rank_ff_mynum;
   int stats;
   struct prefix_node* n;
   struct prefix_node* r;
   struct prefix_node* l;
   struct prefix_node* my_node;
   struct prefix_node* their_node;
   volatile int* prefx;
   int index;
   int level;
   int base;
   int offset;

  {
#if 0
    asm("sfence");
#endif
    int lsense = (global->barrier_key).gsense;
    while (1) {
      int oldcount = (global->barrier_key).count;
      int newcount = oldcount + lsense;
      int updatedcount, retVal;

      //atomic_section_begin();
      updatedcount = atomic_cmpxchg(oldcount, newcount);
      //atomic_section_end();

      if (updatedcount == oldcount) {
        if ((newcount == (number_of_processors) && lsense == 1) || (newcount == 0 && lsense == -1))
        {
          (global->barrier_key).gsense = -lsense;
          Criteria(1);
        }
        break;
      }
    }
    while ((global->barrier_key).gsense == lsense)
      ;
    Criteria(1);
#if 0
    asm("lfence");
#endif
  }
  ;
} 
