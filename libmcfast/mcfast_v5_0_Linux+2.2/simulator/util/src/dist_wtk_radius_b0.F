      integer function dist_wtk_radius_b0(w1, r, bf, slen)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Finds distance to radius r in the forward direction in zero
c  B field.
c
c
c  w1       w track structure (read)
c           Input track parameters
c
c  r        DFLOAT variable (read)
c           radius of cylinder
c
c  bf       B field structure (read)
c           B field information
c
c *slen     Arc structure (write)
c           Arc length information
c
c return    
c           0 ==> all OK
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "wtrack_struct.inc"
#include "bfield_struct.inc"
#include "arc_struct.inc"
#include "const.inc"

c     calling arguments
      record /wtrack_struct/ w1
      record /bfield_struct/ bf
      record /arc_struct/ slen
      DFLOAT r

c     local variables
      DFLOAT disc, a2, delta, s1, s2
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(w1.pt .eq. 0.) goto 9999

c     a2 = u0*x0 + v0*y0 = r*cos(alpha)
c     a2 > 0 when moving away from center (the usual case)

      a2 = (w1.px*w1.x + w1.py*w1.y) / w1.pt
      delta = r**2 - w1.x**2 - w1.y**2

c     If moving towards center, two intersections are possible. Choose the
c     one first encountered in the direction of motion.

      disc = (delta + a2**2)
      if(disc .lt. 0.) goto 9999
      disc = sqrt(disc)
      s1 = -a2 - disc
      s2 = -a2 + disc

      if(s1 .lt. s2) then
        slen.s = s1
      else
        slen.s = s2
      endif

      slen.s3d = slen.s * w1.p / w1.pt
      slen.sinps = 0.
      slen.cosps = 1.
 
c     Normal exit
      dist_wtk_radius_b0 = 0
      return

c     No intersection, infinite distance
 9999 slen.s = 1.e20
      slen.s3d = 1.e20
      slen.sinps = 0.
      slen.cosps = 1.

      dist_wtk_radius_b0 = 1

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:28  garren
c add rcs log line
c
