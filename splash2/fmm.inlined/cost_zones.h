 





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

#ifndef _Cost_Zones_H
#define _Cost_Zones_H 1

typedef enum { RIGHT, LEFT, UP, DOWN } direction;
extern void CostZones(int my_id);
extern void CostZones_1(int my_id);
extern void CostZones_2(int my_id);
extern void ComputeSubTreeCosts(int my_id, box *b);
extern void CostZonesHelper(int my_id, box *b, int work, direction dir);
#endif /* _Cost_Zones_H */
