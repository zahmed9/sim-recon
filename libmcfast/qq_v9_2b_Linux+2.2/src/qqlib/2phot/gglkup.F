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
*CMZ :  1.03/15 05/12/90  08.51.58  by  R.A.FULTON
*-- Author :
      FUNCTION GGLKUP(FRAC,BOUND)
C********************************************
C LOOK-UP FUNCTION FOR GG SPECTRUM INTEGRAL
C********************************************
C
C********************************************************

      REAL    GGLKUP

#include "qqlib/gggseq/ggprms.inc"

      INTEGER   N, K
      REAL      FRAC, BOUND, RK

C
C
       DO 35 N=2,NSTPSD
        IF(FRAC.GT.XSINT(N))GOTO 35
        K=N-1
        GOTO 37
  35   CONTINUE
       K=NSTPSD-1
  37   RK=FLOAT(K)
       GGLKUP=D2GW*(RK-1.+(FRAC-XSINT(K))/(XSINT(K+1)-XSINT(K)))/
     +       FLOAT(NSTPSD-1)+BOUND

      RETURN
      END
