      integer function dcalc_wtk_xyplane_drv(w, xpos, etan, etam, drv)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Calculate the derivatives of the calculated position on a barrel silicon
c   wafer wrt the w track parameters.

c   The derivative uses the calculation in dcalc_wtk_xyplane, which is based
c   on a straight line approximation. The calculation in the present
c   routine assumes that the track lies on the silicon.
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
c  w          w track structure
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
c  drv(7)     DFLOAT array
c             Derivatives of dcalc wrt w track parameters
c
c return    
c           0 ==> all OK
c           1 ==> track cannot be projected
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "wtrack_struct.inc"
#include "const.inc"

c     Externals

c     Calling arguments
      record /wtrack_struct/ w
      integer type
      DFLOAT xpos(3), etan(3), etam(3), drv(7)

c     Local variables
      DFLOAT px0_b, ratio
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     We assume that the track is already at the plane and use
c     the straight line approximation in this region to calculate
c     the derivatives. See the discussion above.

c     Rotated value of px0
      px0_b =  w.px*etan(1) + w.py*etan(2)

      if(px0_b .eq. 0.) goto 9999

      ratio = (w.px*etam(1) + w.py*etam(2) + w.pz*etam(3)) / px0_b

      drv(1) = 0.
      drv(2) = 0.
      drv(3) = 0.
      drv(4) = 0.
      drv(5) = etam(1) - etan(1) * ratio
      drv(6) = etam(2) - etan(2) * ratio
      drv(7) = etam(3) - etan(3) * ratio

c     Normal exit
      dcalc_wtk_xyplane_drv = 0
      return

c     Error exit
 9999 dcalc_wtk_xyplane_drv = 1
      call vzero(drv, 7*FLOAT_WORD)

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:43  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:31:12  garren
c add rcs log line
c
