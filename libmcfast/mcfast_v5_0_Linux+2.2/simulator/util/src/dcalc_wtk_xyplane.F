      integer function dcalc_wtk_xyplane(w, xpos, etan, etam, bf, dcalc,
     *                                s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c    Calculate the distance along a barrel silicon wafer. Assumes that the
c    track is near the plane so that a straight line approximation is
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
c    The measured coordinate is
c
c           dw = dx*etam(1) + dy*etam(2) + dz*etam(3)
c  ..........................................................................
c
c  Inputs:
c  w          w track structure
c             Track parameters before move
c
c  xpos(3)    DFLOAT array
c             Point on the wafer
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
c             Distance along wafer in local coordinate system
c
c  s3d        DFLOAT variable
c             Distance track moved
c
c return    
c           0 ==> all OK
c           1 ==> track cannot be projected to wafer
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "wtrack_struct.inc"
#include "bfield_struct.inc"
#include "const.inc"

c     Externals

c     Calling arguments
      record /wtrack_struct/ w
      record /bfield_struct/ bf
      integer type
      DFLOAT xpos(3), etan(3), etam(3), dcalc, s3d

c     Local variables
      DFLOAT dx0, dy0, dz0, dx, dy, dz
      DFLOAT px0_b, dx0_b, soverp
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      dx0 = w.x - xpos(1)
      dy0 = w.y - xpos(2)
      dz0 = w.z - xpos(3)

c     Calculate the rotated values of px0, x0
      px0_b =  w.px*etan(1) + w.py*etan(2)
      dx0_b =   dx0*etan(1) + dy0*etan(2)

      if(px0_b .eq. 0.) goto 9999

      soverp = -dx0_b / px0_b    !Arc length / p

c     Calculate the intersection point and measured value
      dx = dx0 + w.px*soverp
      dy = dy0 + w.py*soverp
      dz = dz0 + w.pz*soverp

      dcalc = dx*etam(1) + dy*etam(2) + dz*etam(3)

      s3d = soverp * w.p

c     Normal exit
      dcalc_wtk_xyplane = 0
      return

c     Error exit
 9999 dcalc = 1.e10
      dcalc_wtk_xyplane = 1
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
