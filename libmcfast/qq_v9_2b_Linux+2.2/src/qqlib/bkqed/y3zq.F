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

      DOUBLE PRECISION FUNCTION Y3ZQ(ZQZQ)
C.....USE ZQZQ=1/(E-Z) IN RANGE Z=-1.0...+1.0
C....AND WITH Y3Z(Z)=FF(Z)-FF(-Z), USE ONLY FF(+Z) PART
C....IN CALLING ROUTINE FLIP COIN TO CHANGE Z >>> -Z
      IMPLICIT DOUBLE PRECISION(A-H,K-Z)
      COMMON / GETAL / BARN,PI,ALFA,BETA,DELTA,SIG0,AME,AMT,EME,S
      COMMON / OUT11 / K,Z,ZM,ZP,SZ,FG,SFG,CFG
      Z = EME - 1./ZQZQ
      KM=1.D0-K
      KM2=1.D0+KM*KM
C CUMULATIVE INTEGRAL OF Z IN LAB SYSTEM
      Y3ZQ=KM2*DLOG(ZQZQ)-Z*K*K/2.-AME*KM*ZQZQ
      RETURN
      END
