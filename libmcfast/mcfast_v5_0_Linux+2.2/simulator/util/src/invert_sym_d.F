      function invert_sym_d(a,d)
c
c Invert a symmetric 5x5 double precision matrix.
c
c Taken from CLEO Kalman filter code:
c
c Original header:
c
C     Code created by 
C
C     Robert Kutschke : kutschke@lns598.lns.cornell.edu
C     Anders Ryd      : ryd@charm.physics.ucsb.edu
C
C     Created : Sept 1994 -- June 1995
C     Title   : invert_sym_d
C     Purpose : invert symmetric 5*5 matrix
c End of original header.

      implicit none

      integer invert_sym_d

#include "const.inc"

      real*8 a(5,5),d(5,5)
      real*8 b(5,5),c(5,5)
      real*8 c11inv,c22inv,c33inv,c44inv,c55inv

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      c(1,1)=a(1,1)
      c(2,1)=a(2,1)
      c(3,1)=a(3,1)
      c(4,1)=a(4,1)
      c(5,1)=a(5,1)

      if ( c(1,1) .eq. 0. ) goto 9999
      c11inv=1.0/c(1,1)

      b(1,2)=c(2,1)*c11inv
      b(1,3)=a(3,1)*c11inv
      b(1,4)=a(4,1)*c11inv
      b(1,5)=a(5,1)*c11inv


      c(2,2)=a(2,2)-c(2,1)*b(1,2)
      c(3,2)=a(3,2)-c(3,1)*b(1,2)
      c(4,2)=a(4,2)-c(4,1)*b(1,2)
      c(5,2)=a(5,2)-c(5,1)*b(1,2)

      if ( c(2,2) .eq. 0. ) goto 9999
      c22inv=1.0/c(2,2)

      b(2,3)=c(3,2)*c22inv
      b(2,4)=c(4,2)*c22inv
      b(2,5)=c(5,2)*c22inv

      c(3,3)=a(3,3)-c(3,1)*b(1,3)-c(3,2)*b(2,3)
      c(4,3)=a(4,3)-c(4,1)*b(1,3)-c(4,2)*b(2,3)
      c(5,3)=a(5,3)-c(5,1)*b(1,3)-c(5,2)*b(2,3)

      if ( c(3,3) .eq. 0. ) goto 9999
      c33inv=1.0/c(3,3)

      b(3,4)=c(4,3)*c33inv
      b(3,5)=c(5,3)*c33inv

      c(4,4)=a(4,4)-c(4,1)*b(1,4)-c(4,2)*b(2,4)-c(4,3)*b(3,4)
      c(5,4)=a(5,4)-c(5,1)*b(1,4)-c(5,2)*b(2,4)-c(5,3)*b(3,4)

      if ( c(4,4) .eq. 0. ) goto 9999
      c44inv=1.0/c(4,4)

      b(4,5)=c(5,4)*c44inv

      c(5,5)=a(5,5)-c(5,1)*b(1,5)-c(5,2)*b(2,5)-c(5,3)*b(3,5)-
     +              c(5,4)*b(4,5)

      if ( c(5,5) .eq. 0. ) goto 9999
      c55inv=1.0/c(5,5)


      d(5,5)=c55inv
      d(5,4)=-(c(5,4)*d(5,5))*c44inv
      d(5,3)=-(c(5,3)*d(5,5)+c(4,3)*d(5,4))*c33inv
      d(5,2)=-(c(5,2)*d(5,5)+c(4,2)*d(5,4)+c(3,2)*d(5,3))*c22inv
      d(5,1)=-(c(5,1)*d(5,5)+c(4,1)*d(5,4)+c(3,1)*d(5,3)+
     +                                     c(2,1)*d(5,2))*c11inv
      d(4,5)=d(5,4)
      d(3,5)=d(5,3)
      d(2,5)=d(5,2)
      d(1,5)=d(5,1)

      d(4,4)=(1.0-c(5,4)*d(4,5))*c44inv
      d(4,3)=-(c(5,3)*d(4,5)+c(4,3)*d(4,4))*c33inv
      d(4,2)=-(c(5,2)*d(4,5)+c(4,2)*d(4,4)+c(3,2)*d(4,3))*c22inv
      d(4,1)=-(c(5,1)*d(4,5)+c(4,1)*d(4,4)+c(3,1)*d(4,3)+
     +                                     c(2,1)*d(4,2))*c11inv
      d(3,4)=d(4,3)
      d(2,4)=d(4,2)
      d(1,4)=d(4,1)

      d(3,3)=(1.0-c(5,3)*d(3,5)-c(4,3)*d(3,4))*c33inv
      d(3,2)=-(c(5,2)*d(3,5)+c(4,2)*d(3,4)+c(3,2)*d(3,3))*c22inv
      d(3,1)=-(c(5,1)*d(3,5)+c(4,1)*d(3,4)+c(3,1)*d(3,3)+
     +                                     c(2,1)*d(3,2))*c11inv
      d(2,3)=d(3,2)
      d(1,3)=d(3,1)

      d(2,2)=(1.0-c(5,2)*d(2,5)-c(4,2)*d(2,4)-c(3,2)*d(2,3))*c22inv
      d(2,1)=-(c(5,1)*d(2,5)+c(4,1)*d(2,4)+c(3,1)*d(2,3)+
     +                                     c(2,1)*d(2,2))*c11inv
      d(1,2)=d(2,1)

      d(1,1)=(1.0-c(5,1)*d(1,5)-c(4,1)*d(1,4)-c(3,1)*d(1,3)-
     +                    c(2,1)*d(1,2))*c11inv

      ! Normal return
      invert_sym_d = 0
      return

      ! Error return.
 9999 call vzero(  d, 25*FLOAT_WORD )
      Print *, 'Error in invert_sym_d: '
      invert_sym_d = 1
      end
c
c$Id$
c
c$Log$
cRevision 1.1  2000/06/19 19:59:44  eugenio
cInitial revision
c
cRevision 1.2  1998/09/08 16:23:47  kutschke
cReturn completion status as function value.
c
c Revision 1.1  1998/02/13  23:08:30  kutschke
c New routine.
c
c
