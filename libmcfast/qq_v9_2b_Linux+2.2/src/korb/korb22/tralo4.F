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
*CMZ :  2.00/00 21/01/93  15.42.12  by  Alan Weinstein
*-- Author :
      SUBROUTINE TRALO4(KTO,AP,BP,AM)
C     *******************************
C REAL*4 VERSION OF TRALOR
      REAL*4 AP(4),BP(4),AM
      REAL*8 DP(4),AMAST
      DO 30 I=1,4
  30  DP(I)=AP(I)
      CALL TRALOR(KTO,DP)
      DO 31 I=1,4
  31  AP(I)=DP(I)
      AM=AMAST(DP)
      RETURN
      END
