      integer function deriv_ctk_point(c1, c2, R)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Calculate the derivatives of the helix parameters at a new reference
c  point wrt parameters at the old reference point in a solenoidal B
c  field.
c
c  c1       c track structure (read)
c           Track parameters at old reference point
c
c  c2       c track structure (read)
c           Track parameters at new reference point
c
c *R        DFLOAT array (write)
c           5x5 derivative matrix of d(c2) / d(c1)
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "ctrack_struct.inc"
#include "const.inc"

c     Externals

c     calling arguments
      record /ctrack_struct/ c1, c2
      DFLOAT R(5,5)

c     local variables
      record /ctrack_struct/ c
      integer status
      DFLOAT T, rho, rhoinv, cosphi, sinphi, cosps, sinps
      DFLOAT dx, dy, dz, xpr, ypr, s, da, u0, v0, phi0, rhoda
      DFLOAT rhoda_pr, den, den2
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      dx = c2.xref - c1.xref
      dy = c2.yref - c1.yref
      dz = c2.zref - c1.zref
      rho = 2. * c1.cu
      if(rho .ne. 0.) rhoinv = 1. / rho
      rhoda = 1. + rho*c1.da
      rhoda_pr = 1. + rho*c2.da
      den = 1. / rhoda_pr

      xpr = c1.u0*dx + c1.v0*dy
      ypr = c1.u0*dy - c1.v0*dx

      call vzero(R, 5*5*FLOAT_WORD)

      R(jccu,jccu) = 1.
      R(jcphi,jccu) = 2.* xpr * den**2
      R(jcphi,jcphi) = rhoda * (rhoda - rho*ypr) * den**2
      R(jcphi,jcda) = -rho**2 * xpr * den**2
      if(rho .eq. 0.) then
        R(jcda,jccu) = xpr**2
      else
        den2 = rhoda_pr + rhoda - rho*ypr
        if(den2 .eq. 0.) goto 9999
        R(jcda,jccu) = 2. * xpr**2 * den / den2
      endif
      R(jcda,jcphi) = rhoda * xpr * den
      R(jcda,jcda) = (rhoda - rho*ypr) * den
      R(jcct,jcct) = 1.
      if(rho .eq. 0.) then
        s = xpr
        R(jcz0,jccu) = -2.* c1.ct * xpr * (c1.da - ypr)
      else
        s = rhoinv * atan2(rho*xpr, rhoda - rho*ypr)
        R(jcz0,jccu) = 2.* c1.ct * rhoinv * (-s + xpr*den**2)
      endif
      R(jcz0,jcphi) = c1.ct * (ypr*rhoda - rho*(dx**2+dy**2) ) * den**2
      R(jcz0,jcda) = -c1.ct * rho * xpr * den**2
      R(jcz0,jcct) = s
      R(jcz0,jcz0) = 1.

      deriv_ctk_point = 0

      return

c     Error return
 9999 deriv_ctk_point = 1
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.5  1997/12/02 22:45:01  kutschke
c Fix R(jcda,jccu). From pra.
c
c Revision 1.4  1997/04/04  20:31:19  garren
c add rcs log line
c

