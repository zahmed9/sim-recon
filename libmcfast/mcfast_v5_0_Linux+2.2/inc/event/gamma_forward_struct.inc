#ifndef GAMMA_FORWARD_STRUCT
#define GAMMA_FORWARD_STRUCT

c     Parametrization for gammas reconstructed in the forward direction.
c     Only the first 3 parameters are used in the fit
c
c     Parametrization of track
c
c        x = x0 + mx*z
c        y = y0 + my*z

#include "const.inc"

      structure /gamma_forward_s/
        DFLOAT E           !Energy
        DFLOAT mx          !dx/dz
        DFLOAT my          !dy/dz
        DFLOAT cov(3,3)    !Covariance matrix
        integer ihep       !Track number in HEP common
        integer icov       !0 ==> covariance matrix not defined
c                          !1 ==> covariance matrix defined
      end structure
#endif
