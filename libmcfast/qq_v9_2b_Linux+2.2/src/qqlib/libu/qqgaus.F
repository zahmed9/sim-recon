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
*CMZ :  1.01/00 18/09/90  20.18.19  by  Paul Avery
*CMZ :  1.00/00 06/06/90  12.18.42  by  Paul Avery
*-- Author :
* 28/10/96  L. Garren: Add double precision conditionals.
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION FUNCTION QQGAUS(DUMMY)
#else
      REAL FUNCTION QQGAUS(DUMMY)
#endif

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C    Returns a value distributed as a guassian with mean 0 and sigma 1.
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C     Calling arguments
      REAL DUMMY

C     Local variables
      INTEGER I
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION VALUE
      REAL VEC(12)
#else
      REAL VALUE, VEC(12)
#endif
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      CALL RANECU(VEC, 12, 1)
      VALUE = -6.
      DO 10 I=1,12
        VALUE = VALUE + VEC(I)
10    CONTINUE

      QQGAUS = VALUE

      RETURN
      END
