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
      SUBROUTINE DAMPPK(MNUM,PT,PN,PIM1,PIM2,PIM3,AMPLIT,HV)
C ----------------------------------------------------------------------
* CALCULATES DIFFERENTIAL CROSS SECTION AND POLARIMETER VECTOR
* FOR TAU DECAY INTO K K pi, K pi pi.
* ALL SPIN EFFECTS IN THE FULL DECAY CHAIN ARE TAKEN INTO ACCOUNT.
* CALCULATIONS DONE IN TAU REST FRAME WITH Z-AXIS ALONG NEUTRINO MOMENT
C MNUM DECAY MODE IDENTIFIER.
C
C     called by : DPHSAA
C ----------------------------------------------------------------------
      COMMON / PARMAS / AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
C
      REAL*4            AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
      COMMON / DECPAR / GFERMI,GV,GA,CCABIB,SCABIB,GAMEL
      REAL*4            GFERMI,GV,GA,CCABIB,SCABIB,GAMEL
      REAL  HV(4),PT(4),PN(4),PIM1(4),PIM2(4),PIM3(4)
      REAL  PAA(4),VEC1(4),VEC2(4),VEC3(4),VEC4(4),VEC5(4)
      REAL  PIVEC(4),PIAKS(4),HVM(4)
      REAL FNORM(0:7),COEF(1:5,0:7)
      COMPLEX HADCUR(4),FORM1,FORM2,FORM3,FORM4,FORM5,UROJ
      EXTERNAL FORM1,FORM2,FORM3,FORM4,FORM5
      DATA PI /3.141592653589793238462643/
      DATA ICONT /0/
C
      DATA  FPI /93.3E-3/
      IF (ICONT.EQ.0) THEN
       ICONT=1
       UROJ=CMPLX(0.0,1.0)
       DWAPI0=SQRT(2.0)
       FNORM(0)=CCABIB/FPI
       FNORM(1)=CCABIB/FPI
       FNORM(2)=CCABIB/FPI
       FNORM(3)=CCABIB/FPI
       FNORM(4)=SCABIB/FPI/DWAPI0
       FNORM(5)=SCABIB/FPI
       FNORM(6)=SCABIB/FPI
       FNORM(7)=CCABIB/FPI
C
       COEF(1,0)= 2.0*SQRT(2.)/3.0
       COEF(2,0)=-2.0*SQRT(2.)/3.0
       COEF(3,0)= 0.0
       COEF(4,0)= FPI
       COEF(5,0)= 0.0
C
       COEF(1,1)=-SQRT(2.)/3.0
       COEF(2,1)= SQRT(2.)/3.0
       COEF(3,1)= 0.0
       COEF(4,1)= FPI
       COEF(5,1)= SQRT(2.)
C
       COEF(1,2)=-SQRT(2.)/3.0
       COEF(2,2)= SQRT(2.)/3.0
       COEF(3,2)= 0.0
       COEF(4,2)= 0.0
       COEF(5,2)=-SQRT(2.)
C
       COEF(1,3)= 0.0
       COEF(2,3)=-1.0
       COEF(3,3)= 0.0
       COEF(4,3)= 0.0
       COEF(5,3)= 0.0
C
       COEF(1,4)= 1.0/SQRT(2.)/3.0
       COEF(2,4)=-1.0/SQRT(2.)/3.0
       COEF(3,4)= 0.0
       COEF(4,4)= 0.0
       COEF(5,4)= 0.0
C
       COEF(1,5)=-SQRT(2.)/3.0
       COEF(2,5)= SQRT(2.)/3.0
       COEF(3,5)= 0.0
       COEF(4,5)= 0.0
       COEF(5,5)=-SQRT(2.)
C
       COEF(1,6)= 0.0
       COEF(2,6)=-1.0
       COEF(3,6)= 0.0
       COEF(4,6)= 0.0
       COEF(5,6)=-2.0
C
       COEF(1,7)= 0.0
       COEF(2,7)= 0.0
       COEF(3,7)= 0.0
       COEF(4,7)= 0.0
       COEF(5,7)=-SQRT(2.0/3.0)
C
      ENDIF
C
      DO 10 I=1,4
   10 PAA(I)=PIM1(I)+PIM2(I)+PIM3(I)
      XMAA   =SQRT(ABS(PAA(4)**2-PAA(3)**2-PAA(2)**2-PAA(1)**2))
      XMRO1  =SQRT(ABS((PIM3(4)+PIM2(4))**2-(PIM3(1)+PIM2(1))**2
     $                -(PIM3(2)+PIM2(2))**2-(PIM3(3)+PIM2(3))**2))
      XMRO2  =SQRT(ABS((PIM3(4)+PIM1(4))**2-(PIM3(1)+PIM1(1))**2
     $                -(PIM3(2)+PIM1(2))**2-(PIM3(3)+PIM1(3))**2))
      XMRO3  =SQRT(ABS((PIM1(4)+PIM2(4))**2-(PIM1(1)+PIM2(1))**2
     $                -(PIM1(2)+PIM2(2))**2-(PIM1(3)+PIM2(3))**2))
