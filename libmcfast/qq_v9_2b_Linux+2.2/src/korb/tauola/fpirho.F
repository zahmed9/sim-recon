*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:31  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:03  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/00 21/01/93  15.42.34  by  Alan Weinstein
*-- Author :
      FUNCTION FPIRHO(W)
C **********************************************************
C     SQUARE OF PION FORM FACTOR
C **********************************************************
      COMPLEX FPIK
      FPIRHO=CABS(FPIK(W))**2
      END
