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
* Revision 1.2  1994/10/06 16:46:31  zfiles
* Do not use CALL MESLOG. (RCS keywords will not be printed out.)
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
#if defined(CLEO_CLEVER)
*CMZ :  1.00/30 02/11/90  09.13.41  by  B. Heltsley
*CMZ :          25/07/89  15.30.17  by  B. Heltsley
* minimize dependence on bank sequences
*CMZ :          07/12/88  16.54.33  by  R. Namjoshi
*-- Author :    R. Namjoshi   18/07/88
      SUBROUTINE MESLSH( LMES, ISEVER )
C.......................................................................
C.
C. MESLSH - Lift header bank for logging particular severity message in
C.          the statistics division
C.
C. Inputs    : ISEVER - Severity
C. Outputs   : LMES   - Link to created bank
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
      INTEGER LMES, ISEVER
* -------------------- EXTERNAL declarations ---------------
* None
* -------------------- SEQUENCE declarations ---------------
#include "seq/clbank/czbank.inc"
#include "cleoks/cluseq/clutof.inc"
#include "seq/clever/descseq.inc"
* -------------------- Local    declarations ---------------

      CHARACTER*(*) IOMLH
      PARAMETER(    IOMLH = '2H - I')

* -------------------- SAVE     declarations ---------------
* None
* -------------------- DATA  initializations ---------------
* None
* ----------------- Executable code starts here ------------
C
C== Raise appropriate bank depending on ISEVER
C
      IF(     ISEVER .EQ. OFMLHS ) THEN
*
         CALL UCTOH( 'MLHS', MMBK, 4, 4 )
         MMBK(2) = 2
         MMBK(3) = 2
         MMBK(4) = 6
         CALL MZIOBK( MMBK, MXMMBK, IOMLH )
         CALL MZLIFT( ICLSTA, LMES, LSTML, -OFMLHS, MMBK, 0 )

      ELSEIF( ISEVER .EQ. OFMLHI ) THEN
*
         CALL UCTOH( 'MLHI', MMBK, 4, 4 )
         MMBK(2) = 2
         MMBK(3) = 2
         MMBK(4) = 6
         CALL MZIOBK( MMBK, MXMMBK, IOMLH )
         CALL MZLIFT( ICLSTA, LMES, LSTML, -OFMLHI, MMBK, 0 )

      ELSEIF( ISEVER .EQ. OFMLHW ) THEN
*
         CALL UCTOH( 'MLHW', MMBK, 4, 4 )
         MMBK(2) = 2
         MMBK(3) = 2
         MMBK(4) = 6
         CALL MZIOBK( MMBK, MXMMBK, IOMLH )
         CALL MZLIFT( ICLSTA, LMES, LSTML, -OFMLHW, MMBK, 0 )

      ELSEIF( ISEVER .EQ. OFMLHE ) THEN
*
         CALL UCTOH( 'MLHE', MMBK, 4, 4 )
         MMBK(2) = 2
         MMBK(3) = 2
         MMBK(4) = 6
         CALL MZIOBK( MMBK, MXMMBK, IOMLH )
         CALL MZLIFT( ICLSTA, LMES, LSTML, -OFMLHE, MMBK, 0 )

      ELSEIF( ISEVER .EQ. OFMLHF ) THEN
*
         CALL UCTOH( 'MLHF', MMBK, 4, 4 )
         MMBK(2) = 2
         MMBK(3) = 2
         MMBK(4) = 6
         CALL MZIOBK( MMBK, MXMMBK, IOMLH )
         CALL MZLIFT( ICLSTA, LMES, LSTML, -OFMLHF, MMBK, 0 )

      ELSEIF( ISEVER .EQ. OFMLHA ) THEN
*
         CALL UCTOH( 'MLHA', MMBK, 4, 4 )
         MMBK(2) = 2
         MMBK(3) = 2
         MMBK(4) = 6
         CALL MZIOBK( MMBK, MXMMBK, IOMLH )
         CALL MZLIFT( ICLSTA, LMES, LSTML, -OFMLHA, MMBK, 0 )

      ENDIF

      RETURN
      END
#endif
