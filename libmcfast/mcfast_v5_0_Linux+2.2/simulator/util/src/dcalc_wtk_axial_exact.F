      integer function dcalc_wtk_axial_exact(w, xpos, bf, dcalc, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c   Calculate the drift distance to an axial wire at xpos.
c   This is done in the lazy way by converting the wtrack to a ctrack
c   and using an existing routine.
c
c  ..........................................................................
c
c  Inputs:
c  w          w track structure
c             Track parameters
c
c  xpos(3)    DFLOAT array
c             A point on the stereo wire
c             
c
c  bf         b field structure
c             B field info
c
c  Outputs:
c  dcalc      DFLOAT variable
c             Signed drift distance
c
c  s3d        DFLOAT variable
c             Distance track moved
c
c return    
c           0 ==> all OK
c           1 ==> track cannot be projected
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "wtrack_struct.inc"
#include "ctrack_struct.inc"
#include "bfield_struct.inc"
#include "const.inc"

c     Calling arguments
      record /wtrack_struct/ w
      record /bfield_struct/ bf
      DFLOAT xpos(3), dcalc, s3d

c     Externals
      external cvt_wtk_ctk
      integer  cvt_wtk_ctk

c     Local variables
      record /ctrack_struct/ c
      integer status

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      status = cvt_wtk_ctk(w, xpos, bf, c)
      if ( status .ne. 0 ) goto 9999
      dcalc = -c.da
      s3d   = 0.

c     Normal return.
      return

c     Error return.
 9999 dcalc_wtk_axial_exact = 1
      dcalc = 1.e10
      s3d = 0.

      end
c
c $Id$
c
c $Log$
c Revision 1.1  2000/06/19 19:59:43  eugenio
c Initial revision
c
c Revision 1.1  1999/05/12 20:21:39  kutschke
c 21 files changed/added to implement ctk Kalman filter.
c
c
