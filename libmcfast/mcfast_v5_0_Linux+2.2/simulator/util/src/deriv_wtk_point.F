      integer function deriv_wtk_point(w1, w2, bf, R)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Calculate the derivatives of the track parameters at a new
c  point wrt parameters at an old point in an arbitrarily oriented,
c  fixed B field.
c
c  Inputs:
c  w1       w track structure
c           Old track parameters
c
c  w2       w track structure
c           New track parameters
c
c  bf       B field structure
c           B field info
c
c Outputs:
c *R        DFLOAT array
c           7x7 derivative matrix of d(w2) / d(w1)
c
c Return:
c           0 ==> all OK
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "wtrack_struct.inc"
#include "bfield_struct.inc"

c     Externals
      integer  deriv_wtk_point_b0
      integer  deriv_wtk_point_bx
      integer  deriv_wtk_point_by
      integer  deriv_wtk_point_bz

      external deriv_wtk_point_b0
      external deriv_wtk_point_bx
      external deriv_wtk_point_by
      external deriv_wtk_point_bz

c     calling arguments
      record /wtrack_struct/ w1, w2
      record /bfield_struct/ bf
      DFLOAT R(7,7)

c     local variables
      integer status
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
      if (w1.q .eq. 0) goto 100

      goto (100, 110, 120, 9999, 140, 9999, 9999, 9999), bf.type + 1

 100  status = deriv_wtk_point_b0(w1, w2, bf, R)
      goto 500

 110  status = deriv_wtk_point_bx(w1, w2, bf, R)
      goto 500

 120  status = deriv_wtk_point_by(w1, w2, bf, R)
      goto 500

c 130  status = deriv_wtk_point_bxy(w1, w2, bf, R)

 140  status = deriv_wtk_point_bz(w1, w2, bf, R)
      goto 500

c 150  status = deriv_wtk_point_bzx(w1, w2, bf, R)

c 160  status = deriv_wtk_point_byz(w1, w2, bf, R)

c 170  status = deriv_wtk_point_bxyz(w1, w2, bf, R)

 500  deriv_wtk_point = status

      return

c     Error return
9999  write(6,5000) bf.type
5000  format('deriv_wtk_point: Does not support bfield type ',i1)
      deriv_wtk_point = -bf.type
      return

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.4  1997/04/04 20:31:22  garren
c add rcs log line
c
