*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:15  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  17:59:58  nk
* Consolidation
*
* Revision 1.2  1994/10/06 16:46:34  zfiles
* Do not use CALL MESLOG. (RCS keywords will not be printed out.)
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/30 07/11/90  13.08.50  by  B. Heltsley
* put in LPT unit
*CMZ :          07/12/88  16.54.32  by  R. Namjoshi
*-- Author :    R. Namjoshi   18/07/88
      SUBROUTINE MESOUT( CRBEF, CRAFT )
C.......................................................................
C.
C. MESOUT - Write the contents of the message buffer CHMESS
C.
C. Inputs    : CRBEF  - Preceed write with this many CR/LF's
C.           : CRAFT  - Follow  write with this many CR/LF's
C. Outputs   : None
C. COMMON    : MESBUF MESLUN
C. Calls     : MESINI
C. Called    : <USER>
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
#include "seq/clutil/mesrep.inc"
#include "cleoks/cluseq/meslun.inc"
* -------------------- Local    declarations ---------------
      INTEGER I
* -------------------- SAVE     declarations ---------------
* None
* -------------------- DATA  initializations ---------------
* None
* ----------------- Executable code starts here ------------
*
      DO 10 I = 1, CRBEF
         WRITE( MESLOU, 10000)
#if !defined(CLEO_CLEVER)
         WRITE( MESLPT, 10000)
#endif
   10 CONTINUE
C
      WRITE( MESLOU, 10010) CHMESS(1:LENOCC(CHMESS))
#if !defined(CLEO_CLEVER)
      WRITE( MESLPT, 10010) CHMESS(1:LENOCC(CHMESS))
#endif
C
      DO 20 I = 1, CRAFT
         WRITE( MESLOU, 10000)
#if !defined(CLEO_CLEVER)
         WRITE( MESLPT, 10000)
#endif
   20 CONTINUE
C
      RETURN
*
10000 FORMAT(1X)
10010 FORMAT(A)
*
      END
