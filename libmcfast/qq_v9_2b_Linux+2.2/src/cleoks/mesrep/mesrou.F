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
* Revision 1.2  1994/10/06 16:46:39  zfiles
* Do not use CALL MESLOG. (RCS keywords will not be printed out.)
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/30 17/04/89  10.49.31  by  R. Namjoshi
*-- Author :    R. Namjoshi   18/07/88
      SUBROUTINE MESROU( CRNAME, IMES, ISEVER )
C.......................................................................
C.
C. MESROU - Route the message
C.
C. Inputs    : CRNAME - Name of calling routine
C.           : IMES   - Message number
C.           : ISEVER - Severity
C. Outputs   : None
C.
C. COMMON    : MESBUF MESREP
C. Calls     : LENOCC MESCON MESITC MESPUT
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
#include "seq/clutil/mesrep.inc"
#include "cleoks/cluseq/mesbuf.inc"
* -------------------- Local    declarations ---------------
      CHARACTER*(*) MRNAME
      PARAMETER(    MRNAME = 'MESROU' )
      CHARACTER*1 CSEVER
      INTEGER LENN, LENM, IERR
* -------------------- SAVE     declarations ---------------
* None
* -------------------- DATA  initializations ---------------
* None
* ----------------- Executable code starts here ------------
C
C== Output the context message
C
      CALL MESCON
C
C== Construct output buffer
C
      LENN   = LENOCC(CRNAME)
      LENM   = LENOCC(CHMESS)
      CALL MESITC( ISEVER, CSEVER )
C
C== Negative message numbers means supress name/severity. Zero means
C   output blank line.
C
      IF( LENN+3+LENM .LT. 132 .AND. IMES.GT.0 ) THEN
         WRITE(CHMBUF,10000,IOSTAT=IERR) CRNAME(1:LENN), CSEVER(1:1),
     +                                   CHMESS(1:LENM)
         CALL MESPUT(0,0)

      ELSEIF( IMES.EQ.0 ) THEN
         CHMBUF = ' '
         CALL MESPUT(0,0)

      ELSE
         IF( IMES.GT.0 ) THEN
            WRITE(CHMBUF,10010,IOSTAT=IERR) CRNAME(1:LENN), CSEVER(1:1)
            CALL MESPUT(0,0)
         ENDIF
         WRITE(CHMBUF,10020,IOSTAT=IERR) CHMESS(1:LENM)
         CALL MESPUT(0,0)
      ENDIF
C
      RETURN
*
10000 FORMAT(1X, A, '-', A, '-', A )
10010 FORMAT(1X, A, '-', A, '-' )
10020 FORMAT(1X, A )
*
      END
