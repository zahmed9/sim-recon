*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:37  eugenio
* Initial revision
*
* Revision 1.3  1996/02/16 19:59:48  zfiles
* Primary quark flavor in Continuum events saved in IQQFLV
*
* Revision 1.2  1995/08/24  16:51:29  zfiles
* Fix bugs in in event decay history for Upsilon decays,
* one is Jetset, the other in decadl.F
* Fix for boosting in case of asymetric beams.
*
* Revision 1.1.1.1  1994/10/08  02:21:34  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 04/10/94  16.28.57  by  Paul Avery
*CMZ :  1.03/49 21/09/92  14.02.31  by  Peter C Kim
*CMZ :  1.03/15 22/07/91  21.14.46  by  Peter C Kim
*CMZ :  1.03/04 10/04/91  14.23.06  by  Peter C Kim
*CMZ :  1.03/00 02/04/91  14.57.33  by  Peter C Kim
*CMZ :  1.02/00 21/02/91  11.12.39  by  Peter C Kim
*-- Author :

      SUBROUTINE QMLUND
C-----------------------------------------------------------------------
C  Main LUND program that generates events
C
C-----------------------------------------------------------------------

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqtrak.inc"
#include "qqlib/seq/qqcntl.inc"
#include "seq/clinc/qqevnt.inc"
#include "seq/clinc/qqbmst.inc"
#include "qqlib/seq/qqluns.inc"
#include "qqlib/seq/jetscl.inc"
#include "geant/gcdes/ludat1.inc"

C-- External variables

      INTEGER QQRINP,LQPMAT
      REAL    RANP,ULANGL
      EXTERNAL QQRINP,LQPMAT,RANP,ULANGL

C-- Local variables

      INTEGER I,LEVTYP, QCODE,LCODE
      REAL EFINAL,CROSS,EGAM,ERES,XK,PME
      REAL CTHM,CTHE,STHE,THEK,PHIK
      REAL RANWID
      Real BETA

      REAL RESMAS,WRESON,ECMMAX,ECMMIN,TRAD,RATMX,ERES2
      COMMON /MOD14/RESMAS,WRESON,ECMMAX,ECMMIN,TRAD,RATMX,ERES2

C     Get unit numbers -- Eliminated 10-9-93 (PA)
CPA      CALL DVLUNS(LTTIQQ, LTTOQQ, LOUTQQ, LTMPQQ, LTINQQ, LTOUQQ)

C-- Event type to be generated.
C
C          1 : e+e- --> qq=
C
C          2 : e+e- --> ggg
C
C--------------------------------
C DISABLED 3 : Insert a single particle of user-defined 4-vector.
C
C                  e.g.  GOD -->  D*+
C---------------------------------------
C          4 : (bb=) resonance production with proper radiative tails
C
C                  e.g.  e+e-  -->  Y(3S)  -->  Y(1S) pi+ pi-
C
C         10 : User-defined event type


      LEVTYP = MODEL - 10
      IF (LEVTYP.LT.1.OR.LEVTYP.GT.10) GOTO 9001

C==================================================================

      IF     (LEVTYP.EQ.1)  THEN
                             CALL LUEEVT(IQTYPE,ECM)
C save primary quark type
                             IQQFLV = MSTU(161)

        IF ( BMPSQQ .NE. BMNGQQ ) THEN
          BETA = (BMPSQQ-BMNGQQ ) / (BMPSQQ+BMNGQQ)
          Call LUROBO ( 0.0, 0.0, 0.0, 0.0, BETA )
        ENDIF
      ELSEIF (LEVTYP.EQ.2) THEN
        CALL LUONIA(IQTYPE,ECM)
        IF ( BMPSQQ .NE. BMNGQQ ) THEN
          BETA = (BMPSQQ-BMNGQQ ) / (BMPSQQ+BMNGQQ)
          Call LUROBO ( 0.0, 0.0, 0.0, 0.0, BETA )
        ENDIF
      ELSEIF (LEVTYP.EQ.3) THEN


      ELSEIF (LEVTYP.EQ.4) THEN

C-- narrow resonance production with radiative tails

        IF(WRESON.GE.0.0001) GOTO 499

 400    EFINAL = ECMMIN + RANP(0)*(ECMMAX-ECMMIN)
        CROSS = EXP(-(ECM-EFINAL)**2.0*0.5/ERES2)
     *          * (2.0/EFINAL)**TRAD / (EFINAL - RESMAS)**(1.-TRAD)
        IF(RANP(0).GT.CROSS/RATMX) GOTO 400

        EGAM = (EFINAL*EFINAL - RESMAS*RESMAS) * 0.5 / EFINAL
        ERES = (EFINAL*EFINAL + RESMAS*RESMAS) * 0.5 / EFINAL

C...Photon polar and azimuthal angle.

        XK = EGAM*2.0/EFINAL
        PME=2.*(0.000511/EFINAL)**2
 410    CTHM=PME*(2./PME)**RANP(0)
        IF(1. - (XK**2*CTHM*(1.-0.5*CTHM)
     *             + 2.*(1.-XK)*PME/MAX(PME,CTHM*(1.-0.5*CTHM)))
     *      / (1.+(1.-XK)**2) .LT. RANP(0)) GOTO 410
        CTHE=1.-CTHM
        IF(RANP(0).GT.0.5) CTHE=-CTHE
        STHE=SQRT(MAX(0.,(CTHM-PME)*(2.-CTHM)))
        THEK=ULANGL(CTHE,STHE)
        PHIK=6.2831854*RANP(0)

        CALL LU1ENT(1,22,EGAM,THEK,PHIK)
        QCODE = QQRINP(CRESON)
        LCODE = LQPMAT(QCODE,2)
        CALL LU1ENT(2,LCODE,ERES,-THEK,-PHIK)
        CALL LUEXEC

        ENERNW = EFINAL
        BEAMNW = ENERNW*0.5
        BEAMP  = ENERNW*BMPSQQ/(BMPSQQ+BMNGQQ)
        BEAMN  = ENERNW*BMNGQQ/(BMPSQQ+BMNGQQ)

        P4CMQQ(1) = 0.0
        P4CMQQ(2) = 0.0
        P4CMQQ(3) = 0.0
        P4CMQQ(4) = ENERNW

 499    CONTINUE

      ELSEIF (LEVTYP.EQ.10) THEN
                                     CALL LUUSER
      ENDIF

C-- Remove unwanted quarks and partons

      IF(LXEDIT.EQ.1) CALL LUEDIT(1314)

C-- Boost/rotate the ECM system

      IF(BSTECM(6).EQ.1.0)
     *   CALL LUROBO(BSTECM(1),BSTECM(2),
     *               BSTECM(3)/ECM,BSTECM(4)/ECM,BSTECM(5)/ECM)

C-- List the LUND event record

      IF(LNDDMP.EQ.1) THEN
        IF(IEVTQQ.LE.NDUMP) CALL LULIST(1)
      ENDIF

C-- Move particles from /LUJETS/ into /JET/
C   Decay unstable particles according to QQ and fill QQTRAK

      CALL DECADL

9001  CONTINUE

      RETURN
      END



