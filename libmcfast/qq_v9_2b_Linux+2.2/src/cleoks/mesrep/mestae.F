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
* Revision 1.2  1994/10/06 16:46:40  zfiles
* Do not use CALL MESLOG. (RCS keywords will not be printed out.)
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
#if defined(CLEO_CLEVER)
*CMZ :  1.00/47 19/05/93  11.54.14  by  C Ray Ng
* Fixed a typo on creating message link.
*CMZ :  1.00/30 02/11/90  09.07.38  by  B. Heltsley
* add select flag
*CMZ :          29/08/89  21.10.20  by  Nobu Katayama
*CMZ :          24/07/89  16.49.46  by  B. Heltsley
* minimize dependence on bank sequences
*CMZ :          05/12/88  20.19.45  by  R. Namjoshi
*-- Author :    R. Namjoshi   18/07/88
      SUBROUTINE MESTAE( CRNAME, IMES, ISEVER )
C.......................................................................
C.
C. MESTAE - Tally the message in the event division
C.
C. Inputs    : CRNAME - Name of calling routine
C.           : IERR   - Message number
C.           : ISEVER - Severity
C. Outputs   : None
C.
C. COMMON    : MESBUF MESREP
C. Calls     : LENOCC MESDAT MESLEH MESLET UCTOH
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
#include "cleoks/cluseq/clutof.inc"
* -------------------- Local    declarations ---------------
      INTEGER LMES, LTXT, HRNAME(2), MESCHA, MESWRD, LDIMS
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
C== Get link to correct message severity bank in the event div.
C
      LFOUND = .FALSE.
      LDIMS  = CLLQ(CLKQ+LCLDI-OFDIMS)
      LMES   = CLLQ(CLKQ+LDIMS-ISEVER)
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
         CALL MESLEH( LMES, ISEVER )
         CLIQ(CLKQ+LMES+1) = HRNAME(1)
         CLIQ(CLKQ+LMES+2) = HRNAME(2)
         CLIQ(CLKQ+LMES+3) = IMES
         CLIQ(CLKQ+LMES+4) = 1
         MESCHA     = LENOCC(CHMESS)
         MESWRD     = MESCHA/4 + 1 + 3
         CALL MESLET( LMES, LTXT, ISEVER, MESWRD )
         CALL MESDAT( CLIQ(CLKQ+LTXT+1), CLIQ(CLKQ+LTXT+2) )
         CLIQ(CLKQ+LTXT+3) = MESCHA/4 + 1
         CALL UCTOH ( CHMESS, CLIQ(CLKQ+LTXT+4), 4, MESCHA )
      ELSE
         CLIQ(CLKQ+LMES+4) = CLIQ(CLKQ+LMES+4) + 1
      ENDIF
C
C== Bump severity count
C
      CLIQ(CLKQ+LDIMS+ISEVER) = CLIQ(CLKQ+LDIMS+ISEVER) + 1
C
      RETURN
*
      END
#endif
