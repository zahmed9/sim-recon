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
* Revision 1.2  1994/10/06 16:46:18  zfiles
* Do not use CALL MESLOG. (RCS keywords will not be printed out.)
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
#if defined(CLEO_CLEVER)
*CMZ :  1.00/30 02/11/90  09.15.29  by  B. Heltsley
* insert select flag.
*CMZ :          29/08/89  20.24.02  by  Nobu Katayama
*-- Author :    B. Heltsley   21/07/89
      SUBROUTINE MESBNK
C.......................................................................
C.
C. MESBNK - check if MESLOG banks exist
C.
C. Inputs    : None
C. Outputs   : None
C.
C. COMMON    : CLBANK CLLINK GCLINK MESCOM
C. Banks D   : None
C. Banks L   : None
C. Banks M   : None
C. Banks U   : CLST STML
C.
C. Calls     : None
C. Called    : MESLOG
C. Author    : B. Heltsley  21/07/89  16.25.19
C.
C. Detailed description
C.  Set flag for putting messages in banks.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
* -------------------- Argument declarations ---------------
* None
* -------------------- EXTERNAL declarations ---------------
* None
* -------------------- SEQUENCE declarations ---------------

#include "seq/clbank/czbank.inc"

#include "cleoks/cluseq/mescom.inc"

#include "cleoks/cluseq/clutof.inc"

* -------------------- Local    declarations ---------------
* None
* -------------------- SAVE     declarations ---------------
* None
* -------------------- DATA  initializations ---------------
* NONE
* ----------------- Executable code starts here ------------
C
C== Check top level message bank exists
C
      MSCLOG = .FALSE.

      IF( LCLST .GE. 1 ) THEN

         LSTML = CLLQ(CLKQ+ LCLST - OFSTML )

         IF( LSTML .GE. 1 ) MSCLOG = .TRUE.

      ENDIF

      RETURN
      END
#endif
