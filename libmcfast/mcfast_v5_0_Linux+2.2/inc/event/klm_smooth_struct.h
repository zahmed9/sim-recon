#ifndef KLM_SMOOTH_STRUCT_H
#define KLM_SMOOTH_STRUCT_H

/*

   -------------------------------------------------------------------

   WARNING: if you change this file, also change klm_smooth_struct.inc

   -------------------------------------------------------------------

   Rob Kutschke, Oct. 22, 1998.

   Information about the smoothed track parameters and residuals.

   Notes:
   (1) The error on the residual has two contributions.  If the
       local hit was not used in the fit then the error on the
       residual is simply,
       sr1**2 = err1**2 + sm1**2.
       where err1 is the error on the local measurement and where
       sr1 and sm1 are defined below.
       If the local hit was used in the fit then the error on the
       residual is,
       sr1**2 = err1**2 - sm1**2.
       Note the sign change.  This is guaranteed to be positive
       ( ignoring problems from finite precision ) since sm1 contains
       more information than just the local hit.

 */

#include "ftrack_struct.h"


typedef struct Klm_smooth_s *Sptr;

typedef struct Klm_smooth_s{
   ftrack_s   f;              /* The track parameters in the neighbourhood
                                 of the point. */
   DFLOAT     fcov[5][5];     /* The covariance matrix of f. */

                              /* For 1D measurements.                       */
   DFLOAT         m1;         /* The fitted value of the measured quantity. */
   DFLOAT        sm1;         /* The error**2 on m1.                        */
   DFLOAT         r1;         /* The residual.                              */
   DFLOAT        sr1;         /* The total error**2 on r1.                  */

                              /* For 2D measurements:                       */
   DFLOAT      m2[2];         /* The fitted value of the measured quantity. */
   DFLOAT     sm2[2][2];      /* The error**2 on m2                         */
   DFLOAT      r2[2];         /* The residual.                              */
   DFLOAT     sr2[2][2];      /* The total error**2 on r2.                  */
   int        error;          /* If non-zero then an error occured
                                 either in the smoothing, in the computation 
                                 of the residual or in the computation of
                                 the error in the residual.                 */
   int        hit_in_fit;     /* If TRUE then the local hit was used in 
                                 the track fit to obtain f.                 */
} klm_smooth_s;

#endif
