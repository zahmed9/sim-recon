#ifndef FTRACK_STRUCT_H
#define FTRACK_STRUCT_H

#include "const.h"

/*
  Track parametrization in f form (forward track)

  The parametrization expresses the x,y positions and their slopes
  as a function of z. It is useful for the case where a particle moves
  in the forward direction.

   -------------------------------------------------------
   WARNING: if you change this file, also make sure you change 
            ftrack_struct.inc !
   -------------------------------------------------------- 
*/

#define FTRACK_NPAR  5

static const int FTRACK_WORD     = 9*FLOAT_WORD;
static const int FTRACK_COV_SIZE = FTRACK_NPAR*FTRACK_NPAR*FLOAT_WORD;

typedef struct _ftrack_s *ftrack_ptr;

typedef struct _ftrack_s {
  double  alpha;   /* 1/Pz */
  double  xslp;    /* x' = dx/dz at z = zp */
  double  yslp;    /* y' = dy/dz at z = zp */
  double  xp;      /* x at z = zp */
  double  yp;      /* y at z = zp */
  double  zp;      /* z position of reference plane */
  double  pt;      /* Pt = sqrt(px**2 + py**2) */
  double  p;       /* Momentum */
  double  q;       /* Charge */
} ftrack_s; 

static const int jfalpha = 0;
static const int jfxslp  = 1;
static const int jfyslp  = 2;
static const int jfxp    = 3;
static const int jfyp    = 4;

#endif

/*
 * $Id$
 *
 * $Log$
 * Revision 1.1  2000/06/19 19:58:36  eugenio
 * Initial revision
 *
 * Revision 1.2  1998/11/11 03:40:43  kutschke
 * Define FTRACK_NPAR, FTRACK_COV_SIZE, new style for FTRACK_WORD.
 *
 * Revision 1.1  1998/09/15  04:19:45  kutschke
 * New file.
 *
 *
 */
