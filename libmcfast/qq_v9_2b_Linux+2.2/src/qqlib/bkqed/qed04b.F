*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:34  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:29  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.01/00 18/09/90  08.36.33  by  Paul Avery
*CMZ :  1.00/00 04/06/90  18.55.46  by  Jorge L. Rodriguez
*-- Author :

      SUBROUTINE QED04B(K1,K2,K3)

      IMPLICIT DOUBLE PRECISION(A-H,K-Z)

      REAL RANP
      EXTERNAL RANP
      DIMENSION L(3,4),K1(4),K2(4),K3(4)
      INTEGER PERM(3,6)
      DATA PERM/1,2,3, 2,3,1, 3,1,2, 3,2,1, 2,1,3, 1,3,2/
      DO 11 I=1,4
      L(1,I)=K1(I)
      L(2,I)=K2(I)
11    L(3,I)=K3(I)
C...PICK ANY PERMUTATION OF THE THREE MOMENTA
C...TO ASSURE SYMMETRICAL EVENT SHAPES
      IT=IDINT(RANP(0)*6.D0)+1
      J1=PERM(1,IT)
      J2=PERM(2,IT)
      J3=PERM(3,IT)
      DO 7 J=1,4
      K1(J)=L(J1,J)
      K2(J)=L(J2,J)
    7 K3(J)=L(J3,J)
      RETURN
      END
