*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:34  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:35  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.03/36 08/12/91  17.21.00  by  R.A.FULTON
*CMZ :  1.03/15 25/04/91  18.06.15  by  R.A.FULTON
*-- Author :
* 16/10/96 Lynn Garren: Add double precision conditionals.
        FUNCTION WGTMOD(EB1,EB2,W,OM1,OM2)
C**********************************************
C MODEL CORRECTION WEIGHTS.
C O1 IS THE PHOTON EMITTED FROM THE TAGGED ELECTRON.
C**********************************************

        REAL WGTMOD

#include "qqlib/gggseq/ggconst.inc"
#include "qqlib/gggseq/ggprms.inc"
#include "qqlib/gggseq/ggmodl.inc"
#include "qqlib/gggseq/sintag.inc"
#include "qqlib/gggseq/fragmt.inc"
#include "qqlib/gggseq/jetwgt.inc"
#include "qqlib/gggseq/ggcombo.inc"
#include "qqlib/gggseq/ggramp.inc"

C********************************************************
C  3-24-89  TCJ   PHOTON MOMENTUM IN CM

#if defined(NONCLEO_DOUBLE)
        DOUBLE PRECISION  SRHO, W2X, XBUD, DTBUD, TBUD
        DOUBLE PRECISION  XM2SQ(4), XMUS(4), SMQ
        DOUBLE PRECISION  QMAS(4), QCHRG2(4), QCHRG4(4), QTHRSH(4)
        DOUBLE PRECISION  LUMFAC, CRGFAC, DFAC, DFACS
        DOUBLE PRECISION  X1, X2, OM1, OM2, EB1, EB2
        DOUBLE PRECISION  XQ1, XS, XQ2
        DOUBLE PRECISION  QQ1, QQ2, Q1Q2
        DOUBLE PRECISION  W, WW, WX, WS, WCUT, WCUT1, RK, RKINV
        DOUBLE PRECISION  S1, SLOG
        DOUBLE PRECISION  PTMNN, ESYS, RAND
        DOUBLE PRECISION  WATE1, WATE2, WEIGHT
        DOUBLE PRECISION  TTSM, SIGTT, SIGLT, SIGTL, SIG00
        DOUBLE PRECISION  BETA, BETSQ
        DOUBLE PRECISION  ARG, E1, F1, BXS
        DOUBLE PRECISION  AQ1, BQ1, CQ1, AF1, BF1, CF1, XF1, XF2, DISC
        DOUBLE PRECISION  COR1, KESLER

        DOUBLE PRECISION  CTMP1, CTMP2, CTMP3, CTMP4, CTMP5, CTMP6
#else
        REAL      SRHO, W2X, XBUD, DTBUD, TBUD
        REAL      XM2SQ(4), XMUS(4), SMQ
        REAL      QMAS(4), QCHRG2(4), QCHRG4(4), QTHRSH(4)
        REAL      LUMFAC, CRGFAC, DFAC, DFACS
        REAL      X1, X2, OM1, OM2, EB1, EB2
        REAL      XQ1, XS, XQ2
        REAL      QQ1, QQ2, Q1Q2
        REAL      W, WW, WX, WS, WCUT, WCUT1, RK, RKINV
        REAL      S1, SLOG
        REAL      PTMNN, ESYS, RAND
        REAL      WATE1, WATE2, WEIGHT
        REAL      TTSM, SIGTT, SIGLT, SIGTL, SIG00
        REAL      BETA, BETSQ
        REAL      ARG, E1, F1, BXS
        REAL      AQ1, BQ1, CQ1, AF1, BF1, CF1, XF1, XF2, DISC
        REAL      COR1, KESLER

        REAL      CTMP1, CTMP2, CTMP3, CTMP4, CTMP5, CTMP6
#endif

C  ADDED FORM FACTOR PARAMETERS   TCJ 3-22-89
        INTEGER   I, IQ, IQACP, NBIN
        REAL      TBIN, DELR
        REAL      FF, RHOM2, PSIM2
        LOGICAL   FIRST

C*** FOR DEBUGGING PURPOSES
        LOGICAL   IPROB

        REAL      FGAM
        EXTERNAL  FGAM

#if defined(NONCLEO_DOUBLE)
        DOUBLE PRECISION     QGCM
#else
        REAL   QGCM
#endif
        COMMON /QFF/ QGCM

        DATA   SRHO/0.00071602/
        DATA   RHOM2,PSIM2 /0.593,9.591/
        DATA   QMAS,QCHRG4/.325,.325,.500,1.600,2.,1.,1.,2./
        DATA   NBIN/100/
        DATA   FIRST /.TRUE./

C**********************************************

        IPROB      = .FALSE.
        WGTMOD     = 0.0
        FRMODS(1)  = 0.0
        FRMODS(2)  = 0.0
        FRMODS(3)  = 0.0
        DO 31 IQ = 1, 4
          FRACQ( IQ)   = 0.0
          FRTYPE(IQ,1) = 0.0
          FRTYPE(IQ,2) = 0.0
          FRTYPE(IQ,3) = 0.0
 31     CONTINUE

      IF(FIRST)THEN
        LUMFAC = SIG0/818.596
        FIRST = .FALSE.
        TBIN  = FLOAT(NBIN)
        DELR  = 1.0/TBIN

        QCHRG2(1) = (2.0/3.0)**2
        QCHRG2(2) = (1.0/3.0)**2
        QCHRG2(3) = (1.0/3.0)**2
        QCHRG2(4) = (2.0/3.0)**2

        QCHRG4(1) = (2.0/3.0)**4
        QCHRG4(2) = (1.0/3.0)**4
        QCHRG4(3) = (1.0/3.0)**4
        QCHRG4(4) = (2.0/3.0)**4

        CRGFAC = 3.0


        DO 1 I=1,4
          XMUS(I)  = (QMAS(I))**2
          XM2SQ(I) = 4.0*XMUS(I)
          QTHRSH(I) = XM2SQ(I)
 1      CONTINUE
        QTHRSH(4) = 14.44
        SIGTT = 0.0
        SIGTL = 0.0
        SIGLT = 0.0
        SIG00 = 0.0
        IF(MODE2G.EQ.5)THEN
          IF(F2TYPE.EQ.1)PRINT *,'     F2 = ALPHA'
          IF(F2TYPE.EQ.2)PRINT *,'     F2 = ALPHA*üQü'
          IF(F2TYPE.EQ.3)PRINT *,'     VDM ONLY'
          IF(F2TYPE.EQ.4)PRINT *,'     QPM ONLY'
          IF(F2TYPE.EQ.5)PRINT *,'     F2 = ALPHA*LOG(Q**2/LAMBDA**2)'
          IF(F2TYPE.EQ.6)PRINT *,'     3JET ONLY'
          IF(F2TYPE.EQ.7)PRINT *,'     VDM + QPM + 3JET'
          IF(F2TYPE.EQ.8)PRINT *,'     VDM + QPM'
        ENDIF
C        PRINT *,' NTAG2G, F2TYPE =',NTAG2G,F2TYPE
      ENDIF

      IF(NUMQRK.EQ.1)QRKM = QMAS(IQRK)

C**********************************************

C NORMALIZED Q**2 OF PHOTONS

      X1  = OM1/EB1
*
      CTMP1 = 1.0-X1
      CTMP2 = SIN(T1/2.0)*SIN(T1/2.0)
      CTMP1 = CTMP1*CTMP2
