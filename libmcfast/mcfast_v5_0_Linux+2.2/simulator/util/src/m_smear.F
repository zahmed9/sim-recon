      subroutine m_smear(V, mv, npar, alpha_in, alpha_out)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Smear parameters according to their covariance V.
c
c  Inputs:
c
c  V       real array
c          Covariance matrix of parameters
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"

c     Externals
      real get_gauss
      external get_gauss

c     Calling arguments
      integer mv, npar
      DFLOAT V(mv,npar), alpha_in(npar), alpha_out(npar)

c     Local variables
      integer mw
      parameter (mw=5)   !Must be at least as large as npar
      integer i, j, ierr
      double precision eigval(mw), eigvec(mw,mw), work(mw)
      double precision vv(mw,mw)
      real dbeta(mw)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Alpha parameters are correlated so it is difficult to smear them in
c     such a way as to correctly account for the correlations.
c     Rotate into basis where they are uncorrelated (covariance
c     matrix is diagonal).

c     Set of eigenvectors constitute the rotation matrix
c     Eigenvalues are variances of rotated parameters (call them beta)
c     Use double precision version because of errors in single precision
      ierr = 0
      do i=1,mw
        do j=1,mw
          vv(j,i) = v(j,i)
        enddo
      enddo
      call deisrs1(mv, npar, VV, eigval, eigvec, ierr, work)

c     A = [eigvec_1 eigvec_2 ... eigvec_n] = rotation matrix
c     V' = At * V * A  (V' is diagonal)

c     Now smear the quantities beta
      do i=1,npar
        if(eigval(i) .lt. 0.) write(6,5000) i, eigval(i)
 5000   format(' Negative error: ', i5, 1pE15.5)
        dbeta(i) = sqrt(abs(eigval(i))) * get_gauss(0)
      enddo

c     Rotate the smeared quantities into the old basis and add to
c     input parameters
      do i=1,npar
        alpha_out(i) = alpha_in(i)
        do j=1,npar
          alpha_out(i) = alpha_out(i) + eigvec(i,j) * dbeta(j)
        enddo
      enddo

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.3  1998/06/23 23:47:43  bphyslib
c fix references to renamed routines
c
c Revision 1.2  1997/04/04  20:30:32  garren
c add rcs log line
c
