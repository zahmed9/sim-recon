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
*CMZ :  1.04/00 22/09/94  00.24.39  by  Paul Avery
*CMZ :  1.03/26 04/10/91  11.46.31  by  Peter C Kim
*CMZ :  1.01/00 30/10/90  00.43.50  by  Paul Avery
*CMZ :  1.00/00 23/08/90  15.50.56  by  Paul Avery
*-- Author :
* 16/10/96 Lynn Garren: Add double precision conditionals.
      SUBROUTINE QQGEN2(T, CMAS, XMATRX, XM, P)

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C     Decay the 4-vector T into 2 body phase space
C
C  T        real array (read)
C           4-vector of parent
C
C  CMAS     real variable (real)
C           Mass of parent (redundant)
C
C  XMATRX   real array (read)
C           XMATRX(1-7) = Coefficients of angular distribution
C
C  XM       real array (read)
C           XM(1-2) = Masses of 2 daughters
C
C  P        real array (write)
C           P(1-4,2) = 4-vectors of daughters
C
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C     External declarations
#if defined(NONCLEO_DOUBLE)
      REAL RANP
      DOUBLE PRECISION QQGANG
#else
      REAL RANP, QQGANG
#endif
      EXTERNAL RANP, QQGANG

C     Calling arguments
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION T(4), CMAS, XMATRX(7), XM(2), P(4,2)
#else
      REAL T(4), CMAS, XMATRX(7), XM(2), P(4,2)
#endif

C     Local variables
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION COSTH, SINTH, EE, PP, PPD, PHI, THETA, PSQ
#else
      REAL COSTH, SINTH, EE, PP, PPD, PHI, THETA, PSQ
#endif
      INTEGER I

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      COSTH = QQGANG(XMATRX)
      PHI = 2. * 3.141592654 * RANP(0)
      SINTH = SQRT(1. - COSTH**2)
      EE = (CMAS**2 + XM(1)**2 - XM(2)**2) / (2. * CMAS)

C== SQRT protected  (PCK 2/10/91)

      PSQ = EE**2 - XM(1)**2
      IF(PSQ.LE.0.0) THEN
          PP = 0.0
      ELSE
          PP = SQRT(PSQ)
      ENDIF

      P(1,1) = PP * SINTH * COS(PHI)
      P(2,1) = PP * SINTH * SIN(PHI)
      P(3,1) = PP * COSTH
      P(4,1) = EE

      P(1,2) = -P(1,1)
      P(2,2) = -P(2,1)
      P(3,2) = -P(3,1)
      P(4,2) = CMAS - EE

      PPD = SQRT(T(1)**2 + T(2)**2 + T(3)**2)

C   If parent momentum is 0, we are done
      IF(PPD .EQ. 0) GOTO 1000

C   If we have an angular distribution, must reference it to particle
C   direction. We will rotate to this direction before we boost to lab
      IF(XMATRX(2).NE.0 .OR. XMATRX(3).NE.0.) THEN
        THETA = ACOS(T(3) / PPD)
        IF(T(1).EQ.0. .AND. T(2).EQ.0.) THEN
          PHI = 0.
        ELSE
          PHI = ATAN2(T(2), T(1))
        ENDIF
#if defined(NONCLEO_DOUBLE)
        CALL D4ROTA(PHI, THETA, 0.D0, 2, P, P)
#else
        CALL R4ROTA(PHI, THETA, 0., 2, P, P)
#endif
      ENDIF
#if defined(NONCLEO_DOUBLE)
      CALL DBOOSF(T, 2, P, P)
#else
      CALL RBOOSF(T, 2, P, P)
#endif

C     Only exit
1000  RETURN
      END
