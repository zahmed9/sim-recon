*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:15  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  17:59:57  nk
* Consolidation
*
* Revision 1.2  1994/10/06 16:46:23  zfiles
* Do not use CALL MESLOG. (RCS keywords will not be printed out.)
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
#if defined(CLEO_CLEVER)
*CMZ :  1.00/30 02/11/90  09.20.35  by  B. Heltsley
* insert select flag
*CMZ :          06/04/89  20.49.32  by  R. Namjoshi
*-- Author :    R. Namjoshi   04/04/89
      SUBROUTINE MESEND
C.......................................................................
C.
C. MESEND - Enter job termination phase, query if interactive
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
C. Calls     : INTRAC KUPROC MESOUT
C. Called    : MESACT
C. Author    : R. Namjoshi  04/04/89  10.50.47
C.
C. Detailed description
C.  Call ZEND to enter job termination phase. If the job is running
C.  interactively, query the user before doing so.
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
      PARAMETER(    CRNAME = 'MESEND' )
*
      CHARACTER*10 CHYENO
      INTEGER DUMMY, LENGTH
      LOGICAL LEND
*
* -------------------- SAVE     declarations ---------------
* None
* -------------------- DATA  initializations ---------------
* None
* ----------------- Executable code starts here ------------
*
      LEND = .TRUE.

      IF( INTRAC(DUMMY) ) THEN

10       CHYENO = ' '
         CALL KUPROC(
     +   'Interactive job, do you really want to terminate? (Y/N)',
     +   CHYENO, LENGTH )

         IF(     CHYENO(1:1).EQ.'Y' ) THEN
            LEND = .TRUE.
         ELSEIF( CHYENO(1:1).EQ.'N' ) THEN
            LEND = .FALSE.
         ELSE
            GOTO 10
         ENDIF

      ENDIF
C
C== STOP or continue
C
      IF( LEND ) THEN
         CALL ZEND
      ELSE
         CHMBUF = ' MESEND-I- Execution continued by user request'
         CALL MESPUT(1,1)
      ENDIF
*
      RETURN
      END
#endif
