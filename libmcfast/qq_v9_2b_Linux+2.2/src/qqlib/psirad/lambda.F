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
*CMZ :  1.04/00 04/10/94  22.13.38  by  Paul Avery
*CMZ :  1.03/57 15/02/93  16.15.37  by  Peter C Kim
*-- Author :    D. Coffman    15/02/93
      DOUBLE PRECISION FUNCTION LAMBDA(X, Y, Z)
C--------------------------------------------------------------------+
C This is the "three-body phase-space" function.                     |
C                                                                    |
C    In the rest frame of a particle decaying to two other           |
C    particles, the three-momenta of these particles has magnitude:  |
C                                                                    |
C        p = lambda(m0**2, m1**2, m2**2)**1/2                        |
C            -------------------------------                         |
C                  2*m0                                              |
C--------------------------------------------------------------------+
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

      DOUBLE PRECISION X, Y, Z
      LAMBDA = X**2      + Y**2      + Z**2
     *       - 2.0D0*X*Y - 2.0D0*X*Z - 2.0D0*Y*Z
      RETURN
      END
