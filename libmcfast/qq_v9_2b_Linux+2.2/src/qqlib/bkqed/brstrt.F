*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:34  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:28  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/00 04/06/90  18.55.47  by  Jorge L. Rodriguez
*-- Author :

      SUBROUTINE BRSTRT(ENERGY)
C-----------ROUTINES BRSTRT AND QED031 GOT CHANGED 5.JUNE.85
      IMPLICIT DOUBLE PRECISION (A-H,K-Z)
      DIMENSION PH(4)
        CALL QED031(ENERGY,0.D0,0.D0,0,0.D0)
      RETURN
C
C
      ENTRY BREVNT(PH)
      CALL QED032(PH,PH,PH)
      RETURN
      END
