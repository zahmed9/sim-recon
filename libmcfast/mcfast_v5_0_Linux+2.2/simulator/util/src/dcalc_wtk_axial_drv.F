      integer function dcalc_wtk_axial_drv(w, xpos, bf, drv)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Calculate the derivatives of drift distance to an axial wire wrt the
c   w track parameters. The derivative is based on a straight line
c   approximation.
c
c  ..........................................................................
c
c    The equations of motion close to the wire are
c
c        x = x0 + px * s/p
c        y = y0 + py * s/p
c        z = z0 + pz * s/p

c  ..........................................................................
c
c  Inputs:
c  w          w track structure
c             Track parameters
c
c  xpos(3)    DFLOAT array
c             Position of axial wire (z not used)
c
c  bf         b field structure
c             B field info
c
c  Outputs:
c  drv(7)     DFLOAT array
c             Derivatives of dcalc wrt w track parameters
c
c return    
c           0 ==> all OK
c           1 ==> track cannot be projected
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "wtrack_struct.inc"
#include "bfield_struct.inc"
#include "const.inc"

c     Externals
      external dcalc_wtk_axial
      integer  dcalc_wtk_axial

c     Calling arguments
      record /wtrack_struct/ w
      record /bfield_struct/ bf
      DFLOAT xpos(3), drv(7)

c     Local variables
      DFLOAT dx, dy
      integer status
      DFLOAT dcalc, s3d
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     We assume that the track is already close to the wire and use
c     the straight line approximation in this region to calculate
c     the drift distance.

      if(w.pt .eq. 0.) goto 9999

      dx = w.x - xpos(1)
      dy = w.y - xpos(2)

c     Calculate dcalc for now by function ??????
      status = dcalc_wtk_axial(w, xpos, bf, dcalc, s3d)

      drv(1) = -(dy + dcalc*w.px/w.pt) / w.pt
      drv(2) =  (dx + dcalc*w.py/w.pt) / w.pt
      drv(3) = 0.
      drv(4) = 0.
      drv(5) =  w.py / w.pt
      drv(6) = -w.px / w.pt
      drv(7) = 0.

c     Normal exit
      dcalc_wtk_axial_drv = 0
      return

c     Error exit
 9999 dcalc_wtk_axial_drv = 1
      call vzero(drv, 7*FLOAT_WORD)

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:43  eugenio
c Initial revision
c
c Revision 1.4  1997/04/04 20:31:09  garren
c add rcs log line
c
