      integer function dcalc_ftk_zplane_drv(f, eta, drv)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Calculate the derivatives of the calculated position on an FTRK plane
c   layer wrt the f track parameters.
c   
c  ..........................................................................
c  Equations of motion can be written, assuming straight line motion, are
c
c     x = xp + xslp * dz
c     y = yp + yslp * dz
c
c  where dz = z - zp.
c
c  We assume that the reference point is on the plane, but not necessarily
c  at the intersection point. Thus dz = 0. The calculated point is
c
c    dcalc = x*eta1 + y*eta2
c
c  ..........................................................................
c
c  Inputs:
c
c  f          f track structure
c             Track parameters
c
c  eta(3)     DFLOAT array
c             Direction cosines of measurement direction
c
c  Outputs:
c
c  drv(5)     DFLOAT array
c             Derivatives of dcalc wrt f track parameters
c
c return    
c           0 ==> all OK
c           1 ==> track cannot be projected
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "ftrack_struct.inc"

c     Calling arguments
      record /ftrack_struct/ f
      DFLOAT eta(3), drv(5)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      drv(1) = 0.
      drv(2) = 0.
      drv(3) = 0.
      drv(4) = eta(1)
      drv(5) = eta(2)

c     Normal exit
      dcalc_ftk_zplane_drv = 0

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:43  eugenio
c Initial revision
c
c Revision 1.4  1997/04/04 20:31:09  garren
c add rcs log line
c
