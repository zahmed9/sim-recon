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
*CMZ :  1.02/00 05/06/90  15.41.33  by  Jorge L. Rodriguez
*-- Author :
* 15/10/96 Lynn Garren:  Add double precision conditionals.
      SUBROUTINE GGGGEN(ECM,ICH)
C.......................................................................
C.
C. GGGGEN -
C.
C. Inputs    :
C. Outputs   :
C.
C. COMMON    : MCGEN
C.
C. Calls     : GGGJET ROTBST
C. Called    : EVTGEN
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

*- Argument declarations
      INTEGER ICH
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
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'GGGGEN' )
*
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION X1, X2, X3
      DOUBLE PRECISION PGAM, ECMR, ECMD
#else
      REAL X1, X2, X3
      REAL PGAM, ECMR
#endif
*
*- Executable code starts here
*
C-- Choice of X1 and X2 according to matrix element
 100  X1=RANP(ISEED)
      X2=RANP(ISEED)
      X3=2.-X1-X2
      IF(X3.GE.1.) GO TO 100
      IF(((1.-X1)/(X2*X3))**2+((1.-X2)/(X1*X3))**2+
     +((1.-X3)/(X1*X2))**2.LE.2.*RANP(ISEED)) GOTO 100
      P(248,1)=X1
      P(248,2)=X2

C-- Three-gluon or gluon-gluon-photon event
#if defined(NONCLEO_DOUBLE)
      PGAM=0.382*(ICH/3.)**2*PAR(5)*(33.-2.*PAR(6))*ALOG(ECM/PAR(7))
      IF(RANP(ISEED).LE.PGAM/(1.+PGAM)) GOTO 101
      ECMD = ECM
      CALL GGGJET(ECMD,X1,X2)
#else
      PGAM=0.382*(ICH/3.)**2*PAR(5)*(33.-2.*PAR(6))*ALOG(ECM/PAR(7))
      IF(RANP(ISEED).LE.PGAM/(1.+PGAM)) GOTO 101
      CALL GGGJET(ECM,X1,X2)
#endif
      RETURN

  101 ECMR=SQRT(1.-X3)*ECM
#if defined(NONCLEO_DOUBLE)
      IF(ECMR.LE.1.D0) GOTO 100
      CALL GGGJET(ECMR,1.D0,1.D0)
      CALL ROTBST(ACOS((X2-X1)/X3),0.D0,0.D0,0.D0,-X3/(X1+X2))
#else
      IF(ECMR.LE.1.) GOTO 100
      CALL GGGJET(ECMR,1.,1.)
      CALL ROTBST(ACOS((X2-X1)/X3),0.,0.,0.,-X3/(X1+X2))
#endif
      N=N+1

C-- Stay where we are at
      IF(IST.EQ.-1) N=LASTN+1
      IF(IST.EQ.-1) IST=-2
      K(N,1)=38
      K(N,2)=1
      P(N,1)=0.
      P(N,2)=0.
      P(N,3)=0.5*X3*ECM
      P(N,4)=P(N,3)
      P(N,5)=0.

#if defined(NONCLEO_DOUBLE)
      CALL ROTBST(-ACOS(PC(1,3)/PC(1,4)),0.D0,0.D0,0.D0,0.D0)
#else
      CALL ROTBST(-ACOS(PC(1,3)/PC(1,4)),0.,0.,0.,0.)
#endif

      RETURN
      END
