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
* Revision 1.2  1994/10/06 16:46:35  zfiles
* Do not use CALL MESLOG. (RCS keywords will not be printed out.)
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/30 01/11/90  17.55.03  by  B. Heltsley
* put in CLEVER select flags
*CMZ :          03/04/89  14.23.53  by  R. Namjoshi
*-- Author :    R. Namjoshi   18/07/88
      SUBROUTINE MESPRO( CRNAME, IMES, ISEVER )
C.......................................................................
C.
C. MESPRO - Steering routine to process a message log
C.
C. Inputs    : CRNAME - Name of calling routine
C.           : IERR   - Message number
C.           : ISEVER - Severity
C. Outputs   : None
C.
C. COMMON    : MESBUF MESREP
C. Calls     : MESACT MESCON MESROU MESTAL
C. Called    : MESLOG
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
* -------------------- Argument declarations ---------------
      CHARACTER*(*) CRNAME
      INTEGER IMES, ISEVER
* -------------------- EXTERNAL declarations ---------------
* None
* -------------------- SEQUENCE declarations ---------------
#include "cleoks/cluseq/mescom.inc"
#include "seq/clutil/mesrep.inc"
#include "cleoks/cluseq/mesbuf.inc"
* -------------------- Local    declarations ---------------
      CHARACTER*(*) MRNAME
      PARAMETER(    MRNAME = 'MESPRO' )
* -------------------- SAVE     declarations ---------------
* None
* -------------------- DATA  initializations ---------------
* None
* ----------------- Executable code starts here ------------
C
C== Tally the message if possible
C
#if defined(CLEO_CLEVER)
      IF( MSCLOG ) CALL MESTAL( CRNAME, IMES, ISEVER )
#endif
C
C== Route the message
C
      CALL MESROU( CRNAME, IMES, ISEVER )
C
C== Take appropriate control action for ISEVER
C
#if defined(CLEO_CLEVER)
      CALL MESACT( CRNAME, IMES, ISEVER )
#endif
C
      RETURN
*
      END
