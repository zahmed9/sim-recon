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

      FUNCTION Y3KQ(QKQK)
      IMPLICIT DOUBLE PRECISION(A-H,K-Z)

      COMMON / GETAL / BARN,PI,ALFA,BETA,DELTA,SIG0,AME,AMT,EME,S
      COMMON / GRENS / KMAX,A ,CMAX,SOFT,TRSHLD,K0
      K=K0*DEXP(QKQK)
      KM=1.D0-K
C finite contribution of hard bremsstrahlung
      FINITE=0.5D0*(-DLOG(KM)-K)
      IF(AMT.EQ.0.D0) GOTO 43
C
C mass effects of heavy particle
C
      G=(KMAX-K)/AMT
      IF(G.GT.0.001D0)GO TO 1
C...note that kmax=1-amt
C...X=SQRT(1-AMT/KM) or: KM=AMT*(1+EPS)...X=SQRT(EPS/(EPS+1))
      IF(G.GE.0.D0) GOTO 3
      X=0.D0
C*****IF(G.LT.-1.D-13)TYPE*,' COMPLAINT FROM Y3KQ...G=',G,', K=',K
      GOTO 2
    3 X=DSQRT(G*(1.D0-G*(1.D0-G)))
      GO TO 2
    1 X =DSQRT(1.D0-AMT/KM)
    2 X0=DSQRT(1.D0-AMT)
      FINITE=FINITE+DLOG((1.D0+X0)/(1.D0+X))
     Z   +X*(1.D0-X*X/6.D0)-X0*(1.D0-X0*X0/6.D0)
C TOTAL CORRECTED CROSSECTION WITH EXPONENTIATION (LAB SYSTEM)
   43 Y3KQ=BETA*(FINITE+QKQK)
      RETURN
      END
