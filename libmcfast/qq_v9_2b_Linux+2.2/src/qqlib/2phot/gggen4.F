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
*CMZ :  1.03/76 15/08/94  23.10.50  by  Peter C Kim
*CMZ :  1.03/15 05/06/91  01.36.24  by  R.A.FULTON
*-- Author :   R.A.FULTON
      SUBROUTINE GGGEN4
C*******************************************************************
#include "qqlib/gggseq/ggmodl.inc"
#include "geant/gcdes/lujets.inc"
#include "geant/gcdes/ludat1.inc"
#include "qqlib/gggseq/genarg.inc"
C.................LOCALS
       INTEGER   J2, KF, NC, KCRES, NTRY, NZ
       REAL      BETA(3), ECMC
       REAL      THEGZ, PGG(4)

C..EXTERNAL::
       REAL      ULMASS, ULANGL
       EXTERNAL  ULMASS, ULANGL

C.    Reset lund particle counters
      NC  = 0

C     scattered electron stored, for possible further interactions
      DO 14 J2=1,2
        NC = NC + 1
        K(NC,1)  =  1
  14  P(NC,5)    =  ULMASS(11)

      DO 15 J2=1,4
        P(NC - 1,J2)  = E14V(J2)
  15  P(NC,J2)    = E24V(J2)
      K(NC-1,2)   = -11*IC1
      K(NC,2)     = -11*IC2

      CALL LUEXEC

      RETURN
      END
