      integer function cov_addhit_2(ccov1, derv, hcov, ccov2,
     *                              mdim, npar)
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Add a 2-d hit to a and update the covariance matrix. This is the
c  repeating step in the kalman filter.
c
c  Inputs:
c
c  ccov1   DFLOAT array
c          Initial covariance matrix (npar x npar)
c
c  derv    DFLOAT array
c          Derivatives of hit coord. wrt track parameters (2 x npar)
c
c  hcov    DFLOAT array
c          Covariance matrix of hit (2 x 2)
c
c  mdim    integer variable
c          1st dimension of ccov1, ccov2
c
c  npar    integer variable
c          # of parameters
c
c  Outputs:
c  ccov2   DFLOAT array
c          Updated covariance matrix after hit added (npar x npar)
c
c  Return:
c          0 ==> all ok
c          1 ==> error
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
      implicit none

#include "const.inc"

c     Calling arguments
      integer mdim, npar
      DFLOAT ccov1(mdim,mdim), ccov2(mdim,mdim)
      DFLOAT derv(mdim,2), hcov(2,2)

c     Local variables
      integer mtmp
      parameter (mtmp = 7)

      integer i, i1, i2, i3
      DFLOAT vtmp(mtmp,mtmp), temp(2,2), temp2(2,mtmp)
      DFLOAT disc, vxa(mtmp,2), tinv(2,2)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      do i1=1,npar
        do i2=1,npar
          vtmp(i2,i1) = ccov1(i2,i1)
        enddo
      enddo

c     Calculate vx * at
      do i1=1,npar
        do i2=1,2
          vxa(i1,i2) = 0.0
          do i3=1,npar
            vxa(i1,i2) = vxa(i1,i2) + vtmp(i1,i3)*derv(i3,i2)
          end do
        enddo
      enddo

c     Calculate (hcov + a*vx*at)**-1:

      do i1=1,2
        do i2=1,2
          temp(i1,i2) = hcov(i1,i2)
          do i3=1,npar
            temp(i1,i2) = temp(i1,i2) + derv(i3,i1)*vxa(i3,i2)
          end do
        end do
      end do

      ! Invert covariance matrix of measurements.
      disc = temp(1,1)*temp(2,2)-temp(1,2)*temp(2,1)
      if ( disc .eq. 0. ) goto 9999
      tinv(1,1) =  temp(2,2)/disc
      tinv(1,2) = -temp(1,2)/disc
      tinv(2,1) = -temp(2,1)/disc
      tinv(2,2) =  temp(1,1)/disc

c     Calculate vx' = vx - vx*a(t)*[(hcov + a*vx*at)**-1]*a*vx
      do i1=1,2
        do i2=1,npar
          temp2(i1,i2) = 0.0
          do i3=1,2
            temp2(i1,i2) = temp2(i1,i2) + tinv(i1,i3)*vxa(i2,i3)
          end do
        end do
      end do
      do i1=1,npar
        do i2=1,npar
          do i3=1,2
            vtmp(i1,i2) = vtmp(i1,i2) - vxa(i1,i3)*temp2(i3,i2)
          end do
        end do
      end do

      do i1=1,npar
        do i2=1,npar
          ccov2(i2,i1) = vtmp(i2,i1)
        enddo
      enddo

c     normal exit
      cov_addhit_2 = 0
      return

c     abnormal exit
 9999 cov_addhit_2 = 1
      return

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:42  eugenio
c Initial revision
c
c Revision 1.4  1998/11/11 05:04:13  kutschke
c Bugfix in inversion of temp.
c
c Revision 1.3  1998/02/13  23:08:36  kutschke
c Allow temp to be diagonal.
c
c Revision 1.2  1997/04/04  20:30:57  garren
c add rcs log line
c
