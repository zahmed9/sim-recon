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
*CMZ :  1.03/15 04/12/90  14.36.14  by  R.A.FULTON
*-- Author :
      FUNCTION QSTAR(XM,XMCH1,XMCH2)

       REAL    QSTAR
       REAL    XM, XMCH1, XMCH2, QRES

           QRES=(XM-XMCH1-XMCH2)*(XM-XMCH1+XMCH2)*
     +           (XM+XMCH1-XMCH2)*(XM+XMCH1+XMCH2)

           QSTAR=SQRT(QRES)*0.5/XM

      RETURN
      END
