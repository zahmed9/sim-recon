*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:41  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:29  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/00 14/06/90  17.19.29  by  Paul Avery
*-- Author :

      SUBROUTINE DCODA(J,JQRK,JP)
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C  ---------------------------------------------------------------------------
C   TO DECODE-CASE-A
C  ---------------------------------------------------------------------------

C     Calling variables
      INTEGER J, JQRK(2,3), JP
C
C     Local variables
      INTEGER I
C  ---------------------------------------------------------------------------


C   SELECT (J)
      J = JP/2
      DO 10 I=1,3
         JQRK(1,I) = I
10    CONTINUE
      IF(J .EQ. 1)THEN
         JQRK(1,3) = 4
      ELSEIF(J .EQ. 2)THEN
         JQRK(1,2) = 4
      ELSEIF(J .EQ. 3)THEN
         JQRK(1,1) = 4
      ENDIF

      RETURN

      END

