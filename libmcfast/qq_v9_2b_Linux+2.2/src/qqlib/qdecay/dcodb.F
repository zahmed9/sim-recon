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
*CMZ :  1.00/00 14/06/90  14.26.28  by  Paul Avery
*-- Author :

      SUBROUTINE DCODB(JP,JQRK)
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C  -------------------------------------------------------------------------
C  TO DECODE-CASE-B
C  -------------------------------------------------------------------------

C     Calling variables
      INTEGER JP, JQRK(2,3)

C     Local variables
      INTEGER J1, J2
C  ---------------------------------------------------------------------------

      J2 = 1+JP/6
      J1 = 1+MOD(JP/2,3)
      IF (J2 .LE. J1) J1 = J1+1
      JQRK(1,1) = J2
      JQRK(1,2) = J2
      JQRK(1,3) = J1

      RETURN

      END


