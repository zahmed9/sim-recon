#ifndef PRIM_VERTEX_H
#define PRIM_VERTEX_H 

/*

   Rob Kutschke, Sept 24, 1998.

   Generated primary vertex positions for each interaction in this
   beam crossing.

   -------------------------------------------------------

   WARNING: if you change this file, also make sure you change 
            prim_vertex.inc !

   -------------------------------------------------------- 

*/

#include "c_fortran_types.h"

#define PRIM_MAXVTX 100

extern struct prim_vertex {
   int    prim_numvtx;                     /* Number of primary vertices. */
   int    idm_pmvt;                        /* Alignment dummy.            */
   DFLOAT prim_vertex[PRIM_MAXVTX][4];     /* Primary vertex (cm).        */
} prim_vertex_c_;

#endif
/*
 *  $Id$
 *
 *  $Log$
 *  Revision 1.1  2000/06/19 19:58:38  eugenio
 *  Initial revision
 *
 *  Revision 1.1  1998/09/25 02:51:24  kutschke
 *  New file.  Derived from prim_vertex.inc.
 *
 *
 */
