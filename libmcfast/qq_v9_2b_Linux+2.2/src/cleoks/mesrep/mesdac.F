* Urheim - rename char. strings interpreted as trigraphs by cpp on rs6000.
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
* Revision 1.3  1994/12/06 17:29:39  zfiles
* Change comments for AIX cpp (related trigraph, from J. Urheim)
*
* Revision 1.2  1994/10/06  16:46:21  zfiles
* Do not use CALL MESLOG. (RCS keywords will not be printed out.)
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/30 13/04/89  13.04.32  by  R. Namjoshi
*-- Author :    R. Namjoshi   13/04/89
      SUBROUTINE MESDAC( CDATE, CTIME )
C.......................................................................
C.
C. MESDAC - Return character date and time
C.
C. Inputs    : None
C. Outputs   : CDATE  - Current character date dd-mmm-yyyy  (11 char.)
C.           : CTIME  - Current character time hh:mm:ss.cc  (11 char.)
C.
C. COMMON    : None
C. Banks D   : None
C. Banks L   : None
C. Banks M   : None
C. Banks U   : None
C.
C. Calls     : MESDAT
C. Called    : MESCON
C. Author    : R. Namjoshi  13/04/89  12.37.17
C.
C. Detailed description
C.  Convert/format current date/time and return in CDATE, CTIME
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
* -------------------- Argument declarations ---------------
      CHARACTER*(*) CDATE, CTIME
* -------------------- EXTERNAL declarations ---------------
* None
* -------------------- SEQUENCE declarations ---------------
* None
* -------------------- Local    declarations ---------------
*
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'MESDAC' )
*
      CHARACTER*3 CMONT(13)
      CHARACTER*11 CLDATE, CLTIME
*
      INTEGER IDATE, ITIME
      INTEGER ICENT, IYEAR, IMONT, IDAY
      INTEGER IHOUR, IMIN , ISEC , IHUNS
*
* -------------------- SAVE     declarations ---------------
      SAVE CMONT
* -------------------- DATA  initializations ---------------
      DATA CMONT / 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
#if defined(CLEO_RS6000)
     +             'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'Xxx'  /
#else
     +             'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', '???'  /
#endif
* ----------------- Executable code starts here ------------

      CALL MESDAT( IDATE, ITIME )
C
C== Date first, good till 2088 !!
C
      IYEAR = IDATE / 10000
      ICENT = 19
      IF( IYEAR.LT.88 ) ICENT = 20
      IYEAR = ICENT*100 + IYEAR
*- Day
      IDAY  = MOD( IDATE, 100 )
*- Month
      IMONT = IDATE / 100
      IMONT = MOD( IMONT, 100 )
      IF( IMONT.LT.1 .OR. IMONT.GT.12 ) IMONT = 13

      WRITE( CLDATE, 10000 ) IDAY, CMONT(IMONT), IYEAR
      CDATE = CLDATE
C
C== Now the time
C
      IHUNS = MOD( ITIME, 100 )
      ITIME = ITIME / 100

      ISEC  = MOD( ITIME, 100 )
      ITIME = ITIME / 100

      IMIN  = MOD( ITIME, 100 )
      ITIME = ITIME / 100

      IHOUR = ITIME

      WRITE( CLTIME, 10010 ) IHOUR, IMIN, ISEC, IHUNS
      CTIME = CLTIME
*
      RETURN
10000 FORMAT( I2, '-', A3, '-', I4 )
10010 FORMAT( I2, ':', I2.2, ':', I2.2, '.', I2.2 )
      END
