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
      SUBROUTINE EVENTB
C     ****************
      IMPLICIT REAL*8(A-H,O-Z)
C     ****************************************************************
C     *  EVENT IS CENTRAL  ROUTINE FOR SIMULATION OF THE SPINLESS    *
C     *  EVENTS, IT GENERATES ALL ANGULAR VARIABLES AND THE MONENTA  *
C     *  OF TAU+ TAU- AND GAMMA (IF PRESENT).                        *
C     ****************************************************************
      COMMON / CONST / PI,ALFA,ALF1,QE2,QF2,QEF
      COMMON / UTIL  / QP(4),QM(4),PH(4)
      COMMON / UTIL2 / XK0,XKMIN,XKMAX
      COMMON / UTIL1 / XK,C1,S1,C2,S2,CF,SF,CG,SG,V
      COMMON / WEAK  / QCE,QCF,CVE,CVF,CAE,CAF,ZPROP
      COMMON / ENERG / ENE,AEL2,AMF2,AMF,ALGEL,ALGMF,BETI,BT1,ATH2
      COMMON / CONTRL/ SWT(6),ISPIN
      COMMON / SIGMA / SIG0,SIG0CM,SOFT,SOF1,F2RE,BRM,BOX
      REAL*4 RRR
      FUND(C1,S1,C2,S2)=(1.-.5*XK*(1.-C1))**2+
     +( XKT*S1*S2*CF-(1.-.5*XK)*C1*C2-.5*XK*C2 )**2
C-----
    1 CONTINUE
      R=RNF100(1)
C-----RAW  XK-DISTRIBUTION ,  CHOICE BETWEEN SOFT AND HARD EMISSION
      XK=RRGEN(R)
      IF(XK.GT.XK0) GO TO 20
C-----****************************************************************
C-----SOFT PHOTON EMISSION, FIRST THE ANGULAR DISTRIBUTION
C-----WITH ONLY C-SYMETRIC COMPONENT
   10 FIG=2.*PI*RNF100(4)
   11 XK=0.
      C1=1.-2.*RNF100(6)
      S1=SQRT((1.-C1)*(1.+C1))
      C2=1.
      S2=0.
      CF=1.
      SF=0.
      V=BT1
      WT=((2.-(S1*V)**2)*(1.+SOFT)+4.*F2RE)/(2.*(1.+SOFT))
      IF(RNF100(8).GT.WT) GO TO 11
C-----****************************************************************
C-----IMPOSING  C-ODD (INTERFERENCE,BOX ETC.) TERMS
      CALL BRMBOX
      IF(QEF.NE.0.) ZCONA=4.*ZPROP/QCE/QCF*CAE*CAF
      IF(QEF.EQ.0.) ZCONA=0.
      WT=.5*( 1. + ( ALF1*QEF*((2.-(S1*V)**2)*BRM+BOX) +C1*V*ZCONA)
     $            /((2.-(S1*V)**2)*(1.+SOFT)+4.*F2RE)   )
      IF(RNF100(9).GT.WT) GO TO 10
      GO TO 400
C-----****************************************************************
C-----   HARD PHOTON BREMSSTRAHLUNG,
C.....1  MODELING XK-DISTRIBUTION
C.....2  CHOICE BETWEEN INITIAL AND FINAL BREMSSTRAHLUNG
C.....3  GENERATING ANGULAR VARIABLES
C------------------------
C.....1111111111111111111111111111111111111111111111111111111111111111
   20 CONTINUE
      XK1=1.-XK
      XKT=SQRT(XK1)
      V=SQRT(ABS(1.-AMF2/XK1))
      EPS1=AMF2/XK1/(1.+V)
      U=1.-.5*AEL2
      EPS=.5*AEL2
      ROIT=.5*BETI*(1.+XK1*XK1)/XK/XK1
      ROFT=1.5*QF2*ALF1*(1.+XK1*XK1-2.*AMF2)/XK*ATH2
      ROI=BETI*(1.+XK1**2)/XK/XK1*V*(3.-V**2)/4.
      ROF=QF2*ALF1/XK*( (1.+XK1*XK1-AMF2*XK-.50*AMF2**2)*
     $   LOG((1.+V)**2*XK1/AMF2) -((2.+AMF2)*XK1+XK**2)*V )
      WT=(ROI+ROF)/(ROIT+ROFT)
      SWT(1)=SWT(1)+1.
      SWT(2)=SWT(2)+WT
      SWT(3)=SWT(3)+WT*WT
      IF(RNF100(2).GT.WT) GO TO 1
