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
* Revision 1.2  1994/10/06 16:46:14  zfiles
* Do not use CALL MESLOG. (RCS keywords will not be printed out.)
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
#if defined(CLEO_CLEVER)
*CMZ :  1.00/30 02/11/90  09.06.52  by  B. Heltsley
* add select flag
*CMZ :          06/04/89  20.46.11  by  R. Namjoshi
*-- Author :    R. Namjoshi   03/04/89
      SUBROUTINE MESACT( CANAME, IMES, ISEVER )
C.......................................................................
C.
C. MESACT - Take appropriate action for message of severity ISEVER
C.
C. Inputs    : CANAME - Name of message issuer
C.           : IMES   - Message number
C.           : ISEVER - Message severity
C. Outputs   : None
C.
C. COMMON    : ?
C. Banks D   : None
C. Banks L   : None
C. Banks M   : None
C. Banks U   : None
C.
C. Calls     : MESEND MESITC MESOUT MESTOP QNEXTE
C. Called    : MESPRO
C. Author    : R. Namjoshi  03/04/89  14.24.38
C.
C. Detailed description
C.  For FATAL and ABORT severity messages, take appropriate action
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
* -------------------- Argument declarations ---------------
      CHARACTER*(*) CANAME
      INTEGER       IMES, ISEVER
* -------------------- EXTERNAL declarations ---------------
* { EXTERNAL type declarations or "* None" if none }
* -------------------- SEQUENCE declarations ---------------
#include "cleoks/cluseq/mesbuf.inc"
#include "seq/clutil/mesrep.inc"
* -------------------- Local    declarations ---------------
*
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'MESACT' )
*
      CHARACTER*30 CSEVER
      INTEGER NPHAZE
*
* -------------------- SAVE     declarations ---------------
* None
* -------------------- DATA  initializations ---------------
* None
* ----------------- Executable code starts here ------------
C
C== Get Character severity
C
      CALL MESITC( ISEVER, CSEVER )
C
C== Get ZEBRA phase
C
      CALL ZQPHAS( NPHAZE )
C
C== Take action only if FATAL or ABORT
C
      IF(     CSEVER.EQ.MSFATA ) THEN

         IF(     NPHAZE.EQ.0 ) THEN
*
*- Error during initialization, STOP the job if necessary
*
            WRITE(CHMBUF,10000)
            CALL MESPUT(1,0)
            CALL MESTOP

         ELSEIF( NPHAZE.GE.1 ) THEN
*
*- Error during event processing, skip to next event
*
            WRITE(CHMBUF,10010)
            CALL MESPUT(1,0)
            CALL QNEXTE

         ELSEIF( NPHAZE.LE.-1 ) THEN
*
*- Error during termination phase, just continue
*
            WRITE(CHMBUF,10020)
            CALL MESPUT(1,0)
         ENDIF

      ELSEIF( CSEVER.EQ.MSABOR ) THEN

         IF(     NPHAZE.EQ.0 ) THEN
*
*- Error during initialization, STOP the job if necessary
*
            WRITE(CHMBUF,10030)
            CALL MESPUT(1,0)
            CALL MESTOP

         ELSEIF( NPHAZE.GE.1 ) THEN
*
*- Error during event processing, enter termination phase
*
            WRITE(CHMBUF,10040)
            CALL MESPUT(1,0)
            CALL MESEND

         ELSEIF( NPHAZE.LE.-1 ) THEN
*
*- Error during termination phase, just continue
*
            WRITE(CHMBUF,10050)
            CALL MESPUT(1,0)
         ENDIF

      ENDIF

      RETURN
10000 FORMAT(' MESACT-I- Fatal severity message during initialization',
     +       ' phase, execution will be stopped' )
10010 FORMAT(' MESACT-I- Fatal severity message during processing',
     +       ' phase, skipping to next event' )
10020 FORMAT(' MESACT-I- Fatal severity message during termination',
     +       ' phase, continuing execution' )
10030 FORMAT(' MESACT-I- Abort severity message during initialization',
     +       ' phase, execution will be stopped' )
10040 FORMAT(' MESACT-I- Abort severity message during processing',
     +       ' phase, entering termination phase' )
10050 FORMAT(' MESACT-I- Abort severity message during termination',
     +       ' phase, continuing execution' )

      END
#endif
