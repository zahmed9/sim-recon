      integer function deriv_wtk_point_bz(w1, w2, bf, R)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Calculate the derivatives of the track parameters at a new
c  point wrt parameters at an old point in a solenoidal B field.
c
c  The return value is always 0.
c
c  w1       w track structure (read)
c           Old track parameters
c
c  w2       w track structure (read)
c           New track parameters
c
c  bf       B field structure (read)
c           B field info
c
c *R        DFLOAT array (write)
c           7x7 derivative matrix of d(w2) / d(w1)
c
c  .....................................................................
c
c  Equations of motion are
c
c  px' = px*cosps - py*sinps
c  py' = py*cosps + px*sinps
c  pz' = pz
c   E' = E
c   x' = x + (px/a)*sinps - (py/a)*(1-cosps)
c   y' = y + (py/a)*sinps + (px/a)*(1-cosps)
c   z' = z + (pz/p)*s
c
c  where   a = c_b * Bfield * charge
c          s = 3-D arc length between the two points
c         ps = (a/p) * s
c
c  In doing the transport, I assume that the arc length is fixed. This
c  is not quite the same as transporting to a fixed location, such as the
c  surface of a cylinder or to a plane, in which case the arc length s is
c  also variable.
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "wtrack_struct.inc"
#include "bfield_struct.inc"

c     Externals

c     calling arguments
      record /wtrack_struct/ w1, w2
      record /bfield_struct/ bf
      DFLOAT R(7,7)

c     local variables
      DFLOAT a, ainv, den, den2, factor1, factor2, s3d
      DFLOAT sinps, cosps, ptsqinv
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      a = c_b * bf.bmag * w1.q
      ptsqinv = 1. / w1.pt**2

      call vzero(R, 7*7*FLOAT_WORD)

      cosps = (w2.px*w1.px + w2.py*w1.py) * ptsqinv
      sinps = (w2.py*w1.px - w2.px*w1.py) * ptsqinv
      s3d = atan2(sinps, cosps) * w1.p / a

      den = 1. / w1.p
      den2 = 1. / w1.E
      ainv = 1. / a

      factor1 = s3d * den**3
      factor2 = a * factor1

      R(jwpx,jwpx) =  cosps + w1.px * w2.py * factor2
      R(jwpx,jwpy) = -sinps + w1.py * w2.py * factor2
      R(jwpx,jwpz) =          w1.pz * w2.py * factor2

      R(jwpy,jwpx) =  sinps - w1.px * w2.px * factor2
      R(jwpy,jwpy) =  cosps - w1.py * w2.px * factor2
      R(jwpy,jwpz) =        - w1.pz * w2.px * factor2

      R(jwpz,jwpz) = 1.

      R(jwe,jwpx) = w1.px * den2
      R(jwe,jwpy) = w1.py * den2
      R(jwe,jwpz) = w1.pz * den2
      R(jwe,jwe) = 1.

      R(jwx,jwpx) = ainv * R(jwpy,jwpx)
      R(jwx,jwpy) = ainv * (R(jwpy,jwpy) - 1.)
      R(jwx,jwpz) = ainv * R(jwpy,jwpz)
      R(jwx,jwx) = 1.

      R(jwy,jwpx) = -ainv * (R(jwpx,jwpx) - 1.)
      R(jwy,jwpy) = -ainv * R(jwpx,jwpy)
      R(jwy,jwpz) = -ainv * R(jwpx,jwpz)
      R(jwy,jwy) = 1.

      R(jwz,jwpx) = -w1.pz * w1.px * factor1
      R(jwz,jwpy) = -w1.pz * w1.py * factor1
      R(jwz,jwpz) = (w1.p**2 - w1.pz**2) * factor1
      R(jwz,jwz) = 1.

      deriv_wtk_point_bz = 0

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:24  garren
c add rcs log line
c
