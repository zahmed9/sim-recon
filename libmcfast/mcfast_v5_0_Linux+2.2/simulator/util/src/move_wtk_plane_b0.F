      integer function move_wtk_plane_b0(w1, pln, direct, bf, w2, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c    Projects a track expressed in the w parametrization to a plane
c    (described by the cyl structure) in the forward/backward/either
c    direction (direct = +1/-1/0) in a zero B field.
c
c    The vector form of the track equation (for straight line)
c
c         x_v = x_v0 + p0_v/p * s
c
c    where I have used the convention that quantities such as x_v are
c    vectors. p0_v is the momentum, x_v is the position, h_v represents
c    the direction cosines of the B field direction, rho is a/p and s
c    is the three dimensional arc length.
c
c    The equation describing the plane can be written in vector form
c
c      [x_v - xp_v , eta] = 0
c
c    where eta_v represents the direction cosines of the normal and xp_v is a
c    point on the plane.
c
c    The equation defining the intersection(s) is
c
c   0 = [delta_v, eta_v] + s * [p0_v, eta_v]/p
c
c    where delta_v = x0_v - xp_v and [x,y] is the dot product of the
c    vectors x, y.
c
c    
c  ..........................................................................
c
c  w1       w track structure (read)
c           Input track parameters (px, py, pz, E, x, y, z, pt, p, q)
c
c  pln      plane structure (read)
c           plane description
c
c  direct   integer variable (read)
c           +1 ==> project track forward to intersection with plane
c            0 ==> project track to nearest intersection with plane
c           -1 ==> project track backward to intersection with plane
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
#include "plane_struct.inc"
#include "const.inc"

c     Externals
      external move_wtk_arc
      integer  move_wtk_arc

c     Calling arguments
      record /wtrack_struct/ w1, w2
      record /bfield_struct/ bf
      record /plane_struct/ pln
      integer direct
      DFLOAT s3d

c     local variables
      DFLOAT s, bb, cc
      DFLOAT delta(3), etadotx, etadotp
      integer status
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(w1.p .eq. 0.) goto 9999

c     Compute dot products
      delta(1) = w1.x - pln.xp(1)
      delta(2) = w1.y - pln.xp(2)
      delta(3) = w1.z - pln.xp(3)
      etadotx = delta(1)*pln.eta(1) + delta(2)*pln.eta(2)
     *        + delta(3)*pln.eta(3)
      etadotp = w1.px*pln.eta(1) + w1.py*pln.eta(2) + w1.pz*pln.eta(3)

c     Compute the coefficients of the linear equation
      cc = etadotx
      bb = etadotp / w1.p

      if(bb .eq. 0.) goto 9999
      s = -cc / bb

c     direct = +-1 ==> moving in + or - direction
c     Root is backwards
      if(direct .ne. 0 .and. s*direct .lt. 0.) goto 9999
      
  200 status = move_wtk_arc(w1, s, bf, w2)

c     Normal exit
      s3d = s
      move_wtk_plane_b0 = 0
      return

c     No intersection possible
 9999 move_wtk_plane_b0 = 1
      
 9990 s3d = 0.
      call ucopy(w1, w2, WTRACK_WORD)
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:45  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:31:47  garren
c add rcs log line
c
