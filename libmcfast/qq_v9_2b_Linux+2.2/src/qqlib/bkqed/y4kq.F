*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:35  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:29  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.03/29 18/10/91  18.14.47  by  Peter C Kim
*CMZ :  1.00/00 04/06/90  18.55.46  by  Jorge L. Rodriguez
*-- Author :

      FUNCTION Y4KQ(KLOG)
      IMPLICIT DOUBLE PRECISION(A-Z)

      COMMON / CON1 / PI,M,ALFA,PI2,LE,E,DL,MU,S,K0,CMAX,BETA,
     *                SIG0,SIGA,SIGCOL,THRSLD,LK0
      DATA K000/-33.D0/
      IF(K000.EQ.K0) GOTO 311
         K000=K0
         KM0=1.D0-K0
         HRD0  =KM0*DLOG(KM0)-K0*(LE-1.D0)
C...CUMULATIVE PHOTON MOMENTUM INTEGRAL FOR K LARGER THAN K0
C...FINITE PART
311   K=K0*DEXP(KLOG)
      KM =1.D0-K
      KMLNKM=0.D0
CPCK  IF(KM.NE.0.D0)KMLNKM=KM*DLOG(KM)
      IF(KM.GT.0.000001D0)KMLNKM=KM*DLOG(KM)

      Y4KQ=KMLNKM-K*(LE-1.D0) - HRD0 + 2.*LE*KLOG
C...ADD VIRTUAL AND SOFT FINITE TERMS AND RETURN
      RETURN
      END
