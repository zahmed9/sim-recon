      integer function dcalc_ctk_zplane(c, pos, eta, dcalc, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c   Calculate where a track strikes a plane at fixed z using the c
c   track parameters.  Compute it a local coordinate system specified
c   by pos.
c   
c  ..........................................................................
c
c  Equations of motion can be written, assuming straight line motion, are
c
c   x = -D*v0 + xref + u0 * s - pos(1)
c   y =  D*u0 + yref + v0 * s - pos(2)
c   z =  z0   + zref + ct * s - pos(3)
c
c  where u0 = cos(phi0)
c        v0 = sin(phi0)
c         s = arc length in x-y plane
c       pos = local origin in plane
c
c  The calculated point is
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
c  pos        DFLOAT array
c             Origin of local coordinate system attached to the
c             measurement plane.  The axes of the local system are
c             parallel to those of the world system.
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
#include "ctrack_struct.inc"

c     Calling arguments
      record /ctrack_struct/ c
      DFLOAT pos(3)
      DFLOAT eta(3), dcalc, s3d

c     Local variables
      DFLOAT s
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(c.ct.eq.0. .or. c.pt.eq.0.) goto 9999

c     Calculate arc length in bend plane
      s = (pos(3) - c.zref - c.z0) / c.ct

      dcalc = (-c.da*c.v0 + s*c.u0 + c.xref - pos(1) ) * eta(1)
     *      + ( c.da*c.u0 + s*c.v0 + c.yref - pos(2) ) * eta(2)

      s3d = s * c.p / c.pt

c     Normal exit
      dcalc_ctk_zplane = 0
      return

c     Error exit
 9999 dcalc_ctk_zplane = 1

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:43  eugenio
c Initial revision
c
c Revision 1.4  1999/05/12 20:21:39  kutschke
c 21 files changed/added to implement ctk Kalman filter.
c
c Revision 1.3  1997/04/04  20:31:04  garren
c add rcs log line
c
