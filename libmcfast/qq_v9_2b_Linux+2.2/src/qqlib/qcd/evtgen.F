*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:40  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:31  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 22/09/94  00.12.28  by  Paul Avery
*CMZ :  1.02/00 05/06/90  15.41.33  by  Jorge L. Rodriguez
*-- Author :
      SUBROUTINE EVTGEN(IFL,ECM,IMODE,NSTART,IER)
C.......................................................................
C.
C. EVTGEN -
C.
C. Inputs    :
C. Outputs   :
C.
C. COMMON    : QQPROP MCGEN
C.
C. Calls     : QQJET QQGGEN GGGGEN ANGGEN
C. Called    :
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

*- Argument declarations
      INTEGER IFL, IMODE, NSTART, IER
      REAL    ECM

*- External declarations
      REAL     RANP
      EXTERNAL RANP
*
*- Sequence declarations
#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqprop.inc"
#include "qqlib/seq/mcgen.inc"

      INTEGER ISEED
      COMMON/RANDM/ISEED
*
*- Local declarations
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'EVTGEN' )

#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION DECM
#endif
      INTEGER IFLC, ITER
      REAL     QME
*
C-- Minimum photon energies for various quarks
      REAL XMSMIN(6)
      DATA XMSMIN/.30,.30,1.00,3.8,10.56,41./
*
*- Executable code starts here
*
      IER = 1

C-- LASTN = Last place filled in P(I,J)
      LASTN=NSTART

C-- Choose flavour (for IFL>6) according to QED
      IFLC=IFL

C-- Definite quark flavor (1-6) .... check photon energy
      IF (IFL .LE. 6) THEN

C-- kfr 6/4/86
         IF(IFL .GT. 0) THEN
            IF(ECM .LT. XMSMIN(IFLC))RETURN
         ENDIF
         GOTO 101

      ENDIF

C-- Avoid infinite loop
      ITER = 0
100   ITER = ITER + 1
      IF(ITER .GT. 10)RETURN

      IFLC=MAX0(1,INT(6.*RANP(ISEED)-2.))
C
C....... CHANGED TEST FOR C AND B QUARKS TO BE 2 MESONS AS
C        LOWEST ECM ALLOWED.NOW CAN CHANGE PAR(9) WITHOUT
C        SCREWING UP THIS.GILCHRIESE SEPT 30,1981

#if defined(NONCLEO_DOUBLE)
      DECM = ECM
      IF (DECM .GT. 2.*AMASS(30)) THEN
         IF(4. .GT. 10.*RANP(ISEED))        IFLC=4
      ENDIF

      IF (DECM .GT. 2.*AMASS(36)) THEN
         IF(1. .GT. 11.*RANP(ISEED))        IFLC=5
      ENDIF
#else
      IF (ECM .GT. 2.*AMASS(30)) THEN
         IF(4. .GT. 10.*RANP(ISEED))        IFLC=4
      ENDIF

      IF (ECM .GT. 2.*AMASS(36)) THEN
         IF(1. .GT. 11.*RANP(ISEED))        IFLC=5
      ENDIF
#endif

      IF (ECM .GT. 2.*QMAS(6)+PAR(9)) THEN
         IF(4. .GT. 15.*RANP(ISEED))        IFLC=6
      ENDIF

      IF (IFL.EQ.7 .AND. IFLC.EQ.6)                GOTO 100

C-- FIX ******** IFL=10  ==> U,D,S,C ONLY  **********
      IF (IFL.EQ.10 .AND. IFLC.GT.4)               GOTO 100
      QME=(2.*QMAS(IFLC)/ECM)**2
      IF (QME .GE. 1.0)                            GOTO 100
      IF ((1.+0.5*QME)*SQRT(1.-QME).LT.RANP(ISEED)) GOTO 100
      IF (ECM .LT. XMSMIN(IFLC))                   GOTO 100

101   IER = 0
      IF (RANP(ISEED) .GT. 0.5) IFLC=-IFLC
CPA   IFLC=IFLC*(-1)**INT(RANP(ISEED)+0.5)

C-- Generate event and angular orientation
      IF (IFL.NE.0 .AND. IMODE.LE.0) CALL QQJET(IFLC,ECM)
      IF (IFL.NE.0 .AND. IMODE.GE.1) CALL QQGGEN(IFLC,ECM)
      IF (IFL.EQ.0)                  CALL GGGGEN(ECM,IMODE)

C     CALL LIST
      CALL ANGGEN(ECM,PAR(2))

      RETURN
      END
