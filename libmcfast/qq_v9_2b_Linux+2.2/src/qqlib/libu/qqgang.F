*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:38  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:28  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 22/09/94  00.24.28  by  Paul Avery
*CMZ :  1.01/00 29/10/90  23.44.23  by  Paul Avery
*CMZ :          29/10/90  10.16.03  by  Paul Avery
*>> Author :
* 16/10/96 Lynn Garren: Add double precision conditionals.
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION FUNCTION QQGANG(A)
#else
      REAL FUNCTION QQGANG(A)
#endif

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C    Returns cos(theta) generated according to the distribution
C
C      dN/dcos = A1 + A2*cos(theta) + ... + A7*cos(theta)**6
C
C   Note: Caller must be careful that the function is never negative.
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C     External declarations
      REAL RANP
      EXTERNAL RANP

C     Calling arguments
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION A(7)
#else
      REAL A(7)
#endif
*
C     Local variables
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION FMAX, R, FUNC
#else
      REAL FMAX, R, FUNC
#endif
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C     If A2-7 = 0, generate flat
      IF(A(2).EQ.0 .AND. A(3).EQ.0 .AND. A(4).EQ.0 .AND.
     *   A(5).EQ.0 .AND. A(6).EQ.0 .AND. A(7).EQ.0) THEN
        QQGANG = 2. * RANP(0) - 1.

C     Try to be a little efficient
      ELSE
#if defined(NONCLEO_DOUBLE)
        FMAX = DMAX1(0.D0,A(1)) + DABS(A(2))
     *       + DMAX1(0.D0,A(3)) + DABS(A(4))
     *       + DMAX1(0.D0,A(5)) + DABS(A(6)) + DMAX1(0.D0,A(7))
#else
        FMAX = MAX(0.,A(1)) + ABS(A(2)) + MAX(0.,A(3)) + ABS(A(4))
     *       + MAX(0.,A(5)) + ABS(A(6)) + MAX(0.,A(7))
#endif
10      QQGANG = 2. * RANP(0) - 1
        R = FMAX * RANP(0)
        FUNC = A(1) + QQGANG*(A(2) + QQGANG*(A(3) + QQGANG*
     *        (A(4) + QQGANG*(A(5) + QQGANG*(A(6) + QQGANG*A(7))))))
        IF(R .GT. FUNC) GOTO 10
      ENDIF

C     Only exit
      RETURN
      END
