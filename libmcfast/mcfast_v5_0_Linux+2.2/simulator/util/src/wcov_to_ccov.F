      integer function wcov_to_ccov(w, wcov, c, ccov)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Convert a w covariance matrix to a c covariance matrix at the current
c  point.
c
c  rho       = a / pt
c  tan(phi0) = (py - a*dx / (px + a*dy)
c  da        = (1/a) * {sqrt[pt^2 - 2*(dx*py - dy*px) + a^2*(dx^2+dy^2)] - 1}
c  lambda    = pz / pt
c  z0        = z - pz/pt * s
c
c  where a = c_b * Bfield * Q
c        dx = x0 - xref
c        dy = y0 - yref
c
c  In our case dx = dy = 0 but we still need derivatives
c
c    s = (dx*px + dy*py) / pt
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c Inputs:
c  w         w track structure
c            w track parameters
c
c  wcov      DFLOAT array
c            Initial 7x7 covariance matrix for w
c
c  c         c track structure
c            c track parameters (assume same reference point as w.x-z)
c
c Outputs:
c  ccov      DFLOAT array
c            Final 5x5 c covariance matrix
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "wtrack_struct.inc"
#include "ctrack_struct.inc"

c     calling arguments
      record /wtrack_struct/ w
      record /ctrack_struct/ c
      DFLOAT wcov(7,7), ccov(5,5)
c
c     local variables
      integer i, j
      DFLOAT drv(5,7), den, a
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(w.pt .eq. 0.) goto 9999

      call vzero(drv, 5*7*FLOAT_WORD)
      den = 1. / w.pt**2
      a = 2. * c.cu * w.pt

      drv(jccu,jwpx) = -c.cu * w.px * den
      drv(jccu,jwpy) = -c.cu * w.py * den

      drv(jcphi,jwpx) = -w.py * den
      drv(jcphi,jwpy) =  w.px * den
      drv(jcphi,jwx) =  -a * w.px * den
      drv(jcphi,jwy) =  -a * w.py * den

      drv(jcda,jwx) =  -w.py / w.pt
      drv(jcda,jwy) =   w.px / w.pt

      drv(jcct,jwpx) =  -c.ct * w.px * den
      drv(jcct,jwpy) =  -c.ct * w.py * den
      drv(jcct,jwpz) =  1. / w.pt

      drv(jcz0,jwx) = -w.px * w.pz * den
      drv(jcz0,jwy) = -w.py * w.pz * den
      drv(jcz0,jwz) = 1.

      call MxABAtr(5, 7, drv, wcov, ccov)

c     Normal exit
      wcov_to_ccov = 0
      return

c     Error exit
 9999 wcov_to_ccov = 1
      return

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:46  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:59  garren
c add rcs log line
c
