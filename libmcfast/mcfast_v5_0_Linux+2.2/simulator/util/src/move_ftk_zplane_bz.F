      integer function move_ftk_zplane_bz(f1, zs, bf, f2, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Takes a forward track and calculates the new parameters at the
c  plane z = zs in a B field along the z direction.
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
c   For B along +z axis the equations of motion are
c
c alpha  = alpha_0
c    xp  = xp0 + (1/a*alpha_0) * {xp0'*sin(ps)  - yp0'*[1-cos(ps)]}
c    xp' = xp0'*cos(ps) - yp0'*sin(ps)
c    yp  = yp0 + (1/a*alpha_0) * {yp0'*sin(ps)  + xp0'*[1-cos(ps)]}
c    yp' = yp0'*cos(ps) + xp0'*sin(ps)
c
c  alpha_0 = 1 / Pz_0
c     a    = c_b * Bz * q  (c_b is defined in const.inc)
c    ps    = a * alpha_0 * dz
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
      DFLOAT a, dz, disc, alpha_0, xp0, yp0, xslp0, yslp0
      DFLOAT slp_sq
      DFLOAT aalpha_0, aadz, arg, sinps, cosps, dcosps
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(f1.p .eq. 0.) goto 9999
      if(f1.zp .eq.zs) goto 9998

      dz = zs - f1.zp
      alpha_0 = f1.alpha
      xp0 = f1.xp
      yp0 = f1.yp
      xslp0 = f1.xslp
      yslp0 = f1.yslp

c     B field along z axis
      a = c_b * bf.bmag * bf.bdir(3) * f1.q
      aalpha_0 = a * alpha_0
      aadz = aalpha_0 * dz
      sinps = sin(aadz)
      cosps = cos(aadz)
      dcosps = 1. - cosps
        
      f2.alpha = alpha_0
      f2.xslp = xslp0*cosps - yslp0*sinps
      f2.yslp = yslp0*cosps + xslp0*sinps
      f2.xp = xp0 + (xslp0*sinps - yslp0*dcosps) / aalpha_0
      f2.yp = yp0 + (yslp0*sinps + xslp0*dcosps) / aalpha_0
      f2.zp = zs
      f2.pt = f1.pt
      f2.p = f1.p
      f2.q = f1.q

      s3d = dz * alpha_0 * f2.pt

c     normal exit
1000  move_ftk_zplane_bz = 0
      return

c     exit if zplane is the same
9998  move_ftk_zplane_bz = 0
      call ucopy(f1, f2, FTRACK_WORD)
      s3d = 0.
      return

c     error exit
9999  move_ftk_zplane_bz = 1
      call ucopy(f1, f2, FTRACK_WORD)
      s3d = 0.

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:45  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:39  garren
c add rcs log line
c
