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
*CMZ :  1.02/00 14/06/90  17.14.57  by  Paul Avery
*-- Author :
* 16/10/96 Lynn Garren:  Add double precision conditionals.
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION FUNCTION ZDIST(IFLL,ZMIN,ZMAX)
#else
      REAL FUNCTION ZDIST(IFLL,ZMIN,ZMAX)
#endif

C ---------------------------------------------------------------------
C     Generate z according to different fragmentation functions.
C     For u,d,s quarks use FF or LUND prescription.
C     For c,b,t quarks use Peterson's parametrization:
C
C         dSIG/dZ = { Z [1 - 1/Z - EPS/(1-Z)]**2 }**-1
C
C     EPS = .10 for c quarks and scales like 1/M**2
C ---------------------------------------------------------------------

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

*- Argument declarations
      INTEGER IFLL
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION    ZMIN, ZMAX
#else
      REAL    ZMIN, ZMAX
#endif

*- External declarations
      REAL     RANP
      EXTERNAL RANP
*
*- Sequence declarations
#include "qqlib/seq/mcgen.inc"
#include "qqlib/seq/qqinc.inc"

      INTEGER ISEED
      COMMON/RANDM/ISEED
*
*- Local declarations
*
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = ' ZDIST ' )
*
      INTEGER IFLA
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION EPS, ZPEAK, SIGMAX, FUNC
#else
      REAL    EPS, ZPEAK, SIGMAX, FUNC
#endif
*
*- Executable code starts here
*
      IFLA=IABS(IFLL)

C-- Heavy quarks
      IF (IFLA .GE. 4) THEN

         EPS = .10 * (QMAS(4)/QMAS(IFLA))**2

C-- Solve for MAX(dSIG/dZ)
         ZPEAK = 1 + .5*EPS - SQRT(EPS+.25*EPS**2)
         SIGMAX = 1./( ZPEAK * (1. - 1./ZPEAK - EPS/(1.-ZPEAK))**2 )

C-- REPEAT UNTIL (FUNC .GT. SIGMAX*RANP(ISEED))
   70    ZDIST = ZMIN + RANP(ISEED) * (ZMAX - ZMIN)
         FUNC = 1./( ZDIST * (1. - 1./ZDIST - EPS/(1.-ZDIST))**2 )
         GOTO 80
   80    IF (FUNC .GT. SIGMAX*RANP(ISEED)) GOTO 90
         GOTO 70
   90    CONTINUE

C-- Light quarks
      ELSE

100      ZDIST=RANP(ISEED)

C-- only for ff jets
         IF(IFR.NE.2) THEN
            IF(CZF(IFLA).GT.RANP(ISEED)) ZDIST=1.-ZDIST**(1./3.)
            IF(CZF(IFLA).LT.0.) ZDIST=ZDIST**(1./(1.-CZF(IFLA)))
         ENDIF
         IF(ZDIST.LT.ZMIN.OR.ZDIST.GT.ZMAX) GOTO 100

      ENDIF

      RETURN
      END
