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
* Revision 1.2  1994/10/06 16:46:24  zfiles
* Do not use CALL MESLOG. (RCS keywords will not be printed out.)
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/30 07/11/90  13.11.54  by  B. Heltsley
* add LPT for driver version
*CMZ :          07/08/89  14.39.54  by  B. Heltsley
*-- Author :    B. Heltsley   07/08/89
      SUBROUTINE MESGLU( CHPARM, CALNAM, LUNIT )
C.
C. MESGLU - Get logical unit number of particular unit
C.
C. Inputs    : CHPARM - character string of name of parameter
C.             CALNAM - character string calling routine name
C. Outputs   : LUNIT  - integer value of parameter
C.......................................................................
C.
C.
C. COMMON    : MESCOM MESLUN MESREP
C. Banks D   : None
C. Banks L   : None
C. Banks M   : None
C. Banks U   : None
C.
C. Calls     : LENOCC MESINI
C. Called    : <user>
C. Author    : B. Heltsley  07/08/89  14.26.32
C.
C. Detailed description
C.    Get logical unit number from message logging package.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
* -------------------- Argument declarations ---------------

      CHARACTER*(*) CHPARM, CALNAM
      INTEGER LUNIT

* -------------------- EXTERNAL declarations ---------------

      INTEGER  LENOCC
      EXTERNAL LENOCC

* -------------------- SEQUENCE declarations ---------------

#include "cleoks/cluseq/meslun.inc"
#include "cleoks/cluseq/mescom.inc"
#include "seq/clutil/mesrep.inc"

* -------------------- Local    declarations ---------------
*
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'MESGLU' )
*
      INTEGER LPARM, IOERR

* -------------------- SAVE     declarations ---------------
* None
* -------------------- DATA  initializations ---------------
* None
* ----------------- Executable code starts here ------------
C
C== Initialize if not already done
C
      IF( MSINIT.NE.MSFLAG ) CALL MESINI

      LPARM = LENOCC( CHPARM )

      IF(     CHPARM( 1 : LPARM ) .EQ. 'MESLOU' ) THEN

         LUNIT = MESLOU

      ELSEIF( CHPARM( 1 : LPARM ) .EQ. 'MESLIN' ) THEN

         LUNIT = MESLIN

#if !defined(CLEO_CLEVER)
      ELSEIF( CHPARM( 1 : LPARM ) .EQ. 'MESLPT' ) THEN

         LUNIT = MESLPT
#endif
      ELSE

         WRITE( CHMESS, '('' Routine '', A,
     *    '' requests unknown parameter ='', A )', IOSTAT = IOERR )
     *     CALNAM, CHPARM
         CALL MESPRO( CRNAME, 1, MSERRO )

      ENDIF

      RETURN
      END
