*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:28  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:01  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/03 17/11/94  10.03.41  by  Alan J. Weinstein
*CMZ :  2.00/03 30/03/93  15.21.55  by  Alan J. Weinstein
* Fix so that ITFIN=2 will work
*CMZ :  2.00/01 12/05/92  13.32.33  by  CLEO II Librarian
*-- Author :
* Fix to fill AMEL2, AMF2, etc when beam energy changes.
*CMZ :  1.03/29 28/10/91  19.25.51  by  Peter C Kim
*CMZ :  1.03/17 24/07/91  18.25.54  by  Peter C Kim
*CMZ :  1.03/05 15/04/91  18.40.13  by  Peter C Kim
*CMZ :  1.02/00 12/03/91  12.50.02  by  Peter C Kim
*-- Author :    Alan Weinstein  23/12/90
      SUBROUTINE KORBEV
C.......................................................................
C.
C. KORBEV - generate KORALB event and fill QQ common.
C.
C. Inputs    : None
C.           :
C. Outputs   : None
C.
C. COMMON    :
C.
C. Calls     : KORALB(0), RBOOSF, RANP, VZERO
C. Called    : by MODUSR, at present.
C. Author    : Alan Weinstein 23/12/90
C.
C. Detailed description
C.   Generate BRs for both taus. Fill JAK1, JAK2, ENE for event.
C.   Call KORALB(0) to generate event in HEPEVT common.
C.   Fill /JET/, call DECPAR to fill MCCOMS.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
* -------------------- Argument declarations ---------------
 
* -------------------- EXTERNAL declarations ---------------
*
* -------------------- SEQUENCE declarations ---------------
* MC info
#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqprop.inc"
#include "seq/clinc/qqtrak.inc"
#include "seq/clinc/qqevnt.inc"
#include "qqlib/seq/mcgen.inc"
#include "qqlib/seq/qqbrat.inc"
#include "qqlib/seq/korbcm.inc"
#include "qqlib/seq/hepevt.inc"
*
* -------------------- Local    declarations ---------------
*
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'KORBEV' )
*
* Functions:
      REAL RANP
      INTEGER LQPMAT
*
* KORALB Control commons
      COMMON / JAKI   /  JAK1,JAK2,JAKP,JAKM,KTOM
      INTEGER            JAK1,JAK2,JAKP,JAKM,KTOM
      COMMON / BEAMS / XPB1(4),XPB2(4),KF1,KF2
      REAL             XPB1,   XPB2
      INTEGER                          KF1,KF2
      COMMON / ENERG / ENE,AEL2,AMF2,AMF,ALGEL,ALGMF,BETI,BT1,ATH2
      DOUBLE PRECISION ENE,AEL2,AMF2,AMF,ALGEL,ALGMF,BETI,BT1,ATH2
*
* HEPEVT commons with output of KORALB.
C     INTEGER NMXHEP
C     PARAMETER (NMXHEP=2000)
C     INTEGER IDHEP,ISTHEP,JDAHEP,JMOHEP,NEVHEP,NHEP
C     REAL PHEP,VHEP
C     COMMON/HEPEVT/NEVHEP,NHEP,ISTHEP(NMXHEP),IDHEP(NMXHEP),
C    &JMOHEP(2,NMXHEP),JDAHEP(2,NMXHEP),PHEP(5,NMXHEP),VHEP(4,NMXHEP)
C     SAVE  /HEPEVT/
 
* Pointer from /HEPEVT/ to /JETS/
      INTEGER IPTR(NMXHEP)
* Decay mode for Tau+, tau-
      INTEGER IDKP,IDKC
      COMMON /KORBDK/IDKP(2),IDKC(2)
* Decay flag common
* KS (indexed as in /JET/),
*    = 0 for undecayed particles (QQ will decay if unstable)
*    = 1 for decayed particles (QQ will not decay it)
*    < 0 -pointer into MLLIST (QQ will decay with this mode)
      INTEGER KS
      COMMON/DECKS/KS(250)
 
      INTEGER NCH,I,IT,IPAR,ITYP,JAK
      INTEGER KFB,NPR(40)
      REAL PB1(4),PB2(4),E1(3),E2(3),XPR(40),R
 
