/*

   Rob Kutschke,  Oct 27, 1998.

   Compute the weighted average of two ftracks, represented at the
   same point.  The matrix equations are:

   v^{-1} = ( v_1^{-1} + v_2^{-1} )^{--}
   f      = v (  v_1^{-1} f_1 + v_2^{-1} f_2)

   where,
   input  f_1  - first set of input track parameters 
   input  f_2  - second set of input track parameters 
   input  v_1  - covariance matrix of f_1 
   input  v_2  - covariance matrix of f_2
   output f    - output track parameters
   output v    - covariance matrix of f

   Function value returned:
   0 - all OK
   1 - matrix inversion failed.
   2 - output f.alpha is zero

   The routine is coded such that the output and either one of the
   inputs may occupy the same storage.

 */

#include <sys/types.h>
#include <stdio.h>
#include <math.h>

#include "const.h"
#include "ftrack_struct.h"

#include "util_prototypes.h"
#include "cern_prototypes.h"

int klm_ftk_smooth ( 
         ftrack_ptr f1,                           /* Input,  see above. */
         DFLOAT     v1[FTRACK_NPAR][FTRACK_NPAR], /* Input,  see above. */
         ftrack_ptr f2,                           /* Input,  see above. */
         DFLOAT     v2[FTRACK_NPAR][FTRACK_NPAR], /* Input,  see above. */
         ftrack_ptr f,                            /* Output, see above. */
         DFLOAT     v[FTRACK_NPAR][FTRACK_NPAR])  /* Output, see above. */
{

  /* Inverses of input and output covariance matrices. */
  static DFLOAT i1[FTRACK_NPAR][FTRACK_NPAR];
  static DFLOAT i2[FTRACK_NPAR][FTRACK_NPAR];
  static DFLOAT  i[FTRACK_NPAR][FTRACK_NPAR];

  /* Temporary. */
  static DFLOAT t[FTRACK_NPAR];

  /* Return code. */
  int err;

  err = invert_sym_d_ ( v1, i1 );
  if ( err ) return err;

  err = invert_sym_d_ ( v2, i2 );
  if ( err ) return err;

  /* Matrix equation: i = i_1 + i_2 */
  i[0][0] = i1[0][0]+i2[0][0];
  i[0][1] = i1[0][1]+i2[0][1];
  i[0][2] = i1[0][2]+i2[0][2];
  i[0][3] = i1[0][3]+i2[0][3];
  i[0][4] = i1[0][4]+i2[0][4];

  i[1][1] = i1[1][1]+i2[1][1];
  i[1][2] = i1[1][2]+i2[1][2];
  i[1][3] = i1[1][3]+i2[1][3];
  i[1][4] = i1[1][4]+i2[1][4];

  i[2][2] = i1[2][2]+i2[2][2];
  i[2][3] = i1[2][3]+i2[2][3];
  i[2][4] = i1[2][4]+i2[2][4];

  i[3][3] = i1[3][3]+i2[3][3];
  i[3][4] = i1[3][4]+i2[3][4];

  i[4][4] = i1[4][4]+i2[4][4];

  i[4][0] = i[0][4];
  i[4][1] = i[1][4];
  i[4][2] = i[2][4];
  i[4][3] = i[3][4];

  i[3][0] = i[0][3];
  i[3][1] = i[1][3];
  i[3][2] = i[2][3];

  i[2][0] = i[0][2];
  i[2][1] = i[1][2];

  i[1][0] = i[0][1];

  /* Matrix equation: v_1^{-1} f_1 + v_2^{-1} f_2. */
  t[0] = i1[0][0]*f1->alpha + i2[0][0]*f2->alpha +
         i1[0][1]*f1->xslp  + i2[0][1]*f2->xslp  +
         i1[0][2]*f1->yslp  + i2[0][2]*f2->yslp  +
         i1[0][3]*f1->xp    + i2[0][3]*f2->xp    +
         i1[0][4]*f1->yp    + i2[0][4]*f2->yp;

  t[1] = i1[1][0]*f1->alpha + i2[1][0]*f2->alpha +
         i1[1][1]*f1->xslp  + i2[1][1]*f2->xslp  +
         i1[1][2]*f1->yslp  + i2[1][2]*f2->yslp  +
         i1[1][3]*f1->xp    + i2[1][3]*f2->xp    +
         i1[1][4]*f1->yp    + i2[1][4]*f2->yp;

  t[2] = i1[2][0]*f1->alpha + i2[2][0]*f2->alpha +
         i1[2][1]*f1->xslp  + i2[2][1]*f2->xslp  +
         i1[2][2]*f1->yslp  + i2[2][2]*f2->yslp  +
         i1[2][3]*f1->xp    + i2[2][3]*f2->xp    +
         i1[2][4]*f1->yp    + i2[2][4]*f2->yp;

  t[3] = i1[3][0]*f1->alpha + i2[3][0]*f2->alpha +
         i1[3][1]*f1->xslp  + i2[3][1]*f2->xslp  +
         i1[3][2]*f1->yslp  + i2[3][2]*f2->yslp  +
         i1[3][3]*f1->xp    + i2[3][3]*f2->xp    +
         i1[3][4]*f1->yp    + i2[3][4]*f2->yp;

  t[4] = i1[4][0]*f1->alpha + i2[4][0]*f2->alpha +
         i1[4][1]*f1->xslp  + i2[4][1]*f2->xslp  +
         i1[4][2]*f1->yslp  + i2[4][2]*f2->yslp  +
         i1[4][3]*f1->xp    + i2[4][3]*f2->xp    +
         i1[4][4]*f1->yp    + i2[4][4]*f2->yp;

  /* Compute the final output. */
  err = invert_sym_d_ ( i, v );
  if ( err ) return err;

  f->alpha = v[0][0]*t[0] + v[0][1]*t[1] + v[0][2]*t[2] +
             v[0][3]*t[3] + v[0][4]*t[4];

  f->xslp  = v[1][0]*t[0] + v[1][1]*t[1] + v[1][2]*t[2] +
             v[1][3]*t[3] + v[1][4]*t[4];

  f->yslp  = v[2][0]*t[0] + v[2][1]*t[1] + v[2][2]*t[2] +
             v[2][3]*t[3] + v[2][4]*t[4];

  f->xp    = v[3][0]*t[0] + v[3][1]*t[1] + v[3][2]*t[2] +
             v[3][3]*t[3] + v[3][4]*t[4];

  f->yp    = v[4][0]*t[0] + v[4][1]*t[1] + v[4][2]*t[2] +
             v[4][3]*t[3] + v[4][4]*t[4];

  if ( f->alpha == 0. ) return 2;

  f->p  = sqrt( 1. + f->xslp*f->xslp + f->yslp*f->yslp)/fabs(f->alpha);
  f->pt = sqrt(      f->xslp*f->xslp + f->yslp*f->yslp)/fabs(f->alpha);
  f->q  = f1->q;
  f->zp = f1->zp;

  return 0;

}
