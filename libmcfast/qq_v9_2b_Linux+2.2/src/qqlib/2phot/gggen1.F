*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:33  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:35  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.03/20 12/08/91  11.33.01  by  R.A.FULTON
*CMZ :  1.03/15 25/04/91  18.09.48  by  R.A.FULTON
*-- Author :   R.A.FULTON
      SUBROUTINE GGGEN1
C*******************************************************************
#include "qqlib/gggseq/ggconst.inc"
#include "qqlib/gggseq/ggmodl.inc"
#include "qqlib/gggseq/ggprms.inc"
#include "qqlib/gggseq/ggcombo.inc"
#include "qqlib/gggseq/sintag.inc"
#include "qqlib/gggseq/wgtsum.inc"
#include "qqlib/gggseq/fragmt.inc"
#include "qqlib/gggseq/ggcos.inc"
#include "geant/gcdes/ludat1.inc"
#include "qqlib/seq/ludat2.inc"
#include "geant/gcdes/ludat3.inc"
#include "qqlib/gggseq/genarg.inc"
      INTEGER     ICALL, I, KINT

      REAL        QTOTS, EMM, SINV, PHI1, XX, DUM
      REAL        ECHR, ENEU, RENER, SPROB, SCORR
      REAL        CMSSQ, QPROD, RWHT, RMAX, RWGT, RHWL, ZZZ
      REAL        GCM4V(4), Q14V(4), Q24V(4)

      DOUBLE PRECISION W1,CMP,CMBET,CMBSQ,CMCOS,CMCSQ,
     +A2,B2,C2,CMAXSQ,D,DPAIR,DRAN,DROOT2,WGTMAX,WGT

      DOUBLE PRECISION WGT1,WGT2,WGT3,WGT4,WGT5,WGT6,WGT7,WGTT,
     +H1,H2,H1H1,H1H2,H2H2,
     +EFAC,QRKS,PQ1,PQ2,P1Q1,P1Q2,P2Q1,P2Q2,Q1Q2,PTPT,
     +QQ1,QQ2,P1E0,P2E0,Q2E0

      DOUBLE PRECISION A3, B3, C3, TERM1, TERM2, RATIO, DRAN2
      REAL      COSDIF

C..EXTERNAL::
      INTEGER   LUCOMP
      REAL      RANP, GGDK
      EXTERNAL  LUCOMP, RANP, GGDK

      DATA DROOT2/1.4142136D00/
      DATA ICALL/0/
C**********************************************************
 1    ICALL = ICALL + 1
C

      QTOTS=0.0
      DO 6  KINT=1,3
       GCM4V(KINT) = G14V(KINT) + G24V(KINT)
       QTOTS = QTOTS + GCM4V(KINT)**2
   6  CONTINUE

      GCM4V(4) = G14V(4)+G24V(4)
      EMM = GCM4V(4)**2 - QTOTS
      IF(EMM.LT.0.00000001)EMM=0.00000001
      EMM = SQRT(EMM)

      DPAIR = PAIR2G
      QRKS = DPAIR**2
  16  W1 = .5*SQRT(W2G)
      CMP = W1**2 - DPAIR**2
      IF (CMP .LE. 0.) THEN
        CMP = 0.
        ITERS = ITERS + 1
        WSUM = WSUM - WGTVAL
        WSUMSQ = WSUMSQ - WGTVAL**2
        GOTO 1
      ELSE
        CMP = DSQRT(CMP)
      ENDIF

      CMBET = CMP/W1
      CMBSQ = CMBET**2
      PQ1=G14V(1)**2+G14V(2)**2+G14V(3)**2
      PQ2=G24V(1)**2+G24V(2)**2+G24V(3)**2
      Q1Q2=G14V(4)*G24V(4)-G14V(1)*G24V(1)-G14V(2)*G24V(2)
     +-G14V(3)*G24V(3)
      QQ1=G14V(4)**2-PQ1-(XME*G14V(4)/EPB1)**2/(1.-G14V(4)/EPB1)
      QQ2=G24V(4)**2-PQ2-(XME*G24V(4)/EPB2)**2/(1.-G24V(4)/EPB2)
      IF(QQ1.GT.0.0)QQ1=-(XME*G14V(4)/EPB1)**2/(1.-G14V(4)/EPB1)
      IF(QQ2.GT.0.0)QQ2=-(XME*G24V(4)/EPB2)**2/(1.-G24V(4)/EPB2)

C this is to boost gammas to gamma-gamma cms and get invariants
      GCM4V(1)=G14V(1) + G24V(1)
      GCM4V(2)=G14V(2) + G24V(2)
      GCM4V(3)=G14V(3) + G24V(3)
      GCM4V(4)=G14V(4) + G24V(4)
C
      QPROD = GCM4V(1)*G14V(1) + GCM4V(2)*G14V(2) + GCM4V(3)*G14V(3)
      ZZZ=(GCM4V(4)*G14V(4)-QPROD)/EMM
      Q14V(4) = ZZZ
      ZZZ = (ZZZ + G14V(4))/(GCM4V(4) + EMM)
      DO 43 KINT=1,3
         Q14V(KINT)=G14V(KINT)-ZZZ*GCM4V(KINT)
 43   CONTINUE

      QPROD=GCM4V(1)*G24V(1) + GCM4V(2)*G24V(2) + GCM4V(3)*G24V(3)
      ZZZ=(GCM4V(4)*G24V(4)-QPROD)/EMM
      Q24V(4)=ZZZ
      ZZZ=(ZZZ+G24V(4))/(GCM4V(4)+EMM)
      DO 44 KINT=1,3
         Q24V(KINT)=G24V(KINT)-ZZZ*GCM4V(KINT)
 44   CONTINUE
      PQ1=SQRT(Q14V(1)**2+Q14V(2)**2+Q14V(3)**2)
      PQ2=SQRT(Q24V(1)**2+Q24V(2)**2+Q24V(3)**2)

