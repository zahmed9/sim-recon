*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:35  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:29  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/00 04/06/90  18.55.47  by  Jorge L. Rodriguez
*-- Author :

      FUNCTION Y2CSFT(C)
      DOUBLE PRECISION C,Y2CSFT
      Y2CSFT=C*(1.D0+C*C/3.D0)
      RETURN
      END
