      integer function move_wtk_point_bz(w1, x, bf, w2, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Takes a helix expressed in w form and calculates the new parameters
c  nearest (nearest in the x-y plane) the point x(1-3) in a solenoidal
c  B field.
c
c  w1       w track structure (read)
c           Initial track parameters
c
c  x(3)     DFLOAT array (read)
c           Point to project track to
c
c  bf       B field structure (read)
c           B field information
c
c *w2       w track structure (write)
c           Track parameters at position closest to x(1-3)
c
c *s3d      DFLOAT variable (write)
c           3-D arc length the track moved between points
c
c return    
c           0 ==> all OK
c           1 ==> track cannot be projected
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
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
c   We have to find the point closest to (xc,yc,zc). The solution is
c
c        cos(rho*s) = (1. - rho*(dx*Py0 - dy*Px0) / Pt) / norm
c        sin(rho*s) = (-rho*(dx*Px0 + dy*Py0) / Pt) / norm
c
c        norm = sqrt(1+2*rho*(dy*Px0 - dx*Py0)/Pt + rho**2*(dx**2 + dy**2))
c          dx = x0 - xc
c          dy = y0 - yc
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "wtrack_struct.inc"
#include "bfield_struct.inc"
#include "const.inc"

c     calling arguments
      record /wtrack_struct/ w1, w2
      record /bfield_struct/ bf
      DFLOAT x(3)
      DFLOAT s3d

c     local variables
      DFLOAT rho, delx, dely, sinps, cosps, dcosps
      DFLOAT alpha, a, ainv, sovp, ptinv, px, py
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     quit if no pt
      if(w1.pt .eq. 0.) goto 9999

      a = c_b * bf.bmag * bf.bdir(3) * w1.q
      ptinv = 1. / w1.pt
      rho = a * ptinv

      delx = w1.x - x(1)
      dely = w1.y - x(2)

      ainv = 1. / a
      px = w1.px
      py = w1.py
      cosps =  1. - rho*(delx*py - dely*px) * ptinv
      sinps = -rho*(delx*px + dely*py) * ptinv
      sovp = atan2(sinps, cosps) * ainv
      alpha =  1. / sqrt(cosps**2 + sinps**2)
      cosps = cosps * alpha
      sinps = sinps * alpha
      dcosps = 1. - cosps
      w2.px = px*cosps - py*sinps
      w2.py = py*cosps + px*sinps
      w2.pz = w1.pz
      w2.E = w1.E
      w2.x = w1.x + (px*sinps - py*dcosps) * ainv
      w2.y = w1.y + (py*sinps + px*dcosps) * ainv
      w2.z = w1.z + sovp * w1.pz
      w2.pt = w1.pt
      w2.p = w1.p
      w2.q = w1.q

      s3d = sovp * w2.p

c     normal return
      move_wtk_point_bz = 0
      return

c     error return
9999  move_wtk_point_bz = 1
      call ucopy(w1, w2, WTRACK_WORD)
      s3d = 0.

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:45  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:48  garren
c add rcs log line
c
