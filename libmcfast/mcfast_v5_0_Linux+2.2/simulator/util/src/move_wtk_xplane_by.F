      integer function move_wtk_xplane_by(w1, xs, bf, w2, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Takes a helix expressed in w form and calculates the new parameters
c  at the position x = xs in a B field along the y direction.
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
c   The equations of motion of a particle in a B field along the y axis are
c
c     px = sqrt(px0**2 + 2*a*px0*pz0*dx - (a*dx)^2)
c     py = py0
c     pz = pz0 - a*dx
c
c      x = xs
c      y = y0 + (py0/a) * arcsin{a*[dz*pz0 + dx*px0] / pzx^2}
c      z = z0 + (1/a) * [px - px0]
c        = z0 + dx * (pz0 + pz) / (px0 + px)
c
c   where
c      a = c_b * bfield * q  (c_b is defined in const.inc)
c     dx = xs - x0
c     dz = z - z0
c     pzx = sqrt(pz0**2 + px0**2)
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
      DFLOAT a, ainv, dz, dx, adx, disc, px0, py0, pz0
      DFLOAT px, py, pz, pzxsq, pzx
      DFLOAT zp0, yp0
      DFLOAT pxp, pxm, dzp, dzm, alphap, alpham
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      a = c_b * bf.bmag * bf.bdir(2) * w1.q
      ainv = 1. / a
      dx = xs - w1.x
      adx = a * dx

      px0 = w1.px
      py0 = w1.py
      pz0 = w1.pz
      yp0 = w1.y
      zp0 = w1.z

      pz = pz0 - adx
      disc = px0**2 + 2.*adx*pz0 - adx**2
      if(disc .le. 0.) goto 9999

      pxp = sqrt(disc)
      pxm = -1.0*sqrt(disc)                !two intersections; find closest
      dzp = dx * (pz0+pz) / (px0+pxp)
      dzm = dx * (pz0+pz) / (px0+pxm)

      pzxsq = pz0**2 + px0**2
      pzx = sqrt(pzxsq)
      alphap = acos((pxp*px0+pz*pz0)/pzxsq)    !turning angle
      if ((pz0*pxp-px0*pz)*sign(ONE,a).lt.0.0) alphap = 2.0*pi - alphap
      do while (alphap .lt. 0.0)
        alphap = alphap + 2.0*pi
      end do
      alpham = acos((pxm*px0+pz*pz0)/pzxsq)
      if ((pz0*pxm-px0*pz)*sign(ONE,a).lt.0.0) alpham = 2.0*pi - alpham
      do while (alpham .lt. 0.0)
        alpham = alpham + 2.0*pi
      end do

      if (alphap.lt.alpham) then
        px = pxp
        dz = dzp
        s3d = alphap * abs(pzx/a) * w1.p/pzx
      else
        px = pxm
        dz = dzm
        s3d = alpham * abs(pzx/a) * w1.p/pzx        
      end if

      w2.px = px
      w2.py = py0
      w2.pz = pz
      w2.E = w1.E

      w2.x = xs
      w2.y = yp0 + py0/w1.p*s3d
      w2.z = zp0 + dz

      w2.pt = sqrt(w2.px**2 + w2.py**2)
      w2.p = w1.p
      w2.q = w1.q

c     normal exit
1000  move_wtk_xplane_by = 0
      return

c     error exit
9999  move_wtk_xplane_by = 1
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
