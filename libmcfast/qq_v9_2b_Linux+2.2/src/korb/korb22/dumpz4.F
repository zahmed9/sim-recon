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
*CMZ :  2.00/00 21/01/93  15.42.14  by  Alan Weinstein
*-- Author :
      SUBROUTINE DUMPZ4(JK,PP)
C     **********************
C PRINTS SINGLE FOUR MOMENTUM
      REAL*4 PP(4)
      COMMON / INOUT / NINP,NOUT
      AMS=PP(4)**2
      DO 10 I=1,3
   10 AMS=AMS-PP(I)**2
      IF(AMS.GT.0.0) AMS=SQRT(AMS)
      WRITE(NOUT,1000)
      WRITE(NOUT,1502) JK,(PP(I),I=1,4),AMS
 1000 FORMAT(1X,'* DUMPZ4 *-------',8(10H----------))
 1502 FORMAT(10X,I6,3X,'FOURMOMENTUM  ',5(1X,F12.5))
      RETURN
C======================================================================
C================END OF JMCLIB=========================================
C======================================================================
      END
