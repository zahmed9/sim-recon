      integer function move_ctk_point(c1, x, c2, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Move a helix from one reference point to another in a solenoidal
c  B field. Return value is always 0.
c
c  c1       c track structure (read)
c           Input track parameters
c
c  x(3)     DFLOAT array (read)
c           New reference point
c
c *c2       c track structure (read)
c           Output track parameters
c
c *s3d      DFLOAT variable (write)
c           3-D arc length the track moved between points
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "ctrack_struct.inc"
#include "const.inc"

c     calling arguments
      record /ctrack_struct/ c1, c2
      DFLOAT x(3)
      DFLOAT s3d

c     local variables
      DFLOAT T, rho, cosphi, sinphi, cosps, sinps
      DFLOAT dx, dy, dz, xpr, ypr, s, da, u0, v0, phi0, rhoda
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      dx = x(1) - c1.xref
      dy = x(2) - c1.yref
      dz = x(3) - c1.zref
      rho = 2. * c1.cu

c     cos(phi0') = [u0*(1+rho*da) - rho*dy] / T
c     sin(phi0') = [v0*(1+rho*da) + rho*dx] / T
c     cosphi and sinphi are proportional to cos(phi0'), sin(phi0')

      xpr = c1.u0*dx + c1.v0*dy
      ypr = c1.u0*dy - c1.v0*dx

c   (1+rho*da')*cos(rho*s) = 1+rho*da + rho*[v0*dx - u0*dy] = 1+rho*da-rho*dy'
c   (1+rho*da')*sin(rho*s) = rho*[u0*dx + v0*dy] = rho*dx'
c     cosps and sinps are proportional to cos(rho*s), sin(rho*s)

c     da' = (1./rho)* {sqrt[] - 1}
c     []  = (1+rho*da)^2 + 2*rho*(1+rho*da)*rho*(v0*dx-u0*dy)
c                        + rho^2*(dx^2 + dy^2)
c         = (1+rho*da-rho*dy')^2 + rho^2*dx'^2
      if(rho .eq. 0.) then
        phi0 = c1.phi0
        u0 = c1.u0
        v0 = c1.v0
        s = xpr
        da = c1.da - ypr
      else
        rhoda = 1. + rho*c1.da
        cosphi = c1.u0*rhoda - rho * dy
        sinphi = c1.v0*rhoda + rho * dx
        T = sqrt(sinphi**2 + cosphi**2)
        u0 = cosphi / T
        v0 = sinphi / T
        phi0 = atan2(sinphi, cosphi)
        if(phi0 .lt. 0.) phi0 = phi0 + tpi

        cosps = 1. + rho*(c1.da - ypr)
        sinps = rho*xpr
        s = (1./rho) * atan2(sinps, cosps)
        da = (2.*rhoda*(c1.da - ypr) + rho*(-c1.da**2 + dx**2 + dy**2))
     *         / (T + 1.)
      endif

c     z0' = z0 + zref + ct*s - zref' = z0 + ct*s - dz
      c2.cu = c1.cu
      c2.phi0 = phi0
      c2.da = da
      c2.ct = c1.ct
      c2.z0 = c1.z0 + c1.ct*s - dz
      c2.u0 = u0
      c2.v0 = v0
      c2.pt = c1.pt
      c2.p = c1.p
      c2.q = c1.q
      c2.xref = x(1)
      c2.yref = x(2)
      c2.zref = x(3)

      s3d = s * c2.p / c2.pt

      move_ctk_point = 0

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:35  garren
c add rcs log line
c
