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
* Revision 1.2  1994/10/06 16:46:27  zfiles
* Do not use CALL MESLOG. (RCS keywords will not be printed out.)
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/30 08/11/88  18.57.51  by  R. Namjoshi
*-- Author :
      SUBROUTINE MESITC( ISEVER, CSEVER )
C.......................................................................
C.
C. MESITC - Returns CSEVER corresponding to ISEVER
C.
C. Inputs    : ISEVER - Integer message severity
C. Outputs   : CSEVER - Corresponding CHARACTER message severity
C.
C. COMMON    : None
C. Banks D   : None
C. Banks L   : None
C. Banks M   : None
C. Banks U   : None
C.
C. Calls     : None
C. Called    : MESROU
C.
C. Version   : 1.00
C. Created   : 08-Nov-88
C.
C. Detailed description
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
* -------------------- Argument declarations ---------------
      INTEGER       ISEVER
      CHARACTER*(*) CSEVER
* -------------------- EXTERNAL declarations ---------------
* None
* -------------------- SEQUENCE declarations ---------------
#include "seq/clutil/mesrep.inc"
* -------------------- Local    declarations ---------------
* None
* -------------------- SAVE     declarations ---------------
* None
* -------------------- DATA  initializations ---------------
* None
* ----------------- Executable code starts here ------------
*
      IF(     ISEVER.EQ.1 ) THEN
         CSEVER = MSSUCC
      ELSEIF( ISEVER.EQ.2 ) THEN
         CSEVER = MSINFO
      ELSEIF( ISEVER.EQ.3 ) THEN
         CSEVER = MSWARN
      ELSEIF( ISEVER.EQ.4 ) THEN
         CSEVER = MSERRO
      ELSEIF( ISEVER.EQ.5 ) THEN
         CSEVER = MSFATA
      ELSEIF( ISEVER.EQ.6 ) THEN
         CSEVER = MSABOR
      ELSE
         CSEVER = '?'
      ENDIF
*
      RETURN
      END
