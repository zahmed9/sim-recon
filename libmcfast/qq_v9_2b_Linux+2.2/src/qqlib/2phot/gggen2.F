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
*CMZ :  1.03/20 12/08/91  11.33.42  by  R.A.FULTON
*CMZ :  1.03/15 11/04/91  03.27.28  by  R.A.FULTON
*-- Author :   R.A.FULTON
      SUBROUTINE GGGEN2
C*******************************************************************
#include "qqlib/gggseq/ggconst.inc"
#include "qqlib/gggseq/ggmodl.inc"
#include "qqlib/gggseq/ggprms.inc"
#include "qqlib/gggseq/wgtsum.inc"
#include "qqlib/gggseq/genarg.inc"

      INTEGER     I
      REAL        DUM, CMSSQ, GCM4V(4), Q14V(4), Q24V(4)
      REAL        COSDIF

      DOUBLE PRECISION W1, CMP, CMBET, CMBSQ, CMCOS, CMCSQ,
     + DPAIR, WGT, QRKS, PQ1, PQ2, Q1Q2, QQ1, QQ2

C..EXTERNAL::
      INTEGER   LUCOMP
      REAL      RANP, GGDK
      EXTERNAL  LUCOMP, RANP, GGDK
C**********************************************************
 1    DPAIR=PAIR2G
      QRKS=DPAIR**2
  16  W1 = .5*SQRT(W2G)
      CMP = W1**2 - DPAIR**2
      IF (CMP .LE. 0.) THEN
        CMP = 0.
        ITERS = ITERS + 1
        WSUM = WSUM - WGTVAL
        WSUMSQ = WSUMSQ - WGTVAL**2
        GOTO 1
      ENDIF
      IF (CMP .GT. 0.) CMP = DSQRT(CMP)
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

C MODEL 2: Spin-0 meson angular distribution in the born approximation
C ...eq 5.8 of bkt
 50   CONTINUE
      CMCOS = (2.0*RANP(DUM) - 1.0)*COS2GX
      CMCSQ = CMCOS**2
      CMSSQ = 1. - CMCSQ
      WGT = CMSSQ/((1. - CMBSQ*CMCSQ)**2)
      WGT = 1. - 2.*(1. - CMBSQ)*CMBSQ*WGT
      IF(RANP(DUM).GE.WGT)GOTO 50
C     need to transform to the laboratory and make 4-vectors
 60   CONTINUE
      COSDIF = CMCOS
      THPNT  = ACOS(COSDIF)
      PHIPNT = RANP(DUM)*TWOPI

C     convert point production output to lund format
        CALL LUPOIT

  500 CONTINUE
      RETURN
      END
