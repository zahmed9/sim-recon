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
* Revision 1.2  1994/10/06 16:46:28  zfiles
* Do not use CALL MESLOG. (RCS keywords will not be printed out.)
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
#if defined(CLEO_CLEVER)
*CMZ :  1.00/30 02/11/90  09.12.29  by  B. Heltsley
* insert selct flag.
*CMZ :          30/08/89  14.03.15  by  Nobu Katayama
*CMZ :          27/07/89  11.22.10  by  B. Heltsley
* minimize dependence on bank sequences
*CMZ :          07/12/88  16.54.33  by  R. Namjoshi
*-- Author :    R. Namjoshi   18/07/88
      SUBROUTINE MESLEH( LMES, ISEVER )
C.......................................................................
C.
C. MESLEH - Lift header bank for logging particular severity message in
C.          the event division
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

      CHARACTER*(*) IOMSH
      PARAMETER(    IOMSH = '2H 2I - I')

      INTEGER LDIMS

* -------------------- SAVE     declarations ---------------
* None
* -------------------- DATA  initializations ---------------
* None
* ----------------- Executable code starts here ------------
*
      LDIMS = CLLQ(CLKQ+ LCLDI - OFDIMS )
C
C== Raise appropriate bank depending on ISEVER
C
      IF( LDIMS .GT. 0 ) THEN

         IF(     ISEVER .EQ. OFMSHS ) THEN
*
            CALL UCTOH( 'MSHS', MMBK, 4, 4 )
            MMBK(2) = 1
            MMBK(3) = 1
            MMBK(4) = 6
            CALL MZIOBK( MMBK, MXMMBK, IOMSH )
            CALL MZLIFT( ICLDIV, LMES, LDIMS, -OFMSHS, MMBK, 0 )

         ELSEIF( ISEVER .EQ. OFMSHI ) THEN
*
            CALL UCTOH( 'MSHI', MMBK, 4, 4 )
            MMBK(2) = 1
            MMBK(3) = 1
            MMBK(4) = 6
            CALL MZIOBK( MMBK, MXMMBK, IOMSH )
            CALL MZLIFT( ICLDIV, LMES, LDIMS, -OFMSHI, MMBK, 0 )

         ELSEIF( ISEVER .EQ. OFMSHW ) THEN
*
            CALL UCTOH( 'MSHW', MMBK, 4, 4 )
            MMBK(2) = 1
            MMBK(3) = 1
            MMBK(4) = 6
            CALL MZIOBK( MMBK, MXMMBK, IOMSH )
            CALL MZLIFT( ICLDIV, LMES, LDIMS, -OFMSHW, MMBK, 0 )

         ELSEIF( ISEVER .EQ. OFMSHE ) THEN
*
            CALL UCTOH( 'MSHE', MMBK, 4, 4 )
            MMBK(2) = 1
            MMBK(3) = 1
            MMBK(4) = 6
            CALL MZIOBK( MMBK, MXMMBK, IOMSH )
            CALL MZLIFT( ICLDIV, LMES, LDIMS, -OFMSHE, MMBK, 0 )

         ELSEIF( ISEVER .EQ. OFMSHF ) THEN
*
            CALL UCTOH( 'MSHF', MMBK, 4, 4 )
            MMBK(2) = 1
            MMBK(3) = 1
            MMBK(4) = 6
            CALL MZIOBK( MMBK, MXMMBK, IOMSH )
            CALL MZLIFT( ICLDIV, LMES, LDIMS, -OFMSHF, MMBK, 0 )

         ELSEIF( ISEVER .EQ. OFMSHA ) THEN
*
            CALL UCTOH( 'MSHA', MMBK, 4, 4 )
            MMBK(2) = 1
            MMBK(3) = 1
            MMBK(4) = 6
            CALL MZIOBK( MMBK, MXMMBK, IOMSH )
            CALL MZLIFT( ICLDIV, LMES, LDIMS, -OFMSHA, MMBK, 0 )

         ENDIF
      ENDIF

      RETURN
      END
#endif