* ELEMENTS OF HADRON CURRENT
      PROD1  =PAA(4)*(PIM2(4)-PIM3(4))-PAA(1)*(PIM2(1)-PIM3(1))
     $       -PAA(2)*(PIM2(2)-PIM3(2))-PAA(3)*(PIM2(3)-PIM3(3))
      PROD2  =PAA(4)*(PIM3(4)-PIM1(4))-PAA(1)*(PIM3(1)-PIM1(1))
     $       -PAA(2)*(PIM3(2)-PIM1(2))-PAA(3)*(PIM3(3)-PIM1(3))
      PROD3  =PAA(4)*(PIM1(4)-PIM2(4))-PAA(1)*(PIM1(1)-PIM2(1))
     $       -PAA(2)*(PIM1(2)-PIM2(2))-PAA(3)*(PIM1(3)-PIM2(3))
      DO 40 I=1,4
      VEC1(I)= PIM2(I)-PIM3(I) -PAA(I)*PROD1/XMAA**2
      VEC2(I)= PIM3(I)-PIM1(I) -PAA(I)*PROD2/XMAA**2
      VEC3(I)= PIM1(I)-PIM2(I) -PAA(I)*PROD3/XMAA**2
 40   VEC4(I)= PIM1(I)+PIM2(I)+PIM3(I)
      CALL PROD5(PIM1,PIM2,PIM3,VEC5)
* HADRON CURRENT
C be aware that sign of vec2 is opposite to sign of vec1 in a1 case
      DO 45 I=1,4
      HADCUR(I)= CMPLX(FNORM(MNUM)) * (
     $CMPLX(VEC1(I)*COEF(1,MNUM))*FORM1(MNUM,XMAA**2,XMRO1**2,XMRO2**2)+
     $CMPLX(VEC2(I)*COEF(2,MNUM))*FORM2(MNUM,XMAA**2,XMRO2**2,XMRO1**2)+
     $CMPLX(VEC3(I)*COEF(3,MNUM))*FORM3(MNUM,XMAA**2,XMRO3**2,XMRO1**2)+
     *(-1.0*UROJ)*
     $CMPLX(VEC4(I)*COEF(4,MNUM))*FORM4(MNUM,XMAA**2,XMRO1**2,
     $                                      XMRO2**2,XMRO3**2)         +
     $(-1.0)*UROJ/4.0/PI**2/FPI**2*
     $CMPLX(VEC5(I)*COEF(5,MNUM))*FORM5(MNUM,XMAA**2,XMRO1**2,XMRO2**2))
 45   CONTINUE
C
* CALCULATE PI-VECTORS: VECTOR AND AXIAL
      CALL CLVEC(HADCUR,PN,PIVEC)
      CALL CLAXI(HADCUR,PN,PIAKS)
      CALL CLNUT(HADCUR,BRAKM,HVM)
* SPIN INDEPENDENT PART OF DECAY DIFF-CROSS-SECT. IN TAU REST  FRAME
      BRAK= (GV**2+GA**2)*PT(4)*PIVEC(4) +2.*GV*GA*PT(4)*PIAKS(4)
     &     +2.*(GV**2-GA**2)*AMNUTA*AMTAU*BRAKM
      AMPLIT=(GFERMI)**2*BRAK/2.
      IF (MNUM.GE.9) THEN
        PRINT *, 'MNUM=',MNUM
        ZNAK=-1.0
        XM1=0.0
        XM2=0.0
        XM3=0.0
        DO 77 K=1,4
        IF (K.EQ.4) ZNAK=1.0
        XM1=ZNAK*PIM1(K)**2+XM1
        XM2=ZNAK*PIM2(K)**2+XM2
        XM3=ZNAK*PIM3(K)**2+XM3
 77     PRINT *, 'PIM1=',PIM1(K),'PIM2=',PIM2(K),'PIM3=',PIM3(K)
        PRINT *, 'XM1=',SQRT(XM1),'XM2=',SQRT(XM2),'XM3=',SQRT(XM3)
        PRINT *, '************************************************'
      ENDIF
C POLARIMETER VECTOR IN TAU REST FRAME
      DO 90 I=1,3
      HV(I)=-(AMTAU*((GV**2+GA**2)*PIAKS(I)+2.*GV*GA*PIVEC(I)))
     &      +(GV**2-GA**2)*AMNUTA*AMTAU*HVM(I)
C HV IS DEFINED FOR TAU-    WITH GAMMA=B+HV*POL
      HV(I)=-HV(I)/BRAK
 90   CONTINUE
      END
