      integer function move_wtk_cone_bxyz(w1, cone, direct, bf, w2,
     *                                    s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c    Projects a track expressed in the w parametrization to a cone
c    (described by the cone structure) in the forward/backward/either
c    direction (direct = +1/-1/0) in an arbitrarily oriented, fixed B
c    field.
c
c  -----------------------------------------------------------------------
c    Note: for now the cone surface is allowed to be on both sides of
c    the apex.
c  -----------------------------------------------------------------------
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
c    The equation describing the cone can be written in vector form
c
c      |x_v - xc_v|^2 - [(x_v - xc_v),eta_v] / cosa^2 = 0
c
c    where eta_v represents the direction cosines of the axis, xc_v is the
c    apex and cosa is the cosine of half the opening angle.
c
c    The equation defining the intersection(s) is
c
c  0 = |delta_v|^2 - [delta_v,eta_v]^2 / cosa^2
c    + 2 * s * {[delta_v,p0_v] - [delta_v,eta_v]*[p0_v,eta_v] / cosa^2} / p
c    + s^2 * {1 - [p0_v,eta_v]^2 / p^2 / cosa^2
c   - rho * ([ph_v,eta_v] - [delta_v,eta_v] * [ph_v,eta_v] / p / cosa^2) }
c
c    where delta_v = x0_v - xc_v and [x,y] is the dot product of the
c    vectors x, y and ph = p0_v x h_v.
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
c  cone     cone structure (read)
c           Cone description
c
c  direct   integer variable (read)
c           +1 ==> project track forward to intersection with cone
c            0 ==> project track to nearest intersection with cone
c           -1 ==> project track backward to intersection with cone
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
#include "cone_struct.inc"
#include "const.inc"

c     Externals
      external move_wtk_arc
      integer  move_wtk_arc

c     Calling arguments
      record /wtrack_struct/ w1, w2
      record /bfield_struct/ bf
      record /cone_struct/ cone
      integer direct
      DFLOAT s3d

c     local variables
      DFLOAT rho, s, stot, s1, s2, sbound, a
      DFLOAT pdotx, phdotx, ph(3), s1d, s2d, temp
      DFLOAT disc, aa, bb, cc, turns, sgn1, phtot
      DFLOAT delta(3), etadotx, etadotp, etadotph
      DFLOAT secsq
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

      secsq = 1. + cone.tana**2

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

c     Compute dot products
      delta(1) = w.x - cone.xc(1)
      delta(2) = w.y - cone.xc(2)
      delta(3) = w.z - cone.xc(3)
      pdotx = w.px*delta(1) + w.py*delta(2) + w.pz*delta(3)
      phdotx = ph(1)*delta(1) + ph(2)*delta(2) + ph(3)*delta(3)

      etadotx = delta(1)*cone.eta(1) + delta(2)*cone.eta(2)
     *        + delta(3)*cone.eta(3)
      etadotp = w.px*cone.eta(1) + w.py*cone.eta(2) + w.pz*cone.eta(3)
      etadotph = ph(1)*cone.eta(1) + ph(2)*cone.eta(2)
     *         + ph(3)*cone.eta(3)

c     Compute the coefficients of the approximate equation
      cc = delta(1)**2 + delta(2)**2 + delta(3)**2 - etadotx**2*secsq
      bb = (pdotx - etadotp * etadotx * secsq) / w.p
      aa = 1 - (etadotp/w.p)**2 * secsq
     *   - rho * (phdotx - etadotx * etadotph * secsq) / w.p

      disc = bb**2 - aa*cc
      if(disc .lt. 0.) then
        if(rho .eq. 0.) goto 9999
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

c     Keep stepping if both roots outside safe region
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
          if(rho .eq. 0.) goto 9999
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
      move_wtk_cone_bxyz = 0
      return

c     Too much distance traveled
c 9996 move_wtk_cone_bxyz = 2
c      goto 9990

c     Too many iterations
 9997 move_wtk_cone_bxyz = 3
      goto 9990

c     Too many turns
 9998 move_wtk_cone_bxyz = 4
      goto 9990

c     No intersection possible
 9999 move_wtk_cone_bxyz = 1
      
 9990 s3d = 0.
      call ucopy(w1, w2, WTRACK_WORD)
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:45  eugenio
c Initial revision
c
c Revision 1.4  1997/04/04 20:31:45  garren
c add rcs log line
c
