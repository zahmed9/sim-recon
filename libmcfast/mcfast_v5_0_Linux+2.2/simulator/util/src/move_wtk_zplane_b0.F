      integer function move_wtk_zplane_b0(w1, zs, bf, w2, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Takes a helix expressed in w form and calculates the new parameters
c  at the position z = zs in a zero B field.
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
c   The equations of motion of a particle in zero B field are
c
c     px = px0
c     py = py0
c     pz = pz0
c
c      x = x0 + (px0/pt)*s
c      y = y0 + (py0/pt)*s
c      z = z0 + (pz0/pt)*s
c
c   where s = arc length in r-phi plane
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "wtrack_struct.inc"
#include "bfield_struct.inc"

c     calling arguments
      DFLOAT zs
      record /wtrack_struct/ w1, w2
      record /bfield_struct/ bf
      DFLOAT s3d

c     local variables
      DFLOAT sovp
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Calculate 3-D arc length from equation zs = z0 + (pz/p)*s
      if(w1.pz .eq. 0.) goto 9999

      sovp = (zs - w1.z) / w1.pz

      w2.px = w1.px
      w2.py = w1.py
      w2.pz = w1.pz
      w2.E = w1.E

      w2.x = w1.x + sovp * w1.px
      w2.y = w1.y + sovp * w1.py
      w2.z = zs

      w2.pt = w1.pt
      w2.p = w1.p
      w2.q = w1.q

      s3d = sovp * w1.p

c     normal exit
1000  move_wtk_zplane_b0 = 0
      return

c     error exit
9999  move_wtk_zplane_b0 = 1
      s3d = 0.

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:46  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:54  garren
c add rcs log line
c
