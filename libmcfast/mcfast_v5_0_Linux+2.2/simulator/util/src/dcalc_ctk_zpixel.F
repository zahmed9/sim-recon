      integer function dcalc_ctk_zpixel(c, zplane, dcalcs, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Calculate where a track strikes a pixel plane at fixed z.
c   
c  ..........................................................................
c
c  Equations of motion can be written, assuming straight line motion, are
c
c   x = -D*v0 + xref + u0 * s
c   y =  D*u0 + yref + v0 * s
c   z =  z0   + zref + ct * s
c
c  where u0 = cos(phi0)
c        v0 = sin(phi0)
c         s = arc length in x-y plane
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
c  c          c track structure
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
#include "ctrack_struct.inc"

c     Calling arguments
      record /ctrack_struct/ c
      integer type
      DFLOAT zplane, dcalcs(2), s3d

c     Local variables
      DFLOAT s
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(c.ct.eq.0. .or. c.pt.eq.0.) goto 9999

c     Calculate arc length in bend plane
      s = (zplane - c.z0) / c.ct

      dcalcs(1) = -c.da*c.v0 + c.xref + s*c.u0
      dcalcs(2) =  c.da*c.u0 + c.yref + s*c.v0

      s3d = s * c.p / c.pt

c     Normal exit
      dcalc_ctk_zpixel = 0
      return

c     Error exit
 9999 dcalc_ctk_zpixel = 1
      dcalcs(1) = 1.e10
      dcalcs(2) = 1.e10
      s3d = 0.

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:43  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:31:03  garren
c add rcs log line
c
