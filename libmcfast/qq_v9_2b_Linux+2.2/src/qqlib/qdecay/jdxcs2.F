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
*CMZ :  1.00/00 14/06/90  14.26.28  by  Paul Avery
*CMZ :          19/05/90  14.51.03  by  Jorge L. Rodriguez
*>> Author :
      SUBROUTINE JDXCS2(J2, J1, JB1, JB3, JDX, KLAS, JSPIN)
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C  ---------------------------------------------------------------------------
C-- TO MAKE-JDX-FOR-CASE-2
C  ---------------------------------------------------------------------------

#include "qqlib/seq/mcgen.inc"

C--   Calling declarations
      INTEGER   J2, J1, JB1, JB3, JDX, KLAS, JSPIN
*
C--   External declarations
      REAL      RANP
      EXTERNAL  RANP
*
C--   Local varibles
      INTEGER ISEED
      COMMON/RANDM/ISEED
C  ---------------------------------------------------------------------------

C-- CONDITIONAL
      IF(J2.EQ.4) THEN
         KLAS = 5

      ELSEIF (J1.EQ.4) THEN
         KLAS = 4

      ELSEIF (J2.EQ.3) THEN
         KLAS = 3

      ELSEIF (J1.EQ.3) THEN
         KLAS = 2

C-- (OTHERWISE)
      ELSE
        KLAS = 1
      ENDIF
      JSPIN = JB1
      IF (RANP(ISEED).GT.BSPIN(KLAS)) JSPIN = JB3
      IF (J2.LT.J1) J1 = J1-1
      JDX = JSPIN+6*(J2-1)+2*(J1-1)

      RETURN
      END
