      integer function dcalc_wtk_xypixel(w, xpos, etan, bf, dcalcs, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c    Calculate where a track strikes barrel pixel wafer. Assumes that the
c    track is near the wafer so that a straight line approximation is
c    justified.
c
c    The equations of motion close to the plane are
c
c        x = x0 + px * s/p
c        y = y0 + py * s/p
c        z = z0 + pz * s/p
c
c    where
c
c        s/p = -(dx*etanx + dy*etany) / (px*etanx + py*etany)
c
c    and dx = x - xpos(1), etc.
c
c    The local coordinates on the silicon wafer are
c
c        dx' =  dx*etanx + dy*etany
c        dy' = -dx*etany + dy*etanx
c        dz' =  dz
c
c    The measured coordinates are dy', dz'
c  ..........................................................................
c
c  Inputs:
c  w          w track structure
c             Track parameters before move
c
c  xpos(3)    DFLOAT array
c             Point on the plane
c
c  etan(3)    DFLOAT array
c             Outward normal to wafer
c
c  bf         b field structure
c             B field info
c
c  Outputs:
c  dcalcs     DFLOAT array
c             Position of struck wafer in local coordinates
c
c  s3d        DFLOAT variable
c             Distance track moved
c
c return    
c           0 ==> all OK
c           1 ==> track cannot be projected to plane
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "wtrack_struct.inc"
#include "bfield_struct.inc"
#include "const.inc"

c     Externals

c     Calling arguments
      record /wtrack_struct/ w
      record /bfield_struct/ bf
      DFLOAT xpos(3), etan(3), dcalcs(2), s3d

c     Local variables
      DFLOAT dx0, dy0, dz0, soverp
      DFLOAT px0_b, py0_b, dx0_b, dy0_b, dy_b, dz_b
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Calculate distance vector from wafer origin
      dx0 = w.x - xpos(1)
      dy0 = w.y - xpos(2)
      dz0 = w.z - xpos(3)

c     Calculate the rotated values of px, py, dx0, dy0
      px0_b =  w.px*etan(1) + w.py*etan(2)
      py0_b = -w.px*etan(2) + w.py*etan(1)
      dx0_b =  dx0*etan(1) + dy0*etan(2)
      dy0_b = -dx0*etan(2) + dy0*etan(1)

      if(px0_b .eq. 0.) goto 9999

      soverp = -dx0_b / px0_b    !Arc length / p

c     Calculate the intersection point and measured value
      dy_b = dy0_b + py0_b*soverp
      dz_b = dz0   + w.pz*soverp

      dcalcs(1) = dy_b
      dcalcs(2) = dz_b

c     3-d arc length moved
      s3d = soverp * w.p

c     Normal exit
      dcalc_wtk_xypixel = 0
      return

c     Error exit
 9999 dcalcs(1) = 1.e10
      dcalcs(2) = 1.e10
      dcalc_wtk_xypixel = 1
      s3d = 0.

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:43  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:31:11  garren
c add rcs log line
c
