      integer function move_ctk_cov(c1, cov1, x, c2, cov2, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Move a helix covariance matrix from one reference point to
c  another in a solenoidal B field. Return value is always 0.
c
c  Note: This routine differs from move_ctk_point_cov in that only the
c        covariance matrix is moved; the old and new track parameters
c        must be provided by the caller.
c
c  c1       c track structure (read)
c           Track parameters at old reference point
c
c  cov1     DFLOAT array (read)
c           5x5 covariance matrix for c1
c
c  x(3)     DFLOAT array (read)
c           New reference point
c
c  c2       c track structure (read)
c           Track parameters at new reference point (provided by caller)
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
      integer  deriv_ctk_point
      external deriv_ctk_point

c     calling arguments
      record /ctrack_struct/ c1, c2
      DFLOAT x(3), cov1(5,5), cov2(5,5)
      DFLOAT s3d

c     local variables
      integer status
      DFLOAT R(5,5), cov(5,5)
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      status = deriv_ctk_point(c1, c2, R)
      if(status .ne. 0) goto 9999

      call vzero(cov, 5*5*FLOAT_WORD)
      call MxABAtr(5, 5, R, cov1, cov)
      call ucopy(cov, cov2, 5*5*FLOAT_WORD)

      move_ctk_cov = 0
      return

c     Error return
 9999 move_ctk_cov = status
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:31:34  garren
c add rcs log line
c

