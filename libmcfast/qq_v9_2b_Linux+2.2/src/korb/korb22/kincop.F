*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:28  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:02  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/00 21/01/93  15.42.11  by  Alan Weinstein
*-- Author :
      SUBROUTINE KINCOP
C     *****************
C COPYING UTIL INTO UTIL4 AND UTIL8
      IMPLICIT LOGICAL(A-H,O-Z)
      COMMON / UTIL  /  QP(4), QM(4), PH(4)
      REAL*8            QP   , QM   , PH
      COMMON / UTIL8 / DQP(4),DQM(4),DPH(4)
      REAL*8           DQP   ,DQM   ,DPH
      COMMON / UTIL4 / AQP(4),AQM(4),APH(4)
      REAL*4           AQP   ,AQM   ,APH
      COMMON / ENERG / ENE,AEL2,AMF2,AMF,ALGEL,ALGMF,BETI,BT1,ATH2
      REAL*8           ENE,AEL2,AMF2,AMF,ALGEL,ALGMF,BETI,BT1,ATH2
      DO 30 I=1,4
      DQP(I)=QP(I)*ENE
      DQM(I)=QM(I)*ENE
      DPH(I)=PH(I)*ENE
      AQP(I)=QP(I)*ENE
      AQM(I)=QM(I)*ENE
 30   APH(I)=PH(I)*ENE
      RETURN
      END
