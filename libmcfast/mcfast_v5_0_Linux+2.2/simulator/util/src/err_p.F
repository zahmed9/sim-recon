      function err_p( na, p, v )
c
c Compute the error on the 3 magnitude of a 3 vector, with
c the 3-vector represented in cartesian components.
c For example, the input vector might be a 3-vector, the space part of a 
c 4-vector or the 3-vector part of a wtrack. )
c 
c The covariance matrix of the momentum components might be a
c submatrix of a larger matrix and so the first dimension of the
c covariance matrix is also required.  The matrix is assumed to
c stored in fortran ordering, not in c ordering.
c

      implicit none

#include "const.inc"

      DFLOAT err_p

      ! First dimension of the covariance matrix.
      integer na

      ! 3-momentum and its covariance matrix.
      DFLOAT p(*), v(na,*)

      ! Derivatives of the magnitude wrt the momentum components.
      DFLOAT deriv(3)

      ! Magnitude of the 3-vector.
      DFLOAT pp

      ! Functions.
      DFLOAT v3mag_d

      ! Square of the error on the magnitude.
      DFLOAT err_sq

      ! Default value in case of errors.
      err_p = 1.e36

      pp = v3mag_d(p)
      if ( pp .eq. 0. ) return

      deriv(1) = p(1)/pp
      deriv(2) = p(2)/pp
      deriv(3) = p(3)/pp

      err_sq  = deriv(1)*deriv(1)*v(1,1) +
     +          deriv(2)*deriv(2)*v(2,2) +
     +          deriv(3)*deriv(3)*v(3,3) +
     +     2.*( deriv(1)*deriv(2)*v(1,2) +
     +          deriv(1)*deriv(3)*v(1,3) +
     +          deriv(2)*deriv(3)*v(2,3)   )

      if ( err_sq .lt. 0.) return

      err_p = sqrt(err_sq)

      end
c
c$Id$
c
c$Log$
cRevision 1.1  2000/06/19 19:59:44  eugenio
cInitial revision
c
cRevision 1.3  1998/04/27 02:18:06  kutschke
creal*8 to DFLOAT
c
c Revision 1.2  1997/04/04  08:19:37  kutschke
c New routine.
c
