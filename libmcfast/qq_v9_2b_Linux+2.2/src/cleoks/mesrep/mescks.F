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
* Revision 1.2  1994/10/06 16:46:19  zfiles
* Do not use CALL MESLOG. (RCS keywords will not be printed out.)
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/30 08/11/88  16.35.23  by  R. Namjoshi
*-- Author :
      INTEGER FUNCTION MESCKS( CSEVER )
C.......................................................................
C.
C. MESCKS - Check that severity code is valid
C.
C. Inputs    : CSEVER - Message severity
C. Outputs   : MESCKS - Integer code for CSEVER, 0 if CSEVER invalid
C.
C. COMMON    : None
C. Banks D   : None
C. Banks L   : None
C. Banks M   : None
C. Banks U   : None
C.
C. Calls     : None
C. Called    : ?
C.
C. Version   : 1.00
C. Created   : 07-Nov-88
C.
C. Detailed description
C.  Checks that CSEVER is one of the valid severity codes defined in
C.  the sequence MESREP. Returns 0 if not, else it returns an integer
C.  value that corresponds to the offset for messages of that severity
C.  in the message logging banks.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
* -------------------- Argument declarations ---------------
      CHARACTER*(*) CSEVER
* -------------------- EXTERNAL declarations ---------------
* None
* -------------------- SEQUENCE declarations ---------------
#include "seq/clutil/mesrep.inc"
* -------------------- Local    declarations ---------------
      INTEGER IVAL
* -------------------- SAVE     declarations ---------------
* None
* -------------------- DATA  initializations ---------------
* None
* ----------------- Executable code starts here ------------
*
      IF(     CSEVER.EQ.MSSUCC ) THEN
         IVAL = 1
      ELSEIF( CSEVER.EQ.MSINFO ) THEN
         IVAL = 2
      ELSEIF( CSEVER.EQ.MSWARN ) THEN
         IVAL = 3
      ELSEIF( CSEVER.EQ.MSERRO ) THEN
         IVAL = 4
      ELSEIF( CSEVER.EQ.MSFATA ) THEN
         IVAL = 5
      ELSEIF( CSEVER.EQ.MSABOR ) THEN
         IVAL = 6
      ELSE
         IVAL = 0
      ENDIF
*
      MESCKS = IVAL
*
      RETURN
      END
