      integer function move_wtk_xyplane_bz(w1, xpl, eta, bf, w2, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Move a w track to a plane whose normal is in the x-y plane in a
c  solenoidal B field.
c
c  The equation of the plane is x*cosb + ysinb - delta = 0
c
c  where eta   = (cosb, sinb, 0)
c        delta = cosb*xp + sinb*yp = perp. distance to the origin
c
c  The helix equations of motion are
c
c         x = x0 + (px0/a)*sin(rho*s) - (py0/a)*(1-cos(rho*s))
c         y = y0 + (py0/a)*sin(rho*s) + (px0/a)*(1-cos(rho*s))
c         z = z0 + (pz0/pt)*s
c
c   where
c    (x0,y0,z0) is a point on the helix
c    (px0,py0,pz0) is the momentum vector at that point
c    a = c_b * bfield * q (c_b defined in const.inc)
c    rho = a/pt = inverse curvature
c    s is the arc length in the x-y plane from (x0,y0,z0).
c
c   Thus the equation of the plane can be written
c
c        px0_b * sin(ps) - py0_b * (1 - cos(ps)) + a*xc_b = 0
c
c   where the rotated quantities are defined as
c
c   px0_b = px0*cosb + py0*sinb
c   py0_b = py0*cosb - px0*sinb
c   xc_b  = x0*cosb + y0*sinb - delta
c
c   To solve, we use the auxiliary quantity w = (2/rho)*sin(ps/2)
c
c         sin(ps)     = rho*w*sqrt(1 - rho^2*w^2/4)
c         1 - cos(ps) = rho^2*w^2 / 2
c
c      0.25*a^2*w^4 - (a*py0_b*xc_b + px0_b^2)*W^2 + pt^2*xc_b^2 = 0
c
c   The solution is
c
c   1 - cos(ps) = (a*x0)^2 * {B + sqrt[B^2 - (a*xc_b*pt)^2]}
c       sin(ps) = [py0_b*(1-cos(ps)) - a*xc_0] / px0_b
c
c    where B = px0_b^2 + a*xc_b*py0_b
c  .........................................................................
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
      DFLOAT x0, y0, z0, cosps, sinps, dcosps
      DFLOAT delta, disc
      DFLOAT s, phi0, xc_b, yc_b, px0, py0, pz0
      DFLOAT px0_b, py0_b, ptsq
      DFLOAT xint, yint, zint, pxint, pyint, pt, a, ainv, B
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      a = c_b * bf.bmag * bf.bdir(3) * w1.q

c     delta = perpendicular distance of plane to origin
      delta = xpl(1)*eta(1) + xpl(2)*eta(2)

      px0 = w1.px
      py0 = w1.py
      pz0 = w1.pz
      x0 = w1.x
      y0 = w1.y
      z0 = w1.z

      pt = w1.pt
      ptsq = w1.pt**2

c     Calculate the rotated values of px0, py0, x0
      px0_b = px0*eta(1) + py0*eta(2)
      py0_b = py0*eta(1) - px0*eta(2)
      xc_b = x0*eta(1) + y0*eta(2) - delta

c     Solve the equations
c   1 - cos(ps) = (a*x0)^2 * {B + sqrt[B^2 - (a*xc_b*pt)^2]}
c       sin(ps) = [py0_b/px0_b*(1-cos(ps)) - a*xc_0/px0_b]

      B = px0_b**2 + a*xc_b*py0_b
      disc = B**2 - (a*xc_b*pt)**2
      if(disc.lt.0. .or. px0_b.eq.0.) goto 9999
      dcosps = (a*xc_b)**2 / (B + sqrt(disc))
      sinps  = (py0_b*dcosps - a*xc_b) / px0_b

      cosps  = 1. - dcosps

      ainv = 1. / a

      s = (w1.pt * ainv) * atan2(sinps, cosps)

      pxint = px0*cosps - py0*sinps
      pyint = py0*cosps + px0*sinps
      xint = x0 + ainv * (pyint - py0)
      yint = y0 - ainv * (pxint - px0)
      zint = z0 + (pz0/pt)*s

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

      s3d = s * w2.p / w1.pt

      move_wtk_xyplane_bz = 0
      return

c     Can't reach this plane
9999  move_wtk_xyplane_bz = 1
      call ucopy(w1, w2, WTRACK_WORD)
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
