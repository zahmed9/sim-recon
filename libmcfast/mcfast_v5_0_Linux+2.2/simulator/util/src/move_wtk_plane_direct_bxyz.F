      integer function move_wtk_plane_direct_bxyz(w1, pln, bf, beatdist,
     *                                            w2, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c    Projects a track expressed in the w parametrization to a plane
c    (described by the pln structure) in the forward/backward/either
c    direction (direct = +1/-1/0) in an arbitrarily oriented, fixed B
c    field.
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
c    The equation describing the plane can be written in vector form
c
c      [x0_v - xp_v, eta_v] = 0
c
c    where xp_v is a point in the plane and eta_v represents the direction
c    cosines of the normal.
c
c    The equation defining the intersection(s) is
c
c  0 = [delta_v,eta_v] + s * [p0_v,eta_v] / p - 0.5 * s^2 * rho * [ph_v,eta_v]
c
c    where delta_v = x0_v - xp_v and [x,y] is the dot product of the
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
c  pln      plane structure (read)
c           Plane description
c
c  no more 'direct' variable, always forward solution!
c
c  bf       B field structure (read)
c           B field information
c
c  beatdist distance to beat (to speed up algorithm!)
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
#include "plane_struct.inc"
#include "const.inc"

c     Externals
      integer  move_wtk_arc
      external move_wtk_arc

      integer  calc_wtk_plane_direct_b0
      external calc_wtk_plane_direct_b0

c     Calling arguments
      record /wtrack_struct/ w1, w2
      record /bfield_struct/ bf
      record /plane_struct/ pln
      DFLOAT s3d

      DFLOAT beatdist, s_straight

c     local variables
      DFLOAT rho, s, stot, s1, s2, sbound, a
      DFLOAT pdotx, phdotx, ph(3), s1d, s2d, temp
      DFLOAT disc, aa, bb, cc, turns, sgn1, phtot
      DFLOAT delta(3), etadotx, etadotp, etadotph
      integer status, iter
      record /wtrack_struct/ w

      DFLOAT eps, s_min, s_max, s_max_set, turns_max
      integer iter_max
      !save eps, s_max, turns_max, iter_max

      parameter( s_min=1.e-8 )        !Min distance to move in meters
      parameter( s_max_set=1.e10 )    !Max distance to move in meters
      parameter( eps=1.e-4 )          !Distance in meters to define step
      parameter( turns_max=10. )      !Max numbers of turns
      parameter( iter_max=100 )       !Max number of iterations
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(w1.p .eq. 0.) goto 9999

c     reset to max distance every time we're called!
      s_max = s_max_set

#ifndef MKL_SLOW_MOVE /* comment out new speed improvements */
c     cutoff if given positive limit (mkl)
      if( beatdist .ge. 0 ) s_max = beatdist

c ------------- trying to speed up routine ------------------
c ****1.) first try straight line; if can't beat, get out
c (have to ignore status, because could be that straight line algo has
c  no solution, but real algo does!)
      status = calc_wtk_plane_direct_b0(w1, pln, s_straight)
      if( s_straight .gt. s_max ) goto 9997
#endif /* comment out new speed improvements */

c ****2.) do cut off in real algorithm

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

c     Compute dot products
      delta(1) = w.x - pln.xp(1)
      delta(2) = w.y - pln.xp(2)
      delta(3) = w.z - pln.xp(3)
      pdotx = w.px*delta(1) + w.py*delta(2) + w.pz*delta(3)

      etadotx = delta(1)*pln.eta(1) + delta(2)*pln.eta(2)
     *        + delta(3)*pln.eta(3)
      etadotp = w.px*pln.eta(1) + w.py*pln.eta(2) + w.pz*pln.eta(3)
      etadotph = ph(1)*pln.eta(1) + ph(2)*pln.eta(2) + ph(3)*pln.eta(3)

c     Compute the coefficients of the approximate equation
      cc = etadotx
      bb = 0.5*etadotp / w.p
      aa = 0.5 * rho * etadotph / w.p

      disc = bb**2 - aa*cc
      if(disc .lt. 0.) then
        if(rho .eq. 0.) goto 9999
        s = sbound
        goto 200
      endif

      disc = sqrt(disc)
      sgn1 = sign(ONE, bb)
      if(aa .ne. 0.) then
        s1 = (-bb + sgn1*disc) / aa
        s2 = (-bb - sgn1*disc) / aa
      else
        if(bb .eq. 0.) then
          s = sbound
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

c     Keep stepping if both roots outside safe region
      if(abs(s) .ge. sbound) then
        s = sbound
        goto 200
      endif

      s1d = s1
      s2d = s2

c     Both roots backwards
c     If net step (including this one) is in wrong direction, step
c     in correct direction and try again
      if(s1d.lt.0. .and. s2d.lt.0.) then
        if(rho .eq. 0.) goto 9999
        if((s + stot) .lt. 0.) s = sbound
        goto 200

c     Both roots forwards...pick closest one
c     If both outside bounds, step in correct direction and try again
      else if(s1*s2 .gt. 0.) then
        goto 200
        
c     Opposite sign roots
c     If net step (including this one) is in wrong direction, step
c     in correct direction and try again
      else
        if((s + stot) .lt. 0.) then
          if(abs(s2) .lt. sbound) then
            s = s2
          else
            s = sbound
          endif
        endif
        goto 200
        
      endif
      
c  ----------------------------------------------------------------------
c   This code block is used many times
c  ----------------------------------------------------------------------

c     If short enough move, we are done, otherwise repeat
c  200 status = move_wtk_arc(w, s, bf, w)
  200 if(abs(stot) .gt. s_max ) goto 9997
      status = move_wtk_arc(w, s, bf, w)
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
      move_wtk_plane_direct_bxyz = 0
      return

c     Too much distance traveled
c 9996 move_wtk_plane_direct_bxyz = 2
c      goto 9990

c     Too many iterations
 9997 move_wtk_plane_direct_bxyz = 3
      goto 9990

c     Too many turns
 9998 move_wtk_plane_direct_bxyz = 4
      goto 9990

c     No intersection possible
 9999 move_wtk_plane_direct_bxyz = 1

 9990 s3d = 0.
      call ucopy(w1, w2, WTRACK_WORD)
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:45  eugenio
c Initial revision
c
c Revision 1.6  1999/04/23 14:21:07  mkl
c further refinement of speed stuff
c
c Revision 1.5  1999/04/23  04:34:38  mkl
c fix up thanks to Paul's comments
c
c Revision 1.4  1999/04/22  20:34:31  mkl
c minor change
c
c Revision 1.3  1999/04/22  01:27:58  mkl
c only calculate straight solution, dont move
c
c Revision 1.2  1999/04/21  22:41:49  mkl
c further refinements: first look for straight-line solution for quick-guess
c
c Revision 1.1  1999/04/21  20:40:04  mkl
c first version of new faster move_wtk_plane* routines
c
c
