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
*CMZ :  1.00/00 23/08/90  15.50.56  by  Paul Avery
*-- Author :
      SUBROUTINE QQGLUN(LUN)
C
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C     Finds next available Fortran unit and returns the answer in "lun".
C     If none is available lun is set to 0.
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
C     Calling argument
      INTEGER LUN
C
      LOGICAL LOPEN
      INTEGER I
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C
C     Loop through units until we find one that's available
      DO 100 I=99,1,-1
        INQUIRE(UNIT=I, OPENED=LOPEN)
        IF(.NOT. LOPEN) THEN
          LUN = I
          GOTO 1000
        ENDIF
100   CONTINUE
      LUN = 0
C
C     Only exit point
1000  RETURN
      END
