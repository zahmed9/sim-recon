      integer function dcalc_ftk_xyplane_drv(f, xpos, etan, etam, drv)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Calculate the derivatives of the calculated position on a barrel silicon
c   layer wrt the f track parameters.
c
c   The derivative uses the calculation in dcalc_ftk_xyplane, which is based
c   on a straight line approximation. The calculation in the present
c   routine assumes that the track lies on the silicon.
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
c  c          c track structure
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
c  Outputs:
c  drv(5)     DFLOAT array
c             Derivatives of dcalc wrt c track parameters
c
c return    
c           0 ==> all OK
c           1 ==> track cannot be projected
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "ftrack_struct.inc"
#include "const.inc"

c     Externals

c     Calling arguments
      record /ftrack_struct/ f
      integer type
      DFLOAT xpos(3), etan(3), etam(3), drv(5)

c     Local variables
      DFLOAT xslp_b, ratio
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     We assume that the track is already at the plane and use
c     the straight line approximation in this region to calculate
c     the derivatives. See the discussion above.

c     Rotated value of xslp
      xslp_b =  f.xslp*etan(1) + f.yslp*etan(2)
      if(xslp_b .eq. 0.) goto 9999

      ratio = (f.xslp*etam(1) + f.yslp*etam(2) + etam(3) ) / xslp_b

      drv(1) = 0.
      drv(2) = 0.
      drv(3) = 0.
      drv(4) = etam(1) - etan(1) * ratio
      drv(5) = etam(2) - etan(2) * ratio

c     Normal exit
      dcalc_ftk_xyplane_drv = 0
      return

c     Error exit
 9999 dcalc_ftk_xyplane_drv = 1
      call vzero(drv, 5*FLOAT_WORD)

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:43  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:07  garren
c add rcs log line
c
