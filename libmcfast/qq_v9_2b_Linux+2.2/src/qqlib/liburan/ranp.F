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
*CMZ :  1.01/00 18/09/90  17.52.39  by  Paul Avery
*CMZ :  1.00/00 26/07/90  13.29.10  by  Paul Avery
*-- Author :    Jorge L. Rodriguez   05/06/90
      REAL FUNCTION RANP(ISEED)

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C     Returns a random number distributed uniformly between 0 and 1.
C     This routine will eventually be replaced by one which directly
C     uses the RANECU information.
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C     Calling arguments (not used)
      INTEGER ISEED

C     Local variables
      REAL R
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      CALL RANECU(R, 1, 1)

      RANP = R

      RETURN
      END
