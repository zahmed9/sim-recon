*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:15  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  17:59:56  nk
* Consolidation
*
* Revision 1.2  1994/10/06 16:46:20  zfiles
* Do not use CALL MESLOG. (RCS keywords will not be printed out.)
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/30 02/11/90  09.24.40  by  B. Heltsley
* fix up for nonCLEVER version
*CMZ :          22/11/89  19.25.42  by  B. Heltsley
* fix check on record type
*CMZ :          15/11/89  22.12.29  by  B. Heltsley
* fix to type out record type if not event
*CMZ :          13/04/89  13.06.17  by  R. Namjoshi
*-- Author :    R. Namjoshi   18/07/88
      SUBROUTINE MESCON
C.......................................................................
C.
C. MESCON - Output the context message if changed
C.
C. Inputs    : None
C. Outputs   : None
C.
C. COMMON    : MESBUF MESREP
C. Calls     : MESDAC MESREV MESPUT CLRNAM LENOCC
C. Called    : MESROU
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
* -------------------- Argument declarations ---------------
* None
* -------------------- EXTERNAL declarations ---------------

      EXTERNAL LENOCC
      INTEGER  LENOCC

* -------------------- SEQUENCE declarations ---------------

#if defined(CLEO_CLEVER)
#include "seq/clever/cldtype.inc"
#endif

#include "seq/clutil/mesrep.inc"

#include "cleoks/cluseq/mesbuf.inc"

* -------------------- Local    declarations ---------------
      CHARACTER*(*) MRNAME
      PARAMETER(    MRNAME = 'MESCON' )
*
      CHARACTER*11 CDATE, CTIME
      CHARACTER*26 RECNAM
      INTEGER      IRUN , IEVT  , ORUN , OEVT, ITYP, IOERR, OTYP
*
* -------------------- SAVE     declarations ---------------
      SAVE    ORUN, OEVT, OTYP
* -------------------- DATA  initializations ---------------
      DATA    ORUN, OEVT, OTYP / 0, 0, 0 /
* ----------------- Executable code starts here ------------
C
C== Get run and event number, no context if both are zero
C
#if defined(CLEO_CLEVER)
      CALL MESREV( IRUN, IEVT, ITYP )
#endif
#if !defined(CLEO_CLEVER)
      IRUN = 0
      IEVT = 0
      CALL DVGRUN( IRUN, IEVT )
      ITYP = 0
#endif
      IF( IRUN.NE.0 .AND. IEVT.NE.0 ) THEN
*- Changed?
         IF( IRUN.NE.ORUN .OR. IEVT.NE.OEVT .OR. OTYP .NE. ITYP ) THEN
            CALL MESDAC( CDATE, CTIME )
#if defined(CLEO_CLEVER)
            IF( ITYP .EQ. DTDEVT .OR. ITYP .EQ. DTMEVT .OR.
     *          ITYP .EQ. DTCEVT ) THEN
#endif
               WRITE(CHMBUF,10000,IOSTAT=IOERR) CDATE, CTIME, IRUN, IEVT
#if defined(CLEO_CLEVER)
            ELSE
               CALL CLRNAM( ITYP, RECNAM )

               WRITE(CHMBUF,10001,IOSTAT=IOERR) CDATE, CTIME, IRUN,
     +            RECNAM( 1 : LENOCC( RECNAM ) ), IEVT
            ENDIF
#endif
            CALL MESPUT(1,0)
            ORUN = IRUN
            OEVT = IEVT
            OTYP = ITYP
         ENDIF
      ENDIF

      RETURN
*
10000 FORMAT(' MESLOG-I- ', A11, 1X, A11, ' Run:', I6, ' Event:', I6 )
10001 FORMAT(' MESLOG-I- ', A11, 1X, A11, ' Run:', I6, 1X,
     +         A, ' Record:', I5 )
*
      END
