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
* Revision 1.2  1994/10/06 16:46:32  zfiles
* Do not use CALL MESLOG. (RCS keywords will not be printed out.)
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
#if defined(CLEO_CLEVER)
*CMZ :  1.00/30 02/11/90  09.14.24  by  B. Heltsley
* insert select flag
*CMZ :          29/08/89  20.24.03  by  Nobu Katayama
*CMZ :          24/07/89  15.25.15  by  B. Heltsley
* minimize dependence on bank sequences
*CMZ :          05/12/88  20.19.46  by  R. Namjoshi
*-- Author :    R. Namjoshi   18/07/88
      SUBROUTINE MESLST( LMES, LTXT, ISEVER, NWORD )
C.......................................................................
C.
C. MESLST - Lift text bank for logging particular severity message in
C.          the statistics division.
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
#include "cleoks/cluseq/clutof.inc"
#include "seq/clever/descseq.inc"
* -------------------- Local    declarations ---------------

      CHARACTER*(*) IOMLT
      PARAMETER(    IOMLT = '3I / 1H')

* -------------------- SAVE     declarations ---------------
* None
* -------------------- DATA  initializations ---------------
* None
* ----------------- Executable code starts here ------------
C
C== Raise appropriate bank depending on ISEVER
C
      IF(     ISEVER.EQ.OFMLHS ) THEN
         CALL UCTOH( 'MLTS', MMBK(1), 4, 4 )
         MMBK(2) = 0
         MMBK(3) = 0
         MMBK(4) = NWORD
         CALL MZIOBK( MMBK, MXMMBK, IOMLT )
         CALL MZLIFT( ICLSTA, LTXT, LMES, -OFMLTS, MMBK, 0 )

      ELSEIF( ISEVER.EQ.OFMLHI ) THEN
         CALL UCTOH( 'MLTI', MMBK(1), 4, 4 )
         MMBK(2) = 0
         MMBK(3) = 0
         MMBK(4) = NWORD
         CALL MZIOBK( MMBK, MXMMBK, IOMLT )
         CALL MZLIFT( ICLSTA, LTXT, LMES, -OFMLTI, MMBK, 0 )

      ELSEIF( ISEVER.EQ.OFMLHW ) THEN
         CALL UCTOH( 'MLTW', MMBK(1), 4, 4 )
         MMBK(2) = 0
         MMBK(3) = 0
         MMBK(4) = NWORD
         CALL MZIOBK( MMBK, MXMMBK, IOMLT )
         CALL MZLIFT( ICLSTA, LTXT, LMES, -OFMLTW, MMBK, 0 )

      ELSEIF( ISEVER.EQ.OFMLHE ) THEN
         CALL UCTOH( 'MLTE', MMBK(1), 4, 4 )
         MMBK(2) = 0
         MMBK(3) = 0
         MMBK(4) = NWORD
         CALL MZIOBK( MMBK, MXMMBK, IOMLT )
         CALL MZLIFT( ICLSTA, LTXT, LMES, -OFMLTE, MMBK, 0 )

      ELSEIF( ISEVER.EQ.OFMLHF ) THEN
         CALL UCTOH( 'MLTF', MMBK(1), 4, 4 )
         MMBK(2) = 0
         MMBK(3) = 0
         MMBK(4) = NWORD
         CALL MZIOBK( MMBK, MXMMBK, IOMLT )
         CALL MZLIFT( ICLSTA, LTXT, LMES, -OFMLTF, MMBK, 0 )

      ELSEIF( ISEVER.EQ.OFMLHA ) THEN
         CALL UCTOH( 'MLTA', MMBK(1), 4, 4 )
         MMBK(2) = 0
         MMBK(3) = 0
         MMBK(4) = NWORD
         CALL MZIOBK( MMBK, MXMMBK, IOMLT )
         CALL MZLIFT( ICLSTA, LTXT, LMES, -OFMLTA, MMBK, 0 )

      ENDIF

      RETURN
      END
#endif
