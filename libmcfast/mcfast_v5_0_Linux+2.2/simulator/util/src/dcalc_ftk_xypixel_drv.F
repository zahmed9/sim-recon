      integer function dcalc_ftk_xypixel_drv(f, xpos, etan, drv)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Calculate the derivatives of the calculated position on a barrel pixel
c   wafer wrt the f track parameters.
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
c  Outputs:
c
c  drv(5,2)   DFLOAT array
c             Derivatives of dcalc wrt c track parameters
c  return    
c           0 ==> all OK
c           1 ==> track cannot be projected to plane
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "ftrack_struct.inc"
#include "const.inc"

c     Externals

c     Calling arguments
      record /ftrack_struct/ f
      DFLOAT xpos(3), etan(3), drv(5,2)

c     Local variables
      DFLOAT xslp_b, yslp_b
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     We assume that the track is already at the plane and use
c     the straight line approximation in this region to calculate
c     the derivatives. See the discussion above.

c     Calculate the rotated values of xslp, yslp, dx0, dy0
      xslp_b =  f.xslp*etan(1) + f.yslp*etan(2)
      yslp_b = -f.xslp*etan(2) + f.yslp*etan(1)

      if(xslp_b .eq. 0.) goto 9999

      drv(1,1) = 0.
      drv(2,1) = 0.
      drv(3,1) = 0.
      drv(4,1) = -etan(2)**2 / xslp_b
      drv(5,1) =  etan(1)**2 / xslp_b

      drv(1,2) = 0.
      drv(2,2) = 0.
      drv(3,2) = 0.
      drv(4,2) = -etan(1) / xslp_b
      drv(5,2) = -etan(2) / xslp_b

c     Normal exit
      dcalc_ftk_xypixel_drv = 0
      return

c     Error exit
 9999 call vzero(drv, 10*FLOAT_WORD)
      dcalc_ftk_xypixel_drv = 1

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:43  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:06  garren
c add rcs log line
c
