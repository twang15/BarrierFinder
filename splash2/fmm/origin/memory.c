 





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

#include "defs.h"
#include "memory.h"


#include <pthread.h>
//#include "libittnotify.h"
#ifndef BARRIER_T
#define BARRIER_T
 typedef struct {
  volatile int gsense;
  volatile long count;    /* the count of entered processors */
} barrier_t;
#endif


g_mem *G_Memory;
local_memory Local[MAX_PROCS];

/*
 *  InitGlobalMemory ()
 *
 *  Args : none.
 *
 *  Returns : nothing.
 *
 *  Side Effects : Allocates all the global storage for G_Memory.
 *
 */
void
InitGlobalMemory ()
{
   int i;

   G_Memory = (g_mem *) malloc(sizeof(g_mem));;
   G_Memory->i_array = (int *) malloc(Number_Of_Processors * sizeof(int));;
   G_Memory->d_array = (double *) malloc(Number_Of_Processors
					 * sizeof(double));;
   if (G_Memory == NULL) {
      printf("Ran out of global memory in InitGlobalMemory\n");
      exit(-1);
   }
   G_Memory->count = 0;
   G_Memory->id = 0;
   {pthread_mutex_init(&(G_Memory->io_lock), NULL);};
   {pthread_mutex_init(&(G_Memory->mal_lock), NULL);};
   {pthread_mutex_init(&(G_Memory->single_lock), NULL);};
   {pthread_mutex_init(&(G_Memory->count_lock), NULL);};
   {int i; for (i = 0; i < (MAX_LOCKS); i++)
		  pthread_mutex_init(&((G_Memory->lock_array)[i]), NULL);};
   {
		(G_Memory->synch).gsense=1;
		(G_Memory->synch).count=0;
		};
   G_Memory->max_x = -MAX_REAL;
   G_Memory->min_x = MAX_REAL;
   G_Memory->max_y = -MAX_REAL;
   G_Memory->min_y = MAX_REAL;
}


