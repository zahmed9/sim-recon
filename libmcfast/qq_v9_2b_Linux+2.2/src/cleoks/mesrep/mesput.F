*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:15  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  17:59:59  nk
* Consolidation
*
* Revision 1.2  1994/10/06 16:46:36  zfiles
* Do not use CALL MESLOG. (RCS keywords will not be printed out.)
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/44 16/11/92  13.57.14  by  Brian K. Heltsley
* flush output for errors in UNIX
*CMZ :  1.00/30 07/11/90  13.10.26  by  B. Heltsley
* add LPT for driver
*CMZ :          07/12/88  16.54.32  by  R. Namjoshi
*-- Author :    R. Namjoshi   18/07/88
      SUBROUTINE MESPUT( CRBEF, CRAFT )
C.......................................................................
C.
C. MESPUT - Write the contents of the message buffer CHMBUF
C.
C. Inputs    : CRBEF  - Preceed write with this many CR/LF's
C.           : CRAFT  - Follow  write with this many CR/LF's
C. Outputs   : None
C. COMMON    : MESBUF MESLUN
C. Calls     : None
C. Called    : MESLOG
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
* -------------------- Argument declarations ---------------
      INTEGER CRBEF, CRAFT
* -------------------- EXTERNAL declarations ---------------
      INTEGER  LENOCC
      EXTERNAL LENOCC
* -------------------- SEQUENCE declarations ---------------
#include "cleoks/cluseq/mesbuf.inc"
#include "cleoks/cluseq/meslun.inc"
* -------------------- Local    declarations ---------------
      INTEGER I
* -------------------- SAVE     declarations ---------------
* None
* -------------------- DATA  initializations ---------------
* None
* ----------------- Executable code starts here ------------
C
      DO 10 I = 1, CRBEF
         WRITE( MESLOU, 10000)
#if !defined(CLEO_CLEVER)
         WRITE( MESLPT, 10000)
#endif
   10 CONTINUE
C
      WRITE( MESLOU, 10010) CHMBUF(1:LENOCC(CHMBUF))
#if !defined(CLEO_CLEVER)
      WRITE( MESLPT, 10010) CHMBUF(1:LENOCC(CHMBUF))
#endif
C
      DO 20 I = 1, CRAFT
         WRITE( MESLOU, 10000)
#if !defined(CLEO_CLEVER)
         WRITE( MESLPT, 10000)
#endif
   20 CONTINUE
C
#if defined(CLEO_DECS)||defined(CLEO_SGI)||defined(CLEO_UNIX)
      IF(      INDEX(CHMBUF,'-E-') .NE. 0
     *    .OR. INDEX(CHMBUF,'-W-') .NE. 0
     *    .OR. INDEX(CHMBUF,'-F-') .NE. 0
     *    .OR. INDEX(CHMBUF,'-A-') .NE. 0) CALL FLUSH( MESLOU )
#endif

      RETURN
*
10000 FORMAT(1X)
10010 FORMAT(A)
*
      END
