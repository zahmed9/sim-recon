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
*CMZ :  1.04/00 14/08/90  14.54.21  by  Paul Avery
*-- Author :
      SUBROUTINE RBOOSB(T, N, PO, PN)
C
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C     Boost the 4-vectors PO(4,1-N) to PN(4,1-N). PO and PN can be the same
C     vectors.
C
C  T(4)    Defines the boost, i.e., boost is done assuming that T must be
C          be boosted from its current value to its rest frame value.
C
C  N       Number of 4-vectors in PO to be boosted
C
C  PO(4,N) 4-vectors before boost
C
C  PN(4,N) 4-vectors after boost
C
C   Note: Mass of T must be > 0.
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
C
C     Calling arguments
      INTEGER N
      REAL T(4), PO(4,*), PN(4,*)

C     Local variables
      INTEGER J, L
      REAL ETA(4), M, GAM1, EDOTP, TEMP
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C
      IF(N .LE. 0) GOTO 1000

      M = T(4)**2 - T(1)**2 - T(2)**2 - T(3)**2
      IF(M .LE. 0) GOTO 1000
      M = SQRT(M)

C     Calculate auxiliary 4-vector to save time
      DO 5 L=1,3
        ETA(L) = -T(L) / M
5     CONTINUE
      ETA(4) = T(4) / M

      GAM1 = ETA(4) + 1.

      DO 20 J=1,N
        EDOTP = ETA(1)*PO(1,J) + ETA(2)*PO(2,J) + ETA(3)*PO(3,J) +
     *          ETA(4)*PO(4,J)
        TEMP = (EDOTP + PO(4,J)) / GAM1
        PN(4,J) = EDOTP
        DO 10 L=1,3
          PN(L,J) = PO(L,J) + ETA(L)*TEMP
10      CONTINUE
20    CONTINUE

C     Only exit
1000  RETURN
      END
