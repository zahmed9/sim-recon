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
*CMZ :  1.00/00 04/06/90  18.55.48  by  Jorge L. Rodriguez
*-- Author :

      FUNCTION Y3K(K)
      IMPLICIT DOUBLE PRECISION(A-H,K-Z)

      COMMON / GETAL / BARN,PI,ALFA,BETA,DELTA,SIG0,AME,AMT,EME,S
      COMMON / GRENS / KMAX,A ,CMAX,SOFT,TRSHLD,K0
      Y3=SIG0*SOFT
      IF(K.LE.K0) Y3K=Y3*(K/K0)
      IF(K.GT.K0) Y3K=Y3 + SIG0*Y3KQ(DLOG(K/K0))
      RETURN
      END