C.....2222222222222222222222222222222222222222222222222222222222222222
   25 CONTINUE
      IF(RNF100(3)-ROI/(ROI+ROF)) 31,1,41
C-----
C.....3333333333333333333333333333333333333333333333333333333333333333
C-----INITIAL STATE RADIATION, ANGULAR VARIABLES
C-----
   31 FIG=2.*PI*RNF100(4)
      R=RNF100(5)
      DEL1=EPS*((2.-EPS)/EPS)**R
      DEL2=2.-DEL1
      CALL RANMAR(RRR,1)
      IF(RRR.GT.0.5) GO TO 35
      A=DEL1
      DEL1=DEL2
      DEL2=A
   35 C1=1.-DEL1
      S1=SQRT((DEL1-EPS)*(DEL2-EPS))
      ZET1=1.-V+2.*V*RNF100(6)
      ZET2=2.-ZET1
      C2=1.-ZET1
      S2=SQRT((ZET1-EPS1)*(ZET2-EPS1))
      FI=2.*PI*RNF100(7)
      CF=COS(FI)
      SF=SIN(FI)
      D1=2.*FUND( C1, S1, C2, S2)+2.*AMF2/XK1*(1.-.5*XK*DEL1)**2
      D2=2.*FUND(-C1,-S1, C2, S2)+2.*AMF2/XK1*(1.-.5*XK*DEL2)**2
      WT=(D1*(1.-AEL2/XK1/DEL2)+D2*(1.-AEL2/XK1/DEL1) )
     $    /(4.*(1.+XK1*XK1))
      IF(RNF100(8).GT.WT) GO TO 31
      GO TO 200
C.....2222222222222222222222222222222222222222222222222222222222222222
C-----FINAL STATE RADIATION, ANGULAR VARIABLES
C-----
   41 FIG=2.*PI*RNF100(4)
      DEL1=EPS+2.*U*RNF100(5)
      DEL2=2.-DEL1
      C1=1.-DEL1
      S1=SQRT((DEL1-EPS)*(DEL2-EPS))
      R=RNF100(6)
      ZET1=EPS1*((2.-EPS1)/EPS1)**R
      ZET2=2.-ZET1
      CALL RANMAR(RRR,1)
      IF(RRR.GT.0.5) GO TO 45
      A=ZET1
      ZET1=ZET2
      ZET2=A
   45 C2=1.-ZET1
      S2=SQRT((ZET1-EPS1)*(ZET2-EPS1))
      FI=2.*PI*RNF100(7)
      CF=COS(FI)
      SF=SIN(FI)
      D1=2.*FUND(-C2,-S2,-C1,-S1)+2.*AMF2
      D2=2.*FUND( C2, S2,-C1,-S1)+2.*AMF2
      D3=AMF2*XK*XK*(1.+C1*C1)-8.*AMF2*XK
      WT=(D1*(1.-AMF2/ZET2)+D2*(1.-AMF2/ZET1)+D3)
     $   /(4.*(1.+XK1*XK1)-2.*AMF2)
      IF(RNF100(8).GT.WT) GO TO 41
C-----****************************************************************
C-----INTRODUCING INTERFRRENCE TERMS IN GENERATED ANGULAR DISTRIBU-
C-----TIONS FOR HARD BREMSSTRAHLUNG EVENTS.
  200 CONTINUE
      WT=.5*WINTH(DUM)
      IF(RNF100(9).GT.WT) GO TO 25
C-----UNTIL THIS POINT VARIABLES C2 AND S2 WERE MULTIPLIED BY V.
      C2=C2/V
      S2=S2/V
C-----
C-----CONSTRUCTION MOMENTA OUT OF ANGULAR VARIABLES USING TRALOR
  400 CONTINUE
      CG=COS(FIG)
      SG=SIN(FIG)
      DO 420 I=1,3
      QP(I)=0.
  420 QM(I)=0.
      QP(4)=AMF
      CALL TRALOR(1,QP)
      QM(4)=AMF
      CALL TRALOR(2,QM)
      DO 430 I=1,4
  430 PH(I)=-QP(I)-QM(I)
      PH(4)=2.+PH(4)
      IF(XK.EQ.0.) PH(4)=0.
C
      RETURN
      END
