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
*CMZ :  1.00/00 14/06/90  14.26.27  by  Paul Avery
*CMZ :          19/05/90  14.51.03  by  Jorge L. Rodriguez
*>> Author :
      SUBROUTINE DIQFLV(IFL)
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
#include "qqlib/seq/mcgen.inc"

*-- Calling argument
      INTEGER IFL
*
*-  External declarations
      REAL     RANP
      EXTERNAL RANP
*
C-- Local variables
      INTEGER IFO
      REAL    PFL2
*
      INTEGER ISEED
      COMMON/RANDM/ISEED
*
*-- Executable code starts here ----------------------------------------------
*
      PFL2=RANP(ISEED)*PBFL(6)
      IFO = 6
      DO 100 IFL=1,6
         IF (PFL2.LT.PBFL(IFL))RETURN
100   CONTINUE
      RETURN
      END
