      integer function wcov_to_fcov ( w, wcov, f, fcov )

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Convert a w covariance matrix to an f covariance matrix at the current
c  point.
c
c  w       --> Input w track parameters
c  w_cov       Input 7x7 w covariance matrix
c
c  f       --> Input track parameters in f representation
c  f_cov       Output 5x5 f covariance matrix
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "wtrack_struct.inc"
#include "ftrack_struct.inc"

c     Calling arguments
      record /wtrack_struct/ w
      DFLOAT wcov(7,7)
      record /ftrack_struct/ f
      DFLOAT fcov(5,5)

c     Local variables

      ! Indexology.
      integer k

      ! The transformation is done as the matrix equation:
      ! fcov(i,j) = a^t(i,k) wcov(k,l) a(l,j)
      !           =   a(k,i) wcov(k,l) a(l,j)
      !           =   a(k,i) va(k,j)
      ! where,
      !   - a(l,j) = d f_j / d w_l
      !   - ^t denotes transpose, 
      !   - f_j denotes one of the 5 components of an f track
      !   - w_l denotes one of the 7 components of a w track
      !   - va  is a temporary, defined below.

      ! The only non-zero elements of a are:
      ! a(1,2) = d xslp / d px  =  alpha
      ! a(2,3) = d yslp / d py  =  alpha
      ! a(3,1) = d alpha / d pz = -1./alpha**2
      ! a(3,2) = d xslp / d pz  = -xslp*alpha
      ! a(3,3) = d yslp / d pz  = -yslp*alpha
      ! a(5,4) = d xp / d x     =  1.
      ! a(6,7) = d yp / d y     =  1.
      ! Note that the energy is treated as independent of the
      ! momentum components, so the partials of f_i wrt e are all zero.
      !
      ! DFLOAT(a7,5) - but we only need the 3x3 upper right corner.
      DFLOAT a(3,3)

      ! va = wcov*a
      ! DFLOAT va(7,5) - but we never need the seventh row.
      DFLOAT va(6,5)

      a(1,2) =  f.alpha
      a(2,3) =  f.alpha
      a(3,1) = -f.alpha*f.alpha
      a(3,2) = -f.xslp *f.alpha
      a(3,3) = -f.yslp *f.alpha

      ! We never need the 7th row of va so do not bother to compute it.
      do k = 1, 6
         va(k,1) = wcov(k,3)*a(3,1)
         va(k,2) = wcov(k,1)*a(1,2) + wcov(k,3)*a(3,2)
         va(k,3) = wcov(k,2)*a(2,3) + wcov(k,3)*a(3,3)
         va(k,4) = wcov(k,5)
         va(k,5) = wcov(k,6)
      enddo

      ! Build the lower triangle.
      ! Some hand optimation has been done here - sometimes the expression
      ! is actually that for the corresponding piece in the upper triangle,
      ! if that expression is simpler.
      fcov(1,1) = a(3,1)*va(3,1)
      fcov(2,1) = a(3,1)*va(3,2)
      fcov(3,1) = a(3,1)*va(3,3)
      fcov(4,1) =        va(5,1)
      fcov(5,1) =        va(6,1)
      fcov(2,2) = a(1,2)*va(1,2) + a(3,2)*va(3,2)
      fcov(3,2) = a(2,3)*va(2,2) + a(3,3)*va(3,2)
      fcov(4,2) =        va(5,2)
      fcov(5,2) =        va(6,2)
      fcov(3,3) = a(2,3)*va(2,3) + a(3,3)*va(3,3)
      fcov(4,3) =        va(5,3)
      fcov(5,3) =        va(6,3)
      fcov(4,4) =        va(5,4)
      fcov(5,4) =        va(6,4)
      fcov(5,5) =        va(6,5)

      !Now the upper triangle.
      fcov(1,2) = fcov(2,1)
      fcov(1,3) = fcov(3,1)
      fcov(1,4) = fcov(4,1)
      fcov(1,5) = fcov(5,1)
      fcov(2,3) = fcov(3,2)
      fcov(2,4) = fcov(4,2)
      fcov(2,5) = fcov(5,2)
      fcov(3,4) = fcov(4,3)
      fcov(3,5) = fcov(5,3)
      fcov(4,5) = fcov(5,4)

      wcov_to_fcov = 0

      end
c
c$Id$
c
c$Log$
cRevision 1.1  2000/06/19 19:59:46  eugenio
cInitial revision
c
cRevision 1.2  1997/03/27 05:04:05  kutschke
cNew routine.
c
