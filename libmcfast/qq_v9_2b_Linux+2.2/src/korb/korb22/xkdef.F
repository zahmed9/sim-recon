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
*CMZ :  2.00/00 21/01/93  15.42.13  by  Alan Weinstein
*-- Author :
      FUNCTION XKDEF(XK)
C     ******************
      IMPLICIT REAL*8(A-H,O-Z)
C
C     ****************************************************************
C     *                                                              *
C     *  DEFINES RAW CROSS SECTION FOR PHOT. MOMENTUM  .LT. XK       *
C     *  USED IN RRGEN TO GENERATE RAW XK DISTRIBUTION               *
C     *                                                              *
C     ****************************************************************
C
      COMMON / SIGMA / SIG0,SIG0CM,SOFT,SOF1,F2RE,BRM,BOX
      COMMON / CONST / PI,ALFA,ALF1,QE2,QF2,QEF
      COMMON / UTIL2 / XK0,XKMIN,XKMAX
      COMMON / ENERG / ENE,AEL2,AMF2,AMF,ALGEL,ALGMF,BETI,BT1,ATH2
      DATA ENIT /.0/
      FUNH(X)=BETI*( LOG(X)-.5*X-.5* LOG(1.-X))
     $   +3.*ALF1*ATH2*((1.-AMF2)* LOG(X)-X+.25*X*X)
C
      IF(ENIT.EQ.ENE) GO TO 10
      ENIT=ENE
      SOFSIG=BT1*((1.+.5*AMF2)*(1.+SOFT)+3.*F2RE)
      SUDIS0=SOFSIG-FUNH(XK0)
      SUDIST=SUDIS0+FUNH(1.-AMF2)
   10 CONTINUE
      IF(XK.GT.0.) GO TO 110
      XKDEF=0.
      RETURN
  110 IF(XK.GT.XK0) GO TO 120
      XKDEF=SOFSIG*XK/XK0
      RETURN
  120 IF(XK.GT.(1.-AMF2)) GO TO 140
      XKDEF=SUDIS0+FUNH(XK)
      RETURN
  140 XKDEF=SUDIST
      RETURN
      END
