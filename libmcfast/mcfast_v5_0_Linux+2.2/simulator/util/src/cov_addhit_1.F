      integer function cov_addhit_1(ccov1, derv, weight, ccov2,
     *                              mdim, npar)
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Add a hit to a and update the covariance matrix. This is the
c  repeating step in the kalman filter.
c
c  Inputs:
c
c  ccov1   DFLOAT array
c          Initial covariance matrix (npar x npar)
c
c  derv    DFLOAT array
c          Derivatives of hit coord. wrt track parameters (length = npar)
c
c  weight  DFLOAT variable
c          1/sigma**2 of hit
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

c     Externals
      external dcalc_ctk_bsil_drv
      external dcalc_ctk_axial_drv, dcalc_ctk_stereo_drv
      integer  dcalc_ctk_bsil_drv
      integer  dcalc_ctk_axial_drv, dcalc_ctk_stereo_drv

c     Calling arguments
      integer mdim, npar
      DFLOAT ccov1(mdim,mdim), ccov2(mdim,mdim)
      DFLOAT derv(mdim), weight

c     Local variables
      integer mtmp
      parameter (mtmp = 7)

      integer i, i1, i2
      DFLOAT vtmp(mtmp,mtmp), temp, den, vxa(mtmp)
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      do i1=1,npar
        do i2=1,npar
          vtmp(i2,i1) = ccov1(i2,i1)
        enddo
      enddo

c     Calculate vx * a
      do i1=1,npar
        vxa(i1) = 0
        do i2=1,npar
          vxa(i1) = vxa(i1) + vtmp(i2,i1)*derv(i2)
        enddo
      enddo

c     Calculate vx' = vx - vx*a(t)*a*vx/(sig**2 + a*vx*a(t))
      temp = 0.
      do i=1,npar
        temp = temp + derv(i)*vxa(i)
      enddo
      den = weight / (1. + temp*weight)
      do i1=1,npar
        temp = vxa(i1) * den
        do i2=1,i1
          vtmp(i2,i1) = vtmp(i2,i1) - vxa(i2) * temp
          vtmp(i1,i2) = vtmp(i2,i1)
        enddo
      enddo

      do i1=1,npar
        do i2=1,npar
          ccov2(i2,i1) = vtmp(i2,i1)
        enddo
      enddo

c     normal exit
      cov_addhit_1 = 0
      return

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:42  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:57  garren
c add rcs log line
c
