      integer function dcalc_ftk_xypixel(f, xpos, etan, bf, dcalcs, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c    Calculate where a track strikes barrel pixel wafer. Assumes that the
c    track is near the wafer so that a straight line approximation is
c    justified.
c
c    The equations of motion close to the plane are
c
c        x = xp + xslp * (z - zp)
c        y = yp + yslp * (z - zp)
c
c    where
c
c        z = zp - (dx*etanx + dy*etany) / (xslp*etanx + yslp*etany)
c
c    and dx = xp - xpos(1), etc.
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
c  f          f track structure
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

#include "ftrack_struct.inc"
#include "bfield_struct.inc"
#include "const.inc"

c     Externals

c     Calling arguments
      record /ftrack_struct/ f
      record /bfield_struct/ bf
      DFLOAT xpos(3), etan(3), dcalcs(2), s3d

c     Local variables
      DFLOAT dx0, dy0, dz0, dz
      DFLOAT xslp_b, yslp_b, dx0_b, dy0_b, dy_b, dz_b
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Calculate distance vector from wafer origin
      dx0 = f.xp - xpos(1)
      dy0 = f.yp - xpos(2)
      dz0 = f.zp - xpos(3)

c     Calculate the rotated values of xslp, yslp, dx0, dy0
      xslp_b =  f.xslp*etan(1) + f.yslp*etan(2)
      yslp_b = -f.xslp*etan(2) + f.yslp*etan(1)
      dx0_b =  dx0*etan(1) + dy0*etan(2)
      dy0_b = -dx0*etan(2) + dy0*etan(1)

      if(xslp_b .eq. 0.) goto 9999

      dz = -dx0_b / xslp_b   !Distance to move in z

c     Calculate the intersection point and measured value
      dy_b = dy0_b + yslp_b*dz
      dz_b = dz0 + dz

      dcalcs(1) = dy_b
      dcalcs(2) = dz_b

c     3-d arc length moved
      s3d = dz * sqrt(1. + f.xslp**2 + f.yslp**2)

c     Normal exit
      dcalc_ftk_xypixel = 0
      return

c     Error exit
 9999 dcalcs(1) = 1.e10
      dcalcs(2) = 1.e10
      dcalc_ftk_xypixel = 1
      s3d = 0.

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:43  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:31:06  garren
c add rcs log line
c
