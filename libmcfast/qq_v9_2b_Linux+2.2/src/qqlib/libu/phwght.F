*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:38  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:28  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.01/00 10/09/90  17.18.16  by  Paul Avery
*CMZ :  1.00/00 23/08/90  15.50.56  by  Paul Avery
*-- Author :
      SUBROUTINE PHWGHT(N, W, XM1, WT, WTMAX, ISET)

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C   This routine returns the weight generated for an N particle event
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C     External declarations
      REAL RANP
      EXTERNAL RANP

C     Calling arguments
      INTEGER N, ISET
      REAL W, XM1(*), WT, WTMAX

C    Local variable
      REAL XM2(20), XMS(20), QQ(20), Q(20), RR(20), M1, M2, R2
      REAL FACT, X, WW
      INTEGER I, J, JJ, N1, ICHANG, IFLAG, JMX
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      IFLAG = 1

C     Generate mass table
      DO 20 J=1,N
        XM2(J) = XM1(J)**2
        XMS(J) = 0.
        DO 10 JJ=1,J
          XMS(J) = XMS(J)+XM1(JJ)
10      CONTINUE
20    CONTINUE

C     Compute cm energy
      IF(W .LT. XMS(N)) GOTO 1000
      WW = W**2

C     Generate 2 particle submasses according to weight 2*PQ/MQ
      N1 = N-1
40    CONTINUE

C     Generate random numbers to set submasses
      DO 45 I=2,N1
        RR(I) = RANP(0)
45    CONTINUE
      IF(N-4) 90,70,80

C   N = 4  arrange numbers in ascending order
70    IF(RR(2) .LT. RR(3))GOTO90
      X = RR(2)
      RR(2) = RR(3)
      RR(3) = X
      GOTO90

C   N > 4  arrange numbers in ascending order
80    DO 88 I=2,N1
        ICHANG = 0
        JMX = N1+1-I
        DO 85 J=2,JMX
          IF(RR(J) .LT. RR(J+1)) GOTO 85
          X = RR(J)
          RR(J) = RR(J+1)
          RR(J+1) = X
          ICHANG = 1
85      CONTINUE
        IF(ICHANG .EQ. 0) GOTO 90
88    CONTINUE
90    QQ(1) = XM2(1)
      Q(1) = XM1(1)

49    WT = 1.
      R2 = RANP(0)**2 * WTMAX**2
      FACT = W - XMS(N)

      DO 50 J=2,N1
        Q(J) = RR(J)*FACT+XMS(J)
        QQ(J) = Q(J)**2
        WT = WT*((QQ(J)+QQ(J-1)-XM2(J))**2/QQ(J)**2 -
     *       4.*QQ(J-1)/QQ(J))
        IF(ISET .EQ. 0)GOTO50
        IF(R2 .GT. WT)GOTO40
50    CONTINUE
      WT = WT*((WW+QQ(N1)-XM2(N))**2/WW**2 - 4.*QQ(N1)/WW)
      IF(ISET .EQ. 0) GOTO 1000
      IF(R2 .GT. WT) GOTO 40

C     Only exit
1000  CONTINUE
      RETURN
      END
