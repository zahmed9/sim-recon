      integer function dcalc_ftk_axial_drv(f, xpos, bf, drv)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Calculate the derivatives of drift distance to an axial wire wrt the
c   f track parameters. The derivative is based on a straight line
c   approximation.
c
c  ..........................................................................
c  Equations of motion can be written, assuming straight line motion, are
c
c     x = xp + xslp * dz
c     y = yp + yslp * dz
c
c  where dz = z - zp.
c
c  We assume that the reference point is near the wire.
c
c  ..........................................................................
c
c  Inputs:
c  f          f track structure
c             Track parameters
c
c  xpos(3)    DFLOAT array
c             Position of axial wire (z not used)
c
c  bf         b field structure
c             B field info
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

#include "ftrack_struct.inc"
#include "bfield_struct.inc"
#include "const.inc"

c     Externals

c     Calling arguments
      record /ftrack_struct/ f
      record /bfield_struct/ bf
      DFLOAT xpos(3), drv(5)

c     Local variables
      DFLOAT dx, dy, den, fact
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     We assume that the track is already close to the wire and use
c     the straight line approximation in this region to calculate
c     the drift distance.

c     dw = -dy' = -(dy*xslp - dx*yslp) / sqrt(xslp**2 + yslp**2)

      if(f.pt .eq. 0.) goto 9999

      dx = f.xp - xpos(1)
      dy = f.yp - xpos(2)
      den = f.p / f.pt
      fact = (dx*f.xslp + dy*f.yslp) * den**3

      drv(1) = 0.
      drv(2) = -dy * den
      drv(3) =  dx * den
      drv(4) = -f.yslp * fact
      drv(5) =  f.xslp * fact

c     Normal exit
      dcalc_ftk_axial_drv = 0
      return

c     Error exit
 9999 dcalc_ftk_axial_drv = 1
      call vzero(drv, 5*FLOAT_WORD)

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:43  eugenio
c Initial revision
c
c Revision 1.4  1997/04/04 20:31:05  garren
c add rcs log line
c
