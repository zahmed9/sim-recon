      integer function dcalc_ctk_xypixel_drv(c, xpos, etan, drv)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Calculate the derivatives of the calculated position on a barrel pixel
c   wafer wrt the c track parameters.
c
c   The derivative uses the calculation in dcalc_ctk_xypixel, which is based
c   on a straight line approximation. The calculation in the present
c   routine assumes that the track lies on the wafer.
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
c    The measured coordinates are dy', dz'
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
c  Outputs:
c  drv(5,2)   DFLOAT array
c             Derivatives of dcalc wrt c track parameters
c
c  return    
c           0 ==> all OK
c           1 ==> track cannot be projected to plane
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "ctrack_struct.inc"
#include "const.inc"

c     Externals

c     Calling arguments
      record /ctrack_struct/ c
      DFLOAT xpos(3), etan(3), drv(5,2)

c     Local variables
      DFLOAT u0_b, v0_b
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     We assume that the track is already at the plane and use
c     the straight line approximation in this region to calculate
c     the derivatives. See the discussion above.

c     Calculate the rotated values of u0, v0
      u0_b =  c.u0*etan(1) + c.v0*etan(2)
      v0_b = -c.u0*etan(2) + c.v0*etan(1)

      if(u0_b .eq. 0.) goto 9999

      drv(1,1) = 0.
      drv(2,1) = 0.
      drv(3,1) = 1. / u0_b
      drv(4,1) = 0.
      drv(5,1) = 0.

      drv(1,2) = 0.
      drv(2,2) = 0.
      drv(3,2) = c.ct * v0_b / u0_b
      drv(4,2) = 0.
      drv(5,2) = 1.

c     Normal exit
      dcalc_ctk_xypixel_drv = 0
      return

c     Error exit
 9999 call vzero(drv, 10*FLOAT_WORD)
      dcalc_ctk_xypixel_drv = 1

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:43  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:02  garren
c add rcs log line
c
