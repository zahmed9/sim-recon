*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:36  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:31  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 15/10/93  10.37.04  by  Paul Avery
*CMZ :  1.01/02 19/11/90  19.29.49  by  Paul Avery
*CMZ :  1.01/00 03/11/90  17.35.09  by  Paul Avery
*CMZ :          30/10/90  12.03.20  by  Paul Avery
*>> Author :
      SUBROUTINE QQRCHN

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C  Process CHANNEL command
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqprop.inc"
#include "qqlib/seq/qqbrat.inc"
#include "qqlib/seq/readinp.inc"

C     External declarations
      INTEGER QQRINP, QQRINQ
      EXTERNAL QQRINP, QQRINQ

C     Calling arguments
*
C     Local variables
      REAL SCALE
      INTEGER I, J, IPART, NDAU, NDCHAN, IDCHAN(20)
      CHARACTER GNAME(4)*4

      DATA NDCHAN, IDCHAN/20, 1, 2, 18*3/
      DATA GNAME/'GG','GGG','QQ','QQG'/
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      CALL QQRGLN(NDCHAN, IDCHAN, NREAD, LIST, CLIST, LERROR)
      IF(LERROR) GOTO 9990
      IF(NREAD .LT. 2) GOTO 9991
      NDAU = NREAD - 2

C     Check if too many daughters or channels
      IF(NDAU + NDGHTR .GT. MCDTRS) GOTO 9992
      IF(NBRLST .GE. MCHANS) GOTO 9993

C     If there are helicity states defined, make sure there is room
      IF(NPRB .GT. 0) THEN
        IF(NHLPRB+NPRB .GT. MHLPRB) GOTO 9994
        IF(NHLLST+NDAU*NPRB .GT. MHLLST) GOTO 9995
      ENDIF

C     If there are angular_helicity commands, make sure there is room
      IF(NHEL .GT. 0) THEN
        IF(NHLANG+NHEL .GT. MHLANG) GOTO 9996
      ENDIF

C     Add daughters to list (check particle and qqbar list)
      DO 140 I=1,NDAU
        IPART = QQRINP(CLIST(I))
        IF(IPART .LT. 0) THEN
          IPART = -QQRINQ(CLIST(I))
          IF(IPART .EQ. 0) GOTO 9997
        ENDIF
        IDLIST(I+NDGHTR) = IPART
140   CONTINUE
      NBRLST = NBRLST + 1
      NCHAN = NCHAN + 1
      BRLIST(NBRLST) = XLIST(2)
      CALL UCOPY(ANGS, AGLIST(1,NBRLST), 7)

      MLLIST(1,NBRLST) = NDAU
      MLLIST(2,NBRLST) = NDGHTR + 1
      MLLIST(3,NBRLST) = LIST(1)
      MLLIST(4,NBRLST) = NPRB
      MLLIST(5,NBRLST) = NHEL
      LCPTAG(NBRLST)   = LCPTG
      NDGHTR = NDGHTR + NDAU

C     If any HELICITY statements used in this decay, fill up database and
C     pointers to it
      IF(NPRB .GT. 0) THEN
        MLLIST(6,NBRLST) = NHLPRB + 1
        SCALE = 0
        DO 160 I=1,NPRB
          SCALE = SCALE + PROBH(I)
          IHLPRB(NHLPRB+I) = NHLLST + 1
          HELPRB(NHLPRB+I) = SCALE
          DO 155 J=1,NDAU
            HELLST(NHLLST+J) = HEL(J,I)
155       CONTINUE
          NHLLST = NHLLST + NDAU
160     CONTINUE

C     Normalize the probabilities to 1.0
        IF(SCALE .LE. 0.) GOTO 9998
        DO 165 I=1,NPRB
          HELPRB(NHLPRB+I) = HELPRB(NHLPRB+I) / SCALE
165     CONTINUE
        NHLPRB = NHLPRB + NPRB
      ENDIF

C     If any ANGULAR_HELICITY statements used in this decay, fill up database
      IF(NHEL .GT. 0) THEN
        MLLIST(7,NBRLST) = NHLANG + 1
        DO 170 I=1,NHEL
          HELANG(NHLANG+I) = ANGH(1,I)
          COFANG(1,NHLANG+I) = ANGH(2,I)
          COFANG(2,NHLANG+I) = ANGH(3,I)
          COFANG(3,NHLANG+I) = ANGH(4,I)
          COFANG(4,NHLANG+I) = ANGH(5,I)
          COFANG(5,NHLANG+I) = ANGH(6,I)
          COFANG(6,NHLANG+I) = ANGH(7,I)
          COFANG(7,NHLANG+I) = ANGH(8,I)
170     CONTINUE
        NHLANG = NHLANG + NHEL
      ENDIF

C     If this decay is a CP eigenstate, fill up database
      IF(LCPEIG) THEN
        IF(NCPLST .GE. MCPLST) GOTO 9998
        NCPLST = NCPLST + 1
        ICPLST(NCPLST) = NBRLST
        CPSNPH(NCPLST) = SINPHI
        CPLIST(NCPLST) = XLIST(2)
        MLLIST(8,NBRLST) = NCPLST
        NCHNCP = NCHNCP + 1
      ENDIF

C     Normal exit
      CALL QQRINI
      LERROR = .FALSE.
      RETURN

C     Error exits
9990  CALL ZERTYP('.TRUE.')
      LERROR = .TRUE.
      RETURN

9991  CALL ZERTYP('.TRUE.')
      LERROR = .TRUE.
      RETURN

9992  CALL ZERTYP('.TRUE.')
      LERROR = .TRUE.
      RETURN

9993  CALL ZERTYP('.TRUE.')
      LERROR = .TRUE.
      RETURN

9994  CALL ZERTYP('.TRUE.')
      LERROR = .TRUE.
      RETURN

9995  CALL ZERTYP('.TRUE.')
      LERROR = .TRUE.
      RETURN

9996  CALL ZERTYP('.TRUE.')
      LERROR = .TRUE.
      RETURN

9997  CALL ZERTYP('.TRUE.')
      LERROR = .TRUE.
      RETURN

9998  CALL ZERTYP('.TRUE.')
      LERROR = .TRUE.
      RETURN

      END
