*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:40  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:31  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.02/00 05/06/90  15.41.34  by  Jorge L. Rodriguez
*-- Author :
* 15/10/96 Lynn Garren:  Add double precision conditionals.
      SUBROUTINE QQGGEN(IFL,ECM)
C.......................................................................
C.
C. QQGGEN -
C.
C. Inputs    :
C. Outputs   :
C.
C. COMMON    : MCGEN
C.
C. Calls     : QQJET QQGJET
C. Called    : EVTGEN
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

*- Argument declarations
      INTEGER IFL
      REAL    ECM
*
*- External declarations
      REAL     RANP
      EXTERNAL RANP
*
*- Sequence declarations
#include "qqlib/seq/mcgen.inc"
      INTEGER ISEED
      COMMON/RANDM/ISEED
*
*- Local declarations
*
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'QQGGEN' )
*
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION ALS, CR, CRA, V1, V2, X1, X2, X3, QME
#else
      REAL ALS, CR, CRA, V1, V2, X1, X2, X3, QME
#endif
*
*- Executable code starts here
*
*
C-- Choose X1 and X2 within area with total probability=1

#if defined(NONCLEO_DOUBLE)
      ALS=6./((33.-2.*PAR(6))*ALOG(ECM/PAR(7)))
      CR=DEXP(-((1.+1./ALS-PAR(15))/PAR(16))**(1./PAR(17)))
      CRA=-DLOG(2.*CR)
#else
      ALS=6./((33.-2.*PAR(6))*ALOG(ECM/PAR(7)))
      CR=EXP(-((1.+1./ALS-PAR(15))/PAR(16))**(1./PAR(17)))
      CRA=-ALOG(2.*CR)
#endif

 100  V1=CRA*RANP(ISEED)
      V2=CRA*RANP(ISEED)
#if defined(NONCLEO_DOUBLE)
      X1=1.-DEXP(-DMAX1(V1,V2))
      X2=1.-DEXP(-DMIN1(V1,V2))
#else
      X1=1.-EXP(-AMAX1(V1,V2))
      X2=1.-EXP(-AMIN1(V1,V2))
#endif
      X3=2.-X1-X2

C-- mod 10-23-80 by MGDG
      IF(X3.GE.1.) GOTO 100

      IF((1.-X1)*(1.-X2).LE.CR*(1.-X3)) GOTO 100
      IF(X1**2+X2**2.LE.2.*RANP(ISEED)) GOTO 100

C-- Corrections (giving qq systems) due to quark masses and cuts

      QME=(2.*QMAS(IABS(IFL))/ECM)**2
      IF(4.*(1.-X1)*(1.-X2)*(1.-X3)/X3**2.LE.QME) GOTO 110
      IF(QME*X3+0.5*QME**2+(0.5*QME+0.25*QME**2)*((1.-X2)/(1.-X1)+
     +(1.-X1)/(1.-X2)).GT.(X1**2+X2**2)*RANP(ISEED)) GOTO 110
      IF(X1.GT.1.-2.5*PAR(9)*(5.*PAR(9)+4.*QMAS(IABS(IFL)))/ECM**2
     +.OR.(1.-X1)*(1.-X2)/(1.-X3).LT.8.*(PAR(9)/ECM)**2) GOTO 110
      IF(X1.GT.PAR(3).OR.0.5*X3*ECM.LT.PAR(4)) GOTO 110

C-- Call either QQJET or QQGJET

      CALL QQGJET(IFL,ECM,X1,X2)
      RETURN

110   CONTINUE
      CALL QQJET(IFL,ECM)

      RETURN
      END
