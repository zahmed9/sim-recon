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
*CMZ :  1.03/10 12/06/91  11.33.11  by  Peter C Kim
*CMZ :  1.00/00 04/06/90  18.55.47  by  Jorge L. Rodriguez
*-- Author :

      FUNCTION Y2CG(CTH)
      IMPLICIT DOUBLE PRECISION(A-H,K,O-Z)

      COMMON / CONSTQ / E,AE,AM,ALE,ALM,ALL,PI,PI2,ALFA,BETA
      COMMON / OUTPAR / K,C,CG,FIG,FI
      DATA COLD/-999./,KOLD/-99./
      IF(KOLD.EQ.K.AND.COLD.EQ.C) GOTO 11
      COLD=C
      KOLD=K
      KM=1.D0-K
      KM2=1.D0+KM*KM
      DEL=K*AM*AM/4.D0/KM
      S2=(1.D0-C)*(1.D0+C)
      AS=AE*AE*S2
      CP=1.D0+C
      CM=1.D0-C
      CS=1.D0+C*C
      AKC =(CP*CP+KM*KM*CM*CM)/(CP+KM*CM)**4
      AKCM=(CM*CM+KM*KM*CP*CP)/(CM+KM*CP)**4
C
   11 Y=2.D0-K+K*CTH
      X=2.D0*KM/Y
      W =CTH-E*C
      WM=CTH+E*C
      RC =DSQRT(W*W  +AS)
      RMC=DSQRT(WM*WM+AS)
      IF(W.GT.0.D0) WRC=RC+W
      IF(W.LE.0.D0) WRC=AS/(RC-W)
      IF(WM.GT.0.D0) WRMC=RMC+WM
      IF(WM.LE.0.D0) WRMC=AS/(RMC-WM)
      Y2CG=8.D0/K*(AKC *(KM2*DLOG(WRC )-KM*W /RC )
     Z            +AKCM*(KM2*DLOG(WRMC)-KM*WM/RMC)  )
      X1=1.D0-X+DEL
      X2=X-KM+DEL
      Y2CG=Y2CG
     Z +CS*(KM2/K*DLOG(X1/X2)+.5D0*AM*AM*(1.D0/X1-1.D0/X2))
      RETURN
      END
