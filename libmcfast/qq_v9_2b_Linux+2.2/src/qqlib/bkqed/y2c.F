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
*CMZ :  1.03/10 12/06/91  11.33.00  by  Peter C Kim
*CMZ :  1.00/00 04/06/90  18.55.47  by  Jorge L. Rodriguez
*-- Author :

      FUNCTION Y2C(C)
C...CUMULATIVE INTEGRAL OVER SCATTERING ANGLE OF MU+
      IMPLICIT DOUBLE PRECISION(A-H,K,O-Z)

      COMMON / CONSTQ / E,AE,AM,ALE,ALM,ALL,PI,PI2,ALFA,BETA
      COMMON / OUTPAR / K,CG,FIG,FI
      DATA KOLD/-999.D0/
      IF(KOLD.EQ.K) GOTO 1
      KOLD=K
      KM=1.D0-K
      KM0=1.D0+KM
      KM1=1.D0+KM*KM
      KM2=KM1/K
      KMK=2.D0*KM/K
      FAC1=4.D0*(ALE*KM2-KMK)/K/K/K
      FAC2=(ALM+DLOG(KM))*KM2-KMK
    1 KC=K*C
      W=KM0*KM0-KC*KC
      ZZ1=-2.D0*KC/W
      ZZ2=2.D0*KM0*ZZ1/W
      ZZ3=(2.D0*KM0*ZZ2 - ZZ1)/W
      A1= - KM1*ZZ1 + 2.D0*KM*KM0*ZZ2 - 8.D0*KM*KM*ZZ3/3.D0
      A2=C*(1.D0+C*C/3.D0)
      Y2C=FAC1*A1 + FAC2*A2
      RETURN
      END
