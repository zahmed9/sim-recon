      integer function cvt_wtk_ctk(w, x, bf, c)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Takes a track expressed in kinematic form and converts it into
c  standard helix form relative to the reference point x(1-3). B field
c  is assumed to be along +z direction.
c
c  w        w track structure (read)
c           Kinematic track parameters
c
c  x(3)     DFLOAT array (read)
c           Reference point for helix
c
c  bf       B field structure (read)
c           B field information
c
c *c        c track structure (write)
c           Helix parameters
c
c return    
c           0 ==> all OK
c           1 ==> track cannot be computed
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "wtrack_struct.inc"
#include "ctrack_struct.inc"
#include "bfield_struct.inc"
#include "const.inc"

c     calling arguments
      record /wtrack_struct/ w
      record /ctrack_struct/ c
      record /bfield_struct/ bf
      DFLOAT x(3)

c     local variables
      DFLOAT rho, px, py, a, da, dx, dy, dz
      DFLOAT cross, disc, s, dot
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(w.p .eq. 0.) goto 9999
      if(w.pt .eq. 0.) goto 9999

      a = c_b * bf.bmag * bf.bdir(3) * w.q
      rho = a / w.pt

      dx = w.x - x(1)
      dy = w.y - x(2)
      dz = w.z - x(3)
      cross = (dx*w.py - dy*w.px) / w.pt
      dot =   (dx*w.px + dy*w.py) / w.pt

      if(rho .eq. 0.) then
        da  = -cross
        px = w.px
        py = w.py
        s = dot
      else
        disc = sqrt(1. - 2.*rho*cross + rho**2*(dx**2 + dy**2) )
        da   = (-2.*cross + rho*(dx**2+dy**2)) / (disc + 1.)
        px = (w.px + a*dy) / disc
        py = (w.py - a*dx) / disc
        s = atan2(rho*dot, 1.-rho*cross) / rho
      endif

      c.cu = 0.5 * rho
      c.phi0 = atan2(py, px)
      if(c.phi0 .lt. 0.) c.phi0 = c.phi0 + tpi
      c.da = da
      c.ct = w.pz / w.pt
      c.z0 = dz - c.ct * s
      c.u0 = px / w.pt
      c.v0 = py / w.pt
      c.pt = w.pt
      c.p = w.p
      c.q = w.q
      c.xref = x(1)
      c.yref = x(2)
      c.zref = x(3)

      cvt_wtk_ctk = 0
      return

c     error return
9999  cvt_wtk_ctk = 1
      call vzero(c, CTRACK_WORD)
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:42  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:00  garren
c add rcs log line
c
