      integer function dcalc_ctk_xyplane_drv(c, xpos, etan, etam, drv)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Calculate the derivatives of the calculated position on a barrel silicon
c   wafer wrt the c track parameters.
c
c   The derivative uses the calculation in dcalc_ctk_xyplane, which is based
c   on a straight line approximation. The calculation in the present
c   routine assumes that the track lies on the silicon.
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

#include "ctrack_struct.inc"
#include "const.inc"

c     Externals

c     Calling arguments
      record /ctrack_struct/ c
      integer type
      DFLOAT xpos(3), etan(3), etam(3), drv(5)

c     Local variables
      DFLOAT u0_b, ratio
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     We assume that the track is already at the plane and use
c     the straight line approximation in this region to calculate
c     the derivatives. See the discussion above.

c     Rotated value of u0
      u0_b =  c.u0*etan(1) + c.v0*etan(2)
      if(u0_b .eq. 0.) goto 9999

      ratio = (c.v0*etan(1) - c.u0*etan(2)) / u0_b

      drv(1) = 0.
      drv(2) = 0.
      drv(3) = -c.v0*etam(1) + c.u0*etam(2) + ratio
     *       * (c.u0*etam(1) + c.v0*etam(2) + c.ct*etam(3))
      drv(4) = 0.
      drv(5) = etam(3)

c     Normal exit
      dcalc_ctk_xyplane_drv = 0
      return

c     Error exit
 9999 dcalc_ctk_xyplane_drv = 1
      call vzero(drv, 5*FLOAT_WORD)

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
