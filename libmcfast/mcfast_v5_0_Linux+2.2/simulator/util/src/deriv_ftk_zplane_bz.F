      integer function deriv_ftk_zplane_bz(f1, f2, bf, R)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Calculate the derivatives of the forward helix parameters at a new
c  plane wrt parameters at the old plane in a B field along the z
c  direction.
c
c  f1       f track structure (read)
c           Track parameters at the old plane
c
c  f2       f track structure (read)
c           Track parameters at the new plane
c
c  bf       B field structure (read)
c           B field information
c
c *R        DFLOAT array (write)
c           5x5 derivative matrix of d(f2) / d(f1)
c
c return    
c           0 ==> all OK
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "ftrack_struct.inc"
#include "bfield_struct.inc"
#include "const.inc"

c     Externals

c     calling arguments
      record /ftrack_struct/ f1, f2
      record /bfield_struct/ bf
      DFLOAT R(5,5)

c     local variables
      integer status
      DFLOAT alpha_0, aalpha_0, aadz, dz, disc, a
      DFLOAT xp, xp0, yp, yp0, xslp, xslp0, yslp, yslp0
      DFLOAT sinps, cosps, dcosps
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      alpha_0 = f1.alpha
      dz = f2.zp - f1.zp
      disc = alpha_0 / f2.alpha

      xp0 = f1.xp
      xp  = f2.xp
      yp0 = f1.yp
      yp  = f2.yp

      xslp0 = f1.xslp
      xslp  = f2.xslp
      yslp0 = f1.yslp
      yslp  = f2.yslp

      call vzero(R, 5*5*FLOAT_WORD)

c     B field along z axis
      a = c_b * bf.bmag * bf.bdir(3) * f1.q
      aalpha_0 = a * alpha_0
      aadz = a * alpha_0 * dz
      sinps = sin(aadz)
      cosps = cos(aadz)
      dcosps = 1. - cosps

      R(jfalpha,jfalpha) = 1.
      R(jfxslp,jfalpha) = -a * dz * f2.yslp
      R(jfxslp,jfxslp) = cosps
      R(jfxslp,jfyslp) = - sinps
      R(jfyslp,jfalpha) = a * dz * f2.xslp
      R(jfyslp,jfxslp) = sinps
      R(jfyslp,jfyslp) = cosps
      R(jfxp,jfalpha) = -(f2.xp - f1.xp) / alpha_0
     *                  + (dz/alpha_0)*f2.xslp
      R(jfxp,jfxslp) = sinps / aalpha_0
      R(jfxp,jfyslp) = -dcosps / aalpha_0
      R(jfxp,jfxp) = 1.
      R(jfyp,jfalpha) = -(f2.yp - f1.yp) / alpha_0
     *                  + (dz/alpha_0)*f2.yslp
      R(jfyp,jfxslp) = dcosps / aalpha_0
      R(jfyp,jfyslp) = sinps / aalpha_0
      R(jfyp,jfyp) = 1.

      deriv_ftk_zplane_bz = 0

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:21  garren
c add rcs log line
c
