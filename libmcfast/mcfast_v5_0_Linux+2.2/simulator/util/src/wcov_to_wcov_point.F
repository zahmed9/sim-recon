      integer function wcov_to_wcov_point(w, wcov1, bf, wcov2)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Take a w covariance matrix and transport it to the point nearest its
c  current position. This removes the freedom along the helix.
c
c   The equations of motion are
c
c     Px = Px0*cos(rho*s) - Py0*sin(rho*s)
c     Py = Py0*cos(rho*s) + Px0*sin(rho*s)
c     Pz = Pz0
c
c      x = x0 + {Px0*sin(rho*s) - Py0*[1-cos(rho*s)]} / a = x0 + (Py-Py0)/a
c      y = y0 + {Py0*sin(rho*s) + Px0*[1-cos(rho*s)]} / a = y0 - (Px-Px0)/a
c      z = z0 + ct*s
c
c   where s = arc length in r-phi plane
c         a = c_b * Bfield * q (c_b is defined in const.inc)
c       rho = a / Pt
c
c   Point closest to (xc,yc,zc) has the solution
c
c        cos(rho*s) = (1. - rho*(dx*Py0 - dy*Px0) / Pt) / norm
c        sin(rho*s) = (-rho*(dx*Px0 + dy*Py0) / Pt) / norm
c
c        norm = sqrt(1+2*rho*(dy*Px0 - dx*Py0)/Pt + rho**2*(dx**2 + dy**2))
c          dx = x0 - xc
c          dy = y0 - yc
c
c   For current point dx = dy = 0 but we still need derivatives.
c
c          s = -(dx*px + dy*py) /pt**2
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c Inputs:
c  w         w track structure
c            w track parameters
c
c  wcov1     DFLOAT array
c            Initial 7x7 covariance matrix for w
c
c Outputs:
c  wcov2     DFLOAT array
c            Compressed 7x7 covariance matrix for w
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "wtrack_struct.inc"
#include "bfield_struct.inc"

c     calling arguments
      record /wtrack_struct/ w
      record /bfield_struct/ bf
      DFLOAT wcov1(7,7), wcov2(7,7)
c
c     local variables
      integer i, j
      DFLOAT drv(7,7), den, a, wtmp(7,7)
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      call vzero(drv, 7*7*FLOAT_WORD)
      den = 1. / w.pt**2
      a = c_b * bf.bmag * w.q

      drv(jwpx,jwpx) = 1.
      drv(jwpx,jwx) = w.px * w.py * a * den
      drv(jwpx,jwy) = w.py * w.py * a * den

      drv(jwpy,jwpy) = 1.
      drv(jwpy,jwx) = -w.px * w.px * a * den
      drv(jwpy,jwy) = -w.py * w.px * a * den

      drv(jwpz,jwpz) = 1.

      drv(jwe,jwe) = 1.

      drv(jwx,jwx) =  w.py*w.py * den
      drv(jwx,jwy) = -w.px*w.py * den

      drv(jwy,jwx) = -w.py*w.px * den
      drv(jwy,jwy) =  w.px*w.px * den

      drv(jwz,jwx) = -w.px*w.pz * den
      drv(jwz,jwy) = -w.py*w.pz * den
      drv(jwz,jwz) = 1.

      call MxABAtr(7, 7, drv, wcov1, wtmp)
      call ucopy(wtmp, wcov2, 7*7*FLOAT_WORD)

c     Normal exit
      wcov_to_wcov_point = 0
      return

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:46  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:32:00  garren
c add rcs log line
c
