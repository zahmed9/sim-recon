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
*CMZ :  2.00/00 21/01/93  15.42.35  by  Alan Weinstein
*-- Author :
      SUBROUTINE CLNUT(HJ,B,HV)
C ----------------------------------------------------------------------
* CALCULATES THE CONTRIBUTION BY NEUTRINO MASS
* NOTE THE TAU IS ASSUMED TO BE AT REST
C
C     called by : DAMPAA
C ----------------------------------------------------------------------
      COMPLEX HJ(4)
      REAL HV(4),P(4)
      DATA P /3*0.,1.0/
C
      CALL CLAXI(HJ,P,HV)
      B=REAL( HJ(4)*AIMAG(HJ(4)) - HJ(3)*AIMAG(HJ(3))
     &      - HJ(2)*AIMAG(HJ(2)) - HJ(1)*AIMAG(HJ(1))  )
      RETURN
      END
