*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:42  eugenio
* Initial revision
*
* Revision 1.2  1996/07/17 07:30:25  clib
* Save event history correctly when there is final state radiation.
*
* Revision 1.1.1.1  1994/10/08  02:21:27  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 16/09/94  02.27.21  by  Paul Avery
*CMZ :  1.03/68 30/08/93  13.44.35  by  Peter C Kim
*-- Author :
*-- Author :    Alan Weinstein 21/07/93
* 17/10/96 Lynn Garren: Add double precision conditionals.
      SUBROUTINE ADDPHO
C.......................................................................
C.
C. ADDPHO - Add photon radiation to all but primary particles in QQ common
C.
C. COMMON    : HEPEVT, QQTRAK, QQPROP

C. Calls     :
C. Called    :
C. Author    : Alan Weinstein 21/07/93
C.
C  Add photon radiation to all but primary particles in QQ common,
C  using PHOTOS.
C PHOTOS works off of the HEPEVT common, so we must first copy
C  the contents of QQTRAK into HEPEVT, run PHOTOS, then copy back.
C                                     AJW, 7/21/93
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C- Argument  declarations

C- Sequences

#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqprop.inc"
#include "seq/clinc/qqtrak.inc"
#include "seq/clinc/qqvrtx.inc"
#include "qqlib/seq/hepevt.inc"

C-- External variables

      INTEGER LQPMAT
      EXTERNAL LQPMAT

C-- Local variables

      INTEGER I,J,IP,ITYP,NCALL,NOLD

C-- Data statements

      DATA NCALL/0/

C-- Executable code starts here-----------------------------------------------
C
C Initialize PHOTOS:
      IF (NCALL.EQ.0) THEN
        CALL PHOINI
      END IF
      NCALL = NCALL+1
      NOLD = NTRKQQ

C Don't do anything if MCCOMS is already full!
      IF (NTRKQQ.GE.MCTRK) RETURN
C
C-- Fill HEPEVT common with contents of QQTRAK
      DO 10 IP=1,NTRKQQ

        PHEP(5,IP) = 0.
        DO 11 J=1,4
          PHEP(J,IP) = P4QQ(J,IP)
          IF (J.LE.3) PHEP(5,IP)=PHEP(5,IP)-PHEP(J,IP)**2
          IF (J.EQ.4) PHEP(5,IP)=PHEP(5,IP)+PHEP(J,IP)**2
  11    CONTINUE
#if defined(NONCLEO_DOUBLE)
        PHEP(5,IP) = SQRT(DMAX1(PHEP(5,IP),0.01D0))
#else
        PHEP(5,IP) = SQRT(MAX(PHEP(5,IP),0.01))
#endif

        IF (NDAUTV(IP).GT.0) THEN
          JDAHEP(1,IP) = IDAUTV(IP)
          JDAHEP(2,IP) = IDAUTV(IP)+NDAUTV(IP)-1
        ELSE
          JDAHEP(1,IP) = 0
          JDAHEP(2,IP) = 0
        END IF
        JMOHEP(1,IP) = IPRNTV(IP)
        JMOHEP(2,IP) = 0
        IDHEP(IP) = LQPMAT(ITYPEV(IP,1),2)
  10  CONTINUE
      NHEP = NTRKQQ
C
C DEBUG:
CCC   CALL HEPLST(6)
C
C-- Add decay radiation to decay chains of all primary particles:
      DO 20 IP=1,NTRKQQ
        IF (JMOHEP(1,IP).EQ.0.AND.JDAHEP(1,IP).GT.0) CALL PHOTOS(IP)
  20  CONTINUE
C
C Now put the modified event back in QQTRAK if anything has changed:
      IF (NHEP.LE.NTRKQQ) GOTO 999
C
      NSTBMC = 0
      NCHGMC = 0
      CALL VZERO (ISTBMC, MCTRK)
C
C Loop over all QQ tracks, copying in info from HEPEVT common:
      IP = 0
  30  IP = IP+1
C
C Copy over pointers to daughters and parent, and 4-vector
      IF (JDAHEP(1,IP).EQ.0) THEN
        NDAUTV(IP) = 0
      ELSE
        NDAUTV(IP) = JDAHEP(2,IP)-JDAHEP(1,IP)+1
      END IF
      IDAUTV(IP) = JDAHEP(1,IP)
      IPRNTV(IP) = JMOHEP(1,IP)
      DO 32 J=1,4
        P4QQ(J,IP) = PHEP(J,IP)
  32  CONTINUE
C
C Look for an added photon, and make sure there is room in MCCOMS!
      IF (IDHEP(IP).EQ.22 .AND. ITYPEV(IP,1).NE.1
     1    .AND. NTRKQQ.LT.MCTRK) THEN
C Move all subsequent particles in MCCOMS up one line:
        DO 31 J = NTRKQQ,IP,-1
          ITYPEV(J+1,1) = ITYPEV(J,1)
          ITYPEV(J+1,2) = ITYPEV(J,2)
          IDECSV(J+1) = IDECSV(J)
          ISTBMC(J+1) = ISTBMC(J)
          IVPROD(J+1) = IVPROD(J)
          IVDECA(J+1) = IVDECA(J)
          HELCQQ(J+1) = HELCQQ(J)
  31    CONTINUE
C And bump up NTRKQQ
        NTRKQQ = NTRKQQ+1
C here is an added photon:
        ITYPEV(IP,1) = 1
        ITYPEV(IP,2) = 1
        IDECSV(IP) = 0
        ISTBMC(IP) = 0
C Production vertex is same as previous line:
        IVPROD(IP) = IVPROD(IP-1)
        IVDECA(IP) = 0
        HELCQQ(IP) = 0
      END IF

C-- fix vertex info, and store stable particle information
      IF (IVDECA(IP).GT.0) THEN
        J = IVDECA(IP)
        ITRKIN(J) = IP
        NTRKOU(J) = NDAUTV(IP)
        ITRKOU(J) = IDAUTV(IP)
      END IF

C Do the stable particle list:
      ITYP = ITYPEV(IP,1)
      IF(ITYP .GE. 0 .AND. IDECSV(IP) .EQ. 0) THEN
        NSTBMC = NSTBMC + 1
        ISTBMC(IP) = NSTBMC
        IDSTBL(NSTBMC) = IP
        IF(CHARGE(ITYP) .NE. 0.) NCHGMC = NCHGMC + 1
      ENDIF

C If we're not done with the list, loop back:
      IF (IP.LT.NTRKQQ) GOTO 30

C-- # tracks gen. by qq
      NTRKMC = NTRKQQ
C-- # stable particles gen. by qq
      NSTBQQ = NSTBMC
C-- # charged stable part. gen. by qq
      NCHGQQ = NCHGMC
C
C DEBUG:
C     WRITE (6,986) IEVTQQ,NOLD,NTRKQQ
C 986 FORMAT(' Radiated photon! Event, Nold, Nnew =',3I6)
C     CALL HEPLST(6)

  999 RETURN
      END
