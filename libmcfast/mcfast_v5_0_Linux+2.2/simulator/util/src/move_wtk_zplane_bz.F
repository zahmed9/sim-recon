      integer function move_wtk_zplane_bz(w1, zs, bf, w2, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Takes a helix expressed in w form and calculates the new parameters
c  at the position z = zs in a B field along the z direction.
c
c  w1       w track structure (read)
c           Initial track parameters (px, py, pz, E, x0, y0, z0, pt, p, q)
c
c  zs       DFLOAT variable (read)
c           z position to which the track should be projected
c
c  bf       B field structure (read)
c           B field information
c
c *w2       w track structure (write)
c           Track parameters at z = zs
c
c *s3d      DFLOAT variable (write)
c           3-D arc length the track moved between points
c
c return    
c           0 ==> all OK
c           1 ==> track cannot be projected to this radius
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c   The equations of motion of a particle in a B field along the z axis are
c
c     px = px0*cos(rho*s) - py0*sin(rho*s)
c     py = py0*cos(rho*s) + px0*sin(rho*s)
c     pz = pz0
c
c      x = x0 + {px0*sin(rho*s) - py0*[1-cos(rho*s)]} / a = x0 + (py-py0)/a
c      y = y0 + {py0*sin(rho*s) + px0*[1-cos(rho*s)]} / a = y0 - (px-px0)/a
c      z = z0 + ct*s
c
c   where s = arc length in r-phi plane
c         a = c_b * bfield * q  (c_b is defined in const.inc)
c       rho = a / pt
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "wtrack_struct.inc"
#include "bfield_struct.inc"
#include "const.inc"

c     calling arguments
      DFLOAT zs
      record /wtrack_struct/ w1, w2
      record /bfield_struct/ bf
      DFLOAT s3d

c     local variables
      DFLOAT rho, a, ainv, px, py, sovp
      DFLOAT ps, sinps, cosps, dcosps, s
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Calculate arc length from equation zs = z0 + ct*s
      if(w1.pz .eq. 0.) goto 9999

      s = (zs - w1.z)  * w1.pt / w1.pz
      sovp = s / w1.pt

      a = c_b * bf.bmag * bf.bdir(3) * w1.q
      rho = a / w1.pt
      ainv = 1. / a
      ps = rho * s
      sinps = sin(ps)
      cosps = cos(ps)
      dcosps = 1. - cosps

      w2.x = w1.x + (w1.px*sinps - w1.py*dcosps) * ainv
      w2.y = w1.y + (w1.py*sinps + w1.px*dcosps) * ainv
      w2.z = zs

      px = w1.px
      py = w1.py
      w2.px = px*cosps - py*sinps
      w2.py = py*cosps + px*sinps
      w2.pz = w1.pz
      w2.E = w1.E

      w2.pt = w1.pt
      w2.p = w1.p
      w2.q = w1.q

      s3d = sovp * w2.p

c     normal exit
1000  move_wtk_zplane_bz = 0
      return

c     error exit
9999  move_wtk_zplane_bz = 1
      s3d = 0.

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:46  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:55  garren
c add rcs log line
c
