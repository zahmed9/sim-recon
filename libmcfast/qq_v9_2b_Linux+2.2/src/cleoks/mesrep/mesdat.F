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
* Revision 1.2  1994/10/06 16:46:22  zfiles
* Do not use CALL MESLOG. (RCS keywords will not be printed out.)
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/30 09/11/88  10.35.00  by  R. Namjoshi
*-- Author :    R. Namjoshi   18/07/88
      SUBROUTINE MESDAT( IDATE, ITIME )
C.......................................................................
C.
C. MESDAT - Return current date/time
C.
C. Inputs    : None
C. Outputs   : IDATE  - Current date YYMMDD
C. Outputs   : ITIME  - Current time HHMMSSDD
C.
C. COMMON    : None
C. Banks D   : None
C. Banks L   : None
C. Banks M   : None
C. Banks U   : None
C.
C. Calls     : DATIMH UHTOC
C. Called    : ?
C.
C. Version   : 1.00
C. Created   : 07-Nov-88
C.
C. Detailed description
C.  Returns the current date in IDATE, coded as YYMMDD and the
C.  current time in ITIME, coded as HHMMSSDD where DD is hundredths
C.  of seconds.
C.  Currently, this routine calls DATIMH which has a precision of one
C.  second, so the DD field in ITIME is always zero.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
* -------------------- Argument declarations ---------------
      INTEGER IDATE, ITIME
* -------------------- EXTERNAL declarations ---------------
* None
* -------------------- SEQUENCE declarations ---------------
* None
* -------------------- Local    declarations ---------------
      CHARACTER*8 CDATE,    CTIME
      INTEGER     HDATE(2), HTIME(2)
      INTEGER     IYEA, IMON, IDAY, IHOU, IMIN, ISEC, IDEC
* -------------------- SAVE     declarations ---------------
* None
* -------------------- DATA  initializations ---------------
* None
* ----------------- Executable code starts here ------------
*
      CALL DATIMH( HDATE, HTIME )
*
      CALL UHTOC ( HDATE, 4, CDATE, 8 )
      CALL UHTOC ( HTIME, 4, CTIME, 8 )
*
      READ( CDATE, 10000 ) IDAY, IMON, IYEA
      READ( CTIME, 10000 ) IHOU, IMIN, ISEC
      IDEC = 0
*
      IDATE = IDAY + 100 * ( IMON + 100 * IYEA )
      ITIME = IDEC + 100 * ( ISEC + 100 * ( IMIN + 100 * IHOU ) )
*
      RETURN
*
10000 FORMAT( I2, 1X, I2, 1X, I2 )
*
      END
