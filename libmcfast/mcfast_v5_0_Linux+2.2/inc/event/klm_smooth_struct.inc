#ifndef KLM_SMOOTH_STRUCT_INC
#define KLM_SMOOTH_STRUCT_INC
c
c   Information about the smoothed track parameters and residuals.
c
c ------------------------------------------------------------------
c
c WARNING: if you change this file, also change klm_smooth_struct.h
c
c ------------------------------------------------------------------
c
c   Rob Kutschke, Oct. 22, 1998.
c
c   Notes:
c   (1) The error on the residual has two contributions.  If the
c      local hit was not used in the fit then the error on the
c       residual is simply,
c       sr1**2 = err1**2 + sm1**2.
c       where err1 is the error on the local measurement and where
c       sr1 and sm1 are defined below.
c       If the local hit was used in the fit then the error on the
c       residual is,
c       sr1**2 = err1**2 - sm1**2.
c       Note the sign change.  This is guaranteed to be positive
c       ( ignoring problems from finite precision ) since sm1 contains
c       more information than just the local hit.
c
c
c
c f     - the track parameters valid in the neighbourhood of f.zp
c fcov  - the covariance matrix of f
c 
c For 1D measurements:
c m1    - the value of the measurement which was added to the fit
c sm1   - the error on m1
c r1    - the residual, (predicted-measured)
c sr1   - the error on the residual
c
c For 2D measurements:
c m2    - the value of the measurement which was added to the fit
c sm2   - the error on m1
c r2    - the residual, (predicted-measured)
c sr2   - the error on the residual
c
c error - If non-zero then an error occured either in the smoothing, in the 
c         computation of the residual or in the computation of the error 
c         in the residual.
c hit_in_fit - If 1 then the local hit was used in the track fit to obtain f
c              and fcov
c

#include "ftrack_struct.inc"

      structure /klm_smooth_s/
         record  /ftrack_struct/ f
         real*8  fcov(5,5)
         real*8  m1
         real*8  sm1
         real*8  r1
         real*8  sr1      
         real*8  m2(2)
         real*8  sm2(2,2)
         real*8  r2(2)
         real*8  sr2(2,2)
         integer error
         integer hit_in_fit
      end structure
c
c $Id$
c
c $Log$
c Revision 1.1  2000/06/19 19:58:37  eugenio
c Initial revision
c
c Revision 1.1  1999/08/30 18:55:03  kutschke
c First release.  Clone of the .h file.
c
c

#endif

