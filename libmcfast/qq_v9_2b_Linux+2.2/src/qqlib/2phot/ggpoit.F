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
*CMZ :  1.03/15 05/04/91  19.51.36  by  R.A.FULTON
*-- Author :
      FUNCTION GGPOIT(SINV,IQRK,QRKM,NUMQRK)
C********************************************
C Models 1,2,5 => calculates point cross sections
C Model 5      => selects quark type for model 5.
C GGPOIT value is returned as the sum over all requested
C point-particle cross sections at fixed s = 1/sinv.
C Model 5      => IQRK = energy allowed QUARK type (in order udsc,
C                      =  0 if s is below all thresholds
C                      = -1 just above c-cbar threshold).
C********************************************
        REAL    GGPOIT
#include "qqlib/gggseq/ggmodl.inc"
#include "qqlib/gggseq/ggprms.inc"
#include "qqlib/gggseq/jetwgt.inc"
#include "qqlib/gggseq/fragmt.inc"
#include "qqlib/seq/ludat2.inc"

        REAL     BETCOS, CMBET, CMBSQ, CRSCTN, DUM, ECMS, QRKM
        REAL     QTOT, SINV, XLOG, XX
        REAL     QMAS(4),QCHRG4(4),QFRAC(4),CTHRSH(3)
        INTEGER  I, ICALL, IQRK, ITQ, MTST, NPOIT, NUMQRK
        INTEGER  NQRK2G
        LOGICAL  LPOIT(4), LFIRST

        DOUBLE PRECISION RMAS2(4),CSQ2GX(4),SSQ2GX,SINVD,CMBSQ1,VAL
        CHARACTER*4 QNAM(4)

        INTEGER     LUCOMP
        REAL        RANP
        EXTERNAL    LUCOMP, RANP

      DATA QNAM/'  U ','  D ','  S ','  C '/
      DATA LFIRST/.TRUE./
      DATA QMAS,QCHRG4/.325,.325,.500,1.600,2.,1.,1.,2./
C
      ECMS  = SQRT(1.0/SINV)
      SINVD = SINV
C     set-up on first call
      IF( LFIRST )THEN
        LFIRST = .FALSE.
        IF(MODE2G .NE. 5)THEN
C         here we set up models 1 and 2
          NPOIT     = 1
          LPOIT(1)  = .TRUE.
          SSQ2GX    = 1.0 - COS2GX**2
          RMAS2(1)  = 4.*(PAIR2G**2)
          CSQ2GX(1) = RMAS2(1)*COS2GX**2
          QCHRG4(1) = 1.0
        ELSEIF(MODE2G .EQ. 5)THEN
          NPOIT = NUMQRK
C         change parameters for all pion model
          NQRK2G = 0
          SSQ2GX = 1.0 - COS2GX**2
          DO 7 I = 1,4
            LPOIT(I) = .FALSE.
            MTST = MOD(IRES2G,10**I) - MOD(IRES2G,10**(I-1))
            IF(MTST .EQ. 0)GOTO 7
            IF(SQRT(WMX2G) .LE. 2.0*QMAS(I))THEN
               WRITE(6,50) QNAM(I)
  50           FORMAT('0>>>>>GGINIT ERROR.'/
     +            '      MAXIMUM GG MASS INCONSISTANT WITH ',
     +            'MASS OF REQUESTED',A4, ' QUARKS.'/
     +            '      THIS TYPE WILL BE IGNORED.')
               IRES2G = IRES2G - MTST
               GOTO 7
            ENDIF
            LPOIT(I)  = .TRUE.
            NQRK2G    = NQRK2G + 1
            RMAS2(I)  = 4.0*QMAS(I)**2
            CSQ2GX(I) = RMAS2(I)*COS2GX**2
            QCHRG4(I) = (QCHRG4(I)/3.)**4
   7      CONTINUE
