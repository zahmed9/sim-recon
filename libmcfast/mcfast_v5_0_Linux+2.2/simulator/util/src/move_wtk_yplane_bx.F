      integer function move_wtk_yplane_bx(w1, ys, bf, w2, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Takes a helix expressed in w form and calculates the new parameters
c  at the position y = ys in a B field along the x direction.
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
c   The equations of motion of a particle in a B field along the x axis are
c
c     pz = pz0 + a*dy
c     px = px0
c     py = sqrt(py0**2 - 2*a*py0*pz0*dy - (a*dy)^2)
c
c      z = z0 + (1/a) * [py0 - py]
c        = z0 + dy * (pz0 + pz) / (py0 + py)
c      x = x0 + (px0/a) * arcsin{a*[dz*pz0 + dy*py0] / pyz^2}
c      y = ys
c
c   where
c      a = c_b * bfield * q  (c_b is defined in const.inc)
c     dy = ys - y0
c     dz = z - z0
c     pyz = sqrt(py0**2 + pz0**2)
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
      DFLOAT a, ainv, dy, dz, disc, ady, px0, py0, pz0
      DFLOAT px, py, pz, pyzsq, pyz
      DFLOAT zp0, xp0
      DFLOAT pyp, pym, dzp, dzm, alphap, alpham
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      a = c_b * bf.bmag * bf.bdir(1) * w1.q
      ainv = 1. / a
      dy = ys - w1.y
      ady = a * dy

      px0 = w1.px
      py0 = w1.py
      pz0 = w1.pz
      zp0 = w1.z
      xp0 = w1.x

      pz = pz0 + ady
      disc = py0**2 - 2.*ady*pz0 - ady**2
      if(disc .le. 0.) goto 9999

      pyp = sqrt(disc)
      pym = -1.0*sqrt(disc)
      dzp = dy * (pz0+pz) / (py0+pyp)
      dzm = dy * (pz0+pz) / (py0+pym)

      pyzsq = pz0**2 + py0**2
      pyz = sqrt(pyzsq)
      alphap = acos((pyp*py0+pz*pz0)/pyzsq)    !turning angle
      if ((py0*pz-pz0*pyp)*sign(ONE,a).lt.0.0) alphap = 2.0*pi - alphap
      do while (alphap .lt. 0.0)
        alphap = alphap + 2.0*pi
      end do
      alpham = acos((pym*py0+pz*pz0)/pyzsq)
      if ((py0*pz-pz0*pym)*sign(ONE,a).lt.0.0) alpham = 2.0*pi - alpham
      do while (alpham .lt. 0.0)
        alpham = alpham + 2.0*pi
      end do

      if (alphap.lt.alpham) then
        py = pyp
        dz = dzp
        s3d = alphap * abs(pyz/a) * w1.p/pyz
      else
        py = pym
        dz = dzm
        s3d = alpham * abs(pyz/a) * w1.p/pyz        
      end if

      w2.pz = pz
      w2.px = px0
      w2.py = py
      w2.E = w1.E

      w2.z = zp0 + dz
      w2.x = xp0 + px0/w1.p*s3d
      w2.y = ys

      w2.pt = sqrt(w2.px**2 + w2.py**2)
      w2.p = w1.p
      w2.q = w1.q

c     normal exit
1000  move_wtk_yplane_bx = 0
      return

c     error exit
9999  move_wtk_yplane_bx = 1
      s3d = 0.

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:46  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:31:53  garren
c add rcs log line
c
