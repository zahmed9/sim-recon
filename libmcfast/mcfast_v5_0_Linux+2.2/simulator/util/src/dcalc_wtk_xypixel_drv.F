      integer function dcalc_wtk_xypixel_drv(w, xpos, etan, drv)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Calculate the derivatives of the calculated position on a barrel pixel
c   wafer wrt the w track parameters.
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
c  Outputs:
c
c  drv(5,2)   DFLOAT array
c             Derivatives of dcalc wrt c track parameters
c  return    
c           0 ==> all OK
c           1 ==> track cannot be projected to plane
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "wtrack_struct.inc"
#include "const.inc"

c     Externals

c     Calling arguments
      record /wtrack_struct/ w
      DFLOAT xpos(3), etan(3), drv(7,2)

c     Local variables
      DFLOAT px0_b
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     We assume that the track is already at the plane and use
c     the straight line approximation in this region to calculate
c     the derivatives. See the discussion above.

c     Calculate the rotated value of px
      px0_b =  w.px*etan(1) + w.py*etan(2)

      if(px0_b .eq. 0.) goto 9999

      drv(1,1) = 0.
      drv(2,1) = 0.
      drv(3,1) = 0.
      drv(4,1) = 0.
      drv(5,1) = -w.py / px0_b
      drv(6,1) =  w.px / px0_b
      drv(7,1) = 0.

      drv(1,2) = 0.
      drv(2,2) = 0.
      drv(3,2) = 0.
      drv(4,2) = 0.
      drv(5,2) = -etan(1) * (w.pz / px0_b)
      drv(6,2) = -etan(2) * (w.pz / px0_b)
      drv(7,2) = 1.

c     Normal exit
      dcalc_wtk_xypixel_drv = 0
      return

c     Error exit
 9999 call vzero(drv, 2*7*FLOAT_WORD)
      dcalc_wtk_xypixel_drv = 1

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:43  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:11  garren
c add rcs log line
c
