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
*CMZ :  2.00/00 21/01/93  15.42.32  by  Alan Weinstein
*-- Author :
      SUBROUTINE DPHSAA(DGAMT,HV,PN,PAA,PIM1,PIM2,PIPL,JAA)
C ----------------------------------------------------------------------
* IT SIMULATES A1  DECAY IN TAU REST FRAME WITH
* Z-AXIS ALONG A1  MOMENTUM
C ----------------------------------------------------------------------
      COMMON / PARMAS / AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
C
      REAL*4            AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
      COMMON / TAUKLE / BRA1,BRK0,BRK0B,BRKS
      REAL*4            BRA1,BRK0,BRK0B,BRKS
      REAL  HV(4),PN(4),PAA(4),PIM1(4),PIM2(4),PIPL(4)
 
 
      REAL*4 RRR(1)
C MATRIX ELEMENT NUMBER:
      MNUM=0
C TYPE OF THE GENERATION:
      KEYT=1
      CALL RANMAR(RRR,1)
      RMOD=RRR(1)
      IF (RMOD.LT.BRA1) THEN
       JAA=1
       AMP1=AMPI
       AMP2=AMPI
       AMP3=AMPI
      ELSE
       JAA=2
       AMP1=AMPIZ
       AMP2=AMPIZ
       AMP3=AMPI
      ENDIF
 
      CALL
     $   DPHTRE(DGAMT,HV,PN,PAA,PIM1,AMP1,PIM2,AMP2,PIPL,AMP3,KEYT,MNUM)
      END
