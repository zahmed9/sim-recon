      integer function dcalc_wtk_zplane_drv(w, eta, drv)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Calculate the derivatives of the calculated position on a fixed z plane
c   layer wrt the w track parameters.
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
c    dcalc = x*eta1 + y*eta2
c
c  ..........................................................................
c
c  Inputs:
c
c  w          w track structure
c             Track parameters
c
c  eta(3)     DFLOAT array
c             Direction cosines of measurement direction
c
c  Outputs:
c
c  drv(7)     DFLOAT array
c             Derivatives of dcalc wrt w track parameters
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
      DFLOAT eta(3), drv(7)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(w.pz .eq. 0.) goto 9999

c     Be sure to account for uncertainty in z which can change x, y
      drv(1) = 0.
      drv(2) = 0.
      drv(3) = 0.
      drv(4) = 0.
      drv(5) = eta(1)
      drv(6) = eta(2)
      drv(7) = -(w.px*eta(1) + w.py*eta(2)) / w.pz 

c     Normal exit
      dcalc_wtk_zplane_drv = 0
      return

c     Error exit
 9999 dcalc_wtk_zplane_drv = 1
      call vzero(drv, 7*FLOAT_WORD)

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:43  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:31:16  garren
c add rcs log line
c
