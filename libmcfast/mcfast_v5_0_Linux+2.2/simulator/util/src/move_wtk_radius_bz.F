      integer function move_wtk_radius_bz(w1, r, direct, bf, w2, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c    Projects a track expressed in the w parametrization to a radius r
c    in the forward/backward/either direction (direct = +1/-1/0) in a
c    solenoidal B field.
c
c    If there is more than one solution, the one first encountered by the
c    track (moving in the appropriate direction) is chosen. if the track
c    cannot be projected to this radius lerror is set to true and track2
c    is set to track1.
c
c    The algorithm starts with the helix equations of motion
c
c         x = x0 + (u0/rho)*sin(rho*s) - (v0/rho)*(1-cos(rho*s))
c         y = y0 + (v0/rho)*sin(rho*s) + (u0/rho)*(1-cos(rho*s))
c         z = z0 + ct*s
c
c    where
c    (x0,y0,z0) is the starting point
c    (u0,v0,ct) = (px/pt,py/pt,pz/pt) at that point
c    rho = 1/radius of curvature = c_b * Bfield * q
c    s is the arc length in the x-y plane from (x0,y0,z0).
c
c    Squaring and adding the 2-d equations we get
c
c     0 = -delta + (2/rho)*a2*sin(rho*s) + (2/rho^2)*a1*(1-cos(rho*s))
c
c    where delta = r^2 - x0^2 - yo^2
c          a1 = 1 + rho * (u0*y0 - v0*x0)
c          a2 = u0*x0 + v0*y0
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
c  ..........................................................................
c
c  w1       w track structure (read)
c           Input track parameters (px, py, pz, E, x, y, z, pt, p, q)
c
c  r        DFLOAT variable (read)
c           radius of cylinder
c
c  direct   integer variable (read)
c           +1 ==> project track forward to intersection with r
c            0 ==> project track to nearest intersection with r
c           -1 ==> project track backward to intersection with r
c
c  bf       B field structure (read)
c           B field information
c
c *w2       w track structure (write)
c           output track parameters (px, py, pz, E, x, y, z, pt, p, q)
c
c *s3d      DFLOAT variable (write)
c           3-D arc length the track moved between points
c
c return    
c           0 ==> all OK
c           1 ==> track cannot be projected to this radius
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "wtrack_struct.inc"
#include "bfield_struct.inc"
#include "const.inc"

c     calling arguments
      record /wtrack_struct/ w1, w2
      record /bfield_struct/ bf
      DFLOAT r
      integer direct
      DFLOAT s3d

c     local variables
      DFLOAT rho, s, soverp, circum, a, ainv
      DFLOAT sinps, cosps, dcosps, px, py
      DFLOAT disc, a1, a2, rhoinv, den, delta
      DFLOAT ww1, ww2, s1, s2, sinps1, sinps2, cosps1, cosps2
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(w1.pt .eq. 0.) goto 9999

      a = c_b * bf.bmag * bf.bdir(3) * w1.q
      ainv = 1. / a
      rho = a / w1.pt

c     a2 = u0*x0 + v0*y0 = r*cos(alpha)
c     a2 > 0 when moving away from center (the usual case)

      a2 = (w1.px*w1.x + w1.py*w1.y) / w1.pt
      delta = r**2 - w1.x**2 - w1.y**2

c     If moving towards center, two intersections are possible. choose the
c     one first encountered in the direction of motion.

c     Circular motion
c     Choose smallest positive arc length for forward projection
c     Choose smallest negative arc length for backward projection
      a1 = 1. + rho * (w1.px*w1.y - w1.py*w1.x) / w1.pt
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
          sinps = sinps1
          cosps = cosps1
        else
          s = s2
          sinps = sinps2
          cosps = cosps2
        endif
      endif
      soverp = s / w1.pt
      dcosps = 1. - cosps
      w2.x = w1.x + (w1.px*sinps - w1.py*dcosps) * ainv
      w2.y = w1.y + (w1.py*sinps + w1.px*dcosps) * ainv
      w2.z = w1.z + w1.pz*soverp

      px = w1.px
      py = w1.py
      w2.px = px*cosps - py*sinps
      w2.py = py*cosps + px*sinps
      w2.pz = w1.pz
      w2.E = w1.E

      w2.pt = w1.pt
      w2.p = w1.p
      w2.q = w1.q

      s3d = soverp * w2.p

c     Normal exit
      move_wtk_radius_bz = 0
      return

c     Error exit
9999  move_wtk_radius_bz = 1
      call ucopy(w1, w2, WTRACK_WORD)
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:45  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:50  garren
c add rcs log line
c
