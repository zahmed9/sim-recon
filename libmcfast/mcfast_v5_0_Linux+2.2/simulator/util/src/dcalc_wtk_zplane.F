      integer function dcalc_wtk_zplane(w, pos, eta, dcalc, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c   Calculate where a track strikes a plane at fixed z using the w
c   track parameters.  Compute it a local coordinate system specified
c   by pos.
c   
c  ..........................................................................
c
c  Equations of motion can be written, assuming straight line motion, as
c
c     x = x0 + px * s/p - pos(1)
c     y = y0 + py * s/p - pos(2)
c     z = z0 + pz * s/p - pos(3)
c
c   where  s = arc length
c        pos = local origin
c
c   The quantity of interest is
c
c     dcalc = x*eta1 + y*eta2
c
c  ..........................................................................
c
c  Inputs:
c
c  w          w track structure
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
#include "wtrack_struct.inc"

c     Calling arguments
      record /wtrack_struct/ w
      DFLOAT pos(3), eta(3), dcalc, s3d

c     Local variables
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(w.pz .eq. 0.) goto 9999
      s3d = (pos(3) - w.z) * w.p / w.pz 

      dcalc = (w.x - pos(1) + s3d*w.px/w.p) * eta(1)
     *      + (w.y - pos(2) + s3d*w.py/w.p) * eta(2)

c     Normal exit
      dcalc_wtk_zplane = 0
      return

c     Error exit
 9999 dcalc_wtk_zplane = 1
      dcalc = 0.

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:43  eugenio
c Initial revision
c
c Revision 1.4  1999/05/12 20:21:40  kutschke
c 21 files changed/added to implement ctk Kalman filter.
c
c Revision 1.3  1997/04/04  20:31:15  garren
c add rcs log line
c
