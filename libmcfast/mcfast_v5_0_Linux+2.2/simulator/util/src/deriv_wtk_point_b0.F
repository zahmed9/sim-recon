      integer function deriv_wtk_point_b0(w1, w2, bf, R)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Calculate the derivatives of the track parameters at a new
c  point wrt parameters at an old point in zero B field.
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
c   x' = x + (py/a)*sinps + (px/a)*(1-cosps)
c   z' = z + (px/p)*s
c
c  where   a = c_b * Bfield * charge
c          s = 3-D arc length between the two points
c         ps = (a/p) * s
c
c  In doing the transport, I assume that the arc length is fixed. This
c  is not quite the same as transporting to a fixed location, such as the
c  surface of a cylinder or to a plane, in which case the arc length s is
c  also variable.
c
c  d(ps)/px = -
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
      DFLOAT factor, den, s3d
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      call vzero(R, 7*7*FLOAT_WORD)

      s3d = (w1.px*(w2.x - w1.x) + w1.py*(w2.y - w1.y)
     *     + w1.pz*(w2.z - w1.z) ) / w1.p

      factor = s3d / w1.p**3
      den = 1. / w1.E

      R(jwpx,jwpx) = 1.
      R(jwpy,jwpy) = 1.
      R(jwpz,jwpz) = 1.

      R(jwe,jwpx) = w1.px * den
      R(jwe,jwpy) = w1.py * den
      R(jwe,jwpz) = w1.pz * den
      R(jwe,jwe) = 1.

      R(jwx,jwpx) = (w1.p**2 - w1.px**2) * factor
      R(jwx,jwpy) = -w1.px * w1.py * factor
      R(jwx,jwpz) = -w1.px * w1.pz * factor
      R(jwx,jwx) = 1.

      R(jwy,jwpx) = -w1.py * w1.px * factor
      R(jwy,jwpy) = (w1.p**2 - w1.py**2) * factor
      R(jwy,jwpz) = -w1.py * w1.pz * factor
      R(jwy,jwy) = 1.

      R(jwz,jwpx) = -w1.pz * w1.px * factor
      R(jwz,jwpy) = -w1.pz * w1.py * factor
      R(jwz,jwpz) = (w1.p**2 - w1.pz**2) * factor
      R(jwz,jwz) = 1.

      deriv_wtk_point_b0 = 0

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:22  garren
c add rcs log line
c
