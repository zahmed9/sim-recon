*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:43  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:27  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 16/09/94  02.27.35  by  Paul Avery
*CMZ :  1.03/49 22/09/92  11.59.07  by  Peter C Kim
*-- Author :    Peter C Kim   21/09/92
* 16/10/96 Lynn Garren: Add double precision conditionals.
      SUBROUTINE GNSNGL
C.......................................................................
C.
C. GNSNGL - Generate single particle
C.
C. COMMON    : MCGEN,QQSNGL
C. Called    : MODEVT
C
C. Author    : Peter C Kim  21/09/92  14.15.42
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
*
#include "seq/clinc/qqpars.inc"
#include "qqlib/seq/mcgen.inc"
#include "qqlib/seq/qqsngl.inc"
*
      INTEGER QQRINP
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION GETMAS
      REAL RANP
#else
      REAL RANP,GETMAS
#endif
      EXTERNAL RANP,GETMAS,QQRINP

      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'GNSNGL' )

      INTEGER QCODE
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION CMAS,PMOM,PHI
      DOUBLE PRECISION COST,SINT,COS1,COS2,COSP,SINP
#else
      REAL CMAS,PMOM,PHI
      REAL COST,SINT,COS1,COS2,COSP,SINP
#endif
*
C-- QQ particle ID and mass

      QCODE = QQRINP(CSINGL)
      CMAS  = GETMAS(QCODE)

C-- Momentum

      IF(PSINGL(1).EQ.PSINGL(2)) THEN
        PMOM = PSINGL(1)
      ELSE
        PMOM = RANP(0)*(PSINGL(2)-PSINGL(1)) + PSINGL(1)
      ENDIF

C-- Theta

      IF(STHET(1).EQ.STHET(2)) THEN
        COST = COS(STHET(1))
        SINT = SIN(STHET(1))
      ELSE
        COS1 = COS(STHET(1))
        COS2 = COS(STHET(2))
        COST = RANP(0)*(COS2-COS1) + COS1
        SINT = SQRT(1.0-COST*COST)
      ENDIF

C-- Phi

      IF(SPHI(1).EQ.SPHI(2)) THEN
        COSP = COS(SPHI(1))
        SINP = SIN(SPHI(1))
      ELSE
        PHI  = RANP(0)*(SPHI(2)-SPHI(1)) + SPHI(1)
        COSP = COS(PHI)
        SINP = SIN(PHI)
      ENDIF

C-- Save in the P and K banks

      N = 1

      P(N,1) = PMOM*SINT*COSP
      P(N,2) = PMOM*SINT*SINP
      P(N,3) = PMOM*COST
      P(N,4) = SQRT(CMAS*CMAS + PMOM*PMOM)
      P(N,5) = CMAS

      K(N,1) = 0
      K(N,2) = QCODE


C-- Decay any unstable particles
      CALL DECADD

      RETURN
      END
