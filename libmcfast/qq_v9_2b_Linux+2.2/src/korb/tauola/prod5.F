*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:31  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:04  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/00 21/01/93  15.42.35  by  Alan Weinstein
*-- Author :
      SUBROUTINE PROD5(P1,P2,P3,PIA)
C ----------------------------------------------------------------------
C external product of P1, P2, P3 4-momenta.
C SIGN is chosen +/- for decay of TAU +/- respectively
C     called by : DAMPAA, CLNUT
C ----------------------------------------------------------------------
      COMMON / JAKI   /  JAK1,JAK2,JAKP,JAKM,KTOM
      COMMON / IDFC  / IDFF
      REAL PIA(4),P1(4),P2(4),P3(4)
      DET2(I,J)=P1(I)*P2(J)-P2(I)*P1(J)
* -----------------------------------
      IF     (KTOM.EQ.1.OR.KTOM.EQ.-1) THEN
        SIGN= IDFF/ABS(IDFF)
      ELSEIF (KTOM.EQ.2) THEN
        SIGN=-IDFF/ABS(IDFF)
      ELSE
        PRINT *, 'STOP IN PROD5: KTOM=',KTOM
        STOP
      ENDIF
C
C EPSILON( p1(1), p2(2), p3(3), (4) ) = 1
C
      PIA(1)= -P3(3)*DET2(2,4)+P3(4)*DET2(2,3)+P3(2)*DET2(3,4)
      PIA(2)= -P3(4)*DET2(1,3)+P3(3)*DET2(1,4)-P3(1)*DET2(3,4)
      PIA(3)=  P3(4)*DET2(1,2)-P3(2)*DET2(1,4)+P3(1)*DET2(2,4)
      PIA(4)=  P3(3)*DET2(1,2)-P3(2)*DET2(1,3)+P3(1)*DET2(2,3)
C ALL FOUR INDICES ARE UP SO  PIA(3) AND PIA(4) HAVE SAME SIGN
      DO 20 I=1,4
  20  PIA(I)=PIA(I)*SIGN
      END
