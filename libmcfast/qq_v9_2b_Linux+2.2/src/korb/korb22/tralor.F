*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:28  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:02  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/04 17/05/93  22.58.35  by  Alan Weinstein
* Bug fix from authors, affecting spin correlations
*CMZ :  2.00/00 21/01/93  15.42.13  by  Alan Weinstein
*-- Author :
      SUBROUTINE TRALOR(KTO,VEC)
C     **************************
      IMPLICIT REAL*8(A-H,O-Z)
C
C     ******************************************************************
C     *   TRALOR TRANSFORMES FOUR-VECTOR VEC FROM TAU REST SYSTEM      *
C     *   TO LAB SYSTEM. RECOMMENDED TO USE  FOR DECAY PRODUCTS.       *
C     *   KTO=1,2 DENOTES TAU+ AND TAU- CORRESPONDINGLY                *
C     ******************************************************************
C
      COMMON / UTIL1 / XK,C1,S1,C2,S2,CF,SF,CG,SG,V
      COMMON / UTIL2 / XK0,XKMIN,XKMAX
      COMMON / ENERG / ENE,AEL2,AMF2,AMF,ALGEL,ALGMF,BETI,BT1,ATH2
      DIMENSION VEC(4),VEC1(4),TL(4,4)
C IBLAD=1 makes program as with the error which was removed april/may 93.
C IBLAD=0 is the right choice.
      DATA IBLAD / 0/
C
      Y=SQRT(1.-XK)
      A=Y/AMF
      B=SQRT((A-1.)*(A+1.))
      IF(KTO.EQ.2) B=-B
      BB=.5*XK/Y
      GB=(1.-.5*XK)/Y
C
      IF (XK.GT.0.2*XK0) THEN
        H1= C1*S2*CF+GB*S1*C2
        H2=-S1*S2*CF+GB*C1*C2
        TL(1,1)= CF
        TL(1,2)=-C2*SF
        TL(1,3)=-A*S2*SF
        TL(1,4)=-B*S2*SF
        TL(2,1)= C1*SF
        TL(2,2)= C1*C2*CF-GB*S1*S2
        TL(2,3)=-B*BB*S1+A*H1
        TL(2,4)=-A*BB*S1+B*H1
        TL(3,1)=-S1*SF
        TL(3,2)=-S1*C2*CF-GB*C1*S2
        TL(3,3)=-B*BB*C1+A*H2
        TL(3,4)=-A*BB*C1+B*H2
        TL(4,1)= 0.
        TL(4,2)= BB*S2
        TL(4,3)= B*GB-A*BB*C2
        TL(4,4)= A*GB-B*BB*C2
      ELSE
        H1=-S1
        IF (IBLAD.EQ.1) H1=S1
        H2= C1
        TL(1,1)= 1.0
        TL(1,2)= 0.0
        TL(1,3)= 0.0
        TL(1,4)= 0.0
        TL(2,1)= 0.0
        TL(2,2)= H2
        TL(2,3)= A*H1
        TL(2,4)= B*H1
        TL(3,1)= 0.0
        TL(3,2)=-H1
        TL(3,3)= A*H2
        TL(3,4)= B*H2
        TL(4,1)= 0.
        TL(4,2)= 0.
        TL(4,3)= B
        TL(4,4)= A
      ENDIF
C
      DO 100 I=1,4
  100 VEC1(I)=VEC(I)
      DO 110 I=1,4
      SUM=0.
      DO 105 J=1,4
  105 SUM=SUM+TL(I,J)*VEC1(J)
  110 VEC(I)=SUM
C     ROTATION ARROUND THE BEAM
      A=VEC(1)
      VEC(1)=CG*A-SG*VEC(2)
      VEC(2)=SG*A+CG*VEC(2)
C
      RETURN
      END
