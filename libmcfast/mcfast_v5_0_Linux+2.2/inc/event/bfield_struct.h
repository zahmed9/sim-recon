#ifndef BFIELD_STRUCT_H
#define BFIELD_STRUCT_H

/* 

   Description of a magnetic field.

   -------------------------------------------------------
   WARNING: if you change this file, also make sure you change 
            bfield_struct.hh and bfield_struct.inc !
   -------------------------------------------------------- 

*/

#include "const.h"

typedef struct bfield_struct{
      double bmag;     /* Signed magnitude of field*/ 
      double  bdir[3]; /* Direction cosines of field */ 
      int  type;       /* Type of field (used by routines for special cases)*/
                       /*  The value is bit encoded as follows*/
                       /*       0 => no field              */
                       /*       1 => along x axis          */
                       /*       2 => along y axis          */
                       /*       3 => in (x,y) plane        */
                       /*       4 => along z axis          */
                       /*       5 => in (x,z) plane        */
                       /*       6 => in (y,z) plane        */
                       /*       7 => in arbitrary direction*/
      int devtype;     /*       1 => solenoid*/
                       /*       2 => dipole*/
      int devnum;      /*       Device number*/
      int dummy;       /* pad to align structure*/
}bFieldStruct;

#endif

/*
 * $Id$
 *
 * $Log$
 * Revision 1.1  2000/06/19 19:58:36  eugenio
 * Initial revision
 *
 * Revision 1.2  1999/11/17 16:54:04  mcbride
 * added pad to align structure
 *
 * Revision 1.1  1998/09/15  04:20:03  kutschke
 * New file.
 *
 *
 */
