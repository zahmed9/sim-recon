      integer function move_ctk_point_cov(c1, cov1, x, c2, cov2, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Move a helix and its covariance matrix from one reference point to
c  another in a solenoidal B field. Return value is always 0.
c
c  c1       c track structure (read)
c           Input track parameters
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
c *cov2     DFLOAT array (write)
c           5x5 covariance matrix for c2
c
c *s3d      DFLOAT variable (write)
c           3-D arc length the track moved between points
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "ctrack_struct.inc"
#include "const.inc"

c     Externals
      integer  move_ctk_point, deriv_ctk_point
      external move_ctk_point, deriv_ctk_point

c     calling arguments
      record /ctrack_struct/ c1, c2
      DFLOAT x(3), cov1(5,5), cov2(5,5)
      DFLOAT s3d

c     local variables
      record /ctrack_struct/ c
      integer status
      DFLOAT R(5,5), cov(5,5)
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Save initial track and move track to new reference point
c     Track must be saved in case output track is same as input track.
      call ucopy(c1, c, CTRACK_WORD)
      status = move_ctk_point(c1, x, c2, s3d)
      status = deriv_ctk_point(c, c2, R)
      if(status .ne. 0) goto 9999

      call vzero(cov, 5*5*FLOAT_WORD)
      call MxABAtr(5, 5, R, cov1, cov)
      call ucopy(cov, cov2, 5*5*FLOAT_WORD)

      move_ctk_point_cov = 0
      return

c     Error return
 9999 move_ctk_point_cov = status
      call ucopy(c1, c2, CTRACK_WORD)
      return

      end
c
c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.5  1999/05/12 22:26:53  kutschke
c Restore previous version.
c
c Revision 1.4  1999/05/12  20:21:40  kutschke
c 21 files changed/added to implement ctk Kalman filter.
c
c Revision 1.3  1997/04/04  20:31:35  garren
c add rcs log line
c
