*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:38  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:27  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.03/49 18/09/92  14.18.46  by  Peter C Kim
*CMZ :  1.01/00 08/09/90  17.34.12  by  Paul Avery
*CMZ :  1.00/01 06/09/90  12.23.13  by  Paul Avery
*-- Author :
* 28/10/96  L. Garren: Add double precision conditionals.
*                      Add infinite loop trap.
      INTEGER FUNCTION MLTGEN(CMEAN, CSIG, NDMIN, NDMAX)
C
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C   Generates multiplicity distribution generated like a Gaussian
C
C  CMEAN       real variable (read)
C              Mean of Gaussian distribution
C
C  CSIG        real variable (read)
C              Sigma of Gaussian distribution
C
C  NDMIN       integer variable (read)
C              Lowest integer to generate
C
C  NDMAX       integer variable (read)
C              Largest integer to generate
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
#if defined(NONCLEO_DOUBLE)
#include "qqlib/seq/qqluns.inc"
#endif
C     Calling arguments
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION CMEAN, CSIG
#else
      REAL CMEAN, CSIG
#endif
      INTEGER NDMIN, NDMAX

#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION QQGAUS
#else
      REAL QQGAUS
#endif
      EXTERNAL QQGAUS

C     Local variables
      INTEGER IDUMMY, IL
C
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      MLTGEN = NDMIN

C     If NDMIN far up the tail, return it as the answer
      IF(CSIG.LE.0 .OR. NDMIN-CMEAN.GT.3.0*CSIG) GOTO 1000

C     Generate integer between NDMIN and NDMAX distributed normally
C
C--- Bugfix (9/18/92  PCK)
C120   CALL QQGAUS(GAUSS)
C      MLTGEN = NINT(CMEAN + GAUSS)

#if defined(NONCLEO_DOUBLE)
      IL = 0
#endif
120   MLTGEN = NINT(CMEAN + QQGAUS(IDUMMY))
#if defined(NONCLEO_DOUBLE)
      IL = IL+1
      IF(IL.GT.1000) GO TO 2000
#endif
      IF(MLTGEN.LT.NDMIN .OR. MLTGEN.GT.NDMAX)GOTO 120

C     Only exit point
1000  RETURN
#if defined(NONCLEO_DOUBLE)
2000  CONTINUE
      WRITE(LTTOQQ,2001)
2001  FORMAT('MLTGEN: too many iterations')
      MLTGEN = NDMIN
      RETURN
#endif
      END