C        c-cbar thresholds
CTCJ   8-28-90  THESE CHARM THRESHOLDS REALLY AREN'T HANDLED PROPERLY
          IF(LPOIT(4))THEN
            CTHRSH(1) = PMAS(LUCOMP(10423), 1) + PMAS(LUCOMP(10421), 1)
            CTHRSH(2) = 2.0*PMAS(LUCOMP(10421), 1)
            CTHRSH(3) = 4.4
            IF(NQRK2G.EQ.0)GOTO 100
          ENDIF
        ENDIF
      ENDIF
C
C     normal entry to evaluate total gg cross section at S = 1./SINV
      GGPOIT=0.

C     for 3jet model use gamma-gamma cross section
      IF(F2TYPE.GE.3 .AND. F2TYPE.LE.8 .AND. F2TYPE .NE. 5)THEN
        XX = RANP(DUM)
        QTOT = 0.0
        IQRK = 0
        DO 21 ITQ = 1,4
          IF(FRACQ(ITQ) .NE. 0.0)THEN
            QTOT = QTOT + FRACQ(ITQ)
            IF(QTOT .GE. XX)THEN
              IQRK = ITQ
              QRKM = QMAS(IQRK)
              GOTO 9000
            ENDIF
          ENDIF
 21       CONTINUE
      ENDIF

      DO 20 I = 1,NPOIT
        QFRAC(I)=0.
C       Is quark tobe used
        IF(LPOIT(I))THEN
         CMBSQ1 = RMAS2(I)*SINVD
C        Is enough energy for this quark is available
         IF (CMBSQ1 .LT. 1.0)THEN
          CMBSQ  = 1.0 - CMBSQ1
          CMBET  = SQRT(CMBSQ)
          VAL    = SSQ2GX + CSQ2GX(I)*SINVD
          BETCOS = CMBET*COS2GX
          XLOG   = 2.0*ALOG(1.0 + BETCOS) - DLOG(VAL)

C         boson/fermion consideration
          IF(MODE2G.EQ.2)THEN
C           Point boson cross section
            CRSCTN =  0.5*((CMBSQ1**2-2.*CMBSQ1)
     +               *0.5*XLOG + BETCOS*(1.+(CMBSQ1*(CMBSQ1/VAL))))

          ELSE
C           Point fermion cross section
            CRSCTN=(3.0 - CMBSQ**2)*0.5*XLOG
     +                        - BETCOS*(1.0 + (CMBSQ1*(CMBSQ1/VAL)))
          ENDIF
          QFRAC(I) = QCHRG4(I)*CRSCTN
          IF(I.EQ.4 .AND. ECMS .LE. CTHRSH(3))QFRAC(4)=0.
          GGPOIT   = GGPOIT + QFRAC(I)
         ENDIF
        ENDIF
  20  CONTINUE

  22  CONTINUE
C     End models 1 and 2
      IF(MODE2G.EQ.1 .OR. MODE2G.EQ.2)GOTO 9000
C     just use up quarks mass = 0.325 gev test only*
      IF(NPOIT .EQ. 1)THEN
        IQRK  = 1
        QRKM  = QMAS(1)
        GOTO 9000
      ENDIF

C     select quark type for model 5
      IQRK = 0
      IF(GGPOIT .EQ. 0)GOTO 9000
      XX   = RANP(DUM)
      QTOT = 0.
      DO 30 I = 1,NPOIT
        IF(LPOIT(I))THEN
          IQRK = I
          QRKM = QMAS(I)
          QTOT = QTOT + QFRAC(I)/GGPOIT
          IF(XX .LT. QTOT)GOTO 35
        ENDIF
  30  CONTINUE
  35  CONTINUE

C     handle charm threshold if needed
      IF(IQRK .NE. 4)GOTO 9000
      IF(ECMS .GT. CTHRSH(3))GOTO 9000
      GOTO 22
9000  CONTINUE
      RETURN
C     not enough energy to make any quarks
 100  WRITE(6,200)
 200  FORMAT(1H1,'>>>>>GGINIT ERROR.'/
     +  '     MAXIMUM GG MASS INCONSISTENT WITH ALL REQUESTED TYPES.'/
     +  '     I GIVE UP.')
      STOP
      END
