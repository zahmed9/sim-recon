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
* Revision 1.2  1994/10/06 16:46:43  zfiles
* Do not use CALL MESLOG. (RCS keywords will not be printed out.)
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
#if defined(CLEO_CLEVER)
*CMZ :  1.00/30 02/11/90  09.13.09  by  B. Heltsley
* insert select flag
*CMZ :          30/08/89  14.36.03  by  Nobu Katayama
*-- Author :    R. Namjoshi   18/07/88
      SUBROUTINE MESTAS( CRNAME, IMES, ISEVER )
C.......................................................................
C.
C. MESTAS - Tally the message in the statistics ivisions
C.
C. Inputs    : CRNAME - Name of calling routine
C.           : IERR   - Message number
C.           : ISEVER - Severity
C. Outputs   : None
C.
C. COMMON    : MESBUF MESREP
C. Calls     : LENOCC MESDAT MESLSH MESLST UCTOH
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
      INTEGER  LENOCC
      EXTERNAL LENOCC
* -------------------- SEQUENCE declarations ---------------
#include "seq/clbank/czbank.inc"
#include "seq/clutil/mesrep.inc"
#include "cleoks/cluseq/mesbuf.inc"
* -------------------- Local    declarations ---------------
      INTEGER LMES, LTXT, HRNAME(2), MESCHA, MESWRD
      LOGICAL LFOUND
* -------------------- SAVE     declarations ---------------
* None
* -------------------- DATA  initializations ---------------
* None
* ----------------- Executable code starts here ------------
C
C== Convert name to Hollerith
C
      CALL UCTOH( CRNAME, HRNAME, 4, 8 )
C
C== Get link to correct message severity bank in the statistics div.
C
      LFOUND = .FALSE.
      LMES = CLLQ(CLKQ+ LSTML - ISEVER )
10    IF( LMES.GT.0 .AND. .NOT.LFOUND ) THEN
         IF( CLIQ(CLKQ+LMES+1).NE.HRNAME(1) .OR.
     +       CLIQ(CLKQ+LMES+2).NE.HRNAME(2) .OR.
     +       CLIQ(CLKQ+LMES+3).NE.IMES            ) THEN
            LMES = CLLQ(CLKQ+LMES)
         ELSE
            LFOUND = .TRUE.
         ENDIF
         GOTO 10
      ENDIF
C
C== If message was not found create new bank and save text. Messages
C   are all considered to be non-unique for the moment.
C
      IF( .NOT.LFOUND ) THEN
         CALL MESLSH( LMES, ISEVER )
         CLIQ(CLKQ+LMES+1) = HRNAME(1)
         CLIQ(CLKQ+LMES+2) = HRNAME(2)
         CLIQ(CLKQ+LMES+3) = IMES
         CLIQ(CLKQ+LMES+4) = 1
         MESCHA     = LENOCC(CHMESS)
         MESWRD     = MESCHA/4 + 1 + 3
         CALL MESLST( LMES, LTXT, ISEVER, MESWRD )
         CALL MESDAT( CLIQ(CLKQ+LTXT+1), CLIQ(CLKQ+LTXT+2) )
         CLIQ(CLKQ+LTXT+3) = MESCHA/4 + 1
         CALL UCTOH ( CHMESS, CLIQ(CLKQ+LTXT+4), 4, MESCHA )
      ELSE
         CLIQ(CLKQ+LMES+4) = CLIQ(CLKQ+LMES+4) + 1
      ENDIF
C
C== Bump severity count
C
      CLIQ(CLKQ+LSTML+ISEVER) = CLIQ(CLKQ+LSTML+ISEVER) + 1
C
      RETURN
*
      END
#endif
