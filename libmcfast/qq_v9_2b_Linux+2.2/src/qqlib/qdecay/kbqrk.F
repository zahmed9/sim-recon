*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:41  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:30  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/00 14/06/90  17.19.29  by  Paul Avery
*-- Author :
      SUBROUTINE KBQRK(JPART,JQRK)
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C  ---------------------------------------------------------------------------
C  GIVEN JPART, THE PARTICLE CODE FOR A BARYON, KBQRK RETURNS
C  THE QUARK CONTENT OF THE BARYON IN JQRK(1,1:3).
C  IT SETS JQRK(2,1:3) TO ZERO.
C  ---------------------------------------------------------------------------

C     Calling variables
      INTEGER JPART, JQRK(2,3)

C     Local variables
      INTEGER I, JP, JBARY, JC3, J, JB3, JA3, JB1, JA11, JA10

      DATA JBARY/121/
      DATA JA10,JA11,JB1,JA3,JB3,JC3/0,8,16,40,48,72/

      DO 100 I=1,3
         JQRK(2,I) = 0
100   CONTINUE

      JP = JPART-JBARY
C   CONDITIONAL
      IF(JP.GE.JC3)THEN
         JP = JP-JC3
         J = JP/2 + 1
         DO 200 I=1,3
            JQRK(1,I) = J
200      CONTINUE

      ELSEIF(JP.GE.JB3)THEN
         JP = JP-JB3
         CALL DCODB(JP,JQRK)

      ELSEIF(JP.GE.JA3)THEN
         JP = JP-JA3
         CALL DCODA(J,JQRK,JP)

      ELSEIF(JP.GE.JB1)THEN
         JP = JP-JB1
         CALL DCODB(JP,JQRK)

      ELSEIF(JP.GE.JA11)THEN
         JP = JP-JA11
         CALL DCODA(J,JQRK,JP)

C   (OTHERWISE)
      ELSE
         JP = JP-JA10
         CALL DCODA(J,JQRK,JP)
      ENDIF

      IF (MOD(JP,2).NE.0)THEN
         DO 300 I=1,3
            JQRK(1,I) = -JQRK(1,I)
300      CONTINUE
      ENDIF
      RETURN

      END

