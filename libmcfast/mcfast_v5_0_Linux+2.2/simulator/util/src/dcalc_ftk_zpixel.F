      integer function dcalc_ftk_zpixel(f, zplane, dcalcs, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Calculate where a track strikes a pixel plane at fixed z.
c   
c  ..........................................................................
c  Equations of motion can be written, assuming straight line motion, are
c
c     x = xp + xslp * dz
c     y = yp + yslp * dz
c
c  where dz = z - zp.
c
c  The calculated point is
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
c  zplane     DFLOAT variable
c             Z position of plane
c
c  Outputs:
c
c  dcalcs     DFLOAT array
c             Calculated measurement quantities (x and y)
c
c  s3d        DFLOAT variable
c             3-D arc length to plane
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
      DFLOAT zplane, dcalcs(2), s3d

c     Local variables
      DFLOAT dz
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Calculate distance we have to move in z
      dz = zplane - f.zp

      dcalcs(1) = f.xp + dz*f.xslp
      dcalcs(2) = f.yp + dz*f.yslp

      s3d = dz * sqrt(1. + f.xslp**2 + f.yslp**2)

c     Normal exit
      dcalc_ftk_zpixel = 0
      return

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:43  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:31:07  garren
c add rcs log line
c
