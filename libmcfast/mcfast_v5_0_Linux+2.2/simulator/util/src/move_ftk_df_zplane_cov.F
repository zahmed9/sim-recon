      integer function move_ftk_df_zplane_cov(f1, df1, cov1, zs, bf, 
     *                                        f2, df2, cov2, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Move a forward track and its covariance matrix from one plane to
c  another in a dipole B field.  Also move the linearized correction
c  ( which is part of the Kalman filter code ).
c
c  f1       f track structure (read)
c           Input track parameters
c
c  df1      linearized corrections to f1
c           Input.
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
c *f2       f track structure (write)
c           Output track parameters
c
c *df2      linearized corrections to f2
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
      integer  move_ftk_zplane, deriv_ftk_zplane
      external move_ftk_zplane, deriv_ftk_zplane

c     calling arguments
      record /ftrack_struct/ f1, f2
      record /bfield_struct/ bf
      DFLOAT zs, df1(5), df2(5), cov1(5,5), cov2(5,5)
      DFLOAT s3d

c     local variables
      record /ftrack_struct/ f
      integer status, i
      DFLOAT R(5,5), cov(5,5), df_tmp(5)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Save initial track and move track to new plane
c     Track must be saved in case output track is same as input track.
      call ucopy(f1, f, FTRACK_WORD)
      status = move_ftk_zplane(f1, zs, bf, f2, s3d)
      if(status .ne. 0) goto 9999
      status = deriv_ftk_zplane(f, f2, bf, R)
      if(status .ne. 0) goto 9999

      call vzero(cov, 5*5*FLOAT_WORD)
      call MxABAtr(5, 5, R, cov1, cov)
      call ucopy(cov, cov2, 5*5*FLOAT_WORD)

      do i = 1, 5
         df_tmp(i) = R(i,1)*df1(1) + R(i,2)*df1(2) +
     +               R(i,3)*df1(3) + R(i,4)*df1(4) +
     +               R(i,5)*df1(5)
      enddo
      call ucopy ( df_tmp, df2, 5*FLOAT_WORD)

      move_ftk_df_zplane_cov = 0
      return

 9999 move_ftk_df_zplane_cov = 1
      call ucopy(cov1, cov2, 5*5*FLOAT_WORD)
      call ucopy( df1,  df2,   5*FLOAT_WORD)
      return
      end

c $Id$
c
c $Log$
c Revision 1.1  2000/06/19 19:59:45  eugenio
c Initial revision
c
c Revision 1.1  1998/02/13 23:08:33  kutschke
c New routine.
c
c
