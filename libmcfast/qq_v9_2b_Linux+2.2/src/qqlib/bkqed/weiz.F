*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:34  eugenio
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

      FUNCTION WEIZ(K,C)
C  ----------------------------------------------------------------------------
C...CALCULATE YES OR NO FOR REFLECTION OF Z TO -Z AFTER
C...GENERATING Z BY "GENCOS". THIS IS DONE BY CALCULATING THE
C...RATIO OF THE TWO COEFFICIENTS IN THE EXPRESSION FOR
C...THE Z DISTRIBUTION
C  ----------------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION(A-Z)

      COMMON / CON1 / PI,M,ALFA,PI2,LE,E,DL,MU,S,K0,CMAX,BETA,
     *                SIG0,SIGA,SIGCOL,THRSLD,LK0
      KM=1.D0-K
      CM=1.D0-C/E
      CP=1.D0+C/E
      COEFZM=(CP+KM*KM*CM)*(2.D0-K*CP)
      COEFZP=(CM+KM**2*CP)*(2.D0-K*CM)
      WEIZ=COEFZM/(COEFZM+COEFZP)
      RETURN
      END
