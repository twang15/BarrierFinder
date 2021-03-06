 





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
#include "box.h"
#include "partition_grid.h"
#include "cost_zones.h"

#define NUM_DIRECTIONS 4

typedef enum { RIGHT, LEFT, UP, DOWN } direction;

static int Child_Sequence[NUM_DIRECTIONS][NUM_OFFSPRING] = 
{
   { 0, 1, 2, 3 },
   { 2, 3, 0, 1 },
   { 0, 3, 2, 1 },
   { 2, 1, 0, 3 },
};
static int Direction_Sequence[NUM_DIRECTIONS][NUM_OFFSPRING] =
{
   { UP, RIGHT, RIGHT, DOWN },
   { DOWN, LEFT, LEFT, UP },
   { RIGHT, UP, UP, LEFT },
   { LEFT, DOWN, DOWN, RIGHT },
};

void ComputeSubTreeCosts(int my_id, box *b);
void CostZonesHelper(int my_id, box *b, int work, direction dir);
extern void Criteria(int id);
extern int atomic_cmpxchg(int oldcount, int newcount); 


void
CostZones (int my_id)
{
   int i;
   box *b;
  
   PartitionIterate(my_id, ComputeSubTreeCosts, BOTTOM);
   {
#if 0
     asm("sfence");
#endif
     int lsense = (G_Memory->synch).gsense;
     while (1) {
       int oldcount = (G_Memory->synch).count;
       int newcount = oldcount + lsense;
       int updatedcount, retVal;

       //atomic_section_begin();
       updatedcount = atomic_cmpxchg(oldcount, newcount);
       //atomic_section_end();
       if (updatedcount == oldcount) {
         if ((newcount == (Number_Of_Processors) && lsense == 1) || (newcount == 0 && lsense == -1))
         {
           (G_Memory->synch).gsense = -lsense;
           Criteria(12);
         }
         break;
       }
     }
     while ((G_Memory->synch).gsense == lsense)
       ;
     Criteria(12);
#if 0
     asm("lfence");
#endif
   }
   ;
  // Local[my_id].Total_Work = Grid->subtree_cost;
   Local[my_id].Min_Work = ((Local[my_id].Total_Work / Number_Of_Processors)
			   * my_id);
   if (my_id == (Number_Of_Processors - 1))
      Local[my_id].Max_Work = Local[my_id].Total_Work;
   else
      Local[my_id].Max_Work = (Local[my_id].Min_Work
			      + (Local[my_id].Total_Work
				 / Number_Of_Processors));
   InitPartition(my_id);
   //CostZonesHelper(my_id, Grid, 0, RIGHT);
   {
#if 0
     asm("sfence");
#endif
     int lsense = (G_Memory->synch).gsense;
     while (1) {
       int oldcount = (G_Memory->synch).count;
       int newcount = oldcount + lsense;
       int updatedcount, retVal;

       //atomic_section_begin();
       updatedcount = atomic_cmpxchg(oldcount, newcount);
       //atomic_section_end();
       if (updatedcount == oldcount) {
         if ((newcount == (Number_Of_Processors) && lsense == 1) || (newcount == 0 && lsense == -1))
         {
           (G_Memory->synch).gsense = -lsense;
           Criteria(13);
         }
         break;
       }
     }
     while ((G_Memory->synch).gsense == lsense)
       ;
     Criteria(13);
#if 0
     asm("lfence");
#endif
   }
   ;
}


void
ComputeSubTreeCosts (int my_id, box *b)
{
   box *pb;
   box *sb;
   int i;
   box *cb;

   if (b->type == PARENT) {
      while (b->interaction_synch != b->num_children) {
      }
   }
   b->interaction_synch = 0;
   ComputeCostOfBox(my_id, b);
   b->subtree_cost += b->cost;
   pb = b->parent;
   if (pb != NULL) {
      {pthread_mutex_lock(&(G_Memory->lock_array)[(pb->exp_lock_index)]);};
      pb->subtree_cost += b->subtree_cost;
      pb->interaction_synch += 1;
      {pthread_mutex_unlock(&(G_Memory->lock_array)[(pb->exp_lock_index)]);};
   }
}


void
CostZonesHelper (int my_id, box *b, int work, direction dir)
{
   box *cb;
   int i;
   int parent_cost;
   int *next_child;
   int *child_dir;

   if (b->type == CHILDLESS) {
      if (work >= Local[my_id].Min_Work)
	 InsertBoxInPartition(my_id, b);
   }
   else {
      next_child = Child_Sequence[dir];
      child_dir = Direction_Sequence[dir];
      for (i = 0; (i < NUM_OFFSPRING) && (work < Local[my_id].Max_Work);
	   i++) {
	 cb = b->children[next_child[i]];
	 if (cb != NULL) {
	    if ((work + cb->subtree_cost) >= Local[my_id].Min_Work)
	       CostZonesHelper(my_id, cb, work, child_dir[i]);
	    work += cb->subtree_cost;
	 }
	 if (i == 2) {
	    if ((work >= Local[my_id].Min_Work)
		&& (work < Local[my_id].Max_Work))
	       InsertBoxInPartition(my_id, b);
	    work += b->cost;
	 }
      }
   }

}


#undef DOWN
#undef UP
#undef LEFT
#undef RIGHT
#undef NUM_DIRECTIONS

