#ifndef FTRACK_STRUCT
#define FTRACK_STRUCT

c Track parametrization in f form (forward track)

c The parametrization expresses the x,y positions and their slopes
c as a function of z. It is useful for the case where a particle moves
c in the forward direction.

c -------------------------------------------------------------
c WARNING: if you change this file, also make sure you change 
c          ftrack_struct.h !
c -------------------------------------------------------------

#include "const.inc"

      integer FTRACK_WORD, FTRACK_NPAR
      parameter (FTRACK_WORD = 9*FLOAT_WORD)
      parameter (FTRACK_NPAR = 5           )

      structure /ftrack_struct/
        DFLOAT alpha   !1/Pz
        DFLOAT xslp    !x' = dx/dz at z = zp
        DFLOAT yslp    !y' = dy/dz at z = zp
        DFLOAT xp      !x at z = zp
        DFLOAT yp      !y at z = zp
        DFLOAT zp      !z position of reference plane
        DFLOAT pt      !Pt = sqrt(px**2 + py**2)
        DFLOAT p       !Momentum
        DFLOAT q       !Charge
      end structure

c     Constants to identify locations in forward track covariance matrix

      integer jfalpha, jfxslp, jfyslp, jfxp, jfyp
      parameter (jfalpha = 1)
      parameter (jfxslp = 2)
      parameter (jfyslp = 3)
      parameter (jfxp = 4)
      parameter (jfyp = 5)
#endif
