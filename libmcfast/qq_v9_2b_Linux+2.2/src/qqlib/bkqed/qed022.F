*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:34  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:28  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.03/10 12/06/91  11.31.36  by  Peter C Kim
*CMZ :  1.01/00 17/09/90  23.22.39  by  Paul Avery
*CMZ :  1.00/00 04/06/90  18.55.46  by  Jorge L. Rodriguez
*-- Author :

      SUBROUTINE QED022(QP,QM,PH)
      IMPLICIT DOUBLE PRECISION(A-H,K,O-Z)

      DIMENSION QP(4),QM(4),PH(4)
      COMMON / CONSTQ / E,AE,AM,ALE,ALM,ALL,PI,PI2,ALFA,BETA
      COMMON /CONST1/ CMAX,K0,KMIN,KMAX,SIG0,SOFT1,TRSHLD,CHI,GV2,DELW
      COMMON / TRY / RHO,TES,ITRY,IEV,ISYM
      COMMON / OUTPAR / K,C,CG,FIG,FI
      COMMON / OUTPA2 / S,SG,CFIG,SFIG,CFI,SFI
      REAL RANP
      EXTERNAL RANP
      EXTERNAL Y2KQ,Y2C,Y2CSFT,Y2CG,Y2FIG
      IEV=IEV+1
    1 ITRY=ITRY+1
      ISYM=ISYM+1
C...DETERMINE HARD OR SOFT USING HELMUT'S METHOD
      IF(RANP(0).GT.TRSHLD) GOTO 311
         K=0.D0
         CALL EVGENH(Y2CSFT,-1.D0,+1.D0,C)
         IF(DABS(C).GT.CMAX) GOTO 1
         CG=1.D0
         FIG=0.D0
         CFIG=1.D0
         SFIG=0.D0
         SG=0.D0
        GOTO 312
311      CALL EVGENH(Y2KQ,0.D0,DLOG(KMAX/K0),KKK)
         K=K0*DEXP(KKK)
         CALL EVGENH(Y2C,-1.D0,+1.D0,C)
         IF(DABS(C).GT.CMAX) GOTO 1
         CALL EVGENH(Y2CG,-1.D0,1.D0,CG)
         CALL EVGENH(Y2FIG,0.D0,2.D0*PI,FIG)
         SG=DSQRT((1.D0-CG)*(1.D0+CG))
         CFIG=DCOS(FIG)
         SFIG=DSIN(FIG)
312   CONTINUE
      S=DSQRT((1.D0-C)*(1.D0+C))
      FI=2.D0*PI*RANP(0)
      CFI=DCOS(FI)
      SFI=DSIN(FI)
      IF(K.GT.0.D0)CALL QEDSY2(IERR2)
      IF(IERR2 .NE. 0)GOTO 1
      ISYM=ISYM-1
      IF(QEDTS2(0.D0).LT.(RANP(0)*RHO))GO TO 1
      CALL QED02A(QP,QM,PH)
      RETURN
      END
