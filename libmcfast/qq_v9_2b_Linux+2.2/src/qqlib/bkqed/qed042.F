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
*CMZ :  1.02/00 07/02/91  18.02.15  by  Tomasz Skwarnicki
*CMZ :   fix bug with IERR4 (was declared as double precision)
*CMZ :  1.01/00 17/09/90  23.22.39  by  Paul Avery
*CMZ :  1.00/00 04/06/90  18.55.46  by  Jorge L. Rodriguez
*-- Author :

      SUBROUTINE QED042(K1,K2,K3)
      IMPLICIT DOUBLE PRECISION(A-Z)

      DIMENSION K1(4),K2(4),K3(4)
      COMMON / CON1 / PI,M,ALFA,PI2,LE,E,DL,MU,S,K0,CMAX,BETA,
     *                SIG0,SIGA,SIGCOL,THRSLD,LK0
      COMMON / TRY4 / RHO,TTOT,IEV,ITRY,ISYM
      COMMON / OUT13 / K,C,Z,FI,FG
      COMMON / OUT12 / SC,SZ,CGAM,E2
      INTEGER IEV,ITRY,ISYM
      INTEGER IERR4
      REAL RANP
      EXTERNAL RANP
      EXTERNAL Y4KQ,Y4CQ
      IEV=IEV+1
    1 ITRY=ITRY+1
      ISYM=ISYM+1
      FI=2.D0*PI*RANP(0)
      FG=2.D0*PI*RANP(0)
      IF(RANP(0).GT.THRSLD) GOTO 311
C...SOFT CASE: NO BREMSSTRAHLUNG ASSUMED
C...C GOES AS 2./(SIN**2(TH)+M**2) (GIVEN BY "GENCOS" PLUS REFLECTION)
         K=0.D0
         C=GENCOS(K)
         IF(RANP(0).GT.0.5D0) C=-C
         Z=1.D0
      GOTO 312
C...HARD CASE; GENERATE BREMSSTRAHLUNG ABOVE K0
311      CALL EVGENH(Y4KQ,0.,DLOG(1.D0/K0),KLOG)
         K=K0*DEXP(KLOG)
         CALL EVGENH(Y4CQ,0.D0,DLOG(1.+1./MU),CCC)
         C=(1.+MU)*(1.-DEXP(-CCC))
         IF(RANP(0).GT.0.5D0) C=-C
         Z=GENCOS(K)
         IF(RANP(0).GT.WEIZ(K,C)) Z=-Z
312   CONTINUE
      SC=DSQRT((1.-C)*(1.+C))
      SZ=DSQRT((1.-Z)*(1.+Z))
      K=E*K
      CGAM=C*Z+SC*SZ*DCOS(FI-FG)
      E2=2.D0*E*(E-K)/(2.D0*E-K+K*CGAM)
      CALL QEDSY4(IERR4)
      IF(IERR4 .NE. 0)GOTO 1
      ISYM=ISYM-1
      T=QEDTS4(0.D0)
      TTOT=TTOT+T
      IF(RHO*RANP(0).GT.T) GO TO 1
      CALL QED04A(K1,K2,K3)
      CALL QED04B(K1,K2,K3)
      RETURN
      END
