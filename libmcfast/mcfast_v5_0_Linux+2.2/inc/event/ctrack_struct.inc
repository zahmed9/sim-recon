#ifndef CTRACK_STRUCT
#define CTRACK_STRUCT

c     Helix track parametrization, useful in solenoidal field.

c -------------------------------------------------------------
c
c WARNING: if you change this file, also make sure you change 
c          ctrack_struct.h !
c
c -------------------------------------------------------------


c     Equations of motion of track, assuming B field along z direction, are
c
c       x = xp + (u0/rho)*sin(ps) - (v0/rho)*[1 - cos(ps)]
c       y = yp + (v0/rho)*sin(ps) + (u0/rho)*[1 - cos(ps)]
c       z = zp + ct*sperp
c
c      Px = Px0*cos(ps) - Py0*sin(ps)
c      Py = Py0*cos(ps) + Px0*sin(ps)
c      Pz = Pz0
c
c     where  (xp,yp,zp) is a point on the helix
c             u0 = Px0 / Pt
c             v0 = Py0 / Pt
c             ct = Pz0 / Pt
c            (Px0,Py0,Pz0) is the momentum at (xp,yp,zp)
c             rho = 2 * cu = 1/R
c             sperp = arc length in r-phi plane from (xp,yp,zp)
c             ps  = rho * sperp
c
c     When (xp,yp,zp) is the PCA to the reference point, they are given by
c
c       xp = -da * v0 + xref
c       yp = +da * u0 + yref
c       zp = z0 + zref

#include "const.inc"

      integer CTRACK_WORD, CTRACK_NPAR
      parameter (CTRACK_WORD = 13*FLOAT_WORD)
      parameter (CTRACK_NPAR = 5            )

      structure /ctrack_struct/
        DFLOAT cu     !1/2R
        DFLOAT phi0   !phi at PCA to reference point
        DFLOAT da     !DCA to reference point (signed)
        DFLOAT ct     !cot(theta)
        DFLOAT z0     !z - zref at PCA to reference point
        DFLOAT u0     !cos(phi0)
        DFLOAT v0     !sin(phi0)
        DFLOAT pt     !Pt
        DFLOAT p      !Momentum
        DFLOAT q      !Charge
        DFLOAT xref   !x of reference point
        DFLOAT yref   !y of reference point
        DFLOAT zref   !z of reference point
      end structure

c     Constants to identify locations in C track covariance matrix

      integer jccu, jcphi, jcda, jcct, jcz0
      parameter (jccu = 1)
      parameter (jcphi = 2)
      parameter (jcda = 3)
      parameter (jcct = 4)
      parameter (jcz0 = 5)
#endif
