      integer function move_wtk_radius_bxyz(w1, r, direct, bf, w2, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c    Projects a track expressed in the w parametrization to a radius r
c    in the forward/backward/either direction (direct = +1/-1/0) in an
c    arbitrary B field.
c
c    In general, there is no closed form solution, so we proceed by using
c    a parabolic approximation to the equations of motion. The vector form
c    of the exact equations is
c
c       x_v = x_v0 - (p0_v x h_v x h_v)/a * sin(rho*s)
c                  - (p0_v x h)/a * (1 - cos(rho*s))
c                  + [p0_v,h_v]/p * h_v * s
c
c    The vector form of the approximate equations is
c
c         x_v = x_v0 + p0_v/p * s - 0.5 * (p0_v x h_v)/p * rho * s^2
c
c    where I have used the convention that quantities such as x_v are
c    vectors. p0_v is the momentum, x_v is the position, h_v represents
c    the direction cosines of the B field direction, rho is a/p and s
c    is the three dimensional arc length.
c
c    The equation defining the intersection(s) is
c
c  0 = r^2 - r0^2 - 2*{[x0,p0] - z0*pz}/p*s
c          + {rho*[x0,ph]/p - rho*z0*phz/p - pt^2/p^2} * s^2
c
c    where [x,y] is the dot product of the vectors, x, y and ph = p0_v x h_v.
c
c    The exact solution requires iteration and proceeds by the following
c    steps.
c
c    1. Decide the size of s for which the equations are valid. This is
c       done by solving rho^2 * step^3/6 = delta, where delta is a small
c       distance. The LHS is the neglected term in the sin(rho*s)/rho part
c       of the equations of motion.
c
c    2. Find a solution for s using the parabolic equations and
c       compute s_tot, the total distance moved.
c
c    3. s_tot should have the correct sign depending on the variable "direct".
c       If it doesn't, increment s by "step" in the correct direction and
c       go to (2). If the sign is correct, but |s| > step, then increment
c       s by "step" and go to (2) (when stepping, if the total angular
c       turn is larger than some set maximum, quit.).
c
c    4. Iterate the following steps
c          (a) Move the track by s
c          (b) Generate a new approximation
c          (c) Solve for the new value of s
c          (d) Go to (a) unless s < eps
c       
c
c    
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
c           1 ==> could not find solution
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "wtrack_struct.inc"
#include "bfield_struct.inc"
#include "const.inc"

c     Externals
      external move_wtk_arc
      integer  move_wtk_arc

c     Calling arguments
      record /wtrack_struct/ w1, w2
      record /bfield_struct/ bf
      DFLOAT r
      integer direct
      DFLOAT s3d

c     local variables
      DFLOAT rho, s, stot, s1, s2, sbound, a
      DFLOAT pdotx, phdotx, ph(3), s1d, s2d, temp
      DFLOAT disc, aa, bb, cc, turns, sgn1, phtot
      integer status, iter
      record /wtrack_struct/ w

      DFLOAT eps, s_min, s_max, turns_max
      integer iter_max
      save eps, s_max, turns_max, iter_max

      data eps/1.e-4/      !Distance in meters to define step
      data s_min/1.e-8/    !Min distance to move in meters
      data s_max/1.e10/    !Max distance to move in meters
      data turns_max/10./  !Max numbers of turns
      data iter_max/100/   !Max number of iterations
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(w1.p .eq. 0.) goto 9999

      stot = 0.
      turns = 0.
      iter = 0

      call ucopy(w1, w, WTRACK_WORD)   !Use temporary variable

c     Calculate region in s where approximation is valid
      a = c_b * bf.bmag * w1.q
      rho = a / w1.p

c     Compute p0 x h
 10   ph(1) = w.py*bf.bdir(3) - w.pz*bf.bdir(2)
      ph(2) = w.pz*bf.bdir(1) - w.px*bf.bdir(3)
      ph(3) = w.px*bf.bdir(2) - w.py*bf.bdir(1)
      phtot = sqrt(ph(1)**2 + ph(2)**2 + ph(3)**2)

      if(rho.ne.0. .and. phtot.ne.0.) then
        sbound = (6.*eps*unit_meter * w1.p/phtot / rho**2)**(1./3.)
      else
        sbound = 1.e4 * unit_meter
      endif
c     Compute [x0,p0], [x0,ph]
      pdotx  = w.px*w.x + w.py*w.y + w.pz*w.z
      phdotx = ph(1)*w.x + ph(2)*w.y + ph(3)*w.z

c     Compute the coefficients of the approximate equation
      cc = r**2 - w.x**2 - w.y**2
      bb = (w.z*w.pz - pdotx) / w.p
      aa = rho * (phdotx - w.z*ph(3)) / w.p - w.pt**2 / w.p**2

      disc = bb**2 - aa*cc
      if(disc .lt. 0.) then
        if(direct .eq. 0) then
          s = sbound
        else
          s = sbound * direct
        endif
        goto 200
      endif

      disc = sqrt(disc)
      sgn1 = sign(ONE, bb)
      if(aa .ne. 0.) then
        s1 = (-bb + sgn1*disc) / aa
        s2 = (-bb - sgn1*disc) / aa
      else
        if(bb .eq. 0.) then
          if(direct .eq. 0) then
            s = sbound
          else
            s = sbound * direct
          endif
          goto 200
        else
          s1 = -0.5*cc / bb
          s2 = s1
        endif
      endif

      s = s1

c  ---------------------------------------------------------------------
c     In general, two intersections are possible. Choose the one
c     encountered first in the direction of motion.
c  ---------------------------------------------------------------------

c     direct = 0 ==> no preferred direction, find closest root
      if(direct .eq. 0) then
 
c     If short enough move, we are done, otherwise repeat
        if(abs(s) .ge. sbound) then  !Both roots outside safe region
          if(s1*s2 .lt. 0.) then
            s = sbound             !Go forward if roots opposite in sign
          else
            s = sign(sbound, s)    !Go in correct direction if same sign
          endif
        endif

        goto 200

      else
c     direct = +-1 ==> moving in + or - direction

c     Keep stepping if both roots outside active region
        if(abs(s) .ge. sbound) then
          s = sbound * direct
          goto 200
        endif

        s1d = s1 * direct
        s2d = s2 * direct

c     Both roots backwards
c     If net step (including this one) is in wrong direction, step
c     in correct direction and try again
        if(s1d.lt.0. .and. s2d.lt.0.) then
          if((s + stot)*direct .lt. 0.) s = sbound * direct
          goto 200

c     Both roots forwards...pick closest one
c     If both outside bounds, step in correct direction and try again
        else if(s1*s2 .gt. 0.) then
          goto 200

c     Opposite sign roots
c     If net step (including this one) is in wrong direction, step
c     in correct direction and try again
        else
          if((s + stot)*direct .lt. 0.) then
            if(abs(s2) .lt. sbound) then
              s = s2
            else
              s = sbound * direct
            endif
          endif
          goto 200

        endif
 
      endif

c  ----------------------------------------------------------------------
c   This code block is used many times
c  ----------------------------------------------------------------------

c     If short enough move, we are done, otherwise repeat
  200 status = move_wtk_arc(w, s, bf, w)
      stot = stot + s
      turns = turns + abs(rho*s)/tpi
      iter = iter + 1
      if(abs(s) .le. s_min*unit_meter) goto 1000
      if(iter .gt. iter_max) goto 9998
      if(abs(stot) .gt. s_max) goto 9997
      if(turns .ge. turns_max) goto 9999
      goto 10

c     Normal exit
 1000 call ucopy(w, w2, WTRACK_WORD)
      s3d = stot
      move_wtk_radius_bxyz = 0
      return

c     Too much distance traveled
 9997 move_wtk_radius_bxyz = 1
      goto 9990

c     Too many iterations
 9998 move_wtk_radius_bxyz = 2
      goto 9990

c     Too many turns
 9999 move_wtk_radius_bxyz = 3

 9990 s3d = 0.
      call ucopy(w1, w2, WTRACK_WORD)
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:45  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:31:50  garren
c add rcs log line
c
