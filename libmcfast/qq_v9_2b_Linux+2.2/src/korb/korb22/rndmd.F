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
*CMZ :  2.00/00 21/01/93  15.42.14  by  Alan Weinstein
*-- Author :
      FUNCTION RNDMD(IDUMM)
C     ********************
      REAL*8 RNDMD
      DATA IC,IY /65536,13/
C---REINITIALISATION
      IF(IDUMM.EQ.-1) THEN
         IC=65536
         IY=13
         RNDMD=0
         RETURN
      ENDIF
      IY=IY*25
      IY=MOD(IY,IC)
      IY=IY*125
      IY=MOD(IY,IC)
      RNDMD=FLOAT(IY)/FLOAT(IC)
      RETURN
      END
