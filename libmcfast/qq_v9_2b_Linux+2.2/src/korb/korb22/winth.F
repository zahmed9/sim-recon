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
*CMZ :  2.00/00 21/01/93  15.42.13  by  Alan Weinstein
*-- Author :
      FUNCTION WINTH(DUM)
C     *******************
      IMPLICIT REAL*8(A-H,O-Z)
C     ****************************************************************
C     * HERE THE CONTRIBUTION FROM THE INTERFERENCE OF THE INITIAL   *
C     * AND FINAL STATE BREMSSTRAHLUNG IS CALCULATED FOR USE IN      *
C     * SUBROUTINE EVENT  ( HARD BREMSSTARHLUNG ONLY)                *
C     ****************************************************************
C
      COMMON / CONST / PI,ALFA,ALF1,QE2,QF2,QEF
      COMMON / UTIL1 / XK,C1,S1,C2,S2,CF,SF,CG,SG,V
      COMMON / UTIL2 / XK0,XKMIN,XKMAX
      COMMON / ENERG / ENE,AEL2,AMF2,AMF,ALGEL,ALGMF,BETI,BT1,ATH2
      EQUIVALENCE (AMF2,AM),(AEL2,AL)
C
      Z1=SQRT(1.-XK)*S1*S2*CF-(1.-.5*XK)*C1*C2
      Z2=1.-.5*XK
      T = Z1+Z2+.5*XK*( C1-C2)
      U1=-Z1+Z2+.5*XK*(-C1-C2)
      U =-Z1+Z2+.5*XK*( C1+C2)
      T1= Z1+Z2+.5*XK*(-C1+C2)
      TT=T*T
      UU=U*U
      TT1=T1*T1
      UU1=U1*U1
      SS=2.
      SP=2.*(1.-XK)
      X1=XK*(1.-C1)
      X2=XK*(1.+C1)
      IF(C1.GT.0.9) X1=XK*(AEL2+S1**2)/(1.+C1)
      IF(C1.LT.-.9) X2=XK*(AEL2+S1**2)/(1.-C1)
      Y1=XK*(1.-C2)
      Y2=XK*(1.+C2)
      AINI=(TT+UU+AM/SP*(T+U)**2)*(1.-AL/SP*X1/X2)
     $   +(TT1+UU1+AM/SP*(T1+U1)**2)*(1.-AL/SP*X2/X1)
      AINI=AINI*QE2/(SP*X1*X2)
      AFIN=(TT+UU1+AM*SS)*(1.-AM*(Y1+Y2)/Y2/SS)
     $    +(UU+TT1+AM*SS)*(1.-AM*(Y1+Y2)/Y1/SS)
     $    +AM*(X1*X1+X2*X2)/SS-4.*AM*(SS-SP)
      AFIN=AFIN*QF2/(SS*Y1*Y2)
      ANTR=(TT+TT1+UU+UU1+AM*SS+AM*SP)
     $     *(T*X2*Y2+T1*X1*Y1-U*X2*Y1-U1*X1*Y2)
     $      +AM*X1*X2*((SS-SP)*(T+T1-U-U1)-(X1-X2)*(Y1-Y2))
      ANTR=ANTR*QEF/(SS*SP*X1*X2*Y1*Y2)
      WINTH=1.+ANTR/(AINI+AFIN)
      RETURN
      END
