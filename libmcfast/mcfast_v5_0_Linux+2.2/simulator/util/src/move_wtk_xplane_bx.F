      integer function move_wtk_xplane_bx(w1, xs, bf, w2, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Takes a helix expressed in w form and calculates the new parameters
c  at the position x = xs in a B field along the x direction.
c
c  w1       w track structure (read)
c           Initial track parameters (px, py, pz, E, x0, y0, z0, pt, p, q)
c
c  xs       DFLOAT variable (read)
c           x position to which the track should be projected
c
c  bf       B field structure (read)
c           B field information
c
c *w2       w track structure (write)
c           Track parameters at x = xs
c
c *s3d      DFLOAT variable (write)
c           3-D arc length the track moved between points
c
c return    
c           0 ==> all OK
c           1 ==> track cannot be projected to this radius
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c   The equations of motion of a particle in a B field along the x axis are
c
c     px = px0
c     py = py0*cos(rho*s) - pz0*sin(rho*s)
c     pz = pz0*cos(rho*s) + py0*sin(rho*s)
c
c      x = x0 + ct*s
c      y = y0 + {py0*sin(rho*s) - pz0*[1-cos(rho*s)]} / a = y0 + (pz-pz0)/a
c      z = z0 + {pz0*sin(rho*s) + py0*[1-cos(rho*s)]} / a = z0 - (py-py0)/a
c
c   where s = arc length in y-z plane
c         a = c_b * bfield * q  (c_b is defined in const.inc)
c       rho = a / pyz
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "wtrack_struct.inc"
#include "bfield_struct.inc"
#include "const.inc"

c     calling arguments
      DFLOAT xs
      record /wtrack_struct/ w1, w2
      record /bfield_struct/ bf
      DFLOAT s3d

c     local variables
      DFLOAT rho, a, ainv, py, pz, sovp, pyz
      DFLOAT ps, sinps, cosps, s
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Calculate arc length from equation xs = x0 + ct*s
      if(w1.px .eq. 0.) goto 9999

      pyz = sqrt(w1.py**2 + w1.pz**2)

      s = (xs - w1.x)  * pyz / w1.px
      sovp = s / pyz

      a = c_b * bf.bmag * bf.bdir(1) * w1.q
      rho = a / pyz
      ainv = 1. / a
      py = w1.py
      pz = w1.pz
      ps = rho * s
      sinps = sin(ps)
      cosps = cos(ps)

      w2.px = w1.px
      w2.py = py*cosps - pz*sinps
      w2.pz = pz*cosps + py*sinps
      w2.E = w1.E

      w2.x = w1.x + sovp * w1.px
      w2.y = w1.y + (w2.pz - pz) * ainv
      w2.z = w1.z - (w2.py - py) * ainv

      w2.pt = sqrt(w2.px**2 + w2.py**2)
      w2.p = w1.p
      w2.q = w1.q

      s3d = sovp * w2.p

c     normal exit
1000  move_wtk_xplane_bx = 0
      return

c     error exit
9999  move_wtk_xplane_bx = 1
      s3d = 0.

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:45  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:31:51  garren
c add rcs log line
c
