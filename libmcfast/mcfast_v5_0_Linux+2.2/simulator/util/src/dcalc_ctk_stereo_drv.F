      integer function dcalc_ctk_stereo_drv(c, xpos, eta, bf, drv)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Calculate the derivatives of drift distance to a stereo wire wrt
c   the c track parameters. The derivative is based on a straight line
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
c             Position of stereo wire
c
c  eta(3)     DFLOAT array
c             Direction cosines of wire
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
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "ctrack_struct.inc"
#include "bfield_struct.inc"
#include "const.inc"

c     Externals
      external dcalc_ctk_stereo
      integer  dcalc_ctk_stereo

c     Calling arguments
      record /ctrack_struct/ c
      record /bfield_struct/ bf
      DFLOAT xpos(3), eta(3), drv(5)

c     Local variables
      DFLOAT dx, dy, dz, ex, ey, ez, den
      DFLOAT temp, pdoteta, pcrosseta
      integer status
      DFLOAT dcalc, s3d
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     We assume that the track is already close to the wire and use
c     the straight line approximation in this region to calculate
c     the drift distance.

c     dw =   (x0+xref-xw) * (py*etaz - pz*etay) / |p x eta|
c          + (y0+yref-yw) * (pz*etax - px*etaz) / |p x eta|
c          + (z0+zref-zw) * (px*etay - py*etax) / |p x eta|

c     pdoteta   = (p o eta) with pt divided out
c     pcrosseta = |p x eta| with pt divided out
      pdoteta = c.u0*eta(1) + c.v0*eta(2) + c.ct*eta(3)
      pcrosseta = sqrt(1. + c.ct**2 - pdoteta**2)
      if(pcrosseta .eq. 0) goto 9999

      den = 1. / pcrosseta

      dx = -c.da*c.v0 + c.xref - xpos(1)
      dy =  c.da*c.u0 + c.yref - xpos(2)
      dz =  c.z0      + c.zref - xpos(3)

      ex = (c.v0*eta(3) - c.ct*eta(2)) * den
      ey = (c.ct*eta(1) - c.u0*eta(3)) * den
      ez = (c.u0*eta(2) - c.v0*eta(1)) * den

c     Temp for now. Get dcalc from function ???????
      status = dcalc_ctk_stereo(c, xpos, eta, bf, dcalc, s3d)

      temp = dcalc * den**2
      drv(1) = 0.
      drv(2) = 0.  !?????? Fix later
      drv(3) = -c.v0*ex + c.u0*ey
      drv(4) = -temp*(c.ct - pdoteta*eta(3))
     *         - (dx*eta(2) - dy*eta(1)) * den
      drv(5) = ez

c     Normal exit
      dcalc_ctk_stereo_drv = 0
      return

c     Error exit
 9999 dcalc_ctk_stereo_drv = 1
      call vzero(drv, 5*FLOAT_WORD)

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:43  eugenio
c Initial revision
c
c Revision 1.4  1997/04/04 20:31:02  garren
c add rcs log line
c
