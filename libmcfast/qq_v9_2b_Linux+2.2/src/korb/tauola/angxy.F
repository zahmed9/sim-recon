*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:30  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:04  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/00 21/01/93  15.42.37  by  Alan Weinstein
*-- Author :
      FUNCTION ANGXY(X,Y)
C ----------------------------------------------------------------------
C
C     USED BY : KORALZ RADKOR
C ----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      DATA PI /3.141592653589793238462643D0/
C
      IF(ABS(Y).LT.ABS(X)) THEN
        THE=ATAN(ABS(Y/X))
        IF(X.LE.0D0) THE=PI-THE
      ELSE
        THE=ACOS(X/SQRT(X**2+Y**2))
      ENDIF
      ANGXY=THE
      RETURN
      END
