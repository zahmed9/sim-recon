*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:42  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:30  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.03/47 03/09/92  11.54.56  by  Peter C Kim
*CMZ :  1.03/00 29/03/91  14.07.52  by  Peter C Kim
*CMZ :  1.02/00 11/02/91  15.14.50  by  Peter C Kim
*-- Author :    Peter C Kim   11/02/91
      DOUBLE PRECISION FUNCTION QQDCS(Y)
C====================================================================
C
C Function subroutine to calculate the "differential cross section"
C that is to be integrated by ICS program.  Also allows
C the choice of a positive or negative final state lepton.
C Further additions include multiplicative factors for the form
C factors (at the f,g,ap, level not alpha,bpp,gamma level) as well
C as the ability to vary KAPA in each of the form factors seperatly for
C the 1(3S1) final state.
C
C  Flag convention is
C  flag     0      1      2     3       4      5     6       7
C  state  1(1So) 1(3Po) 1(3S1) 1(3P2) 1(3P1) 1(1P1) 2(1S0) 2(3S1)
C
C  Called    : SEMIL1
C  Author    : Marina Artuso
C
C===================================================================


C-- Common variables  (shared with subroutine SEMIL1)

      LOGICAL LTRAN,LLONG
      COMMON /POL/ LTRAN,LLONG

      INTEGER FLAG
      DOUBLE PRECISION XMM,BM,X,SHIFT,KPA
      LOGICAL TRAN
      COMMON /MASS/ SHIFT(3),KPA(3),XMM,BM,X,FLAG,TRAN

      DOUBLE PRECISION BB,BX,MB,MQ,MD,KAPA,LSIGN
      COMMON /FFT/ BB,BX,MB,MQ,MD,KAPA,LSIGN

C-- Local variables

      DOUBLE PRECISION Y,G,YMAX,FORM
      DOUBLE PRECISION MBOT,MX,MS,BBX,TM,T,MSQ
      DOUBLE PRECISION MUP,MUM,FEX,H1,H2,Z,F,AP,C,PX,FSQ,GSQ,APSQ
      DOUBLE PRECISION ALPHA,BPP,GAMMA,BMSQ,XMSQ,MRSQ,H,K,BP,Q
      DOUBLE PRECISION L,KSQ,CP,BR,R,SP,W,FEX5,S,V,BRX
      DOUBLE PRECISION F1,F2,F3,H3,TDCS,FEXC

C                               Common variable used for testing parameters
      COMMON /PHASE/ TDCS

*
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'QQDCS' )
*

       MBOT=MB+MD
       MX=MD+MQ
       MS=MBOT-MX
       BMSQ=BM**2
       XMSQ=XMM**2
       BBX=(BB**2 + BX**2)/2.D0
       BRX=(BX**2)/BBX
       MSQ=(MD**2)/(MX*MBOT)
       MUP=(MB*MQ)/(MB+MQ)
       MUM=(MB*MQ)/(MB-MQ)
       KSQ=KAPA**2
       MRSQ=BMSQ/XMSQ
       BR=(BB**2)/BBX
       W=MRSQ*(1.D0-Y)-1.D0
       PX=((BMSQ*(1.D0-Y)+XMSQ)**2)/(4.D0*BMSQ)-XMSQ
       TM=(BM-XMM)**2
       T=TM-Y*(BM**2)
       FEX=DSQRT(MX/MBOT)*DEXP(-MSQ*T/(4.D0*(KAPA**2)*BBX))

C                                                          1(1S0) CASE
       IF(FLAG.EQ.0)THEN
         FEX=SHIFT(1)*FEX*((BB*BX/BBX)**(1.5D0))
         FORM=FEX*(1.D0 + (MB/(2.D0*MUM)) -
     *        MB*MQ*MD*BR/(4.D0*MUP*MUM*MX))
         F1=FORM
         BPP=FORM**2
         ALPHA=0.D0
         GAMMA=0.D0

C                                                          1(3P0) CASE
       ELSE IF(FLAG.EQ.1)THEN

         FEX=FEX*((BB*BX/BBX)**(2.5D0))
         FORM=SHIFT(1)*FEX*(MD*MQ*MB/(BB*MX*MUM))/(DSQRT(6.D0))
         F1=FORM
         F2=0.D0
         F3=0.D0
         BPP=FORM**2
         ALPHA=0.D0
         GAMMA=0.D0

