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
*CMZ :  2.00/00 21/01/93  15.42.33  by  Alan Weinstein
*-- Author :
      SUBROUTINE DPHSPK(DGAMT,HV,PN,PAA,PIM1,PIM2,PIPL,JAA)
C ----------------------------------------------------------------------
* IT SIMULATES THREE PI (K) DECAY IN THE TAU REST FRAME
* Z-AXIS ALONG HADRONIC SYSTEM
C ----------------------------------------------------------------------
      REAL  HV(4),PN(4),PAA(4),PIM1(4),PIM2(4),PIPL(4)
C MATRIX ELEMENT NUMBER:
      MNUM=JAA
C TYPE OF THE GENERATION:
      KEYT=4
      IF(JAA.EQ.7) KEYT=3
C --- MASSES OF THE DECAY PRODUCTS
       AMP1=APKMAS(1,JAA)
       AMP2=APKMAS(2,JAA)
       AMP3=APKMAS(3,JAA)
      CALL
     $   DPHTRE(DGAMT,HV,PN,PAA,PIM1,AMP1,PIM2,AMP2,PIPL,AMP3,KEYT,MNUM)
      END
