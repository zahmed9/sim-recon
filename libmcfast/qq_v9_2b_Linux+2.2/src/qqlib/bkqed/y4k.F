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
*CMZ :  1.00/00 04/06/90  18.55.46  by  Jorge L. Rodriguez
*-- Author :

      FUNCTION Y4K(K)
      IMPLICIT DOUBLE PRECISION (A-Z)

      COMMON / CON1 / PI,M,ALFA,PI2,LE,E,DL,MU,S,K0,CMAX,BETA,
     *                SIG0,SIGA,SIGCOL,THRSLD,LK0
      Y4K=Y4KQ(DLOG(K/K0))*2.*ALFA**3/S*LE + SIGA
      RETURN
      END
