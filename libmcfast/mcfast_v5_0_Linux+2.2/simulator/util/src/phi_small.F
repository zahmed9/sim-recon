      function phi_small(arg)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Force argument to be in the range [-pi, pi]
c
c  arg      DFLOAT variable (read)
c           Angle
c
c  return   arg modified to be in the range [-pi, pi]
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"

      DFLOAT   phi_small

c     calling arguments
      DFLOAT arg
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      phi_small = arg
      if(phi_small .gt.  pi) phi_small = phi_small - tpi
      if(phi_small .lt. -pi) phi_small = phi_small + tpi

      return
      end
c
c$Id$
c
c$Log$
cRevision 1.1  2000/06/19 19:59:46  eugenio
cInitial revision
c
cRevision 1.2  1997/03/27 05:03:58  kutschke
cCatch cases .lt. -2pi.
c
