*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:39  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:38  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 14/08/90  15.07.02  by  Paul Avery
*-- Author :
      SUBROUTINE R4ROTA(A, B, G, N, PO, PN)
C
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C     Rotate the 4-vectors in PO by Euler angles A, B, G and put the answers
C     in PN. PO and PN can be the same vectors.
C
C  A,B,G   Euler angles defining the rotation.
C
C  N       Number of 4-vectors in PO to be rotated
C
C  PO(4,N) 4-vectors before rotation
C
C  PN(4,N) 4-vectors after rotation
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
C
C     Calling arguments
      INTEGER N
      REAL A, B, G, PO(4,*), PN(4,*)

C     Local variables
      INTEGER I, J
      REAL R(3,3), P(3), COSA, SINA, COSB, SINB, COSG, SING
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C
      IF(N .LE. 0) GOTO 1000

C     Save time by calculating auxiliary variables
      COSA = COS(A)
      COSB = COS(B)
      COSG = COS(G)
      SINA = SIN(A)
      SINB = SIN(B)
      SING = SIN(G)

C     Compute rotation matrix
      R(1,1) = COSG*COSB*COSA - SING*SINA
      R(2,1) = -SING*COSB*COSA - COSG*SINA
      R(3,1) = SINB*COSA
      R(1,2) = COSG*COSB*SINA + SING*COSA
      R(2,2) = -SING*COSB*SINA + COSG*COSA
      R(3,2) = SINB*SINA
      R(1,3) = -COSG*SINB
      R(2,3) = SING*SINB
      R(3,3) = COSB

C     Do the rotation
      DO 300 I=1,N
        DO 100 J=1,3
          P(J) = R(1,J)*PO(1,I) + R(2,J)*PO(2,I) + R(3,J)*PO(3,I)
100     CONTINUE
        PN(4,I) = PO(4,I)
        DO 200 J=1,3
          PN(J,I) = P(J)
200     CONTINUE
300   CONTINUE

C     Only exit
1000  RETURN
      END
