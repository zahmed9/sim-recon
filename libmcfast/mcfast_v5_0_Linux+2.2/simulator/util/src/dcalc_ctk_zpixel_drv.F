      integer function dcalc_ctk_zpixel_drv(c, drv)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Calculate the derivatives of the calculated position on a pixel plane
c   layer at fixed z wrt the c track parameters.
c
c  ..........................................................................
c
c  Equations of motion can be written, assuming straight line motion, are
c
c   x = -D*v0 + u0 * s
c   y =  D*u0 + v0 * s
c   z =  z0   + ct * s
c
c   Where u0 = cos(phi0)
c         v0 = sin(phi0)
c          s = arc length in x-y plane
c
c  We assume that the reference point is on the plane at the intersection
c  point. Thus s = 0 and D = 0. The derivatives are then easy to calculate.
c
c  ..........................................................................
c
c  Inputs:
c
c  c          c track structure
c             Track parameters
c
c  Outputs:
c
c  drv(5,2)     DFLOAT array
c               Derivatives of dcalc wrt c track parameters
c
c return    
c           0 ==> all OK
c           1 ==> track cannot be projected
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "ctrack_struct.inc"

c     Calling arguments
      record /ctrack_struct/ c
      integer type
      DFLOAT drv(5,2)
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(c.ct .eq. 0.) goto 9999

      drv(1,1) = 0.
      drv(2,1) = 0.
      drv(3,1) = -c.v0
      drv(4,1) = 0.
      drv(5,1) = -c.u0 / c.ct
      drv(1,2) = 0.
      drv(2,2) = 0.
      drv(3,2) = c.u0
      drv(4,2) = 0.
      drv(5,2) = -c.v0 / c.ct

c     Normal exit
      dcalc_ctk_zpixel_drv = 0
      return

c     Error exit
 9999 dcalc_ctk_zpixel_drv = 1
      call vzero(drv, 10*FLOAT_WORD)

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:43  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:31:04  garren
c add rcs log line
c
