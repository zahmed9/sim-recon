*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:40  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:30  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.02/00 05/06/90  15.41.33  by  Jorge L. Rodriguez
*-- Author :
* 15/10/96 Lynn Garren:  Add double precision conditionals.
      SUBROUTINE ANGGEN(ECM,POL)
C.......................................................................
C.
C. ANGGEN -
C.
C. Inputs    :
C. Outputs   :
C.
C. COMMON    : MCGEN
C.
C. Calls     : ROTBST
C. Called    : EVTGEN
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

*- Argument declarations
      REAL ECM, POL
*
*- External declarations
      REAL     RANP
      EXTERNAL RANP
*
*- Sequence declarations
#include "qqlib/seq/mcgen.inc"

      INTEGER ISEED
      COMMON/RANDM/ISEED

*- Local declarations
*
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'ANGGEN' )
*
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION QME, SIGU, SIGL, SIGT, SIGI
      DOUBLE PRECISION X1, X2, X3, XQ, CT12, ST12, SIGM
      DOUBLE PRECISION CHI, CTHE, THE, PHI, SIG
#else
      REAL QME, SIGU, SIGL, SIGT, SIGI
      REAL X1, X2, X3, XQ, CT12, ST12, SIGM
      REAL CHI, CTHE, THE, PHI, SIG
#endif
*
*- Executable code starts here
*
*
      IF (KC(1).NE.0) QME=(2.*QMAS(IABS(KC(1)))/ECM)**2
      IF (NC.NE.2 .OR. KC(1).EQ.0) GOTO 101

C-- Differential cross sections for QQ events
      SIGU = 1.
      SIGL = QME
      SIGT = 0.
      SIGI = 0.
  101 IF (NC.NE.3 .OR. KC(1).EQ.0) GOTO 102

C-- Differential cross sections for QQG events
      X1=2.*PC(1,4)/ECM
      X2=2.*PC(2,4)/ECM
      X3=2.-X1-X2
      XQ=(1.-X1)/(1.-X2)
      CT12=(X1*X2-2.*X1-2.*X2+2.+QME)/SQRT((X1**2-QME)*(X2**2-QME))
      ST12=SQRT(1.-CT12**2)
      SIGU=2.*X1**2+X2**2*(1.+CT12**2)-QME*(3.+CT12**2-X1-X2)-
     +QME*X1/XQ+0.5*QME*((X2**2-QME)*ST12**2-2.*X2)*XQ
      SIGL=2.*(X2*ST12)**2-2.*QME*(3.-CT12**2-2.5*(X1+X2)+X1*X2+QME)+
     +QME*(X1**2-X1-QME)/XQ+QME*((X2**2-QME)*CT12**2-X2)*XQ
      SIGT=(X2**2-QME-0.5*QME*(X2**2-QME)/XQ)*ST12**2
      SIGI=(4.-2.*QME*XQ)*(X2**2-QME)*ST12*CT12+4.*QME*(1.-X1-X2+
     +0.5*X1*X2+0.5*QME)*ST12/CT12
  102 IF (KC(1).NE.0) GOTO 103

C-- Differential cross sections for GGG events
      X1=P(248,1)
      X2=P(248,2)
      X3=2.-X1-X2
      CT12=(X1*X2-2.*X1-2.*X2+2.)/(X1*X2)
      ST12=SQRT(1.-CT12**2)
      SIGL=X2**2*((1.-X2)**2+(1.-X3)**2)*ST12**2
      SIGU=(X1*(1.-X1))**2+(X2*(1.-X2))**2+(X3*(1.-X3))**2-0.5*SIGL
      SIGT=0.5*SIGL
      SIGI=2.*SIGL*CT12/ST12+2.*X1*X2*(1.-X3)**2*ST12
  103 CONTINUE

C-- Generation of angular orientation
      SIGM=(2.+DIM(ABS(POL),1.))*ABS(SIGU)+(1.+ABS(POL))*ABS(SIGL)+
     +1.42*(1.+ABS(POL)+DIM(ABS(POL),1.))*(ABS(SIGT)+0.5*ABS(SIGI))
 100  CHI=6.2832*RANP(ISEED)
      CTHE=2.*RANP(ISEED)-1.
      THE=ACOS(CTHE)
      PHI=6.2832*RANP(ISEED)
      SIG=(1.+CTHE**2)*SIGU+(1.-CTHE**2)*(SIGL+COS(2.*CHI)*SIGT)-CTHE*
     +SIN(THE)*COS(CHI)*SIGI+POL*((1.-CTHE**2)*COS(2.*PHI)*(SIGU-SIGL)+
     +((1.+CTHE**2)*COS(2.*PHI)*COS(2.*CHI)-2.*CTHE*SIN(2.*PHI)*
     +SIN(2.*CHI))*SIGT+(CTHE*COS(2.*PHI)*COS(CHI)-SIN(2.*PHI)*
     +SIN(CHI))*SIGI*SIN(THE))
      IF(SIG.LT.SIGM*RANP(ISEED)) GOTO 100

#if defined(NONCLEO_DOUBLE)
      CALL ROTBST(0.D0,CHI,0.D0,0.D0,0.D0)
      CALL ROTBST(THE,PHI,0.D0,0.D0,0.D0)
#else
      CALL ROTBST(0.,CHI,0.,0.,0.)
      CALL ROTBST(THE,PHI,0.,0.,0.)
#endif

      RETURN
      END
