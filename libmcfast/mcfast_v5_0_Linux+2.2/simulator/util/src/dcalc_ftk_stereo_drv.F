      integer function dcalc_ftk_stereo_drv(f, xpos, eta, bf, dcalc,
     *                                      drv)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Calculate the derivatives of drift distance to a stereo wire wrt
c   the f track parameters. The derivative is based on a straight line
c   approximation.
c
c  ..........................................................................
c  Equations of motion can be written, assuming straight line motion, are
c
c     x = xp + xslp * dz
c     y = yp + yslp * dz
c
c  where dz = z - zp.
c
c  ..........................................................................
c
c  Inputs:
c  f          f track structure
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
c  dcalc      DFLOAT variable
c             Signed drift distance
c
c  Outputs:
c  drv(5)     DFLOAT array
c             Derivatives of dcalc wrt c track parameters
c
c return    
c           0 ==> all OK
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "ftrack_struct.inc"
#include "bfield_struct.inc"
#include "const.inc"

c     Externals

c     Calling arguments
      record /ftrack_struct/ f
      record /bfield_struct/ bf
      DFLOAT xpos(3), eta(3), dcalc, drv(5)

c     Local variables
      DFLOAT dx, dy, dz, ex, ey, ez, den, Qz
      DFLOAT temp, pdoteta, pcrosseta
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     We assume that the track is already close to the wire and use
c     the straight line approximation in this region to calculate
c     the drift distance.

c     dw =   (xp-xw) * (yslp*etaz -      etay) / (alpha*|p x eta|)
c          + (yp-yw) * (     etax - xslp*etaz) / (alpha*|p x eta|)
c          + (zp-zw) * (xslp*etay - yslp*etax) / (alpha*|p x eta|)

c     pdoteta   = (p o eta) with pz divided out
c     pcrosseta = |p x eta| with pz divided out
      pdoteta = f.xslp*eta(1) + f.yslp*eta(2) + eta(3)
      Qz = sign(ONE, f.alpha)
      pcrosseta = Qz * sqrt(1. + f.xslp**2 + f.yslp**2 - pdoteta**2)
      if(pcrosseta .eq. 0) goto 9999

      den = 1. / pcrosseta

      dx = f.xp - xpos(1)
      dy = f.yp - xpos(2)
      dz = f.zp - xpos(3)

      ex = (f.yslp*eta(3) -        eta(2)) * den
      ey = (       eta(1) - f.xslp*eta(3)) * den
      ez = (f.xslp*eta(2) - f.yslp*eta(1)) * den

      temp = dcalc * den**2
      drv(1) = 0.
      drv(2) =  (f.yslp*eta(3) - eta(2))
      drv(3) = -(f.xslp*eta(3) - eta(1))
      drv(4) =  (dz*eta(2) - dy)*den - (f.xslp - eta(1)*pdoteta)*temp
      drv(5) = -(dz*eta(1) - dx)*den - (f.yslp - eta(2)*pdoteta)*temp

c     Normal exit
      dcalc_ftk_stereo_drv = 0
      return

c     Error exit
 9999 dcalc_ftk_stereo_drv = 1
      call vzero(drv, 5*FLOAT_WORD)

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:43  eugenio
c Initial revision
c
c Revision 1.4  1997/04/04 20:31:05  garren
c add rcs log line
c
