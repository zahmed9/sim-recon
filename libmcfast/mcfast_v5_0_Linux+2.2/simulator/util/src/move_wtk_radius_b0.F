      integer function move_wtk_radius_b0(w1, r, direct, bf, w2, s3d)

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
c    if rho is 0 (straight line), the solution becomes
c
c          s = -a2 +- sqrt(delta + a2^2)
c
c    where delta = r^2 - x0^2 - yo^2
c             a2 = u0*x0 + v0*y0
c  .........................................................................
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

#include "const.inc"
#include "wtrack_struct.inc"
#include "bfield_struct.inc"

c     calling arguments
      record /wtrack_struct/ w1, w2
      record /bfield_struct/ bf
      DFLOAT r
      integer direct
      DFLOAT s3d

c     local variables
      DFLOAT s, soverp, s1, s2, a2, disc, delta
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(w1.pt .eq. 0.) goto 9999

c     a2 = u0*x0 + v0*y0 = r*cos(alpha)
c     a2 > 0 when moving away from center (the usual case)

      a2 = (w1.px*w1.x + w1.py*w1.y) / w1.pt
      delta = r**2 - w1.x**2 - w1.y**2

c     If moving towards center, two intersections are possible. choose the
c     one first encountered in the direction of motion.

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

      soverp = s / w1.pt
      w2.x = w1.x + w1.px*soverp
      w2.y = w1.y + w1.py*soverp
      w2.z = w1.z + w1.pz*soverp
      w2.px = w1.px
      w2.py = w1.py
      w2.pz = w1.pz
      w2.E = w1.E
      w2.pt = w1.pt
      w2.p = w1.p
      w2.q = w1.q

      s3d = soverp * w2.p

c     Normal exit
      move_wtk_radius_b0 = 0
      return

c     Error exit
9999  move_wtk_radius_b0 = 1
      call ucopy(w1, w2, WTRACK_WORD)
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:45  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:49  garren
c add rcs log line
c
