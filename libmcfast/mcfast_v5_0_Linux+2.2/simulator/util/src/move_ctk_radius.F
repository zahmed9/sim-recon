      integer function move_ctk_radius(c1, r, direct, c2, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c    Projects a track expressed in the c parametrization to a radius r
c    in the forward/backward/either direction (direct = +1/-1/0) in a
c    solenoidal B field. The new parameters are calculated with the
c    reference point equal to the point of intersection with the cylinder.
c
c    If there is more than one solution, the one first encountered by the
c    track (moving in the appropriate direction) is chosen. if the track
c    cannot be projected to this radius lerror is set to true and track2
c    is set to track1.
c
c    The algorithm starts with the helix equations of motion
c
c         x = x0 + xr + (u0/rho)*sin(rho*s) - (v0/rho)*(1-cos(rho*s))
c         y = y0 + yr + (v0/rho)*sin(rho*s) + (u0/rho)*(1-cos(rho*s))
c         z = z0 + zr + ct*s
c
c    where
c    (xr,yr,zr) is the reference point for the helix
c    (x0,y0,z0) is the point of closest approach to (xr,yr,zr)
c    (u0,v0,ct) = (px/pt,py/pt,pz/pt) at that point
c    rho = 1/radius of curvature
c    s is the arc length in the x-y plane from (x0,y0,z0).
c
c    Squaring and adding the 2-d equations we get
c
c     0 = -delta + (2/rho)*a2*sin(rho*s) + (2/rho^2)*a1*(1-cos(rho*s))
c
c    where delta = r^2 - (x0+xr)^2 - (yo+yr)^2
c          a1 = 1 + rho*(u0*(y0+yr) - v0*(x0+xr))
c             = 1 + rho*da + rho*u0*yr - rho*v0*xr
c          a2 = u0*(x0+xr) + v0*(y0+yr)
c             = u0*xr + v0*yr
c
c    To solve this we introduce the variable w = (2/rho) * sin(rho*s/2),
c    defined so that it is meaningful even when rho is zero. We have then
c
c          sin(rho*s) = w * rho * sqrt(1 - (w*rho)^2/4)
c          1 - cos(rho*s) = (w*rho)^2 / 2
c
c    the equation we must solve is
c
c  0 = (a1^2 + (a2*rho)^2)*w^4 - 2*(a1*delta+2*a2^2)*w^2 + delta^2
c
c    the solution for w^2 is
c
c      w^2 = [a1*delta + 2*a2^2 +- a2*disc] / [a1^2 + (a2*rho)^2]
c
c    where disc = sqrt(4*a1*delta + 4*a2^2 - (rho*delta)^2)
c
c    w^2 is essentially cos(rho*ps). To get a unique solution we need to
c    find sin(rho*s). This can be found from the second equation above:
c
c  sin(rho*s) = rho*[delta - a1*w^2] / (2*a2)
c             = rho*[delta*a2*rho^2 - 2*a2*a1 -+ a1*disc]/2(a1^2+rho^2*a2^2)
c
c    where the signs are correlated with the solution for w^2. If there is
c    more than one solution, the one closest to the current point along the
c    forward/backward direction should be chosen.
c
c    if rho is 0 (straight line), the solution becomes
c
c          s = -a2 +- sqrt(delta + a2^2)
c
c  c1       c track structure (read)
c           Input helix track parameters 
c
c  r        DFLOAT variable (read)
c           radius of cylinder
c
c  direct   integer variable (read)
c           +1 ==> project track forward to intersection with r
c            0 ==> project track to nearest intersection with r
c           -1 ==> project track backward to intersection with r
c
c *c2       c track structure (write)
c           Output helix track parameters relative to point at r
c
c *s3d      DFLOAT variable (write)
c           3-D arc length the track moved between points
c return    
c           0 ==> all OK
c           1 ==> track cannot be projected to this radius
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "ctrack_struct.inc"
#include "const.inc"

c     calling arguments
      record /ctrack_struct/ c1, c2
      DFLOAT r
      integer direct
      DFLOAT s3d

c     local variables
      DFLOAT rho, s, circum, xint, yint, zint, uint, vint
      DFLOAT sinps, cosps
      DFLOAT disc, a1, a2, rhoinv, den, delta, x0, y0, z0
      DFLOAT ww1, ww2, s1, s2, sinps1, sinps2, cosps1, cosps2
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      rho = 2. * c1.cu

c     a2 = u0*xr + v0*yr = r*cos(alpha)
c     a2 > 0 when moving away from center (the usual case)

      a2 = c1.u0*c1.xref + c1.v0*c1.yref
      x0 = -c1.da * c1.v0
      y0 =  c1.da * c1.u0
      z0 = c1.z0
      delta = r**2 - (x0+c1.xref)**2 - (y0+c1.yref)**2

c     If moving towards center, two intersections are possible. choose the
c     one first encountered in the direction of motion.

c     need to treat the straight line case specially
      if(rho .eq. 0) then
        disc = (delta + a2**2)
        if(disc .lt. 0.) goto 9999
        disc = sqrt(disc)
        s1 = -a2 - disc
        s2 = -a2 + disc
        if(direct .gt. 0) then
          if(s2 .lt. 0.) then
            goto 9999
          else if(s1 .lt. 0.) then
            s = s2
          else
            s = s1
          endif
        else if(direct .lt. 0) then
          if(s1 .gt. 0.) then
            goto 9999
          else if(s2 .gt. 0.) then
            s = s1
          else
            s = s2
          endif
        else
          if(abs(s1) .le. abs(s2)) then
            s = s1
          else
            s = s2
          endif
        endif

        xint = x0 + c1.xref + c1.u0*s
        yint = y0 + c1.yref + c1.v0*s
        zint = z0 + c1.zref + c1.ct*s
        uint = c1.u0
        vint = c1.v0

c     Circular motion
c     Choose smallest positive arc length for forward projection
c     Choose smallest negative arc length for backward projection
      else
        a1 = 1. + rho*c1.da + rho * (c1.u0*c1.yref - c1.v0*c1.xref)
        disc = 4. * (a1*delta + a2**2) - (rho*delta)**2
        if(disc .lt. 0.) goto 9999
        disc = sqrt(disc)
        den = 1. / (a1**2 + (rho*a2)**2)
        rhoinv = 1. / rho
        circum = tpi * abs(rhoinv)

        ww1 = (a1*delta + 2.*a2**2 - a2*disc) * den
        cosps1 = 1. - 0.5 * rho**2 * ww1
        sinps1 =  0.5*rho * (rho**2*a2*delta - 2.*a1*a2 + a1*disc) * den
        s1 = rhoinv * atan2(sinps1, cosps1)

        ww2 = ww1 + 2.*a2*disc*den
        cosps2 = 1. - 0.5 * rho**2 * ww2
        sinps2 =  sinps1 - rho*a1*disc*den
        s2 = rhoinv * atan2(sinps2, cosps2)

        if(direct .gt. 0) then
          if(s1 .lt. 0) s1 = s1 + circum
          if(s2 .lt. 0) s2 = s2 + circum
          if(s1 .lt. s2) then
            s = s1
            sinps = sinps1
            cosps = cosps1
          else
            s = s2
            sinps = sinps2
            cosps = cosps2
          endif
        else if(direct .lt. 0) then
          if(s1 .gt. 0) s1 = s1 - circum
          if(s2 .gt. 0) s2 = s2 - circum
          if(-s1 .lt. -s2) then
            s = s1
            sinps = sinps1
            cosps = cosps1
          else
            s = s2
            sinps = sinps2
            cosps = cosps2
          endif
        else
          if(abs(s1) .le. abs(s2)) then
            s = s1
          else
            s = s2
          endif
        endif
        uint = c1.u0*cosps - c1.v0*sinps
        vint = c1.v0*cosps + c1.u0*sinps
        xint = x0 + c1.xref + (vint - c1.v0) * rhoinv
        yint = y0 + c1.yref - (uint - c1.u0) * rhoinv
        zint = z0 + c1.zref + c1.ct*s
      endif

c     Use the intersection point as the new reference point
      c2.cu = c1.cu
      c2.phi0 = atan2(vint, uint)
      if(c2.phi0 .lt. 0.) c2.phi0 = c2.phi0 + tpi
      c2.da = 0
      c2.ct = c1.ct
      c2.z0 = 0
      c2.u0 = uint
      c2.v0 = vint
      c2.pt = c1.pt
      c2.p = c1.p
      c2.q = c1.q
      c2.xref = xint
      c2.yref = yint
      c2.zref = zint

      s3d = s * c2.p / c2.pt

c     Normal exit
      move_ctk_radius = 0
      return

c     Error exit
9999  move_ctk_radius = 1
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
