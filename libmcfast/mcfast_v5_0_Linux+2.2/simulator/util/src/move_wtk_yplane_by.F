      integer function move_wtk_yplane_by(w1, ys, bf, w2, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Takes a helix expressed in w form and calculates the new parameters
c  at the position y = ys in a B field along the y direction.
c
c  w1       w track structure (read)
c           Initial track parameters (px, py, pz, E, x0, y0, z0, pt, p, q)
c
c  ys       DFLOAT variable (read)
c           y position to which the track should be projected
c
c  bf       B field structure (read)
c           B field information
c
c *w2       w track structure (write)
c           Track parameters at y = ys
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
c     px = px0*cos(rho*s) + pz0*sin(rho*s)
c     py = py0
c     pz = pz0*cos(rho*s) - px0*sin(rho*s)
c
c      x = x0 + {px0*sin(rho*s) + pz0*[1-cos(rho*s)]} / a = x0 - (pz-pz0)/a
c      y = y0 + ct*s
c      z = z0 + {pz0*sin(rho*s) - px0*[1-cos(rho*s)]} / a = z0 + (px-px0)/a
c
c   where s = arc length in z-x plane
c         a = c_b * bfield * q  (c_b is defined in const.inc)
c       rho = a / pzx
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "wtrack_struct.inc"
#include "bfield_struct.inc"
#include "const.inc"

c     calling arguments
      DFLOAT ys
      record /wtrack_struct/ w1, w2
      record /bfield_struct/ bf
      DFLOAT s3d

c     local variables
      DFLOAT rho, a, ainv, px, pz, sovp, pzx
      DFLOAT ps, sinps, cosps, s
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Calculate arc length from equation ys = y0 + ct*s
      if(w1.py .eq. 0.) goto 9999

      pzx = sqrt(w1.pz**2 + w1.px**2)

      s = (ys - w1.y)  * pzx / w1.py
      sovp = s / pzx

      a = c_b * bf.bmag * bf.bdir(2) * w1.q
      rho = a / pzx
      ainv = 1. / a
      px = w1.px
      pz = w1.pz
      ps = rho * s
      sinps = sin(ps)
      cosps = cos(ps)

      w2.px = px*cosps + pz*sinps
      w2.py = w1.py
      w2.pz = pz*cosps - px*sinps
      w2.E = w1.E

      w2.x = w1.x - (w2.pz - pz) * ainv
      w2.y = w1.y + sovp * w1.py
      w2.z = w1.z + (w2.px - px) * ainv

      w2.pt = sqrt(w2.px**2 + w2.py**2)
      w2.p = w1.p
      w2.q = w1.q

      s3d = sovp * w2.p

c     normal exit
1000  move_wtk_yplane_by = 0
      return

c     error exit
9999  move_wtk_yplane_by = 1
      s3d = 0.

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:46  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:31:54  garren
c add rcs log line
c
