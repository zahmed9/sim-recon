*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:15  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  18:00:01  nk
* Consolidation
*
* Revision 1.2  1994/10/06 16:46:45  zfiles
* Do not use CALL MESLOG. (RCS keywords will not be printed out.)
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
#if defined(CLEO_CLEVER)
*CMZ :  1.00/30 02/11/90  09.26.03  by  B. Heltsley
* insert select flag.
*CMZ :          04/04/89  11.32.52  by  R. Namjoshi
*-- Author :    R. Namjoshi   04/04/89
      SUBROUTINE MESTOP
C.......................................................................
C.
C. MESTOP - Execute a traceback and STOP, query if interactive
C.
C. Inputs    : None
C. Outputs   : None
C.
C. COMMON    : MESBUF
C. Banks D   : None
C. Banks L   : None
C. Banks M   : None
C. Banks U   : None
C.
C. Calls     : INTRAC KUPROC MESOUT TRACEQ
C. Called    : MESACT
C. Author    : R. Namjoshi  04/04/89  10.50.47
C.
C. Detailed description
C.  Print a traceback and then execute a STOP. If the job is running
C.  interactively, query the user before STOPping
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
* -------------------- Argument declarations ---------------
* None
* -------------------- EXTERNAL declarations ---------------
      LOGICAL  INTRAC
      EXTERNAL INTRAC
* -------------------- SEQUENCE declarations ---------------
#include "cleoks/cluseq/mesbuf.inc"
#include "cleoks/cluseq/meslun.inc"
* -------------------- Local    declarations ---------------
*
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'MESTOP' )
*
      CHARACTER*10 CHYENO
      INTEGER DUMMY, LENGTH
      LOGICAL LSTOP
*
* -------------------- SAVE     declarations ---------------
* None
* -------------------- DATA  initializations ---------------
* None
* ----------------- Executable code starts here ------------
*
      LSTOP = .TRUE.

      IF( INTRAC(DUMMY) ) THEN

10       CHYENO = ' '
         CALL KUPROC(
     +   'Interactive job, do you really want to STOP? (Y/N)',
     +   CHYENO, LENGTH )

         IF(     CHYENO(1:1).EQ.'Y' ) THEN
            LSTOP = .TRUE.
         ELSEIF( CHYENO(1:1).EQ.'N' ) THEN
            LSTOP = .FALSE.
         ELSE
            GOTO 10
         ENDIF

      ENDIF
C
C== STOP or continue
C
      IF( LSTOP ) THEN
         CALL TRACEQ( MESLOU, 15 )
         STOP
      ELSE
         CHMBUF = ' MESTOP-I- Execution continued by user request'
         CALL MESPUT(1,1)
      ENDIF
*
      RETURN
      END
#endif
