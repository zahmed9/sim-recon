      integer function dcalc_ctk_axial_drv(c, xpos, bf, drv)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Calculate the derivatives of drift distance to an axial wire wrt the
c   c track parameters. The derivative is based on a straight line
c   approximation.
c   
c  ..........................................................................
c
c  Equations of motion can be written, assuming straight line motion, are
c
c   x = -D*v0 + xref + u0 * s
c   y =  D*u0 + yref + v0 * s
c   z =  z0   + zref + ct * s
c
c   Where u0 = cos(phi0)
c         v0 = sin(phi0)
c          s = arc length in x-y plane
c
c  We assume that the reference point is near the wire.
c  ..........................................................................
c
c  Inputs:
c  c          c track structure
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

#include "ctrack_struct.inc"
#include "bfield_struct.inc"
#include "const.inc"

c     Externals

c     Calling arguments
      record /ctrack_struct/ c
      record /bfield_struct/ bf
      DFLOAT xpos(3), drv(5)

c     Local variables
      DFLOAT dx, dy
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     We assume that the track is already close to the wire and use
c     the straight line approximation in this region to calculate
c     the drift distance.

      if(c.pt .eq. 0.) goto 9999

      dx = c.xref - xpos(1)
      dy = c.yref - xpos(2)

      drv(1) = 0.
      drv(2) = dx*c.u0 + dy*c.v0
      drv(3) = -1.
      drv(4) = 0.
      drv(5) = 0.

c     Normal exit
      dcalc_ctk_axial_drv = 0
      return

c     Error exit
 9999 dcalc_ctk_axial_drv = 1
      call vzero(drv, 5*FLOAT_WORD)

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:43  eugenio
c Initial revision
c
c Revision 1.4  1997/04/04 20:31:01  garren
c add rcs log line
c
