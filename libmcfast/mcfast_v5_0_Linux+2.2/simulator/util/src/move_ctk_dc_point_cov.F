      integer function move_ctk_dc_point_cov(c1, dc1, cov1, x, 
     +                                       c2, dc2, cov2, s3d )

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c  Move a helix and its covariance matrix from one reference point to
c  another in a solenoidal B field. Return value is always 0.
c  Also move the Kalman filter linearized correction.
c
c  c1       c track structure (read)
c           Input track parameters
c
c  dc1      DFLOAT arrary (read)
c           Linearized correction to c1.
c
c  cov1     DFLOAT array (read)
c           5x5 covariance matrix for c1
c
c  x(3)     DFLOAT array (read)
c           New reference point
c
c *c2       c track structure (rwrite)
c           Output track parameters
c
c *dc2      DFLOAT arrar (write)
c           Linearized correction to c2.
c
c *cov2     DFLOAT array (write)
c           5x5 covariance matrix for c2
c
c *s3d      DFLOAT variable (write)
c           3-D arc length the track moved between points
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "ctrack_struct.inc"
#include "const.inc"

c     Externals
      integer  move_ctk_point, deriv_ctk_point
      external move_ctk_point, deriv_ctk_point

      ! Number of track parameters.
      integer MPAR
      parameter ( MPAR = 5 )

c     calling arguments
      record /ctrack_struct/ c1, c2
      DFLOAT x(3), cov1(MPAR,MPAR), cov2(MPAR,MPAR)
      DFLOAT dc1(MPAR), dc2(MPAR)
      DFLOAT s3d

c     local variables
      record /ctrack_struct/ c
      integer i, status
      DFLOAT R(MPAR,MPAR), cov(MPAR,MPAR)
      DFLOAT dc_tmp(MPAR)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Save initial track and move track to new reference point
c     Track must be saved in case output track is same as input track.
      call ucopy(c1, c, CTRACK_WORD)

      status = move_ctk_point(c1, x, c2, s3d)
      status = deriv_ctk_point(c, c2, R)
      if(status .ne. 0) goto 9999

      call vzero(cov, MPAR*MPAR*FLOAT_WORD)
      call MxABAtr(MPAR, MPAR, R, cov1, cov)
      call ucopy(cov, cov2, MPAR*MPAR*FLOAT_WORD)

      ! Should rewrite this to exploit the many 1's and 0's in R.
      do i = 1, MPAR
         dc_tmp(i) = R(i,1)*dc1(1) + R(i,2)*dc1(2) + 
     +               R(i,3)*dc1(3) + R(i,4)*dc1(4) + 
     +               R(i,5)*dc1(5)
      enddo
      call ucopy ( dc_tmp, dc2, MPAR*FLOAT_WORD)

c     Normal return
      move_ctk_dc_point_cov = 0
      return

c     Error return
 9999 move_ctk_dc_point_cov = status
      call ucopy(c1, c2, CTRACK_WORD)
      return

      end
c
c $Id$
c
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.1  1999/05/12 22:27:22  kutschke
c 22nd file for ctk Kalman filter changes.
c
c