*
      CTMP2 = (XME*X1)/(2.0*EB1)
      CTMP2 = CTMP2*CTMP2
      CTMP2 = CTMP2/(1.0-X1)
      QQ1 = CTMP1 + CTMP2
      QQ1LB = 4.0*QQ1*(EB1**2)

      X2  = OM2/EB2
*
      CTMP1 = 1.0-X2
      CTMP2 = SIN(T2/2.0)*SIN(T2/2.0)
      CTMP1 = CTMP1*CTMP2
*
      CTMP2 = (XME*X2)/(2.0*EB2)
      CTMP2 = CTMP2*CTMP2
      CTMP2 = CTMP2/(1.0-X2)
      QQ2 = CTMP1 + CTMP2
      QQ2LB = 4.0*QQ2*(EB2**2)

C       PRINT *,' QQ1, QQ2 = ',QQ1LB,QQ2LB
C...DEFINITION OF THE DEEP-INELASTIC VARIABLE XQ1. DO NOT USE XQ1 FOR
C...ANY OTHER PURPOSE.

      WW    = W/(EB1 + EB2)**2
      RK    = WW + QQ1 + QQ2
      XQ1   = QQ1/RK
      XQ2   = QQ2/RK
      IF(TARGMS)THEN
        S1    = 4.*XQ1*XQ2
        Q1Q2  = (W  + QQ1LB + QQ2LB)/2.0
        W2X   = (Q1Q2**2) - (QQ1LB*QQ2LB)
        XBUD  = W2X/W
        W2X   = SQRT(W2X)
        RK    = SQRT((RK**2) - (4.*QQ1*QQ2))
        XQ1   = QQ1/RK
        XQ2   = QQ2/RK
        WX    = WW/RK
        RKINV = 1.0/(WW + QQ1 + QQ2)
      ENDIF

      IF(XQ1 .LE. XSMIN .OR. XQ1 .GE. XSMAX)RETURN
      IF(   ( XQ1 .GE. 1.0 ) .OR.
     +      ( X1  .GE. 1.0 ) .OR.
     +      ( X2  .GE. 1.0 ) .OR.
     +      ( QQ1 .LE. 0.0 ) .OR.
     +      ( QQ2 .LE. 0.0 ) )THEN
        IPROB = .TRUE.
        WRITE(6,200)XQ1, X1, X2, QQ1LB, QQ2LB, W
 200    FORMAT(1X,' WGTMOD PROBLEMS:   XQ1,  X1,  X2,  QQ1,  QQ2,
     +                W = ',/,10X,6(G12.6,3X))
        RETURN
      ENDIF

C     QED SUPRESSION FACTOR ONLY   *****
      IF(MODE2G.LE.2) THEN
        CTMP1 = (QQ1+QQ2)/WW
        CTMP1 = 1.0 + CTMP1
        CTMP1 = CTMP1*CTMP1
        CTMP2 = 4.0*QQ1*QQ2/(WW*WW)
        WS = CTMP1 - CTMP2
        IF(WS.LE.0)WRITE(6,200)XQ1,X1,X2,QQ1LB,QQ2LB,W
        IF(WS.LE.0)RETURN
        WGTMOD = 1.0/SQRT( WS )
C
C FOR FLAT STRUCTURE FUNCTION ONLY, F2 = ALPHA, WGT = ALPHA/Q**2
      ELSEIF(MODE2G.EQ.5.AND.F2TYPE.EQ.1)THEN
          CTMP1 = 1.0-X1
          CTMP1 = 4.0*CTMP1*EB1*EB1
          WGTMOD = 1.0/CTMP1
C
C FOR F2 = ALPHA * SQRT(Q**2), WGT = ALPHA / |Q|
      ELSEIF(MODE2G.EQ.5.AND.F2TYPE.EQ.2)THEN
          CTMP1 = SQRT(1.0-X1)
          CTMP1 = 2.0*EB1*CTMP1
          WGTMOD= 1.0/CTMP1
C
C
C FOR F2 = ALPHA * Q**2, WGT = ALPHA (a constant) propto SIGMA
      ELSEIF( MODE2G.EQ.5 .AND. F2TYPE.EQ.3 )THEN
C
C       Now we do Generalized Vector Dominance Model Here.
        IF(GVDM.OR.RHOPOL)THEN
          IF(GVDM)THEN
            CALL VDMI(QQ1LB,WATE1)
            CALL VDMI(QQ2LB,WATE2)
            WEIGHT = LUMFAC*WATE1*WATE2
          ENDIF
          IF(RHOPOL)THEN
            CTMP1 = QQ1/SRHO
            CTMP1 = 1.0 + CTMP1
            CTMP1 = CTMP1*CTMP1
            WATE1 = 1.0/CTMP1
*
            CTMP2 = QQ2/SRHO
            CTMP2 = 1.0 + CTMP2
            CTMP2 = CTMP2*CTMP2
            WATE2 = 1.0/CTMP2
*
            WEIGHT=LUMFAC*WATE1*WATE2
          ENDIF
          WGTMOD = WEIGHT
        ELSE
          WGTMOD = 1.0
        ENDIF
          FRTYPE(1,1) = WGTMOD*0.75
          FRTYPE(2,1) = WGTMOD*0.083333
          FRTYPE(3,1) = WGTMOD*0.166667
C
C     for  Quark Parton Model
      ELSEIF(MODE2G.EQ.5.AND.F2TYPE.EQ.4)THEN
C
C       DEEP INELASTIC VARIABLES
C
C       X=QQ1/(QQ1+WW)
C       Y=X1+QQ1
C
C       remember: (2*pi*alpha*hbar*c)**2 has been factored
C       out of the gamma-gamma cross section and put into FACT2G.
C       DEEP INELASTIC ASSUMPTIONS
C
C**********************************************************
        TTSUM = 0.0
        LTSUM = 0.0
        TLSUM = 0.0
        SSSUM = 0.0
        IF(.NOT.LUMTL)THEN
          EPS1 = 0.0
          EPS2 = 0.0
          EPS3 = 0.0
          EPS4 = 0.0
        ENDIF
        IQ = 0
        IQACP = 0
 4      IQ = IQ + 1
        IF(IQ.GE.5)GO TO 14
        FRTYPE(IQ,2) = 0.0
        IF(W.GT.QTHRSH(IQ))THEN
        IF(NUMQRK.EQ.1.AND.IQ.NE.IQRK)GOTO 4
        IQACP = IQACP + 1
        IF(IQACP.GT.NUMQRK)GOTO 4
        SIGTT = 0.0
        SIGTL = 0.0
        SIGLT = 0.0
        SIG00 = 0.0
        BETSQ = XM2SQ(IQ)/W
        BETSQ = 1.0 - BETSQ
*
        IF(BETSQ.LE.0.0)GOTO 4
        BETA  = SQRT(BETSQ)
        IF(TARGMS)THEN

          CTMP1  = XBUD*XM2SQ(IQ)
          CTMP2  = QQ1LB*QQ2LB
          TBUD   = CTMP1 + CTMP2
          DTBUD = 2.0*BETA*W2X
          IF(S1.GE.1.0)GOTO 4
          CTMP1 = BETA*SQRT(1.-S1)
          CTMP1 = 1.0 + CTMP1
          CTMP1 = CTMP1*CTMP1
*
          CTMP2 = S1*BETSQ
          CTMP2 = 1.0 - BETSQ + CTMP2
*
          SLOG  = CTMP1/CTMP2
          IF(SLOG.LE.0.0)PRINT *,' SLOG =',SLOG
#if defined(NONCLEO_DOUBLE)
          SLOG  = DLOG(SLOG)
#else
          SLOG  = ALOG(SLOG)
#endif
C      GET 2XF1
*****
*****     Calculator time for SIGTT
          CTMP1 = 2.0*XMUS(IQ)/XBUD
*
          CTMP2 = XMUS(IQ)/Q1Q2
          CTMP2 = CTMP2*CTMP2
          CTMP2 = 4.0*CTMP2
*
          CTMP3 = (QQ1LB+QQ2LB)
          CTMP3 = CTMP3/XBUD
*
          CTMP4 = (QQ1LB*QQ2LB*W)/(2.0*XBUD*Q1Q2*Q1Q2)

          CTMP5 = QQ1LB*QQ2LB/(XBUD*Q1Q2)
          CTMP5 = 0.75*CTMP5*CTMP5
*
          CTMP1 = 2.0 + CTMP1 - CTMP2 - CTMP3 + CTMP4 + CTMP5
          CTMP1 = SLOG*CTMP1
**
          CTMP2 = XMUS(IQ) - QQ1LB - QQ2LB
          CTMP2 = CTMP2/XBUD
          CTMP2 = 1.0 + CTMP2
*
          CTMP3 = QQ1LB*QQ2LB
          CTMP3 = CTMP3/TBUD
*
          CTMP4 = (0.75*QQ1LB*QQ2LB)/(XBUD*XBUD)
          CTMP2 = DTBUD*(CTMP2 + CTMP3 + CTMP4)
          CTMP2 = CTMP2/Q1Q2
*
          CTMP1 = 0.5*PIINV*(CTMP1 - CTMP2)
*
          SIGTT = CTMP1/(RK*RKINV)
*****
*****     Calculator time for SIGLT

          CTMP1 = 1.5*QQ1LB*QQ2LB
          CTMP1 = CTMP1/XBUD
*
          CTMP2 = 6.0*XMUS(IQ)
          CTMP1 = CTMP1 + CTMP2 - QQ2LB
          CTMP1 = (QQ2LB*CTMP1)/TBUD
          CTMP1 = 1.0 - CTMP1
          CTMP1 = 2.0*BETA*CTMP1
*
          CTMP2 = SLOG/(Q1Q2*W2X)
          CTMP3 = 4.0*XMUS(IQ)*XBUD
          CTMP4 = QQ2LB*(W + 2.0*XMUS(IQ))
          CTMP5 = (1.5*QQ1LB*QQ2LB)/XBUD
          CTMP5 = QQ2LB*(QQ1LB + QQ2LB - CTMP5)
*
          CTMP1 = CTMP1 - CTMP2*(CTMP3 - CTMP4 + CTMP5 )
*
          SIGLT = PIINV*2.0*XQ1*WX*CTMP1
*****
*****     Calculator time for SIGTL
*
          CTMP1 = QQ1LB/TBUD
          CTMP2 = 1.5*QQ1LB*QQ2LB
          CTMP2 = CTMP2/XBUD
          CTMP2 = 6.0*XMUS(IQ) - QQ1LB + CTMP2
          CTMP1 = 1.0 - CTMP1*CTMP2
          CTMP1 = 2.*BETA*CTMP1
*
          CTMP2 = (1.5*QQ1LB*QQ2LB)/XBUD
          CTMP2 = QQ1LB + QQ2LB - CTMP2
          CTMP2 = QQ1LB*CTMP2
*
          CTMP3 = QQ1LB*(W + 2.0*XMUS(IQ))
          CTMP4 = 4.0*XMUS(IQ)*XBUD
          CTMP5 = SLOG/(Q1Q2*W2X)
          CTMP2 = CTMP5*(CTMP4 - CTMP3 + CTMP2)
*
          SIGTL = PIINV*2.0*XQ2*WX*(CTMP1 - CTMP2)
*****
*****     Calculator time for SIG00
*
          CTMP1 = SLOG*(2.0*(W2X**2) + 3.0*QQ1LB*QQ2LB )
          CTMP2 = QQ1LB*QQ2LB
          CTMP2 = CTMP2/TBUD
          CTMP2 = DTBUD*Q1Q2*(2.0 + CTMP2)
*
          CTMP1 = PIINV*8.0*(WX*WX)*XQ1*XQ2*(CTMP1 - CTMP2)
          CTMP2 = Q1Q2*Q1Q2*RKINV
          SIG00 = CTMP1/CTMP2

        ELSE
          SLOG  = W/XM2SQ(IQ)
          IF(SLOG.LE.1.0)GOTO 4
*
          SLOG  = SQRT(SLOG) + SQRT(SLOG-1.0)
          IF(SLOG.LE.0.0)PRINT *,' SLOG =',SLOG
#if defined(NONCLEO_DOUBLE)
          SLOG  = 2.*DLOG(SLOG)
#else
          SLOG  = 2.*ALOG(SLOG)
#endif
          DFAC  = W + QQ1LB + QQ2LB
          DFACS = DFAC**2
C      GET 2XF1
*****
*****     Calculator time for SIGTT
          CTMP1 = 1.0 - XQ1
          CTMP1 = CTMP1*CTMP1
          CTMP2 = W - 2.0*XMUS(IQ)
          CTMP2 = CTMP2/DFACS
          CTMP1 = XQ1*XQ1 + CTMP1 + XM2SQ(IQ)*CTMP2
          CTMP1 = SLOG*CTMP1
*
          CTMP2 = W/DFACS
          CTMP2 = XM2SQ(IQ)*CTMP2
          CTMP3 = 1.0 - 2.0*XQ1
          CTMP3 = CTMP3*CTMP3
          CTMP2 = BETA*(CTMP3 + CTMP2)

          SIGTT = PIINV*(CTMP1 - CTMP2)
*
*****
*****     Calculator time for SIGLT

          CTMP1 = 2.0*XMUS(IQ)*SLOG/DFAC
          CTMP2 = (1.0 - XQ1)*BETA
*
          SIGLT =PIINV*4.0*XQ1*(CTMP2 - CTMP1)
*
        ENDIF
C    GET XF1
C**************
        SIGTT = CRGFAC*SIGTT*QCHRG4(IQ)
        SIGLT = CRGFAC*SIGLT*QCHRG4(IQ)
        SIGTL = CRGFAC*SIGTL*QCHRG4(IQ)
        SIG00 = CRGFAC*SIG00*QCHRG4(IQ)
*
        FRTYPE(IQ,2)  = SIGTT + EPS1*SIGLT
        TTSUM = TTSUM + SIGTT
        LTSUM = LTSUM + SIGLT
        TLSUM = TLSUM + SIGTL
        SSSUM = SSSUM + SIG00
        ENDIF
        GOTO 4
 14     CONTINUE
C For clearity, the terms below that look like gamma-gamma cross
C sections have had a factor of 4(pi*alpha*hbar*c)**2 factored out

C The factor above is equal to 818.596 nbs.

        TTSM  = TTSUM
        WGTCOR = WGTCOR**2
        WGTMOD = TTSUM + EPS1*LTSUM
C
C FOR  LOG(Q**2/Lambda) or Log(Q**2/(lambda**2 + XQ1**2*p**2)) Model
      ELSEIF(MODE2G.EQ.5.AND.F2TYPE.EQ.5)THEN
        IF(TARGMS)THEN
          CTMP1 = LMSBSQ + QQ2LB*XQ1*XQ1
          CTMP1 = LOG(QQ1LB/CTMP1 )
          CTMP2 = 4.0*(1.0 - X1)*EB1*EB1

          WGTMOD = CTMP1/CTMP2
        ELSE
          CTMP1 = LOG(QQ1LB/LMSBSQ)
          CTMP2 = 4.0*(1.-X1)*EB1*EB1
          WGTMOD = CTMP1/CTMP2
        ENDIF
C
C FOR  3jet Monte Carlo Model
      ELSEIF(MODE2G.EQ.5.AND.F2TYPE.EQ.6)THEN
C
C       3JET-WEIGHTING FUNCTION
C
C       X=QQ1/(QQ1+WW)
C       Y=X1+QQ1
C
C       remember: (2*pi*alpha*hbar*c)**2 has been factored
C       out of the gamma-gamma cross section and put into FACT2G.
C       DEEP INELASTIC ASSUMPTIONS
C
C**********************************************************
        TTSUM = 0.0
        IQ = 0
        IQACP = 0
 5      IQ = IQ + 1
        IF(IQ.GE.5)GO TO 15
          IF(W.GT.QTHRSH(IQ))THEN
          IF(NUMQRK.EQ.1.AND.IQ.NE.IQRK)GOTO 5
          IQACP = IQACP + 1
          IF(IQACP.GT.NUMQRK)GOTO 5
          SIGTT    = 0.0
          SMQ   = QMAS(IQ)**2
*
          CTMP1 = 2.0*QMAS(IQ)*(OM1 + OM2)
          CTMP2 = (2.0*PTBRK)
          CTMP2 = CTMP2*CTMP2
          WCUT  = 3.0*SMQ + CTMP2 + CTMP1
          WCUT1 = PTBRK*PTBRK + SMQ
          IF(WCUT1.LE.0.0)THEN
            WRITE(6,300)WCUT1
 300        FORMAT(1X,' HIGH_PT: WCUT1 = ',G12.6)
            WCUT1 = 0.0
          ENDIF
          CTMP1 = (PTBRK + QMAS(IQ))*SQRT(WCUT1)
          CTMP1 = WCUT1 + PTBRK*QMAS(IQ) + CTMP1
          WCUT1 = 2.0*CTMP1
          WCUT = MIN(WCUT,WCUT1)
          IF(W .LE. WCUT) GOTO 5
          CQ1  = 2.0*(OM1 + OM2)
          BQ1  = W + QQ1LB - QQ2LB - CQ1*OM2
          CQ1  = CQ1*CQ1
          AQ1  = W - 3.0*SMQ - 4.0*PTBRK*PTBRK
          BF1  = AQ1*BQ1
          BQ1  = BQ1*BQ1
          AF1  = CQ1*(OM2*OM2 + QQ2LB) - BQ1
          CF1  = CQ1*SMQ - AQ1*AQ1
          DISC = BF1*BF1 - AF1*CF1
          IF(DISC .LE. 0.0)GOTO 5
          DISC = SQRT(DISC)
          CTMP1 = (BF1 - DISC)/AF1
          CTMP2 = (BF1 + DISC)/AF1
          XF1  = 1.0 + CTMP1
          XF2  = 1.0 + CTMP2
          IF( XF2 .LT. XF1 .AND. XF2 .GT. 0.0 )XF1 = XF2
          IF(XF1 .LE. 0.0 .OR. XF1 .GE. 1.0)GOTO 5
          XLWR(IQ) = XF1
          IF(XLWR(IQ) .LE. 0.0)PRINT *,' XLWR(',IQ,') =',XLWR(IQ)
#if defined(NONCLEO_DOUBLE)
          CTMP1 = DLOG(1.0/XLWR(IQ))
#else
          CTMP1 = ALOG(1.0/XLWR(IQ))
#endif
          CTMP1 = CTMP1/TBIN
          F1 = 11.632*QCHRG2(IQ)*CTMP1
          RAND     = -DELR/2.0
          DO 45 I = 1, NBIN
            XINT(I,IQ)  = 0.0
            WXCHK(I,IQ) = 0.0
            XCHKV(I,IQ) = 0.0
 45       CONTINUE
          DO 55  I = 1, NBIN
            RAND   = RAND + DELR
            CTMP1 = 1.0/XLWR(IQ)
            CTMP1 = CTMP1**RAND
            XS     = XLWR(IQ)*CTMP1
            BXS    = 1.0 - XS
            IF(XS .GE. 1.0)GO TO 55
            IF(BXS .GE. 1.0)GO TO 55
            E1   = SMQ + (OM2*OM2 + QQ2LB)*BXS*BXS
            IF(E1.LE.0.0)THEN
              WRITE(6,302)E1
 302          FORMAT(1X,' HIGH PT:  E1 = ',G12.6)
              E1 = 0.0
            ENDIF
            E1   = SQRT( E1 )
            ESYS = OM1 + OM2 - E1
            CTMP1 = (OM2*OM2 + QQ2LB)*XS*XS
            CTMP2 = XS*(W + QQ1LB + QQ2LB - 2.0*OM1*OM2)
            WX = ESYS*ESYS - (OM1*OM1 + QQ1LB) - CTMP1 + CTMP2
            CTMP1 = WX + QQ1LB + QQ2LB
            COR1    = XS/CTMP1
            KESLER  = WX/CTMP1
            IF(WX.GE.W)GO TO 55
            IF(WX.LE.0.0)GO TO 55
            ARGM   = 2.0*QMAS(IQ)/SQRT(WX)
            PTMNN  = 2.0*PTBRK/SQRT(WX)
            BETAPT = 1.0 - ARGM*ARGM  - PTMNN*PTMNN
            IF(ARGM .GE. 1.0)GO TO 55
            IF(PTMNN.GE. 1.0)GO TO 55
            IF(BETAPT .LE. 0.0)GO TO 55
            BETAQ = SQRT( 1.0 - ARGM*ARGM )
            BETAPT= SQRT( BETAPT )
            ARGM  = (BETAQ + BETAPT)/PTMNN
            IF(ARGM.LE.0.0)PRINT *,' ARGM =',ARGM
#if defined(NONCLEO_DOUBLE)
            ARG   = DLOG( ARGM )
#else
            ARG   = ALOG( ARGM )
#endif
*
            CTMP1 = WX*WX
            CTMP2 = 2.0*QQ1LB*(WX + QQ1LB)
            CTMP1 = CTMP2/CTMP1
            CTMP1 = ( 1.0 + CTMP1)*ARG
            ARG1  = CTMP1/BETAQ
*
            CTMP1 = QQ1LB/WX
            CTMP1 = 3.0*CTMP1*CTMP1
            CTMP1 = 1.0 - CTMP1
            ARG2  = BETAPT*CTMP1/4.0
*
            ARG   = ARG1 + ARG2
            ARG   = ARG*BETAQ*COR1*KESLER
            CTMP1 = FGAM(XS,WX,IQ,QQ1LB,QCHRG2(IQ),QMAS(IQ))
            ARG   = F1*ARG*CTMP1
            SIGTT = SIGTT + ARG
            WXCHK(I,IQ) = WX
            XCHKV(I,IQ) = XS
            XINT(I,IQ)  = SIGTT
 55       CONTINUE
          XINT(100,IQ) = SIGTT
          FRTYPE(IQ,3) = SIGTT
          TTSUM = TTSUM + SIGTT
         ENDIF
         GOTO 5
 15      CONTINUE
        WGTMOD =  TTSUM
C*****************************************************
      ELSEIF(MODE2G.EQ.5.AND.F2TYPE.EQ.7)THEN
        WGTMOD = 0.0
C       Now we do Generalized Vector Dominance Model Here.
          CALL VDMI(QQ1LB,WATE1)
          CALL VDMI(QQ2LB,WATE2)
          WEIGHT = LUMFAC*WATE1*WATE2
          FRMODS(1) = WEIGHT
          FRTYPE(1,1)  = WEIGHT*0.75
          FRTYPE(2,1)  = WEIGHT*0.083333
          FRTYPE(3,1)  = WEIGHT*0.166667
C FOR  Quark Parton Model PARTIAL contribution
C
C       remember: (2*pi*alpha*hbar*c)**2 has been factored
C       out of the gamma-gamma cross section and put into FACT2G.
C       DEEP INELASTIC ASSUMPTIONS
C
C**********************************************************

        TTSUM = 0.0
        LTSUM = 0.0
        TLSUM = 0.0
        SSSUM = 0.0
        IF(.NOT.LUMTL)THEN
          EPS1 = 0.0
          EPS2 = 0.0
          EPS3 = 0.0
          EPS4 = 0.0
        ENDIF
        IQ = 0
        IQACP = 0
 6      CONTINUE
        IQ = IQ + 1
        IF(IQ.GE.5)GO TO 16
        IF(W.GT.QTHRSH(IQ))THEN
          IF(NUMQRK .EQ. 1 .AND. IQ .NE. IQRK)GOTO 6
          IQACP = IQACP + 1
          IF(IQACP.GT.NUMQRK)GOTO 6
          SIGTT = 0.0
          SIGTL = 0.0
          SIGLT = 0.0
          SIG00 = 0.0
          BETSQ = 1. - XM2SQ(IQ)/W
          IF(BETSQ.LE.0.0)GOTO 6
          BETA = SQRT(BETSQ)
          IF(TARGMS)THEN
            TBUD  = XBUD*XM2SQ(IQ) + QQ1LB*QQ2LB
            DTBUD = 2.0*BETA*W2X
            IF(S1 .GE. 1.0)GOTO 6
            CTMP1 = 1.0 + BETA*SQRT(1.-S1)
            CTMP1 = CTMP1*CTMP1
            CTMP2 = 1.- BETSQ + S1*BETSQ
            SLOG  = CTMP1/CTMP2
            IF(SLOG.LE.0.0)PRINT *,' SLOG =',SLOG
#if defined(NONCLEO_DOUBLE)
            SLOG  = DLOG(SLOG)
#else
            SLOG  = ALOG(SLOG)
#endif
C      GET 2XF1
*****
*****     Calculator time for SIGTT
          CTMP1 = 2.0*XMUS(IQ)/XBUD
*
          CTMP2 = XMUS(IQ)/Q1Q2
          CTMP2 = CTMP2*CTMP2
          CTMP2 = 4.0*CTMP2
*
          CTMP3 = (QQ1LB+QQ2LB)
          CTMP3 = CTMP3/XBUD
*
          CTMP4 = (QQ1LB*QQ2LB*W)/(2.0*XBUD*Q1Q2*Q1Q2)

          CTMP5 = QQ1LB*QQ2LB/(XBUD*Q1Q2)
          CTMP5 = 0.75*CTMP5*CTMP5
*
          CTMP1 = 2.0 + CTMP1 - CTMP2 - CTMP3 + CTMP4 + CTMP5
          CTMP1 = SLOG*CTMP1
**
          CTMP2 = XMUS(IQ) - QQ1LB - QQ2LB
          CTMP2 = CTMP2/XBUD
          CTMP2 = 1.0 + CTMP2
*
          CTMP3 = QQ1LB*QQ2LB
          CTMP3 = CTMP3/TBUD
*
          CTMP4 = (0.75*QQ1LB*QQ2LB)/(XBUD*XBUD)
          CTMP2 = DTBUD*(CTMP2 + CTMP3 + CTMP4)
          CTMP2 = CTMP2/Q1Q2
*
          CTMP1 = 0.5*PIINV*(CTMP1 - CTMP2)
*
          SIGTT = CTMP1/(RK*RKINV)
*****
*****     Calculator time for SIGLT

          CTMP1 = 1.5*QQ1LB*QQ2LB
          CTMP1 = CTMP1/XBUD
*
          CTMP2 = 6.0*XMUS(IQ)
          CTMP1 = CTMP1 + CTMP2 - QQ2LB
          CTMP1 = (QQ2LB*CTMP1)/TBUD
          CTMP1 = 1.0 - CTMP1
          CTMP1 = 2.0*BETA*CTMP1
*
          CTMP2 = SLOG/(Q1Q2*W2X)
          CTMP3 = 4.0*XMUS(IQ)*XBUD
          CTMP4 = QQ2LB*(W + 2.0*XMUS(IQ))
          CTMP5 = (1.5*QQ1LB*QQ2LB)/XBUD
          CTMP5 = QQ2LB*(QQ1LB + QQ2LB - CTMP5)
*
          CTMP1 = CTMP1 - CTMP2*(CTMP3 - CTMP4 + CTMP5 )
*
          SIGLT = PIINV*2.0*XQ1*WX*CTMP1
*****
*****     Calculator time for SIGTL
*
          CTMP1 = QQ1LB/TBUD
          CTMP2 = 1.5*QQ1LB*QQ2LB
          CTMP2 = CTMP2/XBUD
          CTMP2 = 6.0*XMUS(IQ) - QQ1LB + CTMP2
          CTMP1 = 1.0 - CTMP1*CTMP2
          CTMP1 = 2.*BETA*CTMP1
*
          CTMP2 = (1.5*QQ1LB*QQ2LB)/XBUD
          CTMP2 = QQ1LB + QQ2LB - CTMP2
          CTMP2 = QQ1LB*CTMP2
*
          CTMP3 = QQ1LB*(W + 2.0*XMUS(IQ))
          CTMP4 = 4.0*XMUS(IQ)*XBUD
          CTMP5 = SLOG/(Q1Q2*W2X)
          CTMP2 = CTMP5*(CTMP4 - CTMP3 + CTMP2)
*
          SIGTL = PIINV*2.0*XQ2*WX*(CTMP1 - CTMP2)
*****
*****     Calculator time for SIG00
*
          CTMP1 = SLOG*(2.0*(W2X**2) + 3.0*QQ1LB*QQ2LB )
          CTMP2 = QQ1LB*QQ2LB
          CTMP2 = CTMP2/TBUD
          CTMP2 = DTBUD*Q1Q2*(2.0 + CTMP2)
*
          CTMP1 = PIINV*8.0*(WX*WX)*XQ1*XQ2*(CTMP1 - CTMP2)
          CTMP2 = Q1Q2*Q1Q2*RKINV
          SIG00 = CTMP1/CTMP2

        ELSE
          SLOG  = W/XM2SQ(IQ)
          IF(SLOG.LE.1.0)GOTO 6
*
          SLOG  = SQRT(SLOG) + SQRT(SLOG-1.0)
          IF(SLOG.LE.0.0)PRINT *,' SLOG =',SLOG
#if defined(NONCLEO_DOUBLE)
          SLOG  = 2.*DLOG(SLOG)
#else
          SLOG  = 2.*ALOG(SLOG)
#endif
          DFAC  = W + QQ1LB + QQ2LB
          DFACS = DFAC**2
C      GET 2XF1
*****
*****     Calculator time for SIGTT
          CTMP1 = 1.0 - XQ1
          CTMP1 = CTMP1*CTMP1
          CTMP2 = W - 2.0*XMUS(IQ)
          CTMP2 = CTMP2/DFACS
          CTMP1 = XQ1*XQ1 + CTMP1 + XM2SQ(IQ)*CTMP2
          CTMP1 = SLOG*CTMP1
*
          CTMP2 = W/DFACS
          CTMP2 = XM2SQ(IQ)*CTMP2
          CTMP3 = 1.0 - 2.0*XQ1
          CTMP3 = CTMP3*CTMP3
          CTMP2 = BETA*(CTMP3 + CTMP2)

          SIGTT = PIINV*(CTMP1 - CTMP2)
*
*****
*****     Calculator time for SIGLT

          CTMP1 = 2.0*XMUS(IQ)*SLOG/DFAC
          CTMP2 = (1.0 - XQ1)*BETA
*
          SIGLT =PIINV*4.0*XQ1*(CTMP2 - CTMP1)
*
        ENDIF
C    GET XF1
C**************
          SIGTT = CRGFAC*SIGTT*QCHRG4(IQ)*XQ1/QQ1LB
          SIGLT = CRGFAC*SIGLT*QCHRG4(IQ)*XQ1/QQ1LB
          SIGTL = CRGFAC*SIGTL*QCHRG4(IQ)*XQ1/QQ1LB
          SIG00 = CRGFAC*SIG00*QCHRG4(IQ)*XQ1/QQ1LB
          FRTYPE(IQ,2)  = SIGTT + EPS1*SIGLT
          TTSUM = TTSUM + SIGTT
          LTSUM = LTSUM + SIGLT
          TLSUM = TLSUM + SIGTL
          SSSUM = SSSUM + SIG00
        ENDIF
        GOTO 6
 16     CONTINUE
C For clearity, the terms below that look like gamma-gamma cross
C sections have had a factor of 4(pi*alpha*hbar*c)**2 factored out

C The factor above is equal to 818.596 nbs.

        TTSM = TTSUM
        FRMODS(2) =  TTSUM + EPS1*LTSUM
C...3JET PARTIAL CONTRIBUTION
C
C       remember: (2*pi*alpha*hbar*c)**2 has been factored
C       out of the gamma-gamma cross section and put into FACT2G.
C       DEEP INELASTIC ASSUMPTIONS
C
C**********************************************************
        TTSUM = 0.0
        IQ = 0
        IQACP = 0
 7      IQ = IQ + 1
        IF(IQ.GE.5)GO TO 17
        IF(W.GT.QTHRSH(IQ))THEN
          IF(NUMQRK.EQ.1.AND.IQ.NE.IQRK)GOTO 7
          IQACP = IQACP + 1
          IF(IQACP.GT.NUMQRK)GOTO 7
          SIGTT    = 0.0
          SMQ  = QMAS(IQ)**2
          WCUT = 3.0*SMQ + (2.0*PTBRK)**2 + 2.0*QMAS(IQ)*(OM1 + OM2 )
          WCUT1 = PTBRK**2 + SMQ
          IF(WCUT1.LE.0.0)THEN
            WRITE(6,304)WCUT1
 304        FORMAT(1X,' COMBO: WCUT1 = ',G12.6)
            WCUT1 = 0.0
          ENDIF
          WCUT1 = WCUT1+PTBRK*QMAS(IQ)+(PTBRK + QMAS(IQ))*SQRT(WCUT1)
          WCUT1 = 2.0*WCUT1
          WCUT = MIN(WCUT,WCUT1)
          IF(W.LE. WCUT) GOTO 7
          CQ1  = 2.0*(OM1 + OM2)
          BQ1  = W + QQ1LB - QQ2LB - CQ1*OM2
          CQ1  = CQ1*CQ1
          AQ1  = W - 3.0*SMQ - 4.0*PTBRK**2
          BF1  = AQ1*BQ1
          BQ1  = BQ1*BQ1
          AF1  = CQ1*(OM2**2 + QQ2LB) - BQ1
          CF1  = CQ1*SMQ - AQ1*AQ1
          DISC = BF1**2 - AF1*CF1
          IF(DISC.LE.0.0)GOTO 7
          DISC = SQRT(DISC)
          CTMP1 = (BF1 - DISC)/AF1
          CTMP2 = (BF1 + DISC)/AF1
          XF1  = 1.0 + CTMP1
          XF2  = 1.0 + CTMP2
          IF(XF2 .LT. XF1 .AND. XF2 .GT. 0.0)XF1 = XF2
          IF(XF1 .LE. 0.0 .OR. XF1 .GE. 1.0)GOTO 7
          XLWR(IQ) = XF1
          IF(XLWR(IQ).LE.0.0)PRINT *,' XLWR(',IQ,') =',XLWR(IQ)
#if defined(NONCLEO_DOUBLE)
          CTMP1 = DLOG(1.0/XLWR(IQ))
#else
          CTMP1 = ALOG(1.0/XLWR(IQ))
#endif
          CTMP1 = CTMP1/TBIN
          F1 = 11.632*QCHRG2(IQ)*CTMP1
          RAND     = -DELR/2.0
          DO 70 I = 1, NBIN
            XINT(I,IQ) = 0.0
            WXCHK(I,IQ) = 0.0
            XCHKV(I,IQ) = 0.0
 70       CONTINUE
          DO 75  I = 1, NBIN
            RAND   = RAND + DELR
            CTMP1  = (1.0/XLWR(IQ))
            CTMP1  = CTMP1**RAND
            XS     = XLWR(IQ)*CTMP1
            BXS    = 1.0 - XS
            IF(XS.GE.1.0)GO TO 75
            IF(BXS.GE.1.0)GO TO 75
            E1   = SMQ + (OM2**2 + QQ2LB)*BXS**2
            IF(E1.LE.0.0)THEN
              WRITE(6,305)E1
 305          FORMAT(1X,' COMBO HIGH-PT:  E1 = ',G12.6)
              E1 = 0.0
            ENDIF
            E1   = SQRT( E1 )
            ESYS = OM1 + OM2 - E1
*
            CTMP1 = OM2*OM2 + QQ2LB
            CTMP1 = CTMP1*XS*XS
            CTMP2 = OM1*OM1 + QQ1LB
            CTMP3 = XS*(W + QQ1LB + QQ2LB - 2.0*OM1*OM2)
            WX = ESYS*ESYS - CTMP2 - CTMP1 + CTMP3
            CTMP1 = (WX + QQ1LB + QQ2LB)
            COR1    = XS/CTMP1
            KESLER  = WX/CTMP1
            IF(WX .GE. W)GO TO 75
            IF(WX .LE. 0.0)GO TO 75
            ARGM   = 2.0*QMAS(IQ)/SQRT(WX)
            PTMNN  = 2.0*PTBRK/SQRT(WX)
            BETAPT = 1.0 - ARGM**2 - PTMNN**2
            IF(ARGM .GE. 1.0)GO TO 75
            IF(PTMNN.GE. 1.0)GO TO 75
            IF(BETAPT .LE. 0.0)GO TO 75
            BETAQ = SQRT( 1.0 - ARGM**2 )
            BETAPT= SQRT( BETAPT )
            CTMP1 = BETAQ/PTMNN
            CTMP2 = BETAPT/PTMNN
            ARGM  = CTMP1 + CTMP2
            IF(ARGM.LE.0.0)PRINT *,' ARGM = ',ARGM
#if defined(NONCLEO_DOUBLE)
            ARG   = DLOG( ARGM )
#else
            ARG   = ALOG( ARGM )
#endif
            CTMP1 = 2.0*QQ1LB*(WX + QQ1LB)
            CTMP1 = CTMP1/(WX*WX)
            ARG1  = ( 1.0 + CTMP1)*ARG
            ARG1  = ARG1/BETAQ

            CTMP1 = (QQ1LB/WX)*(QQ1LB/WX)
            CTMP1 = 1.0 - 3.0*CTMP1
            ARG2  = BETAPT*CTMP1/4.0
            ARG   = ARG1 + ARG2
            ARG   = ARG*BETAQ*COR1*KESLER
            ARG   = F1*ARG*FGAM(XS,WX,IQ,QQ1LB,QCHRG2(IQ),QMAS(IQ))
            SIGTT = SIGTT + ARG
            XCHKV(I,IQ) = XS
            WXCHK(I,IQ) = WX
            XINT(I,IQ)  = SIGTT
 75       CONTINUE
          XINT(100,IQ)  = SIGTT
          FRTYPE(IQ,3)  = SIGTT
          TTSUM = TTSUM + SIGTT
        ENDIF
        GOTO 7
 17     CONTINUE
        FRMODS(3) = TTSUM
        WGTMOD = FRMODS(1) + FRMODS(2) + FRMODS(3)
        IF(WGTMOD.NE.0)THEN
          FRMODS(1) = FRMODS(1)/WGTMOD
          FRMODS(2) = FRMODS(2)/WGTMOD
          FRMODS(3) = FRMODS(3)/WGTMOD
        ENDIF
C*****************************************************
C QPM + VDM ONLY
      ELSEIF(MODE2G.EQ.5.AND.F2TYPE.EQ.8)THEN
        WGTMOD = 0.0
C       Now we do Generalized Vector Dominance Model Here.
          CALL VDMI(QQ1LB,WATE1)
          CALL VDMI(QQ2LB,WATE2)
          WEIGHT = LUMFAC*WATE1*WATE2
          FRMODS(1) = WEIGHT
          FRTYPE(1,1)  = WEIGHT*0.75
          FRTYPE(2,1)  = WEIGHT*0.083333
          FRTYPE(3,1)  = WEIGHT*0.166667
C FOR  Quark Parton Model PARTIAL contribution
C
C       remember: (2*pi*alpha*hbar*c)**2 has been factored
C       out of the gamma-gamma cross section and put into FACT2G.
C       DEEP INELASTIC ASSUMPTIONS
C
C**********************************************************

        TTSUM = 0.0
        LTSUM = 0.0
        TLSUM = 0.0
        SSSUM = 0.0
        IF(.NOT.LUMTL)THEN
          EPS1 = 0.0
          EPS2 = 0.0
          EPS3 = 0.0
          EPS4 = 0.0
        ENDIF
        IQ = 0
        IQACP = 0
 8      CONTINUE
        IQ = IQ + 1
        IF(IQ.GE.5)GO TO 18
        IF(W.GT.QTHRSH(IQ))THEN
          IF(NUMQRK.EQ.1.AND.IQ.NE.IQRK)GOTO 8
          IQACP = IQACP + 1
          IF(IQACP.GT.NUMQRK)GOTO 8
          SIGTT = 0.0
          SIGLT = 0.0
          SIGTL = 0.0
          SIG00 = 0.0
          BETSQ = XM2SQ(IQ)/W
          BETSQ = 1. - BETSQ
          IF(BETSQ.LE.0.0)GOTO 8
          BETA = SQRT(BETSQ)
          IF(TARGMS)THEN
            TBUD  = XBUD*XM2SQ(IQ) + QQ1LB*QQ2LB
            DTBUD = 2.0*BETA*W2X
            IF(S1.GE.1.0)GOTO 8
            CTMP1  = (1 + BETA*SQRT(1.-S1))**2
            CTMP2  = ( 1.- BETSQ + S1*BETSQ )
            SLOG   = CTMP1/CTMP2
            IF(SLOG.LE.0.0)PRINT *,' SLOG =',SLOG
#if defined(NONCLEO_DOUBLE)
            SLOG  = DLOG(SLOG)
#else
            SLOG  = ALOG(SLOG)
#endif
C
C      GET 2XF1
*****
*****     Calculator time for SIGTT
          CTMP1 = 2.0*XMUS(IQ)/XBUD
*
          CTMP2 = XMUS(IQ)/Q1Q2
          CTMP2 = CTMP2*CTMP2
          CTMP2 = 4.0*CTMP2
*
          CTMP3 = (QQ1LB+QQ2LB)
          CTMP3 = CTMP3/XBUD
*
          CTMP4 = (QQ1LB*QQ2LB*W)/(2.0*XBUD*Q1Q2*Q1Q2)

          CTMP5 = QQ1LB*QQ2LB/(XBUD*Q1Q2)
          CTMP5 = 0.75*CTMP5*CTMP5
*
          CTMP1 = 2.0 + CTMP1 - CTMP2 - CTMP3 + CTMP4 + CTMP5
          CTMP1 = SLOG*CTMP1
**
          CTMP2 = XMUS(IQ) - QQ1LB - QQ2LB
          CTMP2 = CTMP2/XBUD
          CTMP2 = 1.0 + CTMP2
*
          CTMP3 = QQ1LB*QQ2LB
          CTMP3 = CTMP3/TBUD
*
          CTMP4 = (0.75*QQ1LB*QQ2LB)/(XBUD*XBUD)
          CTMP2 = DTBUD*(CTMP2 + CTMP3 + CTMP4)
          CTMP2 = CTMP2/Q1Q2
*
          CTMP1 = 0.5*PIINV*(CTMP1 - CTMP2)
*
          SIGTT = CTMP1/(RK*RKINV)
*****
*****     Calculator time for SIGLT

          CTMP1 = 1.5*QQ1LB*QQ2LB
          CTMP1 = CTMP1/XBUD
*
          CTMP2 = 6.0*XMUS(IQ)
          CTMP1 = CTMP1 + CTMP2 - QQ2LB
          CTMP1 = (QQ2LB*CTMP1)/TBUD
          CTMP1 = 1.0 - CTMP1
          CTMP1 = 2.0*BETA*CTMP1
*
          CTMP2 = SLOG/(Q1Q2*W2X)
          CTMP3 = 4.0*XMUS(IQ)*XBUD
          CTMP4 = QQ2LB*(W + 2.0*XMUS(IQ))
          CTMP5 = (1.5*QQ1LB*QQ2LB)/XBUD
          CTMP5 = QQ2LB*(QQ1LB + QQ2LB - CTMP5)
*
          CTMP1 = CTMP1 - CTMP2*(CTMP3 - CTMP4 + CTMP5 )
*
          SIGLT = PIINV*2.0*XQ1*WX*CTMP1
*****
*****     Calculator time for SIGTL
*
          CTMP1 = QQ1LB/TBUD
          CTMP2 = 1.5*QQ1LB*QQ2LB
          CTMP2 = CTMP2/XBUD
          CTMP2 = 6.0*XMUS(IQ) - QQ1LB + CTMP2
          CTMP1 = 1.0 - CTMP1*CTMP2
          CTMP1 = 2.*BETA*CTMP1
*
          CTMP2 = (1.5*QQ1LB*QQ2LB)/XBUD
          CTMP2 = QQ1LB + QQ2LB - CTMP2
          CTMP2 = QQ1LB*CTMP2
*
          CTMP3 = QQ1LB*(W + 2.0*XMUS(IQ))
          CTMP4 = 4.0*XMUS(IQ)*XBUD
          CTMP5 = SLOG/(Q1Q2*W2X)
          CTMP2 = CTMP5*(CTMP4 - CTMP3 + CTMP2)
*
          SIGTL = PIINV*2.0*XQ2*WX*(CTMP1 - CTMP2)
*****
*****     Calculator time for SIG00
*
          CTMP1 = SLOG*(2.0*(W2X**2) + 3.0*QQ1LB*QQ2LB )
          CTMP2 = QQ1LB*QQ2LB
          CTMP2 = CTMP2/TBUD
          CTMP2 = DTBUD*Q1Q2*(2.0 + CTMP2)
*
          CTMP1 = PIINV*8.0*(WX*WX)*XQ1*XQ2*(CTMP1 - CTMP2)
          CTMP2 = Q1Q2*Q1Q2*RKINV
          SIG00 = CTMP1/CTMP2

        ELSE
          SLOG  = W/XM2SQ(IQ)
          IF(SLOG.LE.1.0)GOTO 8
*
          SLOG  = SQRT(SLOG) + SQRT(SLOG-1.0)
          IF(SLOG.LE.0.0)PRINT *,' SLOG =',SLOG
#if defined(NONCLEO_DOUBLE)
          SLOG  = 2.*DLOG(SLOG)
#else
          SLOG  = 2.*ALOG(SLOG)
#endif
          DFAC  = W + QQ1LB + QQ2LB
          DFACS = DFAC**2
C      GET 2XF1
*****
*****     Calculator time for SIGTT
          CTMP1 = 1.0 - XQ1
          CTMP1 = CTMP1*CTMP1
          CTMP2 = W - 2.0*XMUS(IQ)
          CTMP2 = CTMP2/DFACS
          CTMP1 = XQ1*XQ1 + CTMP1 + XM2SQ(IQ)*CTMP2
          CTMP1 = SLOG*CTMP1
*
          CTMP2 = W/DFACS
          CTMP2 = XM2SQ(IQ)*CTMP2
          CTMP3 = 1.0 - 2.0*XQ1
          CTMP3 = CTMP3*CTMP3
          CTMP2 = BETA*(CTMP3 + CTMP2)

          SIGTT = PIINV*(CTMP1 - CTMP2)
*
*****
*****     Calculator time for SIGLT

          CTMP1 = 2.0*XMUS(IQ)*SLOG/DFAC
          CTMP2 = (1.0 - XQ1)*BETA
*
          SIGLT =PIINV*4.0*XQ1*(CTMP2 - CTMP1)
*
        ENDIF
C    GET XF1
          SIGTT = CRGFAC*SIGTT*QCHRG4(IQ)*XQ1/QQ1LB
          SIGLT = CRGFAC*SIGLT*QCHRG4(IQ)*XQ1/QQ1LB
          SIGTL = CRGFAC*SIGTL*QCHRG4(IQ)*XQ1/QQ1LB
          SIG00 = CRGFAC*SIG00*QCHRG4(IQ)*XQ1/QQ1LB
          FRTYPE(IQ,2)  = SIGTT + EPS1*SIGLT
          TTSUM = TTSUM + SIGTT
          LTSUM = LTSUM + SIGLT
          TLSUM = TLSUM + SIGTL
          SSSUM = SSSUM + SIG00
        ENDIF
        GOTO 8
18      CONTINUE
C For clearity, the terms below that look like gamma-gamma cross
C sections have had a factor of 4(pi*alpha*hbar*c)**2 factored out

C The factor above is equal to 818.596 nbs.

        TTSM = TTSUM
        FRMODS(2) =  TTSUM + EPS1*LTSUM
        WGTMOD = FRMODS(1) + FRMODS(2)
        IF(WGTMOD.NE.0)THEN
          FRMODS(1) = FRMODS(1)/WGTMOD
          FRMODS(2) = FRMODS(2)/WGTMOD
          FRMODS(3) = 0.0
        ENDIF

C***********************************************************
C
C   FORM FACTORS FOR RESONANCES
C
C  NOTE THAT NOT ALL OF THESE HAVE BEEN SPECIFIED AS YET. 9-1-90 TCJ
C
        ELSEIF(MODE2G.EQ.3)THEN
           WGTMOD = 1.0
           FF = (1.+QQ1LB/PSIM2)*(1.+QQ2LB/PSIM2)
           IF(JRES2G .EQ. 0)THEN
             IF(JPAR2G .EQ. -1) THEN

C              form factor appropriate for ETAC
               IF(FF.GT.0.)WGTMOD = (QGCM/FF**2)/XMRS2G

             ELSEIF(JPAR2G.EQ.1) THEN
C              form factor appropriate for CHI0
               IF(FF.GT.0.) WGTMOD = 1.0/FF**2
             ENDIF

           ELSEIF(JRES2G.EQ.2) THEN

             IF((JPAR2G.EQ.1).AND.(LHRS2G.EQ.0)) THEN
C             *************** NO entry yet ************************

             ELSEIF((JPAR2G.EQ.1).AND.(LHRS2G.EQ.2)) THEN
C                 form factor for CHI2
                 IF(FF.GT.0.) WGTMOD = 1.0/FF**2

             ELSEIF((JPAR2G.EQ.-1).AND.(LHRS2G.EQ.0)) THEN
C             *************** NO entry yet ************************

             ELSEIF((JPAR2G.EQ.-1).AND.(LHRS2G.EQ.2)) THEN
C             *************** NO entry yet ************************

             ENDIF
           ENDIF
        ENDIF
C
C******************************************************************
C---FINAL PRINTOUTS FOR MODE2G = 5
      IF(MODE2G .EQ. 5)THEN
        TTSUM = TTSM
        FRACQ(1) = FRTYPE(1,1) + FRTYPE(1,2) + FRTYPE(1,3)
        FRACQ(2) = FRTYPE(2,1) + FRTYPE(2,2) + FRTYPE(2,3)
        FRACQ(3) = FRTYPE(3,1) + FRTYPE(3,2) + FRTYPE(3,3)
        FRACQ(4) = FRTYPE(4,1) + FRTYPE(4,2) + FRTYPE(4,3)
        IF(WGTMOD.GT.0.0)THEN
          DO 82 IQ = 1,4
            FRACQ( IQ)   = FRACQ(IQ)/WGTMOD
            FRTYPE(IQ,1) = FRTYPE(IQ,1)/WGTMOD
            FRTYPE(IQ,2) = FRTYPE(IQ,2)/WGTMOD
            FRTYPE(IQ,3) = FRTYPE(IQ,3)/WGTMOD
 82       CONTINUE
        ENDIF
       ENDIF
C
        RETURN
      END
