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
*CMZ :  1.03/10 12/06/91  11.35.01  by  Peter C Kim
*CMZ :  1.00/00 04/06/90  18.55.47  by  Jorge L. Rodriguez
*-- Author :

      FUNCTION Y2FIG(FIG)
      IMPLICIT DOUBLE PRECISION(A-H,K,O-Z)

      COMMON / CONSTQ / E,AE,AM,ALE,ALM,ALL,PI,PI2,ALFA,BETA
      COMMON / OUTPAR / K,C,CG,FI
      DATA COLD/-99./,KOLD/-99./,CGOLD/-99./
      IF(COLD.EQ.C.AND.KOLD.EQ.K.AND.CGOLD.EQ.CG) GOTO 11
      COLD=C
      KOLD=K
      CGOLD=CG
      AE2=AE*AE
      AE3=0.5D0*AE2
      AM2=AM*AM
      S2=1.D0-C*C
      AS2=AE2*S2
      SG=DSQRT(1.D0-CG*CG)
      S =DSQRT(S2)
      RC =DSQRT((CG-E*C)**2+AS2)
      RMC=DSQRT((CG+E*C)**2+AS2)
      ABC =CG*C+SG*S
      ABCM=(1.D0+ABC)+AE3
      ABC =(1.D0-ABC)+AE3
      KM=1.D0-K
      KM2=1.D0+KM*KM
      CP=1.D0+C
      CM=1.D0-C
      CS=1.D0+C*C
      AKC =(CP*CP+KM*KM*CM*CM)/(CP+KM*CM)**4
      AKCM=(CM*CM+KM*KM*CP*CP)/(CM+KM*CP)**4
      Y=2.D0-K+K*CG
      X=2.D0*KM/Y
      DEL=AM2*K/4.D0/KM
      TK=2.D0*(X-KM+DEL)
      UK=2.D0*(1.D0-X+DEL)
      TT=(KM2-AM2*K/TK)/TK
      TU=(KM2-AM2*K/UK)/UK
      Y2=Y*Y
C
   11 CF=DCOS(FIG)
      SF=DSIN(FIG)
      SF1=DSIN(.5D0*FIG)
      CF1=DCOS(.5D0*FIG)
      ARGTC =DATAN(RC *SF1/ABC /CF1)
      ARGTMC=DATAN(RMC*SF1/ABCM/CF1)
      IF(CF1.GT.(0.D0))GO TO 1
      ARGTC =ARGTC +PI
      ARGTMC=ARGTMC+PI
    1 E1C =2.D0/RC*ARGTC
      E1MC=2.D0/RMC*ARGTMC
      ABCF =C*CG+S*SG*CF
      ABCFM=(1.D0+ABCF)+AE3
      ABCF =(1.D0-ABCF)+AE3
      E2C =( S*SG*SF/ABCF +(E-C*CG)*E1C )/RC /RC
      E2MC=(-S*SG*SF/ABCFM+(E+C*CG)*E1MC)/RMC/RMC
      TC =KM2*E1C -AE2*KM*E2C
      TMC=KM2*E1MC-AE2*KM*E2MC
      Y2FIG=4.D0/K*( AKC*TC + AKCM*TMC )
     Z    +2.D0*CS*KM*FIG*( TT + TU )/Y2
      RETURN
      END
