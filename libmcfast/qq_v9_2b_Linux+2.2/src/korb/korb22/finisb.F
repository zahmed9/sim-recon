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
      SUBROUTINE FINISB(CSTCMT,ERREL)
C     ************************
      IMPLICIT REAL*8(A-H,O-Z)
C**********************************************************************
C     FINISH CALCULATES TOTAL CROSS SECTION FOR GENERATED EVENTS      I
C     USING AVERAGE WEIGHTS. IT GIVES STATISTICAL ERRORS DEPENDING ON I
C     THE NUMBER OF THE GENERATED EVENTS.                             I
C     CSTOT IS TOTAL EXACT CROSS SECTION GIVEN IN  CM**2              I
C     TO BE USED TO RENORMALISE HISTOGRAMS IN  CM**2 UNITS            I
C**********************************************************************
      COMMON / SIGMA / SIG0,SIG0CM,SOFT,SOF1,F2RE,BRM,BOX
      COMMON / CONTRL/ SWT(6),ISPIN
      COMMON / UTIL2 / XK0,XKMIN,XKMAX
      COMMON / INOUT / NINP,NOUT
C;;
C
      AWTA=0.
      DWTA=0.
      IF(SWT(1).EQ.0.) GO TO 10
      AWTA=SWT(2)/SWT(1)
      DWTA=SQRT(SWT(3)/SWT(2)**2-1./SWT(1))*100.
   10 AWTB=SWT(5)/SWT(4)
      DWTB=SQRT(SWT(6)/SWT(5)**2-1./SWT(4))*100.
C-----
      CSOFT=0.
      IF(XKMIN.EQ.0.) CSOFT=XKDEF(XK0)
      CSTOT=XKDEF(XKMAX)-XKDEF(XKMIN)
      CSHAR=CSTOT-CSOFT
C-----
      CSTOT=(CSOFT+AWTA*CSHAR)*AWTB
      DWTT=AWTA*CSHAR/(CSOFT+AWTA*CSHAR)
      DWTT=DWTT*DWTA+DWTB
      CSTCM=CSTOT*SIG0CM
C;;
      ERREL=SQRT((DWTT*DWTA)**2+DWTB**2)/100.
      CSTCMT=CSTCM
 
      NEVA=INT(SWT(1)-1.)
      NEVB=INT(SWT(4)-1.)
C
      WRITE(NOUT,1000)       NEVA,AWTA,DWTA,
     $                       NEVB,AWTB,DWTB,
     $                           CSTOT,DWTT
C
 1000 FORMAT(1H0,10(10H**********),/,7H FINISB,//
     -  /21X, 20H NO. OF CRUDE EVENTS,20H      AVERAGE WEIGHT,
     -                                20H      PERCENT ERRORS,
     -  /11X, 20HHARD BREMSS. WEIGHT ,I10, F20.6,F10.2,
     -  /11X, 20HSPIN WEIGHT         ,I10, F20.6,F10.2,
     - //11X, 40HTOTAL EXACT CROSS SECT. IN SIG0 UNITS
     -                                   , F10.6,F10.2)
      RETURN
      END
