*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:31  eugenio
* Initial revision
*
* Revision 1.2  1995/05/14  23:49:14  zfiles
* yBug fixes in dphsel.F and sphsmu.F Swapped arguments.
*
* Revision 1.1.1.1  1994/11/22  16:57:03  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/00 21/01/93  15.42.30  by  Alan Weinstein
*-- Author :
      SUBROUTINE DPHSMU(DGAMX,HVX,XNX,PAAX,QPX,XAX,PHX)
C XNX,XAX was flipped in parameters of dphsel and dphsmu. AJW,WAS,5/95
C *********************************************************************
C *   MUON     DECAY MODE                                             *
C *********************************************************************
      REAL*4         PHX(4)
      REAL*4  HVX(4),PAAX(4),XAX(4),QPX(4),XNX(4)
      REAL*8  HV(4),PH(4),PAA(4),XA(4),QP(4),XN(4)
      REAL*8  DGAMT
      IELMU=2
      CALL DRCMU(DGAMT,HV,PH,PAA,XA,QP,XN,IELMU)
      DO 7 K=1,4
        HVX(K)=HV(K)
        PHX(K)=PH(K)
        PAAX(K)=PAA(K)
        XAX(K)=XA(K)
        QPX(K)=QP(K)
        XNX(K)=XN(K)
  7   CONTINUE
      DGAMX=DGAMT
      END
