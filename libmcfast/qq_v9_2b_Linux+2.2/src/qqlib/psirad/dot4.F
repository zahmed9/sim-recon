*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:40  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:37  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 04/10/94  22.13.53  by  Paul Avery
*-- Author :    D. Coffman   15/02/93
      DOUBLE PRECISION FUNCTION DOT4(X, Y)
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
      DOUBLE PRECISION X(4), Y(4)
      DOT4 = X(4)*Y(4) - X(1)*Y(1) - X(2)*Y(2) - X(3)*Y(3)
      RETURN
      END

