      integer function move_ctk_zplane(c1, zs, c2, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Takes a helix expressed in w form and calculates the new parameters
c  at the position z = zs in a solenoidal B field. The reference point
c  is changed to the point of intersection with z = zs.
c
c  c1       c track structure (read)
c           Initial track parameters
c
c  zs       DFLOAT variable (read)
c           z position to which the track should be projected
c
c *c2       c track structure (write)
c           Track parameters at z = zs
c
c *s3d      DFLOAT variable (write)
c           3-D arc length the track moved between points
c
c return    
c             0 if no error
c           > 0 if error projecting to this z position
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c   the equations of motion are
c
c     u = u0*cos(rho*s) - v0*sin(rho*s)
c     v = v0*cos(rho*s) + u0*sin(rho*s)
c
c   x = x0 + xref + {u0*sin(rho*s) - v0*[1-cos(rho*s)]} / rho
c   y = y0 + yref + {v0*sin(rho*s) + u0*[1-cos(rho*s)]} / rho
c   z = z0 + zref + ct*s
c
c   where s = arc length in r-phi plane
c         a = c_b * bfield * q (c_b defined in const.inc)
c       rho = a / pt
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "ctrack_struct.inc"
#include "const.inc"

c     calling arguments
      DFLOAT zs, bfield
      record /ctrack_struct/ c1, c2
      DFLOAT s3d

c     local variables
      DFLOAT rho, rhoinv, s, x0, y0, z0, xint, yint, zint
      DFLOAT uint, vint, ps, sinps, cosps
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Calculate arc length from equation zs = z0 + zref + ct*s
      if(c1.ct .eq. 0.) goto 9999

      s = (zs - c1.z0 - c1.zref) / c1.ct

      rho = 2. * c1.cu
      x0 = -c1.da * c1.v0
      y0 =  c1.da * c1.u0
      z0 =  c1.z0
      if(rho .eq. 0.) then
        xint = x0 + c1.xref + c1.u0*s
        yint = y0 + c1.yref + c1.v0*s
        zint = zs
        uint = c1.u0
        vint = c1.v0
      else
        ps = rho * s
        rhoinv = 1. / rho
        sinps = sin(ps)
        cosps = cos(ps)
        uint = c1.u0*cosps - c1.v0*sinps
        vint = c1.v0*cosps + c1.u0*sinps
        xint = x0 + c1.xref + (vint - c1.v0) * rhoinv
        yint = y0 + c1.yref - (uint - c1.u0) * rhoinv
        zint = zs
      endif

      c2.cu = c1.cu
      c2.phi0 = atan2(vint, uint)
      if(c2.phi0 .lt. 0.) c2.phi0 = c2.phi0 + tpi
      c2.da = 0
      c2.ct = c1.ct
      c2.z0 = 0
      c2.u0 = uint
      c2.v0 = vint
      c2.p = c1.p
      c2.q = c1.q
      c2.xref = xint
      c2.yref = yint
      c2.zref = zint

      s3d = s * c2.p / c2.pt

c     normal exit
1000  move_ctk_zplane = 0
      return

c     error exit
9999  move_ctk_zplane = 1
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:45  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:37  garren
c add rcs log line
c