C                                                         1(3S1) CASE
       ELSE IF(FLAG.EQ.2)THEN

        FEXC=DSQRT(MX/MBOT)*((BB*BX/BBX)**(1.5D0))
        FEX=FEXC*DEXP(-MSQ*T/(4.D0*(KPA(1)**2)*BBX))
        F=SHIFT(1)*2.D0*MBOT*FEX
         F1=F
        FEX=FEXC*DEXP(-MSQ*T/(4.D0*(KPA(2)**2)*BBX))
         G=SHIFT(2)*0.5D0*FEX*((1.D0/MQ)-(MD*BR)/(2.D0*MUM*MX))
         F2=G
        FEX=FEXC*DEXP(-MSQ*T/(4.D0*(KPA(3)**2)*BBX))
         AP=SHIFT(3)*(-FEX/(2.D0*MX))*((MBOT/MB)-(MD*BRX/MB)
     *      -((MD**2)*(BRX**2)/(4.D0*MUM*MBOT)))
         F3=AP

         FSQ=F**2
         GSQ=G**2
         APSQ=AP**2

         ALPHA=FSQ+4.D0*BMSQ*PX*GSQ
         BPP=FSQ/(4.D0*XMSQ)-BMSQ*Y*GSQ+0.5D0*W*F*AP +
     *          BMSQ*PX*APSQ/XMSQ
         GAMMA=2.D0*G*F

C                                                        1(3P2) CASE
       ELSE IF(FLAG.EQ.3)THEN

         FEX=FEX*((BB*BX/BBX)**(2.5D0))
         H=SHIFT(1)*FEX*MD*((1.D0/MQ)-(MD*BR/(2.D0*MX*MUM)))/(2.D0*
     *      DSQRT(2.D0)*MBOT*BB)
         F1=H
         K=SHIFT(2)*DSQRT(2.D0)*FEX*MD/BB
         F2=K
         BP=SHIFT(3)*(-FEX*MD/(2.D0*DSQRT(2.D0)*MX*MB*BB))*(1.D0-(MD*MB*
     *       BRX/(2.D0*MBOT))*(1.D0/MUP - (0.5D0/MUM)*(1.D0 -
     *       MD*BRX/(2.D0*MBOT))))
         F3=BP

         ALPHA=0.5D0*MRSQ*PX*(K**2 + 4.D0*BMSQ*PX*(H**2))
         BPP=MRSQ*PX*(-0.5D0*Y*BMSQ*(H**2) + (2.D0/3.D0)*MRSQ*
     *        PX*(BP**2) + (1.D0/3.D0)*W*K*BP) + (MRSQ/24.D0)*
     *        (Y + 4.D0*(PX/XMSQ))*(K**2)
         GAMMA=MRSQ*PX*K*H

C                                                   1(3P1) CASE
       ELSE IF(FLAG.EQ.4)THEN

         FEX=FEX*((BB*BX/BBX)**(2.5D0))
         Q=0.5D0*FEX*MD/(MX*BB)
         L=-FEX*MBOT*BB*((1.D0/MUM) + 0.5D0*(MD/(MBOT*KSQ*
     *       (BB**2)))*T*((1.D0/MQ) - MD*BR/(2.D0*MUM*MX)))
         CP=FEX*(MD*MB/(4.D0*BB*MBOT))*((1.D0/MUM) - (MD*
     *       MQ/(2.D0*MX*(MUM**2)))*BR)

         ALPHA=L**2 + 4.D0*BMSQ*PX*(Q**2)
         GAMMA=2.D0*Q*L
         BPP=(L**2)/(4.D0*XMSQ) - BMSQ*Y*(Q**2) + 0.5D0*W*
     *         L*CP + MRSQ*PX*(CP**2)