C spin-1/2 point pair angular distribution      (eq 5.7 in bkt)
      D = 0.5*DLOG((1. + CMBET*COS2GX)/(1. - CMBET*COS2GX))
      CMAXSQ = DMAX1((1.0D00 - DROOT2*(DPAIR/W1)**2),0.0D00)
      WGTMAX = CMBSQ*(1. - CMAXSQ)*CMAXSQ+(DPAIR/W1)**2
      WGTMAX=2.*(1.-CMAXSQ*CMBSQ)+4.*CMBSQ*WGTMAX/(1.-CMAXSQ*CMBSQ)
      WGTMAX=WGTMAX*1.05
 40   DRAN=RANP(DUM)
      CMCOS=DTANH(D*DRAN)/CMBET
      IF(RANP(DUM).LE.0.5) CMCOS=-CMCOS
      CMCSQ=CMCOS**2
      CMSSQ=1.-CMCSQ
      P1Q1 = W1*Q14V(4)-CMP*PQ1*CMCOS
      P2Q1 = W1*Q14V(4)+CMP*PQ1*CMCOS
      P1Q2 = W1*Q24V(4)+CMP*PQ2*CMCOS
      P2Q2 = W1*Q24V(4)-CMP*PQ2*CMCOS
      PTPT = CMSSQ*(CMP**2)
      P1E0 = (W1*PQ1-CMP*CMCOS*Q14V(4))/DSQRT(-QQ1)
      P2E0 = (W1*PQ1+CMP*CMCOS*Q14V(4))/DSQRT(-QQ1)
      Q2E0 = (Q24V(4)*PQ1+PQ2*Q14V(4))/DSQRT(-QQ1)
      H1=-QQ1 + 2.*P1Q1
      H2=-QQ2 + 2.*P1Q2

      H1H1=H1*H1
      H1H2=H1*H2
      H2H2=H2*H2
      EFAC=(1.+CMBSQ*CMCSQ)*(W1**2)+QRKS
C
      WGT1=(2.*P1Q1*2.*P2Q1-2.*QQ1*EFAC)/H1H1
      WGT2=(2.*P1Q2*2.*P2Q2-2.*QQ2*EFAC)/H2H2
      WGT3=4.*PTPT*(
     +(2.*EFAC-Q1Q2)/H1H2
     ++(EFAC-P2Q1)/H1H1
     ++(EFAC-P2Q2)/H2H2)
C
      WGT4=( 4.*P1E0*( P1E0*(EFAC-P2Q1) + P1Q1*P2E0 ) - 2.*P1Q1*P2Q1
     ++QQ1*(EFAC-2.*P1E0*P2E0))/H1H1
C
      WGT5= (2.*PTPT*(Q1Q2 + QQ2 - EFAC - 2.*(P2E0**2) - PTPT)
     ++QQ2*(EFAC-2.*P2E0*P1E0) +4.*P2E0*P1Q2*Q2E0 -2.*P1Q2*P2Q2)/H2H2
C
      WGT6=2.*( 2.*PTPT*P1E0*(P2E0-P1E0)
     + - 2.*P1E0*(EFAC*Q2E0 + P1Q2*P2E0 - P2Q2*P1E0)
     + - PTPT*QQ1 + 2.*P2E0*(Q1Q2*P1E0-P1Q1*Q2E0)
     + + P1Q1*P2Q2 + P1Q2*P2Q1 - (EFAC+PTPT)*Q1Q2 )/H1H2
      IF(.NOT.LUMTL)WGT7 = 0.0
      IF(LUMTL)WGT7 = 2.*EPS1*(WGT4+WGT5+WGT6)
      IF(WGT7 .LT. 0.) WGT7 = 0.
      IF(ABS(WGT7)/(ABS(WGT6) + 0.001) .LT. 0.0001) WGT7 = 0.
C
      WGTT=(WGT1 + WGT2 + WGT3 + WGT7)*(1.-CMCSQ*CMBSQ)
      RWHT = WGTT
      RMAX = WGTT/WGTMAX
C     the old qsq=0 formula  eq 5.7 bkt
      WGT=CMBSQ*(1.-CMCSQ)*CMCSQ+1.-CMBSQ
      WGT=2.*(1.-CMCSQ*CMBSQ)+4.*CMBSQ*WGT/(1.-CMCSQ*CMBSQ)
      RWGT = WGTT/WGT
      RHWL = WGT/WGTMAX
C     throw away test done here now.
      DRAN=RANP(DUM)
      IF(DRAN*WGTMAX .GT. WGTT)GOTO 40

      COSDIF = CMCOS
      THPNT  = ACOS(COSDIF)
      PHIPNT = RANP(DUM)*TWOPI
C
      CALL LUPOIT
C
  500 CONTINUE
      RETURN
      END
