*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:14  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  17:59:54  nk
* Consolidation
*
* Revision 1.1.1.1  1994/10/04 21:54:51  zfiles
* first version of clutil in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/00 17/11/88  15.21.09  by  R. Namjoshi
*-- Author :    R. Namjoshi   24/08/88
      SUBROUTINE NAMLUN( ILUN, CFNAME )
C.......................................................................
C.
C. NAMLUN  - Query status of unit ILUN
C.
C. Inputs    : ILUN   - Unit number
C. Outputs   : CFNAME - Name of file connected to ILUN
C.
C. COMMON    : None
C. Banks D   : None
C. Banks L   : None
C. Banks M   : None
C. Banks U   : None
C.
C. Calls     : None
C. Called    : ERRLUN REPLUN
C.
C. Detailed description
C.  This routine returns the name of the file connected to unit ILUN.
C.  If ILUN is not OPEN or the file is unnamed, CFNAME is all blank
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
* -------------------- Argument declarations ---------------
      INTEGER ILUN
      CHARACTER*(*) CFNAME
* -------------------- EXTERNAL declarations ---------------
* None
* -------------------- SEQUENCE declarations ---------------
#include "cleoks/cluseq/lunmcde.inc"
* -------------------- Local    declarations ---------------
      LOGICAL RCSINI
      CHARACTER*(*) CHRCSS, CHRCSR, CHRCST, CHRCSD, CHRCSA
      PARAMETER(CHRCSS='$RCSfile$')
      PARAMETER(CHRCSR='$Revision$')
      PARAMETER(CHRCST='$State$')
      PARAMETER(CHRCSD='$Date$')
      PARAMETER(CHRCSA='$Author$')
      LOGICAL LOPEND, LNAMED
* -------------------- SAVE     declarations ---------------
      SAVE RCSINI
* None
* -------------------- DATA  initializations ---------------
      DATA RCSINI/.TRUE./
* None
* ----------------- Executable code starts here ------------
#if WRITE_RCS_INFO
      IF(RCSINI)THEN
        RCSINI = .FALSE.
        WRITE(6,*)'-------- CVSinfo --------'
        WRITE(6,*)CHRCSS
        WRITE(6,*)CHRCSR//' '//CHRCST
        WRITE(6,*)CHRCSD//' '//CHRCSA
      ENDIF
#endif
*
      CFNAME = ' '
*
      IF( ILUN.LT.LUNMIN .OR. ILUN.GT.LUNMAX ) GOTO 999
*
      INQUIRE( UNIT=ILUN, OPENED=LOPEND )
      IF( LOPEND ) THEN
         INQUIRE( UNIT=ILUN, NAME=CFNAME, NAMED=LNAMED )
         IF( .NOT.LNAMED ) CFNAME = ' '
#if defined(CLEO_APOLLO)
C
C== 'Bug' in Apollo INQUIRE, returns garbage name for LUN=5,6,7
C
         IF( ILUN.EQ.5 ) CFNAME = 'IOS_$STDIN'
         IF( ILUN.EQ.6 .OR. ILUN.EQ.7 ) CFNAME = 'IOS_$STDOUT'
#endif
      ENDIF
*
      RETURN
  999 END
