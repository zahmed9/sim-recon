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
*CMZ :  1.03/10 12/06/91  11.35.53  by  Peter C Kim
*CMZ :  1.00/00 04/06/90  18.55.47  by  Jorge L. Rodriguez
*-- Author :

      FUNCTION Y2KQ(KWW)
      IMPLICIT DOUBLE PRECISION(A-H,K,O-Z)
      COMMON / CONSTQ / E,AE,AM,ALE,ALM,ALL,PI,PI2,ALFA,BETA
      COMMON /CONST1/ CMAX,K0,KMIN,KMAX,SIG0,SOFT1,TRSHLD,CHI,GV2,DELW
      K=K0*DEXP(KWW)
      KM=1.D0-K
      DLKM=DLOG(KM)
      Y=-.5D0*ALE*(K+DLKM)
     Z  +.25D0*KM*(3.D0-K)*DLKM
     Z   -DILOG(K)+K*(1.75D0-.125D0*K)-ALM*K*(1.D0-.25D0*K)
      Y2KQ=BETA*KWW+2.D0*ALFA/PI*Y
      RETURN
      END
