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
*CMZ :  1.00/00 04/06/90  18.55.46  by  Jorge L. Rodriguez
*-- Author :

      DOUBLE PRECISION FUNCTION QED04Z(C)

C  ----------------------------------------------------------------------------
C...FINITE ANGLE-DEPENDENT PART OF VIRTUAL CORRECTIONS
C...THIS MUST BE EVEN IN C
C...THE PSEUDODIVERGENCE IN 1/(K-MU/2) IS TREATED SEPARATELY
C  ----------------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION(A-H,K-Z)

      COMMON / CON1 / PI,M,ALFA,PI2,LE,E,DL,MU,S,DUMMY(8)
      M2=0.5D0*MU
      QED04Z=0.D0
      I=0
      C1=C
    1 K=0.5D0*(1.D0+C1)+M2
      T=0.5D0*(1.D0-C1)+M2
      H0=.5D0/K+.5D0/T
      H1=0.5D0/K+1.D0/T-0.5D0
      H2=2.D0/K-0.5D0+MU/K/K
      H3=-K-0.75D0/T+0.75D0
      H4=-1.5D0/T+1.5D0 -MU/T/T
      H5=2.D0/T+1.D0/K-1.D0 +2.D0*M2*M2/K/K/K
      U=K/M2-1.D0
      FACLI2=PI2/6.D0-DILOG(-U)
      IF(U.LE.1.D-03) GO TO 4
      DIVTRM=DLOG(U+1.D0)*(-1.D0/MU/U-0.5D0/U/U)+0.5D0/U
      GO TO 5
    4 DIVTRM=-1.D0/MU
    5 QED04Z=(0.25D0*LE*LE-PI2/12.D0)*(H0 + 1.D0)
     Z +(DLOG(K)+LE)*(-2.D0*LE*H1 + H2)
     Z +(PI2-LE*LE)*H3 + (2.D0*M2/K-1.D0)*LE
     Z +H4 + FACLI2*H5 + DIVTRM + QED04Z
      IF (I.EQ.1) RETURN
      I=1
      C1=-C
      GO TO 1
      END
