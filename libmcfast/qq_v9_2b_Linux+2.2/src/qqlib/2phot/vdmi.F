*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:33  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:35  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.03/15 04/12/90  13.13.23  by  R.A.FULTON
*-- Author :
* 17/10/96 Lynn Garren: Add double precision conditionals.
      SUBROUTINE VDMI(QSQ,WEIGHT)

C   Use a GVDM F2 to weight MC events. Events were thrown with
C   F2 = alpha * sqrt(qsq). Use F2 = qsq*300nb*ff(qsq) (up to
C   constants), i.e., a constant cross section.

      INTEGER    I
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION M(3), R(3), QSQ, WEIGHT, FF
#else
      REAL       M(3), R(3), QSQ, WEIGHT, FF
#endif

      DATA M/0.77,0.783,1.02/
      DATA R/0.65,0.08,0.05/


        FF = 0.
C       QSQ = ABS(QSQ)

C       get the form factor.
        DO 10 I=1,3
         FF = FF + R(I) * (1.+ QSQ/(4.*M(I)**2))/
     +                       (1.+ QSQ/M(I)**2)**2
 10     CONTINUE

C     FF = FF + 0.22/(1.+ QSQ/1.4**2)

C   THE REST...
C     WEIGHT = FF
      WEIGHT = FF/0.78

      RETURN
      END
