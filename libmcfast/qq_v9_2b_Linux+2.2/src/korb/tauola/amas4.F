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
      FUNCTION AMAS4(PP)
C     ******************
C ----------------------------------------------------------------------
C CALCULATES MASS OF PP
C
C     USED BY :
C ----------------------------------------------------------------------
      REAL  PP(4)
      AAA=PP(4)**2-PP(3)**2-PP(2)**2-PP(1)**2
      IF(AAA.NE.0.0) AAA=AAA/SQRT(ABS(AAA))
      AMAS4=AAA
      RETURN
      END
