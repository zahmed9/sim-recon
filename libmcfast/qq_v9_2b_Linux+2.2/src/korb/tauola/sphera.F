*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:32  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:05  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/00 21/01/93  15.42.38  by  Alan Weinstein
*-- Author :
      SUBROUTINE SPHERA(R,X)
C ----------------------------------------------------------------------
C GENERATES UNIFORMLY THREE-VECTOR X ON SPHERE  OF RADIUS R
C
C     called by : DPHSxx,DADMPI,DADMKK
C ----------------------------------------------------------------------
      REAL  X(4)
      REAL*4 RRR(2)
      DATA PI /3.141592653589793238462643/
C
      CALL RANMAR(RRR,2)
      COSTH=-1.+2.*RRR(1)
      SINTH=SQRT(1.-COSTH**2)
      X(1)=R*SINTH*COS(2*PI*RRR(2))
      X(2)=R*SINTH*SIN(2*PI*RRR(2))
      X(3)=R*COSTH
      RETURN
      END
