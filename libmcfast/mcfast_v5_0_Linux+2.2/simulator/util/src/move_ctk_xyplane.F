      integer function move_ctk_xyplane(c1, xpl, eta, c2, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Move a helix to a plane in a solenoidal B field. The point of
c  intersection is used as the new reference point.
c
c  The equation of the plane is x*cosb + ysinb - delta = 0
c
c  where eta   = (cosb, sinb, 0)
c        delta = cosb*xp + sinb*yp = perp. distance to the origin
c
c  The helix equations of motion are
c
c         x = x0 + xr + (u0/rho)*sin(rho*s) - (v0/rho)*(1-cos(rho*s))
c         y = y0 + yr + (v0/rho)*sin(rho*s) + (u0/rho)*(1-cos(rho*s))
c         z = z0 + zr + ct*s
c
c   where
c    (xr,yr,zr) is the reference point for the helix
c    (x0,y0,z0) is the point of closest approach to (xr,yr,zr)
c    (u0,v0,ct) = (px/pt,py/pt,pz/pt) at that point
c    rho = 1/radius of curvature
c    s is the arc length in the x-y plane from (x0,y0,z0).
c
c   Thus the equation of the plane can be written
c
c        u0_b * sin(ps) - v0_b * (1 - cos(ps)) + rho*xc_b = 0
c
c   where the rotated quantities are defined as
c
c   u0_b = u0*cosb + v0*sinb
c   v0_b = v0*cosb - u0*sinb
c   xc_b = (x0+xr)*cosb + (y0+yr)*sinb - delta
c
c   To solve, we use the auxiliary quantity w = (2/rho)*sin(ps/2)
c
c         sin(ps)     = rho*w*sqrt(1 - rho^2*w^2/4)
c         1 - cos(ps) = rho^2*w^2 / 2
c
c      0.25*rho^2*w^4 - (rho*v0_b*xc_b + u0_b^2)*W^2 + xc_b^2 = 0
c
c   The solution is
c
c      1 - cos(ps) = (rho*x0)^2 * {B + sqrt[B^2 - (rho*xc_b)^2]}
c          sin(ps) = [v0_b*(1-cos(ps)) - rho*xc_0] / u0_b
c
c    where B = u0_b^2 + rho*xc_b*v0_b
c  .........................................................................
c
c      1 - cos(ps) = 1 - v0_b * v0_b' - u0_b * sqrt[1 - v0_b'^2]
c                  = 1 - v0_b * v0_b' - u0_b * u0_b'
c          sin(ps) = u0_b * v0_b' - v0_b * sqrt[1 - v0_b'^2]
c                  = u0_b * v0_b' - v0_b * u0_b'
c
c    where v0_b' = v0_b - rho*xc_b
c          u0_b' = sqrt[1 - v0_b'^2]
c
c  c1       c track structure (read)
c           Input track parameters
c
c  xpl(3)   DFLOAT array (read)
c           Point on the plane
c
c  eta(3)   DFLOAT array (read)
c           Outward normal to the plane (assume z component is 0)
c
c *c2       c track structure (read)
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

#include "const.inc"
#include "ctrack_struct.inc"

c     Externals
      external phi_norm
      DFLOAT   phi_norm

c     calling arguments
      record /ctrack_struct/ c1, c2
      DFLOAT xpl(3), eta(3)
      DFLOAT s3d

c     local variables
      DFLOAT rho, rhoinv, x0, y0, z0, cosps, sinps, dcosps
      DFLOAT delta, disc, B
      DFLOAT s, phi0, u0_b, v0_b, xc_b
      DFLOAT xint, yint, zint, uint, vint
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     delta = perpendicular distance of plane to origin
      delta = xpl(1)*eta(1) + xpl(2)*eta(2)

      x0 = -c1.da * c1.v0 + c1.xref
      y0 =  c1.da * c1.u0 + c1.yref
      z0 =  c1.z0 + c1.zref

      rho = 2. * c1.cu

c     Calculate the rotated quantities
c       u0_b = u0*cosb + v0*sinb
c       v0_b = v0*cosb - u0*sinb
c       xc_b = (x0+xr)*cosb + (y0+yr)*sinb - delta

      u0_b = c1.u0*eta(1) + c1.v0*eta(2)
      v0_b = c1.v0*eta(1) - c1.u0*eta(2)
      xc_b = x0*eta(1) + y0*eta(2) - delta

c     Solve the equations
c      1 - cos(ps) = (rho*x0)^2 * {B + sqrt[B^2 - (rho*xc_b)^2]}
c          sin(ps) = [v0_b*(1-cos(ps)) - rho*xc_0] / u0_b
c
c    where B = u0^2 + a*xc_b*v0_b

      if(rho .eq. 0.) then
        s = -xc_b / u0_b
        xint = x0 + c1.u0*s
        yint = y0 + c1.v0*s
        zint = z0 + c1.ct*s
        phi0 = c1.phi0
      else
        B = u0_b**2 + rho*xc_b*v0_b
        disc = B**2 - (rho*xc_b)**2
        if(disc .lt. 0.) goto 9999
        dcosps = (rho*xc_b)**2 / (B + sqrt(disc))
        sinps  = (v0_b*dcosps - rho*xc_b) / u0_b
        cosps  = 1. - dcosps
        rhoinv = 1. / rho
        s = rhoinv * atan2(sinps, cosps)
        uint = c1.u0*cosps - c1.v0*sinps
        vint = c1.v0*cosps + c1.u0*sinps
        xint = x0 + rhoinv * (c1.u0*sinps - c1.v0*dcosps)
        yint = y0 + rhoinv * (c1.v0*sinps + c1.u0*dcosps)
        zint = z0 + c1.ct*s
        phi0 = phi_norm(atan2(vint, uint))
      endif

c     z0' = z0 + zref + ct*s - zref' = z0 + ct*s - dz
      c2.cu = c1.cu
      c2.phi0 = phi0
      c2.da = 0.
      c2.ct = c1.ct
      c2.z0 = 0.
      c2.u0 = uint
      c2.v0 = vint
      c2.pt = c1.pt
      c2.p = c1.p
      c2.q = c1.q
      c2.xref = xint
      c2.yref = yint
      c2.zref = zint

      s3d = s * c2.p / c2.pt

      move_ctk_xyplane = 0

      return

c     Can't reach this plane
9999  move_ctk_xyplane = 1
      call ucopy(c1, c2, CTRACK_WORD)
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:36  garren
c add rcs log line
c
