      integer function dcalc_wtk_stereo_drv(w, xpos, eta, bf, drv)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Calculate the derivatives of drift distance to a stereo wire wrt the
c   w track parameters. The derivative is based on a straight line
c   approximation.
c
c  ..........................................................................
c
c  Equations of motion can be written, assuming straight line motion, as
c
c     x = x0 + px * s/p
c     y = y0 + py * s/p
c     z = z0 + pz * s/p
c
c   where s = arc length.
c  ..........................................................................
c
c  Inputs:
c  w          w track structure
c             Track parameters
c
c  xpos(3)    DFLOAT array
c             Position of stereo wire
c
c  eta(3)     DFLOAT array
c             Direction cosines of wire
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
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "wtrack_struct.inc"
#include "bfield_struct.inc"
#include "const.inc"

c     Externals
      external dcalc_wtk_stereo
      integer  dcalc_wtk_stereo

c     Calling arguments
      record /wtrack_struct/ w
      record /bfield_struct/ bf
      DFLOAT xpos(3), eta(3), drv(7)

c     Local variables
      DFLOAT dx, dy, dz, ex, ey, ez
      DFLOAT temp, pdoteta, pcrosseta, den
      integer status
      DFLOAT dcalc, s3d
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     We assume that the track is already close to the wire and use
c     the straight line approximation in this region to calculate
c     the drift distance.

c     dw =   (x0-xw) * (py*etaz - pz*etay) / |p x eta|
c          + (y0-yw) * (pz*etax - px*etaz) / |p x eta|
c          + (z0-zw) * (px*etay - py*etax) / |p x eta|

      pdoteta = w.px*eta(1) + w.py*eta(2) + w.pz*eta(3)
      pcrosseta = sqrt(w.p**2 - pdoteta**2)
      if(pcrosseta .eq. 0) goto 9999

      den = 1. / pcrosseta

      dx = w.x - xpos(1)
      dy = w.y - xpos(2)
      dz = w.z - xpos(3)

      ex = (w.py*eta(3) - w.pz*eta(2)) * den
      ey = (w.pz*eta(1) - w.px*eta(3)) * den
      ez = (w.px*eta(2) - w.py*eta(1)) * den

c     Temp for now. Get dcalc from function ???????
      status = dcalc_wtk_stereo(w, xpos, eta, bf, dcalc, s3d)

      temp = dcalc * den**2
      drv(1) = -temp*(w.px - pdoteta*eta(1))
     *         - (eta(3)*dy - eta(2)*dz) * den
      drv(2) = -temp*(w.py - pdoteta*eta(2))
     *         - (eta(1)*dz - eta(3)*dx) * den
      drv(3) = -temp*(w.pz - pdoteta*eta(3))
     *         - (eta(2)*dx - eta(1)*dy) * den
      drv(4) = 0.
      drv(5) = ex
      drv(6) = ey
      drv(7) = ez

c     Normal exit
      dcalc_wtk_stereo_drv = 0
      return

c     Error exit
 9999 dcalc_wtk_stereo_drv = 1
      call vzero(drv, 7*FLOAT_WORD)

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:43  eugenio
c Initial revision
c
c Revision 1.4  1997/04/04 20:31:10  garren
c add rcs log line
c
