*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:31  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:04  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/00 21/01/93  15.42.36  by  Alan Weinstein
*-- Author :
      SUBROUTINE DWRPH(KTO,PHX)
C
C -------------------------
C
      IMPLICIT REAL*8 (A-H,O-Z)
      REAL*4         PHX(4)
      REAL*4 QHOT(4)
C
      DO  9 K=1,4
      QHOT(K)  =0.0
  9   CONTINUE
C CASE OF TAU RADIATIVE DECAYS.
C FILLING OF THE LUND COMMON BLOCK.
        DO 1002 I=1,4
 1002   QHOT(I)=PHX(I)
        IF (QHOT(4).GT.1.E-5) CALL DWLUPH(KTO,QHOT)
        RETURN
      END
