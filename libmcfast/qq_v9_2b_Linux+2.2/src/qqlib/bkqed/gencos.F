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
*CMZ :  1.01/00 17/09/90  23.22.39  by  Paul Avery
*CMZ :  1.00/00 04/06/90  18.55.46  by  Jorge L. Rodriguez
*-- Author :

      FUNCTION GENCOS(X)

C...THIS ROUTINE GENERATES THE COSINE COS(X) OF AN ANGLE
C...WITH A DISTRIBUTION PROPORTIONAL TO
C...             1/(1-COS(X)+M**2/2)
C...THIS CAN BE USED FOR GENERATING C THE LOWEST ORDER CROSSECTION
C...BEFORE TESTING , AS WELL AS FOR GENERATING Z
      IMPLICIT DOUBLE PRECISION(A-H,K-Z)

      COMMON / CON1 / PI,M,ALFA,PI2,LE,E,DL,MU,S,DUMMY(8)
      REAL RANP
      EXTERNAL RANP
      SSS=RANP(0)
      IF(SSS.GT.0.5) GOTO 1
         GENCOS=E-DL*DEXP(-LE*SSS)
      GOTO 2
1        SSS=1.-SSS
         GENCOS=E-MU*DEXP(+LE*SSS)
2     RETURN
      END
