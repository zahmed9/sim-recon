      integer function dcalc_ftk_zplane(f, zplane, eta, dcalc, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Calculate where a track strikes a plane at fixed z using the f
c   track parameters.
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
c    dcalc = x*eta1 + y*eta2
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
c  eta(3)     DFLOAT array
c             Direction cosines of measurement direction
c
c  Outputs:
c
c  dcalc      DFLOAT variable
c             Calculated measurement quantity
c
c  s3d        DFLOAT variable
c             3-D arc length to plane
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
      DFLOAT zplane, eta(3), dcalc, s3d

c     Local variables
      DFLOAT dz
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Calculate distance we have to move in z
      dz = zplane - f.zp

      dcalc = (f.xp + dz*f.xslp) * eta(1)
     *      + (f.yp + dz*f.yslp) * eta(2)

      s3d = dz * sqrt(1. + f.xslp**2 + f.yslp**2)

c     Normal exit
      dcalc_ftk_zplane = 0

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:43  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:31:08  garren
c add rcs log line
c
