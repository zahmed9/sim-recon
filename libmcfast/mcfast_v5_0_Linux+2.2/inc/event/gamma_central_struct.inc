#ifndef GAMMA_CENTRAL_STRUCT
#define GAMMA_CENTRAL_STRUCT

c     Gamma track parametrization in central region. Only the first 3
c     elements are used in fitting.

#include "const.inc"

      structure /gamma_central_s/
        DFLOAT E        !Energy
        DFLOAT theta    !Theta
        DFLOAT phi      !Phi
        DFLOAT ctheta   !cos(theta)
        DFLOAT stheta   !sin(theta)
        DFLOAT cphi     !cos(phi)
        DFLOAT sphi     !sin(phi)
        DFLOAT cov(3,3) !Covariance matrix
        integer ihep    !Track number in HEP common
        integer icov    !0 ==> covariance matrix not defined
c                       !1 ==> covariance matrix defined
      end structure
#endif
