      integer function fcov_to_wcov(f, f_cov, w, w_cov)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Convert a f covariance matrix to a w covariance matrix at the current
c  point.
c
c  f       --> forward track parameters
c  f_cov       Input 5x5 f covariance matrix
c
c  w       --> track parameters in W representation
c  w_cov       Output 7x7 w covariance matrix
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "wtrack_struct.inc"
#include "ftrack_struct.inc"

c     calling arguments
      record /ftrack_struct/ f
      record /wtrack_struct/ w
      DFLOAT f_cov(5,5)
      DFLOAT w_cov(7,7)
c
c     local variables
      integer i, j

      DFLOAT alpha, alpha_inv, xslp, yslp, einv
      DFLOAT a(7,5), avx(7,5)

      save a, avx

      data a/35*0./
      data avx/35*0./
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      alpha = f.alpha
      if(alpha .eq. 0.) goto 99
      xslp = f.xslp
      yslp = f.yslp

      alpha_inv = 1. / alpha
      einv = 1. / w.E

c     now build the covariance matrix in the "w" rep.
c     Let al = alpha
c     dpx = -px/al*dal + (1/al)*dx'         = a11*dal + a12*dx'
c     dpy = -py/al*dal + (1/al)*dy'         = a21*dal + a22*dy'
c     dpz = -pz/al*dal                      = a31*dal
c     de  = -p**2/e/al*dal + (x'/al**2/e)*dx'
c                          + (y'/al**2/e)*dy' = a41*dal + a42*dx' + a43*dy'
c     dx  = dxp                             = a54*dxp
c     dy  = dyp                             = a65*dyp
c     dz  = 0

      a(1,1) = -w.px * alpha_inv
      a(2,1) = -w.py * alpha_inv
      a(3,1) = -w.pz * alpha_inv
      a(4,1) = -w.p**2 * alpha_inv * einv
c     a(5,1) = 0.
c     a(6,1) = 0.
c     a(7,1) = 0.

      a(1,2) = alpha_inv
c     a(2,2) = 0.
c     a(3,2) = 0.
      a(4,2) = xslp * alpha_inv**2 * einv
c     a(5,2) = 0.
c     a(6,2) = 0.
c     a(7,2) = 0.

c     a(1,3) = 0.
      a(2,3) = alpha_inv
c     a(3,3) = 0.
      a(4,3) = yslp * alpha_inv**2 * einv
c     a(5,3) = 0.
c     a(6,3) = 0.
c     a(7,3) = 0.

c     a(1,4) = 0.
c     a(2,4) = 0.
c     a(3,4) = 0.
c     a(4,4) = 0.
      a(5,4) = 1.0
c     a(6,4) = 0.
c     a(7,4) = 0.

c     a(1,5) = 0.
c     a(2,5) = 0.
c     a(3,5) = 0.
c     a(4,5) = 0.
c     a(5,5) = 0.
      a(6,5) = 1.0
c     a(7,5) = 0.

      do i=1,5
        avx(1,i) = f_cov(1,i)*a(1,1) + f_cov(2,i)*a(1,2)
        avx(2,i) = f_cov(1,i)*a(2,1) + f_cov(3,i)*a(2,3)
        avx(3,i) = f_cov(1,i)*a(3,1)
        avx(4,i) = f_cov(1,i)*a(4,1) + f_cov(2,i)*a(4,2)
     *                               + f_cov(3,i)*a(4,3)
        avx(5,i) = f_cov(4,i)*a(5,4)
        avx(6,i) = f_cov(5,i)*a(6,5)
      enddo

      do i=1,6
        w_cov(1,i) = a(1,1)*avx(i,1) + a(1,2)*avx(i,2)
      enddo
      do i=2,6
        w_cov(2,i) = a(2,1)*avx(i,1) + a(2,3)*avx(i,3)
      enddo
      do i=3,6
        w_cov(3,i) = a(3,1)*avx(i,1)
      enddo
      do i=4,6
        w_cov(4,i) = a(4,1)*avx(i,1) + a(4,2)*avx(i,2)
     *                               + a(4,3)*avx(i,3)
      enddo
      w_cov(5,5) = a(5,4)*avx(5,4)
      w_cov(5,6) = a(5,4)*avx(6,4)
      w_cov(6,6) = a(6,5)*avx(6,5)

c     z has no error in f paramtrization
      do i=1,7
        w_cov(i,7) = 0.  
      enddo

c     other side of the matrix:
        do i=2,7
          do j=1,i-1
            w_cov(i,j) = w_cov(j,i)
          enddo
        enddo

c     Normal exit
      fcov_to_wcov = 0
      return

c     Error exit
 99   fcov_to_wcov = 1
      call vzero(w_cov, 7*7*FLOAT_WORD)

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.3  1998/11/11 05:04:53  kutschke
c Good/Bad return codes were swapped.
c
c Revision 1.2  1997/04/04  20:31:32  garren
c add rcs log line
c

