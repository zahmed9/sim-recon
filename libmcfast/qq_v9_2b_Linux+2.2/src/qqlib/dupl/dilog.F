*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:36  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:35  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.03/14 04/06/90  18.55.44  by  Jorge L. Rodriguez
*-- Author :

      FUNCTION DILOG(X)
C  ----------------------------------------------------------------------------
C---> VERSION OF DILOGARITHM FUNCTION FROM CERNLIB.
C
C     CONVERTED SINGLE ---> DOUBLE 12/15/80    B. LOCKMAN
C  ----------------------------------------------------------------------------

      IMPLICIT DOUBLE PRECISION (A-H,O-Z)

      Z=-1.644934066848226D0
      IF(X .LT.-1.0D0 ) GO TO 1
      IF(X .LE. 0.5D0 ) GO TO 2
      IF(X .EQ. 1.0D0 ) GO TO 3
      IF(X .LE. 2.0D0 ) GO TO 4
C
      Z=3.289868133696453D0
    1 T=1.0D0 /X
      S=-0.5D0
      Z=Z-0.5D0 *DLOG(DABS(X))**2
      GO TO 5
C
    2 T=X
      S=0.5D0
      Z=0.D0
      GO TO 5
C
    3 DILOG=1.644934066848226D0
      RETURN
C
    4 T=1.0D0 -X
      S=-0.5D0
      Z=1.644934066848226D0 -DLOG(X)*DLOG(DABS(T))
C
    5 Y=2.666666666666667D0 *T+0.666666666666667D0
      B=      0.00000 00000 00001D0
      A=Y*B  +0.00000 00000 00004D0
      B=Y*A-B+0.00000 00000 00011D0
      A=Y*B-A+0.00000 00000 00037D0
      B=Y*A-B+0.00000 00000 00121D0
      A=Y*B-A+0.00000 00000 00398D0
      B=Y*A-B+0.00000 00000 01312D0
      A=Y*B-A+0.00000 00000 04342D0
      B=Y*A-B+0.00000 00000 14437D0
      A=Y*B-A+0.00000 00000 48274D0
      B=Y*A-B+0.00000 00001 62421D0
      A=Y*B-A+0.00000 00005 50291D0
      B=Y*A-B+0.00000 00018 79117D0
      A=Y*B-A+0.00000 00064 74338D0
      B=Y*A-B+0.00000 00225 36705D0
      A=Y*B-A+0.00000 00793 87055D0
      B=Y*A-B+0.00000 02835 75385D0
      A=Y*B-A+0.00000 10299 04264D0
      B=Y*A-B+0.00000 38163 29463D0
      A=Y*B-A+0.00001 44963 00557D0
      B=Y*A-B+0.00005 68178 22718D0
      A=Y*B-A+0.00023 20021 96094D0
      B=Y*A-B+0.00100 16274 96164D0
      A=Y*B-A+0.00468 63619 59447D0
      B=Y*A-B+0.02487 93229 24228D0
      A=Y*B-A+0.16607 30329 27855D0
      A=Y*A-B+1.93506 43008 69969D0
      DILOG=S*T*(A-B)+Z
      RETURN
      END
