      integer function move_wtk_cylinder_b0(w1, cyl, direct, bf, w2,
     *                                      s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c    Projects a track expressed in the w parametrization to a cylinder
c    (described by the cyl structure) in the forward/backward/either
c    direction (direct = +1/-1/0) in a zero B field.
c
c    The vector form of the track equation (for straight line)
c
c         x_v = x_v0 + p0_v/p * s
c
c    where I have used the convention that quantities such as x_v are
c    vectors. p0_v is the momentum and x_v is the position.
c
c    The equation describing the cylinder can be written in vector form
c
c      |x_v - xc_v|^2 - [(x_v - xc_v),eta_v] = r^2
c
c    where eta_v represents the direction cosines of the axis and xc_v
c    is the center.
c
c    The equation defining the intersection(s) is
c
c   0 = |delta_v|^2 - [delta_v,eta_v]^2 - r^2
c     + 2 * s * {[delta_v,p0_v] - [delta_v,eta_v]*[p0_v,eta_v]} / p
c     + s^2 * {1 - [p0_v,eta_v]^2 / p^2 }
c
c    where delta_v = x0_v - xc_v and [x,y] is the dot product of the
c    vectors x, y and ph = p0_v x h_v.
c
c    
c  ..........................................................................
c
c  w1       w track structure (read)
c           Input track parameters (px, py, pz, E, x, y, z, pt, p, q)
c
c  cyl      cylinder structure (read)
c           cylinder description
c
c  direct   integer variable (read)
c           +1 ==> project track forward to intersection with cylinder
c            0 ==> project track to nearest intersection with cylinder
c           -1 ==> project track backward to intersection with cylinder
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
#include "cylinder_struct.inc"
#include "const.inc"

c     Externals
      external move_wtk_arc
      integer  move_wtk_arc

c     Calling arguments
      record /wtrack_struct/ w1, w2
      record /bfield_struct/ bf
      record /cylinder_struct/ cyl
      integer direct
      DFLOAT s3d

c     local variables
      DFLOAT s, s1, s2, pdotx
      DFLOAT disc, aa, bb, cc, sgn1
      DFLOAT delta(3), etadotx, etadotp
      integer status
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(w1.p .eq. 0.) goto 9999

c     Compute dot products
      delta(1) = w1.x - cyl.xc(1)
      delta(2) = w1.y - cyl.xc(2)
      delta(3) = w1.z - cyl.xc(3)
      pdotx = w1.px*delta(1) + w1.py*delta(2) + w1.pz*delta(3)
      etadotx = delta(1)*cyl.eta(1) + delta(2)*cyl.eta(2)
     *        + delta(3)*cyl.eta(3)
      etadotp = w1.px*cyl.eta(1) + w1.py*cyl.eta(2) + w1.pz*cyl.eta(3)

c     Compute the coefficients of the quadratic equation
      cc = delta(1)**2 + delta(2)**2 + delta(3)**2 - etadotx**2
     *   - cyl.radius**2
      bb = (pdotx - etadotp * etadotx) / w1.p
      aa = 1 - (etadotp/w1.p)**2

      disc = bb**2 - aa*cc
      if(disc .lt. 0.) goto 9999

      disc = sqrt(disc)
      sgn1 = sign(ONE, bb)
      if(aa .ne. 0.) then
        s1 = (-bb + sgn1*disc) / aa
        s2 = (-bb - sgn1*disc) / aa
      else
        if(bb .eq. 0.) then
          goto 9999
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

c     direct = +-1 ==> moving in + or - direction
      if(direct .ne. 0) then

c     Both roots backwards
        if(s1*direct.lt.0. .and. s2*direct.lt.0.) goto 9999

c     Opposite sign roots, choose the one in the correct direction
        if(s1*s2 .lt.0.) then
          if(s1*direct .lt. 0.) s = s2*direct
        endif

      endif
      
  200 status = move_wtk_arc(w1, s, bf, w2)

c     Normal exit
      s3d = s
      move_wtk_cylinder_b0 = 0
      return

c     No intersection possible
 9999 move_wtk_cylinder_b0 = 1
      
 9990 s3d = 0.
      call ucopy(w1, w2, WTRACK_WORD)
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:45  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:31:46  garren
c add rcs log line
c
