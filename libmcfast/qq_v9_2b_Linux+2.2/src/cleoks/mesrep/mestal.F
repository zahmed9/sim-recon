*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:15  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  18:00:00  nk
* Consolidation
*
* Revision 1.2  1994/10/06 16:46:42  zfiles
* Do not use CALL MESLOG. (RCS keywords will not be printed out.)
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
#if defined(CLEO_CLEVER)
*CMZ :  1.00/30 01/11/90  18.02.39  by  B. Heltsley
* put in clever flag
*CMZ :          29/08/89  20.24.02  by  Nobu Katayama
*CMZ :          24/07/89  15.57.19  by  B. Heltsley
* minimize dependence on bank sequences
*CMZ :          05/12/88  20.19.45  by  R. Namjoshi
*-- Author :    R. Namjoshi   18/07/88
      SUBROUTINE MESTAL( CRNAME, IMES, ISEVER )
C.......................................................................
C.
C. MESTAL - Tally the message in the statistics/event divisions
C.
C. Inputs    : CRNAME - Name of calling routine
C.           : IERR   - Message number
C.           : ISEVER - Severity
C. Outputs   : None
C.
C. COMMON    : CLBANK CLLINK GCLINK
C. Calls     : MESTAS MESTAE
C. Called    : MESPRO
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

#include "seq/clbank/czbank.inc"

#include "seq/clever/descseq.inc"

#include "cleoks/cluseq/clutof.inc"

* -------------------- Local    declarations ---------------

      INTEGER LDIMS

* -------------------- SAVE     declarations ---------------
* None
* -------------------- DATA  initializations ---------------
* None
* ----------------- Executable code starts here ------------
C
C== Tally in the statistics division
C
      CALL MESTAS( CRNAME, IMES, ISEVER )
C
C== If event header present, tally in event division too
C
      IF( LCLEV .GT. 1 ) THEN

         LCLDI = CLLQ(CLKQ+ LCLEV - OFCLDI )

         IF( LCLDI .GT. 1 ) THEN

            LDIMS = CLLQ(CLKQ+ LCLDI - OFDIMS )

            IF( LDIMS .LT. 1 ) THEN

               CALL UCTOH( 'DIMS', MMBK, 4, 4 )
               MMBK(2) = 6
               MMBK(3) = 6
               MMBK(4) = 6
               CALL MZIOBK( MMBK, MXMMBK, '6I' )
               CALL MZLIFT( ICLDIV, LDIMS, LCLDI, -OFDIMS, MMBK, 0 )

            ENDIF
            CALL MESTAE( CRNAME, IMES, ISEVER )
         ENDIF
      ENDIF
C
      RETURN
      END
#endif
