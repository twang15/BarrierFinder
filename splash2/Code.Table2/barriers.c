lu

init:
	 gsense=1;
 	 counter=0;
 	 
barrier:
  /* barrier to ensure all initialization is done */
  {
    int lsense = gsense;
    while (1) {
      int oldcount = counter;
      int newcount = oldcount + lsense;
      int updatedcount, retVal;

      //atomic_section_begin();
      updatedcount = atomic_cmpxchg(oldcount, newcount);
      //atomic_section_end();

      if (updatedcount == oldcount) {
        if ((newcount == (P) && lsense == 1) || (newcount == 0 && lsense == -1))
        {
          gsense = -lsense;
          Criteria(1);
        }
        break;
      }
    }
    while (gsense == lsense)
      ;
    Criteria(1);
#if 0
    asm("lfence");
#endif
  }
  
v1_atomic_reusable: all fine
init:
	 gsense=1;
 	 counter=0;
 	 
barrier:
  /* barrier to ensure all initialization is done */
  {
    int lsense = gsense;
    while (1) {
      int oldcount = counter;
      int newcount = oldcount + 1;
      int updatedcount, retVal;

      //atomic_section_begin();
      updatedcount = atomic_cmpxchg(oldcount, newcount);
      //atomic_section_end();

      if (updatedcount == oldcount) {
        if (newcount == P)
        {
		      counter=0;
          gsense = 1 - gsense;
          Criteria(1);
        }
        break;
      }
    }
    while (gsense == lsense)
      ;
    Criteria(1);
  }
  
v8_atomic_nonreusable: the second barrier can all be blocked
init:
	 gsense=1;
 	 counter=0;
 	 
barrier:
  /* barrier to ensure all initialization is done */
  {
    int lsense = gsense;
    while (1) {
      int oldcount = counter;
      int newcount = oldcount + 1;
      int updatedcount, retVal;

      //atomic_section_begin();
      updatedcount = atomic_cmpxchg(oldcount, newcount);
      //atomic_section_end();

      if (updatedcount == oldcount) {
        if (newcount == P)
        {
          gsense = 1 - gsense;
          Criteria(1);
		      counter=0;
        }
        break;
      }
    }
    while (gsense == lsense)
      ;
    Criteria(1);
  }
  
v2_atomic_nonreusable: the second barrier will simply go through
init:
	 gsense=1;
 	 counter=0;
 	 
barrier:
  /* barrier to ensure all initialization is done */
  {
    int lsense = 1;
    lsense = 1 -lsense;
    while (1) {
      int oldcount = counter;
      int newcount = oldcount + 1;
      int updatedcount, retVal;

      //atomic_section_begin();
      updatedcount = atomic_cmpxchg(oldcount, newcount);
      //atomic_section_end();

      if (updatedcount == oldcount) {
        if (newcount == P)
        {
		      counter=0;
          gsense = lsense;
          Criteria(1);
        }
        break;
      }
    }
    while (gsense != lsense)
      ;
    Criteria(1);
  }
  
  
v8'_atomic_nonreusable: the second barrier will simply go through
init:
	 gsense=1;
 	 counter=0;
 	 
barrier:
  /* barrier to ensure all initialization is done */
  {
    int lsense = 1;
    lsense = 1 -lsense;
    while (1) {
      int oldcount = counter;
      int newcount = oldcount + 1;
      int updatedcount, retVal;

      //atomic_section_begin();
      updatedcount = atomic_cmpxchg(oldcount, newcount);
      //atomic_section_end();

      if (updatedcount == oldcount) {
        if (newcount == P)
        {
          gsense = lsense;
          Criteria(1);
		      counter=0;
        }
        break;
      }
    }
    while (gsense != lsense)
      ;
    Criteria(1);
  }
  
  
  //v1: a simple barrier using an atomic counter
//1. The original code uses
//   while(lsense != gsense) as the busy-wait, which is apparently wrong.
//2. counter update is atomic but the author does not mention whether
//   counter read (counter == n) is also atomic. If not atomic,
//   the barrier is incorrect. E.g, all processes performs counter
//   update first, and then all will execute the if statement and
//   there will be data race on counter/gsense. Worse, gsense final
//   value may still equal to lsense and result in deadlock.
int gsense = 0;
int counter = 0; //{0, 1, 2, ..., n}

void barrier_v1()
{
  int lsense=gsense;
  counter = counter + 1;
  if (counter == n)
  {
    counter = 0;
    gsense = 1 - gense;
  }

  while(lsense == gsense);
}

//v5: an errorneous atomic counter-based barrier, not reusable.
//Reason: (t1 t2 t3)
//  1. t1 t2 t3 increment counter
//  2. t1 executes if-statement, and set counter to 0
//  3. t1 goes to the next barrier and increment counter to 1
//  4. t2 t3 will be deadlocked at the first barrier
//
//OR
//  1. t1 t2 t3 increment counter
//  2. t1 t2 t3 enter if
//  3. t1 goes to the next barrier and increment counter to 1
//  4. t2 t3 set counter to 0 in the first barrier
//  5. t1 t2 t3 will be deadlocked at the second barrier because counter
//     will never be 3 (n) again.
int counter = 0; //{0...n}
void barrier_v5()
{
  counter = counter + 1;
  if(counter == n)
  {
    counter = 0;
  }

  while(counter != 0);
}
//after the counter is reset to 0, a fast process may increment it again
//before all the waiting processes get a chance to test it. This will
//result a deadlock.

v5_atomic_wrong: one blocked on barrier 1 and the other blocked on barrier 2
init:
 	 counter=0;
 	 
barrier:
  /* barrier to ensure all initialization is done */
  {
    while (1) {
      int oldcount = counter;
      int newcount = oldcount + 1;
      int updatedcount;

      //atomic_section_begin();
      updatedcount = atomic_cmpxchg(oldcount, newcount);
      //atomic_section_end();

      if (updatedcount == oldcount) {
        if (newcount == P)
        {
		      counter=0;
          Criteria(1);
        }
        break;
      }
    }
    while (counter != 0)
      ;
    Criteria(1);
  }

