       logical function check_cov(v)

C
C This is an adapation of the CLEO routine check_var:
C
C Original CLEO comments below.
C
C     Code created by 
C
C     Robert Kutschke : kutschke@lns598.lns.cornell.edu
C     Anders Ryd      : ryd@charm.physics.ucsb.edu
C
C     Created : Sept 1994 -- June 1995
C     Title   : check_var
C     Purpose : To check is a variance matrix is good or bad.
C               I do not now of a proof that this test is
C               exhaustive. But I'm very convinced that
C               it is actually correct and sufficient.
C                                            Anders
C               Implementation is for 5x5 matrix but 
C               generalizations are trivial.
C     
C
C End of original CLEO comments.
C
C The changes from the CLEO routine are entirely cosmetic.

       implicit none

#include "const.inc"

      DFLOAT v(5,5)
      DFLOAT d(5,5),dsq
      integer i,j,n
      
      check_cov = .true.

      do i=1,5

         do j=1,i-1
            d(j,i)=v(i,j)
           
            do n=1,j-1
               d(j,i)=d(j,i)-d(n,i)*d(n,j)
            enddo

            d(j,i)=d(j,i)/d(j,j)
         enddo

         dsq=v(i,i)

         do n=1,i-1
           dsq=dsq-d(n,i)**2
         enddo

         if (dsq.le.0.0D0) then
           check_cov = .false.
           return
         endif

         d(i,i)=sqrt(dsq)
       enddo

       end
c
c $Id$
c
c $Log$
c Revision 1.1  2000/06/19 19:59:42  eugenio
c Initial revision
c
c Revision 1.3  1998/04/27 19:00:42  kutschke
c Fix archaic do loops.
c
c Revision 1.2  1998/04/27  02:16:56  kutschke
c New file.
c
c
