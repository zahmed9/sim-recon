      integer function dcalc_wtk_zpixel(w, zplane, dcalcs, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Calculate where a track strikes a pixel plane at fixed z.
c   
c  ..........................................................................
c
c  Equations of motion can be written, assuming straight line motion, as
c
c   x = x0 + px * s/p
c   y = y0 + py * s/p
c   z = z0 + pz * s/p
c
c  where s = arc length.
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
c  w          w track structure
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
#include "wtrack_struct.inc"

c     Calling arguments
      record /wtrack_struct/ w
      integer type
      DFLOAT zplane, dcalcs(2), s3d

c     Local variables
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(w.pz .eq. 0.) goto 9999

      s3d = (zplane - w.z) * w.p / w.pz 

      dcalcs(1) = w.x + s3d * w.px / w.p
      dcalcs(2) = w.y + s3d * w.py / w.p

c     Normal exit
      dcalc_wtk_zpixel = 0
      return

c     Error exit
 9999 dcalc_wtk_zpixel = 1
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
c Revision 1.3  1997/04/04 20:31:12  garren
c add rcs log line
c
