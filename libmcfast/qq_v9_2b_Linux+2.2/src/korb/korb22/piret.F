*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:28  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:02  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/00 21/01/93  15.42.13  by  Alan Weinstein
*-- Author :
      FUNCTION PIRET(S)
C     *****************
      IMPLICIT REAL*8(A-H,O-Z)
C-----IT RETURNS THE VALUE OF THE HADRONIC CONTRIBUTION TO VACUUM
C-----POLARISATION, USING PARAMETRISATION OF H. BURKHARD TASSO NOTE
C-----NO. 192, DECEMBER 1981.
      IF(S.LT.1.)
     $                PIRET=-1.3450E-9 -2.3020E-3* LOG(1.+4.091*S)
      IF(S.GT.1.0.AND.S.LT.64)
     $                PIRET=-1.5120E-3 -2.8220E-3* LOG(1.+1.218*S)
      IF(S.GT.64)
     $                PIRET=-1.1344E-3 -3.0680E-3* LOG(1.+0.99992*S)
      RETURN
      END
