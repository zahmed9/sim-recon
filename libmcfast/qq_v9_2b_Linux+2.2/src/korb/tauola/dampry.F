*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:31  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:03  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/00 21/01/93  15.42.30  by  Alan Weinstein
*-- Author :
      SUBROUTINE DAMPRY(ITDKRC,XK0DEC,XK,XA,QP,XN,AMPLIT,HV)
      IMPLICIT REAL*8 (A-H,O-Z)
C ----------------------------------------------------------------------
C IT CALCULATES MATRIX ELEMENT FOR THE
C TAU --> MU(E) NU NUBAR DECAY MODE
C INCLUDING COMPLETE ORDER ALPHA QED CORRECTIONS.
C ----------------------------------------------------------------------
      COMMON / PARMAS / AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
C
      REAL*4            AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
      REAL*8  HV(4),QP(4),XN(4),XA(4),XK(4)
C
      HV(4)=1.D0
      AK0=XK0DEC*AMTAU
      IF(XK(4).LT.0.1D0*AK0) THEN
        AMPLIT=THB(ITDKRC,QP,XN,XA,AK0,HV)
      ELSE
        AMPLIT=SQM2(ITDKRC,QP,XN,XA,XK,AK0,HV)
      ENDIF
      RETURN
      END
