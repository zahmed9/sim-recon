      integer function move_ftk_zplane_by(f1, zs, bf, f2, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Takes a forward track and calculates the new parameters at the
c  plane z = zs in a B field in the y direction.
c
c  f1       forward track structure (read)
c           Initial track parameters
c
c  zs       DFLOAT variable (read)
c           z position to which the track should be projected
c
c  bf       B field structure (read)
c           B field information
c
c *f2       forward track structure (write)
c           Track parameters at z = zs
c
c *s3d      DFLOAT variable (write)
c           3-D arc length the track moved between points
c
c return    
c           0 ==> all OK
c           1 ==> track cannot be projected
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c   For B along +y axis the equations of motion are
c
c alpha  = alpha_0 / disc
c    xp  = xp0 + dz/beta * {1 - disc}
c        = xp0 + dz*(2.*xp0' + beta) / {1 + disc}
c    xp' = (xp0' + beta) / disc
c    yp  = yp0 + yp0'*dz/beta*asin{beta*[dx*x0'/dz + 1]/(1+x0'^2)}
c        = yp0 + yp0'*dz * [1 - 0.5*x0'*beta/(1.+beta*x0')] (approx.)
c    yp' = yp0' / disc
c
c    disc  = sqrt{1 - 2*beta*xp0' - beta^2}
c  alpha_0 = 1 / Pz_0
c     a    = c_b * By * q  (c_b is defined in const.inc)
c     beta = a * alpha_0 * dz
c    dz    = zs - zp0
c    dx    = xp - xp0
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "ftrack_struct.inc"
#include "bfield_struct.inc"
#include "const.inc"

c     calling arguments
      DFLOAT zs
      record /ftrack_struct/ f1, f2
      record /bfield_struct/ bf
      DFLOAT s3d

c     local variables
      DFLOAT a, dx, dz, disc, alpha_0, xp0, yp0, xslp0
      DFLOAT yslp0, slp_sq
      DFLOAT aalpha_0, beta, arg, sinps, cosps, dcosps
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(f1.p .eq. 0.) goto 9999
      if(f1.zp .eq. zs) goto 9998

      dz = zs - f1.zp
      alpha_0 = f1.alpha
      xp0 = f1.xp
      yp0 = f1.yp
      xslp0 = f1.xslp
      yslp0 = f1.yslp

c     B field along y axis
      a = c_b * bf.bmag * bf.bdir(2) * f1.q
      aalpha_0 = a * alpha_0
      beta = aalpha_0 * dz
      disc = 1. - 2.*beta*xslp0 - beta**2
      if(disc .le. 0.) goto 9999
      disc = sqrt(disc)

      dx = dz * (2.*xslp0 + beta) / (1. + disc)

      f2.alpha = alpha_0 / disc
      f2.xslp = (xslp0 + beta) / disc
      f2.yslp = yslp0 / disc
      f2.xp = xp0 + dx

      arg = beta * (1. + xslp0*dx/dz) / (1. + xslp0**2)
      f2.yp = yp0 + yslp0*dz/beta * asin(arg)

      f2.zp = zs
      slp_sq = f2.xslp**2 + f2.yslp**2
      f2.pt = sqrt(slp_sq) / abs(f2.alpha)
      f2.p = f1.p
      f2.q = f1.q

      s3d = dz*arg/beta * sqrt( (1. + slp_sq) / (1. + yslp0**2) )

c     normal exit
1000  move_ftk_zplane_by = 0
      return

c     exit if zplane is the same
9998  move_ftk_zplane_by = 0
      call ucopy(f1, f2, FTRACK_WORD)
      s3d = 0.
      return

c     error exit
9999  move_ftk_zplane_by = 1
      call ucopy(f1, f2, FTRACK_WORD)
      s3d = 0.

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:45  eugenio
c Initial revision
c
c Revision 1.3  1997/12/02 22:48:10  kutschke
c Fix f2.pt, s3d.
c
c Revision 1.2  1997/04/04  20:31:39  garren
c add rcs log line
c
