      integer function dcalc_ftk_zpixel_drv(f, drv)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Calculate the derivatives of the calculated position on a pixel plane
c   layer at fixed z wrt the f track parameters.
c   
c  ..........................................................................
c
c  Equations of motion can be written, assuming straight line motion, are
c
c   x = xp + xslp * dz
c   y = yp + yslp * dz
c
c   where dz = zplane - zp
c
c  We assume that the track is on the plane, thus dz = 0. The calculated
c  point is
c
c    dcalc(1) = x
c    dcalc(2) = y
c
c  ..........................................................................
c
c  Inputs:
c
c  f          f track structure
c             Track parameters
c
c  Outputs:
c
c  drv(5,2)     DFLOAT array
c               Derivatives of dcalc wrt f track parameters
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
      integer type
      DFLOAT drv(5,2)
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      drv(1,1) = 0.
      drv(2,1) = 0.
      drv(3,1) = 0.
      drv(4,1) = 1.
      drv(5,1) = 0.

      drv(1,2) = 0.
      drv(2,2) = 0.
      drv(3,2) = 0.
      drv(4,2) = 0.
      drv(5,2) = 1.

c     Normal exit
      dcalc_ftk_zpixel_drv = 0

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:43  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:08  garren
c add rcs log line
c
