*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:38  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:28  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 22/09/94  00.24.45  by  Paul Avery
*CMZ :  1.00/00 13/08/90  11.40.59  by  Paul Avery
*-- Author :    Jorge L. Rodriguez   05/06/90
      SUBROUTINE QQSRAN(ISEED)

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C  Set the random seed based on time of day. This routine is currently
C  only good to the nearest second.
C
C *ISEED      integer variable (write)
C             Random seed returned to caller
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C     Calling arguments
      INTEGER ISEED

C     Local variables
      REAL TIME
      INTEGER ITIME(3), IDATE(3)
      INTEGER HDATE(2), HTIME(2)
      CHARACTER CDATE*8, CTIME*8
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C     Get date and time in Hollerith. Convert to character string
C     HDATE = dd/mm/yy
C     HTIME = hh.mm.ss
      CALL DATIMH(HDATE, HTIME)
      CALL UHTOC(HDATE, 4, CDATE, 8)
      CALL UHTOC(HTIME, 4, CTIME, 8)

C     Convert to integer arrays
      READ(CTIME,5001) ITIME
5001  FORMAT(I2,1X,I2,1X,I2)
      READ(CDATE,5001) IDATE

C     Calculate random seed from # seconds from the start of the month
C     We really want to get down to the hundredths of a second
      ISEED = 86400*IDATE(1) + 3600*ITIME(1) + 60*ITIME(2) + ITIME(3)

C     Get the execution time just to get times to .001 sec
      CALL TIMEX(TIME)
      ISEED = ISEED + 1000*TIME

      RETURN
      END
