      integer function move_wtk_zplane_bx(w1, zs, bf, w2, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Takes a helix expressed in w form and calculates the new parameters
c  at the position z = zs in a B field along the x direction.
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
c   The equations of motion of a particle in a B field along the x axis are
c
c     px = px0
c     py = py0 - a*dz
c     pz = sqrt(pz0**2 + 2*a*pz0*py0*dz - (a*dz)^2)
c
c      x = x0 + (px0/a) * arcsin{a*[dy*py0 + dz*pz0] / pt^2}
c      y = y0 + (1/a) * [pz - pz0]
c        = y0 + dz * (py0 + py) / (pz0 + pz)
c      z = zs
c
c   where
c      a = c_b * bfield * q  (c_b is defined in const.inc)
c     dz = zs - z0
c     dy = y - y0
c     pt = sqrt(py0**2 + pz0**2)
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
      DFLOAT a, ainv, dy, dz, adz, disc, px0, py0, pz0
      DFLOAT px, py, pz, ptsq, pzy, alpha
      DFLOAT xp0, yp0, arg, arg2
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      a = c_b * bf.bmag * bf.bdir(1) * w1.q
      ainv = 1. / a
      dz = zs - w1.z
      adz = a * dz

      px0 = w1.px
      py0 = w1.py
      pz0 = w1.pz
      xp0 = w1.x
      yp0 = w1.y

      py = py0 - adz
      disc = pz0**2 + 2.*adz*py0 - adz**2
      if(disc .le. 0.) goto 9999
      pz = sqrt(disc)
      pz = pz*sign(ONE,pz0)

      w2.px = px0
      w2.py = py
      w2.pz = pz
      w2.E = w1.E

      dy = dz * (py0+py) / (pz0+pz)
      ptsq = py0**2 + pz0**2
      pzy = sqrt(ptsq)

      arg = a * (dy*py0 + dz*pz0) / ptsq
      w2.x = xp0 + (px0/a) * asin(arg)
      w2.y = yp0 + dy
      w2.z = zs

      w2.pt = sqrt(w2.px**2 + w2.py**2)
      w2.p = w1.p
      w2.q = w1.q

      arg2 = (py*py0+pz*pz0)/ptsq

      if (abs(arg2) .ge. 1.000001) then
        goto 9999
      else if (abs(arg2-1.d0) .gt. 1.e-05) then
        alpha = acos(arg2)
        if ((pz0*py-py0*pz)*sign(ONE,a).gt.0.0) alpha = 2.0*pi - alpha
      else
        alpha = atan( sqrt(dy**2 + dz**2) * abs(a) / pzy )
        if (dz/w1.pz .lt. 0.0) then
          alpha = 2.0*pi - alpha
        end if
      end if

      do while (alpha .lt. 0.0)
        alpha = alpha + 2.0*pi
      end do

      s3d = alpha * abs(pzy/a) * w1.p/pzy

c     normal exit
1000  move_wtk_zplane_bx = 0
      return

c     error exit
9999  move_wtk_zplane_bx = 1
      s3d = 0.

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:46  eugenio
c Initial revision
c
c Revision 1.5  1997/04/04 20:31:55  garren
c add rcs log line
c
