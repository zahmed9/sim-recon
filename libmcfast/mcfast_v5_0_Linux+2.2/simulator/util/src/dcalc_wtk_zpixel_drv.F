      integer function dcalc_wtk_zpixel_drv(w, drv)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Calculate the derivatives of the calculated position on a pixel plane
c   layer at fixed z wrt the w track parameters.
c   
c  ..........................................................................
c
c  Equations of motion can be written, assuming straight line motion, as
c
c   x = x0 + px * s/p
c   y = y0 + py * s/p
c   z = z0 + pz * s/p
c
c   where s = arc length
c
c  We assume that the initial point is on the plane, but not necessarily
c  at the intersection point. Thus s = 0. The calculated point is
c
c    dcalc(1) = x
c    dcalc(2) = y
c
c  ..........................................................................
c
c  Inputs:
c
c  w          w track structure
c             Track parameters
c
c  Outputs:
c
c  drv(7,2)     DFLOAT array
c               Derivatives of dcalc wrt w track parameters
c
c return    
c           0 ==> all OK
c           1 ==> track cannot be projected
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "wtrack_struct.inc"

c     Calling arguments
      record /wtrack_struct/ w
      integer type
      DFLOAT drv(7,2)
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(w.pz .eq. 0.) goto 9999

      drv(1,1) = 0.
      drv(2,1) = 0.
      drv(3,1) = 0.
      drv(4,1) = 0.
      drv(5,1) = 1.
      drv(6,1) = 0.
      drv(7,1) = -w.px / w.pz 

      drv(1,2) = 0.
      drv(2,2) = 0.
      drv(3,2) = 0.
      drv(4,2) = 0.
      drv(5,2) = 0.
      drv(6,2) = 1.
      drv(7,2) = -w.py / w.pz 

c     Normal exit
      dcalc_wtk_zpixel_drv = 0
      return

c     Error exit
 9999 call vzero(drv, 2*7*FLOAT_WORD)
      dcalc_wtk_zpixel_drv = 1

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:43  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:31:13  garren
c add rcs log line
c
