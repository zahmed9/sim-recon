*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:33  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:35  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.03/15 04/12/90  13.10.25  by  R.A.FULTON
*CMZ :          04/12/90  13.07.25  by  R.A.FULTON
      FUNCTION FGAM(X,W,I,QSQ,CHRG,MQ)

      REAL       FGAM

      REAL       X, W, QSQ, CHRG, MQ, ARG
      INTEGER    I
      REAL       C1, C2

      DATA C1,C2 /0.05254,0.013936/

      IF(I.LT.4)THEN
        FGAM = C1*CHRG*( X**2 + (1.0-X)**2 )
      ELSE
        ARG  = SQRT(W)/(2.*MQ)
        FGAM = C2*CHRG*( X**2+(1.0-X)**2 )*ALOG( ARG+SQRT(ARG**2-1.0) )
      ENDIF

      RETURN
      END
