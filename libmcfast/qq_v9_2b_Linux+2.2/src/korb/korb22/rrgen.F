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
      FUNCTION RRGEN(R)
C     *****************
      IMPLICIT REAL*8(A-H,O-Z)
C
C     ****************************************************************
C     *                                                              *
C     *  RRGEN IS GENERAL ROUTINE GENERATING ARBITRARY ONE DIM.      *
C     *  DISTRIBUTION DEFINED THROUGH XKDEF FUNCTION.                *
C     *  IT MEMORIZES THE SCHAPE OF DISTRIBUTION IN XX-MATRIX STEP   *
C     *  BY STEP WITH BETTER AND BETTER PRECISSION.  MATRIX XX       *
C     *  IS UPDATED AT THE MOMENT WHEN CERTAIN NUMBER OF EVENTS      *
C     *  (THAT LISTET IN MATRIX LIST ) HAS BEEN GENERATED.           *
C     *                                                              *
C     ****************************************************************
C
      COMMON / UTIL2 / XK0,XKMIN,XKMAX
      DIMENSION  XX(1025),LIST(11)
      DATA LIST
     $/1,2,3,4,64,256,1024,4096,16384,65536,-1/
      DATA IEV,LEN /0,1024/
C
      IEV=IEV+1
      IF(R.LT.0.) IEV=1
      IF(IEV.NE.1) GO TO 10
      IP=1
      EPS =.05/FLOAT(LEN)
      EPS1=.00025
      ID=LEN
      IW=1
      XW=1.
      XX(1)=XKMIN
      XX(LEN+1)=XKMAX
      F0=XKDEF(XKMIN)
      DF=XKDEF(XKMAX)-F0
   10 CONTINUE
      IF(IEV.NE.LIST(IP))GO TO 300
      IP=IP+1
      DO 100 I=1,IW
      IA1=ID*(I-1)+1
      IA2=IA1+ID
      IA=(IA1+IA2)/2
C     ITERATION COME ON
      X1=XX(IA1)
      X2=XX(IA2)
      IF((X2-X1).LT.EPS1) GO TO 31
      Y1=XKDEF(X1)
      Y2=XKDEF(X2)
      Y=FLOAT(IA-1)/FLOAT(LEN)
      DO 30  ITER=1,30
      X=.5*(X1+X2)
      F=(XKDEF(X)-F0)/DF
      IF(Y-F) 20,31,21
   20 X2=X
      Y2=Y
      GO TO 23
   21 X1=X
      Y1=Y
   23 IF((Y2-Y1) .LT.EPS.AND.(X2-X1).LT.EPS1) GO TO 31
   30 CONTINUE
   31 XX(IA)=.5*(X1+X2)
C     END OF ITERATION
  100 CONTINUE
      ID=ID/2
      IW=IW*2
      XW=XW*2.
C
  300 CONTINUE
      I=INT(.5*XW*R)
      IA1=2*I*ID+1
      IA2=IA1+ID
      IA3=IA2+ID
      X1=XX(IA1)
      X2=XX(IA2)
      X3=XX(IA3)
      Y=R*XW-FLOAT(2*I)
      X=.5*(Y-1.)*(Y-2.)*X1-Y*(Y-2.)*X2+.5*Y*(Y-1)*X3
      X= MAX (X,X1)
      X= MIN (X,X3)
      RRGEN=X
      RETURN
C=======================================================================
C===================END OF CPC PART ====================================
C=======================================================================
      END
