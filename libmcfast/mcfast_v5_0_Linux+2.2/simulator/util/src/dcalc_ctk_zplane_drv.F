      integer function dcalc_ctk_zplane_drv(c, eta, drv)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Calculate the derivatives of the calculated position on a fixed z plane
c   wrt the c track parameters.
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
c  We assume that the reference point is on the plane, but not necessarily
c  at the intersection point. Thus s = 0. The calculated point is
c
c    dcalc = x*eta1 + y*eta2
c
c  ..........................................................................
c
c  Inputs:
c
c  c          c track structure
c             Track parameters
c
c  eta(3)     DFLOAT array
c             Direction cosines of measurement direction
c
c  Outputs:
c
c  drv(5)     DFLOAT array
c             Derivatives of dcalc wrt c track parameters
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
      DFLOAT drv(5), eta(3)
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(c.ct .eq. 0.) goto 9999

      drv(1) = 0.
      drv(2) = -c.da * (c.u0*eta(1) + c.v0*eta(2))
      drv(3) =  -c.v0*eta(1) + c.u0*eta(2)
      drv(4) = 0.
      drv(5) = -(c.u0*eta(1) + c.v0*eta(2)) / c.ct

c     Normal exit
      dcalc_ctk_zplane_drv = 0
      return

c     Error exit
 9999 dcalc_ctk_zplane_drv = 1
      call vzero(drv, 5*FLOAT_WORD)

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:43  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:31:05  garren
c add rcs log line
c
