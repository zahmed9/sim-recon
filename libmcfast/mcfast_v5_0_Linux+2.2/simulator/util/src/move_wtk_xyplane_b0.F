      integer function move_wtk_xyplane_b0(w1, xpl, eta, bf, w2, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Move a w track to a plane whose normal is in the x-y plane in a
c  zero B field.
c
c  The equation of the plane is x*etax + y*etay - delta = 0
c
c  where eta   = (cosb, sinb, 0)
c        delta = etax*xp + etay*yp = perp. distance to the origin
c
c  The track equations of motion in 0 B field are
c
c         x = x0 + px0/pt*s
c         y = y0 + py0/pt*s
c         z = z0 + pz0/pt*s
c
c   where
c    (x0,y0,z0) is a point on the helix
c    (px0,py0,pz0) is the momentum vector at that point
c    s is the arc length in the x-y plane from (x0,y0,z0).
c
c   Thus the equation of the plane can be written
c
c        s*px0_b + pt*xc_b = 0
c
c   where the rotated quantities are defined as
c
c   px0_b = px0*etax + py0*etay
c   py0_b = py0*etax - px0*etay
c   xc_b  = x0*etax + y0*etay - delta
c
c   s = -xc_b * pt / px0_b
c  ..........................................................................
c
c  w1       w track structure (read)
c           Input track parameters
c
c  xpl(3)   DFLOAT array (read)
c           Point on the plane
c
c  eta(3)   DFLOAT array (read)
c           Outward normal to the plane (assume z component is 0)
c
c  bf       B field structure (read)
c           B field information
c
c *w2       w track structure (read)
c           Output track parameters
c
c *s3d      DFLOAT variable (write)
c           3-D arc length the track moved between points
c
c return    
c           0 ==> all OK
c           1 ==> track cannot be projected
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "wtrack_struct.inc"
#include "bfield_struct.inc"
#include "const.inc"

c     calling arguments
      record /wtrack_struct/ w1, w2
      record /bfield_struct/ bf
      DFLOAT xpl(3), eta(3)
      DFLOAT s3d

c     local variables
      DFLOAT x0, y0, z0, delta, disc
      DFLOAT soverp, xc_b, px0, py0, pz0
      DFLOAT px0_b, py0_b, xint, yint, zint, pxint, pyint, pt
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     delta = perpendicular distance of plane to origin
      delta = xpl(1)*eta(1) + xpl(2)*eta(2)

      px0 = w1.px
      py0 = w1.py
      pz0 = w1.pz
      x0 = w1.x
      y0 = w1.y
      z0 = w1.z

      pt = w1.pt

c     Calculate the rotated values of px0, py0, x0
      px0_b = px0*eta(1) + py0*eta(2)
      py0_b = py0*eta(1) - px0*eta(2)
      xc_b = x0*eta(1) + y0*eta(2) - delta

      if(px0_b .eq. 0.) goto 9999

      soverp = -xc_b / px0_b

      pxint = px0
      pyint = py0
      xint = x0 + px0*soverp
      yint = y0 + py0*soverp
      zint = z0 + pz0*soverp

      w2.px = pxint
      w2.py = pyint
      w2.pz = pz0
      w2.E = w1.E
      w2.x = xint
      w2.y = yint
      w2.z = zint
      w2.pt = w1.pt
      w2.p = w1.p
      w2.q = w1.q

      s3d = soverp * w2.p

      move_wtk_xyplane_b0 = 0
      return

c     Can't reach this plane
9999  move_wtk_xyplane_b0 = 1
      call ucopy(w1, w2, WTRACK_WORD)
      s3d = 0.

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:45  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:52  garren
c add rcs log line
c
