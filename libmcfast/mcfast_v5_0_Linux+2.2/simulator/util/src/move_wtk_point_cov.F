      integer function move_wtk_point_cov(w1, cov1, x, bf, w2,
     *                                    cov2, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Move a helix and its covariance matrix from one reference point to
c  another in a solenoidal B field. Return value is always 0.
c
c  Inputs:
c  w1       w track structure
c           Input track parameters
c
c  cov1     DFLOAT array
c           7x7 covariance matrix for w1
c
c  x(3)     DFLOAT array
c           New reference point
c
c  bf       B field structure
c           B field info
c
c  Outputs:
c  w2       w track structure
c           Output track parameters
c
c  cov2     DFLOAT array
c           7x7 covariance matrix for w2
c
c  s3d      DFLOAT variable
c           3-D arc length the track moved between points
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "wtrack_struct.inc"
#include "bfield_struct.inc"
#include "const.inc"

c     Externals
      integer  move_wtk_point, deriv_wtk_point
      external move_wtk_point, deriv_wtk_point

c     calling arguments
      record /wtrack_struct/ w1, w2
      record /bfield_struct/ bf
      DFLOAT x(3), cov1(7,7), cov2(7,7)
      DFLOAT s3d

c     local variables
      record /wtrack_struct/ w
      integer status
      DFLOAT R(7,7), cov(7,7)
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Save initial track and move track to new reference point
c     Track must be saved in case output track is same as input track.
      call ucopy(w1, w, WTRACK_WORD)
      status = move_wtk_point(w1, x, bf, w2, s3d)
      status = deriv_wtk_point(w, w2, bf, R)

      call vzero(cov, 7*7*FLOAT_WORD)
      call MxABAtr(7, 7, R, cov1, cov)
      call ucopy(cov, cov2, 7*7*FLOAT_WORD)

      move_wtk_point_cov = 0

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:45  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:49  garren
c add rcs log line
c
