      integer function cvt_ftk_ctk(f, x, bf, c)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Takes a track expressed in forward form and converts it into standard
c  helix form using its instantaneous motion and position.
c  B field is assumed to be along +z direction.
c
c  f        f track structure (read)
c           Forward track parameters
c
c  x(3)     DFLOAT array (read)
c           Reference point for helix
c
c  bf       B field structure (read)
c           B field information
c
c *c        c track structure (write)
c           Helix track parameters
c
c return    
c           0 ==> all OK
c           1 ==> track cannot be computed
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "ftrack_struct.inc"
#include "ctrack_struct.inc"
#include "bfield_struct.inc"
#include "const.inc"

c     calling arguments
      record /ftrack_struct/ f
      record /ctrack_struct/ c
      record /bfield_struct/ bf
      DFLOAT x(3)

c     local variables
      DFLOAT rho, a, da, dx, dy, dz, ct, xslp, yslp, T0
      DFLOAT u, v, phi0
      DFLOAT cross, Talpha, s, dot, cosphi, sinphi, alpha
      DFLOAT cosps, sinps
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(f.alpha .eq. 0.) goto 9999
      dx = f.xp - x(1)
      dy = f.yp - x(2)
      dz = f.zp - x(3)

      if(f.pt .eq. 0.) goto 9998

      a = c_b * bf.bmag * bf.bdir(3) * f.q
      rho = a / f.pt

      alpha = f.alpha

c     cosphi, sinphi proportional to cos(phi0), sin(phi0)
      cosphi = f.xslp + a*alpha*dy
      sinphi = f.yslp - a*alpha*dx
      T0 = sqrt(cosphi**2 + sinphi**2)
      u = cosphi / T0
      v = sinphi / T0
      ct = 1./(alpha*f.pt)
      cross = (dx*f.yslp - dy*f.xslp) * ct
      dot =   (dx*f.xslp + dy*f.yslp) * ct

      if(rho .eq. 0.) then
        da  = -cross
        s = dot
      else
        sinps = rho*dot
        cosps = 1. - rho*cross
        Talpha = sqrt(cosps**2 + sinps**2)
        da   = (-2.*cross + rho*(dx**2+dy**2)) / (Talpha + 1.)
        s = atan2(sinps, cosps) / rho
      endif

      c.cu = 0.5 * rho
      c.phi0 = atan2(sinphi, cosphi)
      if(c.phi0 .lt. 0.) c.phi0 = c.phi0 + tpi
      c.da = da
      c.ct = ct
      c.z0 = dz - ct * s
      c.u0 = u
      c.v0 = v
      c.pt = f.pt
      c.p = f.p
      c.q = f.q
      c.xref = x(1)
      c.yref = x(2)
      c.zref = x(3)

      cvt_ftk_ctk = 0
      return

c     pt = 0 special case
9998  da = sqrt(dx**2 + dy**2)
      if(da .ne. 0.) then
        u =  dy / da
        v = -dx / da
        phi0 = atan2(v, u)
        if(phi0 .lt. 0.) phi0 = phi0 + tpi
      else
        u = 1.
        v = 0.
        phi0 = 0.
      endif
      c.cu = 1.e10
      c.phi0 = phi0
      c.da = da
      c.ct = 1.e10
      c.z0 = 0
      c.u0 = u
      c.v0 = v
      c.pt = 0.
      c.p = f.p
      c.q = f.q
      c.xref = x(1)
      c.yref = x(2)
      c.zref = x(3)

      cvt_ftk_ctk = 0
      return

c     error return
9999  cvt_ftk_ctk = 1
      call vzero(c, CTRACK_WORD)
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:42  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:59  garren
c add rcs log line
c
