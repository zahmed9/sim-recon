      integer function deriv_ftk_zplane_by(f1, f2, bf, R)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Calculate the derivatives of the forward helix parameters at a new
c  plane wrt parameters at the old plane in a B field along the y
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
      DFLOAT alpha_0, aalpha_0, beta, dz, disc, a
      DFLOAT xp, xp0, yp, yp0, xslp, xslp0, yslp, yslp0
      DFLOAT eps, den, den2, dx, betapr, arg, cosarg, arcsin
      DFLOAT temp

      data eps/0.2/
      save eps
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      alpha_0 = f1.alpha
      dz = f2.zp - f1.zp
      disc = alpha_0 / f2.alpha

      xp0 = f1.xp
      xp  = f2.xp
      yp0 = f1.yp
      yp  = f2.yp
      dx = xp - xp0

      xslp0 = f1.xslp
      xslp  = f2.xslp
      yslp0 = f1.yslp
      yslp  = f2.yslp

      call vzero(R, 5*5*FLOAT_WORD)

c     B field along y axis
      a = c_b * bf.bmag * bf.bdir(2) * f1.q
      aalpha_0 = a * alpha_0
      beta = aalpha_0 * dz

      R(jfalpha,jfalpha) = (1. - beta*xslp0) / disc**3
      R(jfalpha,jfxslp) = beta * alpha_0 / disc**3

      R(jfxslp,jfalpha) = a*dz*(1. + xslp0**2) / disc**3
      R(jfxslp,jfxslp) = (1. - beta*xslp0) / disc**3

      R(jfyslp,jfalpha) = a*dz*xslp*yslp/disc
      R(jfyslp,jfxslp) = beta * yslp / disc**2
      R(jfyslp,jfyslp) = 1. / disc

      R(jfxp,jfalpha) = a*dz**2 * (1. + xslp0**2) /
     *                    (disc * (1. - beta*xslp0 + disc) )
      R(jfxp,jfxslp) = dz / disc
      R(jfxp,jfxp) = 1.

c     Use approximation when bend is small to avoid arcsin calculation
      temp = 1. + xslp0**2
      den2 = 1. / (disc + 1 - beta*xslp0)
      if(abs(beta) .lt. eps) then
        den = 1. / (1. + beta*yslp0)
        betapr = beta * den
        R(jfyp,jfalpha) =  0.5*a*xslp0*yslp0*dz**2 * den**2
        R(jfyp,jfxslp) =  0.5*beta*yslp0*dz * den**2
        R(jfyp,jfyslp) = dz * (1. + 0.5*xslp0*betapr)
      else
        arg = -beta * (1. + xslp0*dx/dz) / temp
        cosarg = sqrt(1. - arg**2)
        arcsin = asin(arg)
        R(jfyp,jfalpha) = yslp0*dz/alpha_0 * (arcsin / beta
     *                         + (1. + xslp0*xslp)/temp/cosarg)
        R(jfyp,jfyslp) = -arcsin / aalpha_0
        R(jfyp,jfxslp) = yslp0*dz*beta*den2 * (1. + beta*xslp0*den2
     *                * (1./disc + 1.) ) / cosarg
      endif
      R(jfyp,jfyp) = 1.

      deriv_ftk_zplane_by = 0

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
