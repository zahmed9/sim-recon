      integer function dcalc_ctk_xyplane(c, xpos, etan, etam, bf, dcalc,
     *                                   s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c    Calculate the distance along a barrel silicon wafer. Assumes that the
c    track is near the wafer so that a straight line approximation is
c    justified.
c
c    The equations of motion close to the plane are
c
c        x = -D*v0 + xref + u0 * s
c        y =  D*u0 + yref + v0 * s
c        z =  z0   + zref + ct * s
c
c    where
c
c        s = -(dx*etanx + dy*etany) / (u0*etanx + v0*etany)
c
c    and dx = x - xpos(1), etc.
c
c    The local coordinates on the silicon wafer are
c
c        dx' =  dx*etanx + dy*etany
c        dy' = -dx*etany + dy*etanx
c        dz' =  dz
c
c    The measured coordinate is
c
c           dw = dx*etam(1) + dy*etam(2) + dz*etam(3)
c  ..........................................................................
c
c  Inputs:
c  c          c track structure
c             Track parameters before move
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
c  bf         b field structure
c             B field info
c
c  Outputs:
c  dcalc      DFLOAT variable
c             Distance along plane in local coordinate system
c
c  s3d        DFLOAT variable
c             Distance track moved
c
c return    
c           0 ==> all OK
c           1 ==> track cannot be projected to plane
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "ctrack_struct.inc"
#include "bfield_struct.inc"
#include "const.inc"

c     Externals

c     Calling arguments
      record /ctrack_struct/ c
      record /bfield_struct/ bf
      DFLOAT xpos(3), etan(3), etam(3), dcalc, s3d

c     Local variables
      DFLOAT dx0, dy0, dz0, dx, dy, dz
      DFLOAT u0_b, dx0_b, s
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Calculate distance vector from wafer origin
      dx0 = -c.da*c.v0 + c.xref - xpos(1)
      dy0 =  c.da*c.u0 + c.yref - xpos(2)
      dz0 =  c.z0      + c.zref - xpos(3)

c     Calculate the rotated values of u0, dx0
      u0_b =  c.u0*etan(1) + c.v0*etan(2)
      dx0_b = dx0*etan(1) + dy0*etan(2)

      if(u0_b .eq. 0.) goto 9999

      s = -dx0_b / u0_b   !Arc length in bend plane

c     Calculate the intersection point and measured value
      dx = dx0 + c.u0*s
      dy = dy0 + c.v0*s
      dz = dz0 + c.ct*s

      dcalc = dx*etam(1) + dy*etam(2) + dz*etam(3)

c     3-d arc length moved
      s3d = s * c.p / c.pt

c     Normal exit
      dcalc_ctk_xyplane = 0
      return

c     Error exit
 9999 dcalc = 1.e10
      dcalc_ctk_xyplane = 1
      s3d = 0.

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:43  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:31:03  garren
c add rcs log line
c