* -------------------- SAVE     declarations ---------------
*
* -------------------- DATA  initializations ---------------
*
* ----------------- Executable code starts here ------------
*
* Before calling KORALB(0), we modify ENE, XPB1&2, and JAK1,JAK2:
* Here is true e+e- cms energy (after beam smear in MODEVT)
      AMF=AMF*ENE/BEAMNW
      AMF2=AMF**2
      ENE = BEAMNW
      AEL2=(.51110034E-3/ENE)**2
      BT1=SQRT(1.-AMF)*SQRT(1.+AMF)
C
      XPB1(3) = BEAMNW
      XPB1(4) = BEAMNW
      XPB2(3) = -BEAMNW
      XPB2(4) = BEAMNW
*
* only generate branching fractions for tau decays:
      JAK1 = -1
      JAK2 = -1
      IF (ITFIN.NE.1) GOTO 84
 
C Generate BRs:
      DO 80 I=1,2
        R = RANP(0)
        NCH = IPLIST(2,17-I)
        IDKC(I) = 0
        IDKP(I) = IPLIST(1,17-I)-1
 82     IDKC(I) = IDKC(I)+1
        IDKP(I) = IDKP(I)+1
        IF (IDKC(I).LT.NCH.AND.R.GT.BRLIST(IDKP(I))) GOTO 82
 80   CONTINUE
C
C KoralB handles it if JAK1,JAK2 <= 19; otherwise, QQ.
      JAK = MLLIST(3,IPLIST(1,16)+IDKC(1)-1)-2000
      IF(JAK.GE.0.AND.JAK.LE.19) JAK1 = JAK
C
      JAK = MLLIST(3,IPLIST(1,15)+IDKC(2)-1)-2000
      IF(JAK.GE.0.AND.JAK.LE.19) JAK2 = JAK
*
  84  CONTINUE
*
* KORALB will generate an event at nominal ECM, filling LUNCOM
* (all inputs are ignored if first input=0).
      CALL KORALB(0 ,KFB,PB1,E1,-KFB,PB2,E2,XPR,NPR)
C     **********************************************
C PRINTING FIRST EVENTS PRODUCTION PROCESS ONLY
C      IF(IEV.LE.1)   CALL DUMPB4
C
C copy particles from /HEPEVT/ to /JETS/
      CALL VZERO(KS,250)
      N = 0
      DO 100 IT = 1,MIN(NHEP,250)
        IPTR(IT) = 0
C get rid of incoming beam particles.
        IF (ISTHEP(IT).GE.3) GOTO 100
C Copy particle in, store /HEPEVT/ line number so parent history is intact.
        N = N+1
        IPTR(IT) = N
C replace Lund particle type with QQ particle type
C at present, KoralB only gives particles with Lundid between -38 and 38.
        ITYP = LQPMAT(IDHEP(IT),1)
        K(N,2) = ITYP
C Store decay history.
        KS(N) = 0
        IF (JDAHEP(1,IT).GE.1) KS(N) = 1
C Store channel number of tau decay. If undecayed, store pointer.
        IF (ITYP.EQ.16) THEN
          KS(N) = IDKC(1)
          IF (JAK1.EQ.-1) KS(N) = -IDKP(1)
        ELSEIF (ITYP.EQ.15) THEN
          KS(N) = IDKC(2)
          IF (JAK2.EQ.-1) KS(N) = -IDKP(2)
        END IF
C Store parent line number in /JETS/
        IPAR = JMOHEP(1,IT)
        K(N,1) = 0
        IF (IPAR.GT.0) K(N,1) = -IPTR(IPAR)
C Finally, 4-vector.
        DO 98 I=1,5
          P(N,I) = PHEP(I,IT)
   98   CONTINUE
  100 CONTINUE
C
C Now have QQ decay the particles that need decaying and fill MCCOMS.
      CALL DECAKS(.TRUE.)
 
      RETURN
      END
