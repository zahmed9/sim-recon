*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:28  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:06  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/05 21/10/93  17.43.05  by  Alan Weinstein
*-- Author :
* 15/10/96 Lynn Garren: Add double precision conditionals.
      FUNCTION PHOAN1(X,Y)
C.----------------------------------------------------------------------
C.
C.    PHOTOS:   PHOton radiation in decays calculation of ANgle '1'
C.
C.    Purpose:  Calculate angle from X and Y
C.
C.    Input Parameters:  X, Y
C.
C.    Output Parameter:  Function value
C.
C.    Author(s):  S. Jadach                       Created at:  01/01/89
C.                B. van Eijk                     Last Update: 02/01/90
C.
C.----------------------------------------------------------------------
C--   IMPLICIT NONE
      DOUBLE PRECISION PHOAN1
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION X,Y
#else
      REAL X,Y
#endif
      REAL PI,TWOPI
      COMMON/PHPICO/PI,TWOPI
      IF (ABS(Y).LT.ABS(X)) THEN
        PHOAN1=ATAN(ABS(Y/X))
        IF (X.LE.0.) PHOAN1=PI-PHOAN1
      ELSE
        PHOAN1=ACOS(X/SQRT(X**2+Y**2))
      ENDIF
      IF (Y.LT.0.) PHOAN1=TWOPI-PHOAN1
      RETURN
      END
