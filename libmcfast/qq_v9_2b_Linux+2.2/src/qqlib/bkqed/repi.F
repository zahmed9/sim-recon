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
*CMZ :  1.00/00 04/06/90  18.55.45  by  Jorge L. Rodriguez
*-- Author :

      FUNCTION REPI(S)
      IMPLICIT DOUBLE PRECISION(A-H,O-Z)
C-------------------------------------------- REMARKS -----------------
C VACUUM POLARIZATION IN QED. THE LEPTONIC CONTRIBUTION IS AN ANALYTIC
C EXPRESSION INVOLVING THE LEPTON MASS; THE HADRONIC CONTRIBUTION IS
C A DISPERSION INTEGRAL OVER THE KNOWN HADRONIC CROSS SECTION. THE
C RESULT USED HERE IS A PARAMETRIZATION GIVEN BY
C H.BURKHARDT, TASSO NOTE 192(1981).
C----------------------------------------------------------------------

C     Calling arguments

*
C     Local variables

*
C     External declarations


      DATA IFLAG/0/
      IF(S.LE.0.D0 .OR. S.GT.100.D0) GOTO 311
C*****          IF(IFLAG.EQ.0) TYPE 1,S
1               FORMAT('0S=',F6.3,' GEV**2',/,
     *          ' VACUUM POLARIZATION MAY BE BADLY APPROXIMATED')
                IFLAG=1
311   X=DABS(S)
C-------------------------------------------- HADRONIC PART -----------
      IF(X.LT.1.)  REPI= - 0.002302*DLOG(1.+4.091*X)
      I F(X.GE.1..AND.
     *   X.LT.64.) REPI= - 0.002822*DLOG(1.+1.218*X) - 0.001512
      IF(X.GE.64.) REPI= - 0.003068*DLOG(1.+      X) - 0.0011344
C-------------------------------------------- LEPTONIC PART -----------
      REPI= REPI - 0.01045 - 0.002323*DLOG(X)
      RETURN
      END
