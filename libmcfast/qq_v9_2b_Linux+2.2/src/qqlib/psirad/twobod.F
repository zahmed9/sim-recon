*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:40  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:37  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 04/10/94  22.14.17  by  Paul Avery
*CMZ :  1.03/57 15/02/93  16.26.40  by  Peter C Kim
*-- Author :    D. Coffman    15/02/93
      DOUBLE PRECISION FUNCTION TWOBOD(  P4A,   P4B,   P4C,
     *                                 MASSA, MASSB, MASSC )
C
C Generate the 4-vectors for the process A --> B C according to
C two-body phase-space.
C

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

      DOUBLE PRECISION P4A(4), P4B(4), P4C(4)
      DOUBLE PRECISION MASSA,  MASSB,  MASSC
      DOUBLE PRECISION P4_TEMP(4)

C
C Declare the random number generator
C

      INTEGER  ISEED
      COMMON/RANDM/ISEED
      REAL     RANP
      EXTERNAL RANP

      DOUBLE PRECISION COSTHT, SINTHT, PHI
      DOUBLE PRECISION QB
      DOUBLE PRECISION TWOPI, FOURPI
      PARAMETER(TWOPI = 2.0D0*3.141592653D0, FOURPI=2.0D0*TWOPI)
      DOUBLE PRECISION LAMBDA
C
C Generate the direction of B in the rest frame of A.
C
      COSTHT = 2.0D0*DBLE(RANP(ISEED)) - 1.0D0
      SINTHT = DSQRT(DMAX1(0.0D0, 1.0D0 - COSTHT**2))
      PHI    = TWOPI*DBLE(RANP(ISEED))
C
C Calculate the 4-momentum of B in the rest frame of A.
C
      QB = DSQRT(DMAX1(0.0D0,
     *        LAMBDA(MASSA**2, MASSB**2, MASSC**2)))
     *        / (2.0D0*MASSA)

      P4B(1) = QB*SINTHT*DCOS(PHI)
      P4B(2) = QB*SINTHT*DSIN(PHI)
      P4B(3) = QB*COSTHT
      P4B(4) = DSQRT(QB**2 + MASSB**2)
C
C Boost the 4-momentum of B to the lab frame.
C
      CALL EBOOST(MASSA, P4A, P4B)
C
C Calculate the 4-momentum of C from momentum conservation.
C
      P4C(1) = P4A(1) - P4B(1)
      P4C(2) = P4A(2) - P4B(2)
      P4C(3) = P4A(3) - P4B(3)
      P4C(4) = P4A(4) - P4B(4)
C
C Calculate the event weight.
C
      TWOBOD = QB/(4.0D0*MASSA)  * FOURPI

C That's all there is to it!

      RETURN
      END
