      integer function err_mass( na, p, v, m, vm)
c 
c   Calculate:
c    - the invariant mass of the 4-vector p and
c    - the error on the mass, using the covarinace matrix v.
c
c   vm is the error on the mass
c
      implicit none

#include "const.inc"

c Arguments:

      ! Input: first dimension of the covariance matrix.
      integer na

      ! Input: 4 vector and its covariance matrix.
      DFLOAT p(4), v(na,4)

      ! Output: mass and its error
      DFLOAT m, vm

c Local variables.
 
      ! Mass squared.
      DFLOAT msq

      ! Derivatives of mass wrt to components of 4 vector.
      DFLOAT dm(4)

      err_mass = 1
      m        = 0.
      vm       = 99999.

      msq = p(4)**2-p(1)**2-p(2)**2-p(3)**2
      if ( msq .le. 0. ) return

      m=sqrt(msq)

      dm(1)=-p(1)/m
      dm(2)=-p(2)/m
      dm(3)=-p(3)/m
      dm(4)= p(4)/m

      vm =  dm(1)*dm(1)*v(1,1) +
     +      dm(2)*dm(2)*v(2,2) +
     +      dm(3)*dm(3)*v(3,3) +
     +      dm(4)*dm(4)*v(4,4) +
     + 2.*( dm(1)*dm(2)*v(1,2) +
     +      dm(1)*dm(3)*v(1,3) +
     +      dm(1)*dm(4)*v(1,4) +
     +      dm(2)*dm(3)*v(2,3) +
     +      dm(2)*dm(4)*v(2,4) +
     +      dm(3)*dm(4)*v(3,4)  )

      ! Check for legal error.
      if ( vm .lt. 0. ) return

      vm = sqrt(vm)
      err_mass = 0
      return

      end
c
c$Id$
c
c$Log$
cRevision 1.1  2000/06/19 19:59:44  eugenio
cInitial revision
c
cRevision 1.4  1998/04/27 02:17:50  kutschke
cReturn mass if error is bad.  real*8 to DFLOAT.
c
c Revision 1.3  1997/04/04  08:19:33  kutschke
c Add na argument.  Roll out loops
c
c Revision 1.2  1997/03/27  05:04:03  kutschke
c New routine.
c