C                                                       1(1P1) CASE
       ELSE IF(FLAG.EQ.5)THEN

         FEX=FEX*((BB*BX/BBX)**(2.5D0))
         R=SHIFT(1)*FEX*MBOT*BB/(DSQRT(2.D0)*MUP)
         F1=R
         SP=FEX*(MD/(DSQRT(2.D0)*BB*MBOT))*(1.D0 + MB/(2.D0*MUM) -
     *       MB*MQ*MD*BR/(4.D0*MUM*MUP*MX))*SHIFT(3)
         F3=SP
         V=SHIFT(2)*FEX*MBOT*BB/(4.D0*DSQRT(2.D0)*MB*MQ*MX)
         F2=V

         ALPHA=R**2 + 4.D0*BMSQ*PX*(V**2)
         GAMMA=2.D0*R*V
         BPP=(R**2)/(4.D0*XMSQ) + 0.5D0*W*R*SP + MRSQ*PX*(SP**2)
     *        -BMSQ*Y*(V**2)

C                                                       2(1S0) CASE
       ELSE IF(FLAG.EQ.6)THEN

         FEX=FEX*DSQRT(3.D0/8.D0)*(MB/MUP)*((BB*BX/BBX)**(1.5D0))
         FORM=FEX*(((BB**2 - BX**2)/(2.D0*BBX)) + MQ*(MD/(3.D0*
     *         MUM*MX))*BR*(7.D0*(BX**2)-3.D0*(BB**2))/(4.D0*BBX) +
     *         MSQ*((BX**2)/BBX)*(T/(6.D0*KSQ*BBX))*(1.D0 - MQ*MD*
     *         (BR/(2.D0*MUM*MX))))

         ALPHA=0.D0
         GAMMA=0.D0
         BPP=FORM**2

C                                                       2(3S1) CASE
       ELSE IF(FLAG.EQ.7)THEN

         FEX5=FEX*((BB*BX/BBX)**(2.5D0))
         FEX=FEX*((BB*BX/BBX)**(1.5D0))
         L=(BB**2 - BX**2)/(2.D0*BBX) + MSQ*(BX**2)*T/(6.D0*
     *       BBX*KSQ*BBX)
         F=FEX*(DSQRT(6.D0))*MBOT*L
         G=FEX*(DSQRT(3.D0/8.D0))*(L*((1.D0/MQ) - MD*BR/(2.D0*
     *       MUM*MX)) + MD*(BX**2)*BR/(3.D0*MUM*MX*BBX))
         S=MSQ*BRX*T/(KSQ*(BB**2))
         AP=(FEX5/(DSQRT(6.D0)*MX))*((3.D0*MBOT*BBX/(2.D0*MB*BB*BX))*
     *      (1.D0 - (MD**2)*MB*(BRX**2)/(4.D0*(MBOT**2)*MUM)) -
     *      3.D0*MD*BX/(2.D0*MB*BB) + (5.D0*MD*BB*BX/(2.D0*MB*BBX))*
     *      (1.D0 + S/(10.D0)) - (3.D0*MBOT*BB/(2.D0*MB*BX))*(1.D0 +
     *      S/(6.D0)) + (7.D0*(MD**2)*BB*(BRX**2)/(8.D0*MBOT*MUM*BX))*
     *      (1.D0 + S/(14.D0)))

         FSQ=F**2
         GSQ=G**2
         APSQ=AP**2

         ALPHA=FSQ+4.D0*BMSQ*PX*GSQ
         BPP=FSQ/(4.D0*XMSQ)-BMSQ*Y*GSQ+0.5D0*((BMSQ/XMSQ)*(1.D0-Y)
     *        -1.D0)*F*AP + BMSQ*PX*APSQ/XMSQ
         GAMMA=2.D0*G*F

       ELSE

         STOP 'FLAG NOT IN WORKING RANGE'
       ENDIF

      Z=1.D0-(XMM/BM)**2 +Y
      H1=2.D0*X*(Z-2.D0*X) -Y
      H2=LSIGN*Y*(Z-4.D0*X)
      H3=Z*Z -4.D0*Y
C                             IF H3=0, THEN H1/H3 GOES TO ZERO
        IF(H3.EQ.0.D0)THEN
          H3=1.D0
          H1=0.D0
        ENDIF
        TDCS=(ALPHA*Y/BMSQ)*(1.D0 -2.D0*(H1/H3)) + GAMMA*H2

      IF(LTRAN)THEN
        QQDCS=TDCS
      ELSE
        QQDCS=ALPHA*Y/(BMSQ) + BPP*H1*2.D0 + GAMMA*H2
      ENDIF
      IF(LLONG)QQDCS=QQDCS-TDCS
      RETURN
      END
