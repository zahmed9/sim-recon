      integer function move_ftk_cov(f1, cov1, zs, bf, f2, cov2, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Move a forward track covariance matrix from one plane to
c  another in a dipole B field.
c
c  Note: This routine differs from move_ftk_zplane_cov in that only the
c        covariance matrix is moved; the old and new track parameters
c        must be provided by the caller.
c
c  f1       f track structure (read)
c           Input track parameters
c
c  cov1     DFLOAT array (read)
c           5x5 covariance matrix for f1
c
c  zs       DFLOAT array (read)
c           Plane to project to
c
c  bf       B field structure (read)
c           B field information
c
c  f2       f track structure (read)
c           Output track parameters
c
c *cov2     DFLOAT array (write)
c           5x5 covariance matrix for f2
c
c *s3d      DFLOAT variable (write)
c           3-D arc length the track moved between points
c
c return    
c           0 ==> all OK
c           1 ==> track cannot be projected
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "ftrack_struct.inc"
#include "bfield_struct.inc"
#include "const.inc"

c     Externals
      integer  deriv_ftk_zplane
      external deriv_ftk_zplane

c     calling arguments
      record /ftrack_struct/ f1, f2
      record /bfield_struct/ bf
      DFLOAT zs, cov1(5,5), cov2(5,5)
      DFLOAT s3d

c     local variables
      integer status
      DFLOAT R(5,5), cov(5,5)
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      status = deriv_ftk_zplane(f1, f2, bf, R)

      call vzero(cov, 5*5*FLOAT_WORD)
      call MxABAtr(5, 5, R, cov1, cov)
      call ucopy(cov, cov2, 5*5*FLOAT_WORD)

      move_ftk_cov = 0
      return

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:45  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:37  garren
c add rcs log line
c
