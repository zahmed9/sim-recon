      integer function ccov_to_wcov(c, c_cov, w, w_cov)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Convert a c covariance matrix to a w covariance matrix at the current 
c  point
c
c Inputs:
c  c       --> track parameters from central track list
c  c_cov       Input 5x5 c covariance matrix
c
c  w       --> track parameters in W representation
c
c Output:
c *w_cov       Output 7x7 w covariance matrix
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "wtrack_struct.inc"
#include "ctrack_struct.inc"

c     calling arguments
      record /ctrack_struct/ c
      record /wtrack_struct/ w
      DFLOAT c_cov(5,5)
      DFLOAT w_cov(7,7)
c
c     local variables
      integer i, j

      DFLOAT einv, cuinv, p, pt, px, py, pz, cu, ct
      DFLOAT a(7,5), avx(7,5), delx, dely, w_cov1(7,7)
      DFLOAT diff(7,7)

      save a, avx

      data a/35*0./
      data avx/35*0./
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

        cu = c.cu
        if(cu .eq. 0.) goto 99
        cuinv = 1. / cu
        ct = c.ct

        px = w.px
        py = w.py
        pz = w.pz
        pt = w.pt
        p =  w.p
        einv = 1. / w.E
        delx = w.x - c.xref
        dely = w.y - c.yref


c     now build the covariance matrix in the "w" rep.
c       dpx = -px/c*dc - py*dfi               = a11*dc + a12*dfi
c       dpy = -py/c*dc + px*dfi               = a21*dc + a22*dfi
c       dpz = -pz/c*dc + pt*dct               = a31*dc + a34*dct
c       de  = -p**2/e/c*dc + ct*pt**2/e*dct   = a41*dc + a44*dct
c       dx  = -py/pt*dd - y*dfi               = a52*dfi+ a53*dd
c       dy  =  px/pt*dd + x*dfi               = a62*dfi+ a63*dd
c       dz  = dz0                             = 1*dz0

        a(1,1) = -px*cuinv
        a(2,1) = -py*cuinv
        a(3,1) = -pz*cuinv
        a(4,1) = -p**2*einv*cuinv
c       a(5,1) = 0.
c       a(6,1) = 0.
c       a(7,1) = 0.

        a(1,2) = -py
        a(2,2) =  px
c       a(3,2) = 0.
c       a(4,2) = 0.
        a(5,2) = -dely
        a(6,2) =  delx
c       a(7,2) = 0.

c       a(1,3) = 0.
c       a(2,3) = 0.
c       a(3,3) = 0.
c       a(4,3) = 0.
        a(5,3) = -py/pt
        a(6,3) =  px/pt
c       a(7,3) = 0.

c       a(1,4) = 0.
c       a(2,4) = 0.
        a(3,4) = pt
        a(4,4) = ct*pt**2*einv
c       a(5,4) = 0.
c       a(6,4) = 0.
c       a(7,4) = 0.

c       a(1,5) = 0.
c       a(2,5) = 0.
c       a(3,5) = 0.
c       a(4,5) = 0.
c       a(5,5) = 0.
c       a(6,5) = 0.
        a(7,5) = 1.

        do i=1,5
          avx(1,i) = c_cov(1,i)*a(1,1) + c_cov(2,i)*a(1,2)
          avx(2,i) = c_cov(1,i)*a(2,1) + c_cov(2,i)*a(2,2)
          avx(3,i) = c_cov(1,i)*a(3,1) + c_cov(4,i)*a(3,4)
          avx(4,i) = c_cov(1,i)*a(4,1) + c_cov(4,i)*a(4,4)
          avx(5,i) = c_cov(2,i)*a(5,2) + c_cov(3,i)*a(5,3)
          avx(6,i) = c_cov(2,i)*a(6,2) + c_cov(3,i)*a(6,3)
          avx(7,i) = c_cov(5,i)
        enddo

        do i=1,7
          w_cov(1,i) = a(1,1)*avx(i,1) + a(1,2)*avx(i,2)
        enddo
        do i=2,7
          w_cov(2,i) = a(2,1)*avx(i,1) + a(2,2)*avx(i,2)
        enddo
        do i=3,7
          w_cov(3,i) = a(3,1)*avx(i,1) + a(3,4)*avx(i,4)
        enddo
        do i=4,7
          w_cov(4,i) = a(4,1)*avx(i,1) + a(4,4)*avx(i,4)
        enddo
        w_cov(5,5) = a(5,2)*avx(5,2) + a(5,3)*avx(5,3)
        w_cov(5,6) = a(5,2)*avx(6,2) + a(5,3)*avx(6,3)
        w_cov(5,7) = a(5,2)*avx(7,2) + a(5,3)*avx(7,3)
        w_cov(6,6) = a(6,2)*avx(6,2) + a(6,3)*avx(6,3)
        w_cov(6,7) = a(6,2)*avx(7,2) + a(6,3)*avx(7,3)
        w_cov(7,7) = avx(7,5)

c     other side of the matrix:
        do i=2,7
          do j=1,i-1
            w_cov(i,j) = w_cov(j,i)
          enddo
        enddo

      call MxABAtr(7, 5, a, c_cov, w_cov1)

      do i=1,7
        do j=1,7
          diff(i,j) = w_cov(i,j) - w_cov1(i,j)
        enddo
      enddo

c     Normal exit
      ccov_to_wcov = 0
      return

c     Error exit
 99   ccov_to_wcov = 1
      call vzero(w_cov, 7*7*FLOAT_WORD)

      return
      end
c
c$Id$
c
c$Log$
cRevision 1.1  2000/06/19 19:59:42  eugenio
cInitial revision
c
cRevision 1.2  1997/03/27 05:03:56  kutschke
cFix return status codes.
c
