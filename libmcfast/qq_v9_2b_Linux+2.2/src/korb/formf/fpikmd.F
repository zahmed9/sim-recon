*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:27  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:05  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/00 21/01/93  15.42.59  by  Alan Weinstein
*-- Author :
      COMPLEX FUNCTION FPIKMD(W,XM1,XM2)
C **********************************************************
C     PION FORM FACTOR
C **********************************************************
      COMPLEX BWIGM
      REAL ROM,ROG,ROM1,ROG1,PI,PIM,S,W
      EXTERNAL BWIG
      DATA  INIT /0/
C
C ------------ PARAMETERS --------------------
      IF (INIT.EQ.0 ) THEN
      INIT=1
      PI=3.141592654
      PIM=.140
      ROM=0.773
      ROG=0.145
      ROM1=1.500
      ROG1=0.220
      ROM2=1.750
      ROG2=0.120
      BETA=6.5
      DELTA=-26.0
      ENDIF
C -----------------------------------------------
      S=W**2
      FPIKMD=(DELTA*BWIGM(S,ROM,ROG,XM1,XM2)
     $      +BETA*BWIGM(S,ROM1,ROG1,XM1,XM2)
     $      +     BWIGM(S,ROM2,ROG2,XM1,XM2))
     & /(1+BETA+DELTA)
      RETURN
      END
