#ifndef WTRACK_STRUCT_H
#define WTRACK_STRUCT_H

/*
 *  There is another file in which this structure and its associated
 *  constants are defined and, for historical reasons, it sometimes gets 
 *  included along with this one - so protect against it.
 *
 *  This should be a temporary fix.
 *
 */

#ifndef _new_wtrack_struct_INC

#include "const.h"

/* -------------------------------------------------------
   WARNING: if you change this file, also make sure you change 
             wtrack_struct.hh and wtrack_struct.inc !
   -------------------------------------------------------- 
*/

#define WTRACK_WORD 10*FLOAT_WORD
#define WTRACK_NPAR 7

typedef struct _wtrack_s *wtrack_ptr;

typedef struct _wtrack_s {
  double px; /* Px */
  double py; /* Py */
  double pz; /* Pz */
  double e;  /* E */
  double x;  /* x */
  double y;  /* y */
  double z;  /* z */
  double pt; /* Pt = sqrt(px**2 + py**2) */
  double p;  /* Momentum */
  double q;  /* Charge */
} wtrack_s;

static const int jwpx = 0; /*  */
static const int jwpy = 1; /*  */
static const int jwpz = 2; /*  */
static const int jwe  = 3; /*  */
static const int jwx  = 4; /*  */
static const int jwy  = 5; /*  */
static const int jwz  = 6; /*  */

/* For backward compatibility. */
typedef wtrack_s wtrack_struct;

#endif

#endif

/*
 * $Id$
 *
 * $Log$
 * Revision 1.1  2000/06/19 19:58:38  eugenio
 * Initial revision
 *
 * Revision 1.2  1998/11/11 04:00:04  kutschke
 * Define WTRACK_NPAR and wtrack_ptr.
 *
 * Revision 1.1  1998/09/15  04:19:40  kutschke
 * New file.
 *
 *
 */
