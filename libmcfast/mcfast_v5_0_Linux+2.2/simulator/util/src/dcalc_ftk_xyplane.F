      integer function dcalc_ftk_xyplane(f, xpos, etan, etam, bf, dcalc,
     *                                   s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Calculate the distance along a barrel silicon wafer. Assumes that the
c   track is near the plane so that a straight line approximation is
c   justified.
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
c        x' =  dx*etanx + dy*etany
c        y' = -dx*etany + dy*etanx
c        z' =  dz
c
c    The measured coordinate is then
c
c           dw = dx*etam(1) + dy*etam(2) + dz*etam(3)
c
c    from which the derivatives are easy to calculate.
c  ..........................................................................
c
c  Inputs:
c  f          f track structure
c             Track parameters
c
c  xpos(3)    DFLOAT array
c             Point on the plane
c
c  etan(3)    DFLOAT array
c             Outward normal to wafer
c
c  etam(3)    DFLOAT array
c             Measurement vector
c
c  bf         B field structure
c             B field info
c
c  Outputs:
c  dcalc      DFLOAT variable
c             Distance along plane in local coordinate system
c
c  s3d        DFLOAT variable
c             Distance track moved
c
c
c return    
c           0 ==> all OK
c           1 ==> track cannot be projected
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "ftrack_struct.inc"
#include "bfield_struct.inc"
#include "const.inc"

c     Externals

c     Calling arguments
      record /ftrack_struct/ f
      record /bfield_struct/ bf
      integer type
      DFLOAT xpos(3), etan(3), etam(3), dcalc, s3d

c     Local variables
      DFLOAT dx0, dy0, dz0, dx, dy, dz
      DFLOAT xslp_b, dx0_b
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Calculate distance vector from wafer origin
      dx0 = f.xp - xpos(1)
      dy0 = f.yp - xpos(2)
      dz0 = f.zp - xpos(3)

c     Calculate the rotated values of xslp, dx0
      xslp_b =  f.xslp*etan(1) + f.yslp*etan(2)
      dx0_b = dx0*etan(1) + dy0*etan(2)

      if(xslp_b .eq. 0.) goto 9999

      dz = -dx0_b / xslp_b   !Distance to move in z

c     Calculate the intersection point and measured value
      dx = dx0 + f.xslp*dz
      dy = dy0 + f.yslp*dz

      dcalc = dx*etam(1) + dy*etam(2) + (dz0 + dz)*etam(3)

c     3-d arc length moved
      s3d = dz * sqrt(1. + f.xslp**2 + f.yslp**2)

c     Normal exit
      dcalc_ftk_xyplane = 0
      return

c     Error exit
 9999 dcalc_ftk_xyplane = 1

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
