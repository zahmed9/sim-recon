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
* Revision 1.2  1994/10/06 16:46:29  zfiles
* Do not use CALL MESLOG. (RCS keywords will not be printed out.)
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
#if defined(CLEO_CLEVER)
*CMZ :  1.00/30 02/11/90  09.18.09  by  B. Heltsley
* insert select flag.
*CMZ :          29/08/89  20.24.02  by  Nobu Katayama
*CMZ :          21/07/89  17.24.00  by  B. Heltsley
* minimize dependence on bank sequences
*CMZ :          05/12/88  20.19.46  by  R. Namjoshi
*-- Author :    R. Namjoshi   18/07/88
      SUBROUTINE MESLET( LMES, LTXT, ISEVER, NWORD )
C.......................................................................
C.
C. MESLET - Lift text bank for logging particular severity message in
C.          the event division.
C.
C. Inputs    : LMES   - Link to parent bank
C.           : ISEVER - Severity
C.           : NWORD  - Size of the bank to create
C. Outputs   : LTXT   - Link to created bank
C.
C. COMMON    : CLBANK CLLINK GCLINK
C. Calls     : MZIOBK MZLIFT UCTOH
C. Called    : MESTAL
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
* -------------------- Argument declarations ---------------
      INTEGER LMES, LTXT, ISEVER, NWORD
* -------------------- EXTERNAL declarations ---------------
* None
* -------------------- SEQUENCE declarations ---------------
#include "seq/clbank/czbank.inc"
#include "seq/clever/descseq.inc"
#include "cleoks/cluseq/clutof.inc"
* -------------------- Local    declarations ---------------

      CHARACTER*(*) IOMST
      PARAMETER ( IOMST = '3I / 1H' )

* -------------------- SAVE     declarations ---------------
* None
* -------------------- DATA  initializations ---------------
* None
* ----------------- Executable code starts here ------------
C
C== Raise appropriate bank depending on ISEVER
C
      IF(     ISEVER.EQ.OFMSHS ) THEN
         CALL UCTOH( 'MSTS', MMBK(1), 4, 4 )
         MMBK(2) = 0
         MMBK(3) = 0
         MMBK(4) = NWORD
         CALL MZIOBK( MMBK, MXMMBK, IOMST )
         CALL MZLIFT( ICLDIV, LTXT, LMES, -OFMSTS, MMBK, 0 )

      ELSEIF( ISEVER.EQ.OFMSHI ) THEN
         CALL UCTOH( 'MSTI', MMBK(1), 4, 4 )
         MMBK(2) = 0
         MMBK(3) = 0
         MMBK(4) = NWORD
         CALL MZIOBK( MMBK, MXMMBK, IOMST )
         CALL MZLIFT( ICLDIV, LTXT, LMES, -OFMSTI, MMBK, 0 )

      ELSEIF( ISEVER.EQ.OFMSHW ) THEN
         CALL UCTOH( 'MSTW', MMBK(1), 4, 4 )
         MMBK(2) = 0
         MMBK(3) = 0
         MMBK(4) = NWORD
         CALL MZIOBK( MMBK, MXMMBK, IOMST )
         CALL MZLIFT( ICLDIV, LTXT, LMES, -OFMSTW, MMBK, 0 )

      ELSEIF( ISEVER.EQ.OFMSHE ) THEN
         CALL UCTOH( 'MSTE', MMBK(1), 4, 4 )
         MMBK(2) = 0
         MMBK(3) = 0
         MMBK(4) = NWORD
         CALL MZIOBK( MMBK, MXMMBK, IOMST )
         CALL MZLIFT( ICLDIV, LTXT, LMES, -OFMSTE, MMBK, 0 )

      ELSEIF( ISEVER.EQ.OFMSHF ) THEN
         CALL UCTOH( 'MSTF', MMBK(1), 4, 4 )
         MMBK(2) = 0
         MMBK(3) = 0
         MMBK(4) = NWORD
         CALL MZIOBK( MMBK, MXMMBK, IOMST )
         CALL MZLIFT( ICLDIV, LTXT, LMES, -OFMSTF, MMBK, 0 )

      ELSEIF( ISEVER.EQ.OFMSHA ) THEN
         CALL UCTOH( 'MSTA', MMBK(1), 4, 4 )
         MMBK(2) = 0
         MMBK(3) = 0
         MMBK(4) = NWORD
         CALL MZIOBK( MMBK, MXMMBK, IOMST )
         CALL MZLIFT( ICLDIV, LTXT, LMES, -OFMSTA, MMBK, 0 )

      ENDIF

      RETURN
      END
#endif
