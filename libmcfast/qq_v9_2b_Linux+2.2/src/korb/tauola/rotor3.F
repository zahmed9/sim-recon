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
      SUBROUTINE ROTOR3(PHI,PVEC,QVEC)
C ----------------------------------------------------------------------
C
C     USED BY : TAUOLA
C ----------------------------------------------------------------------
      REAL*4 PVEC(4),QVEC(4),RVEC(4)
C
      CS=COS(PHI)
      SN=SIN(PHI)
      DO 10 I=1,4
  10  RVEC(I)=PVEC(I)
      QVEC(1)= CS*RVEC(1)-SN*RVEC(2)
      QVEC(2)= SN*RVEC(1)+CS*RVEC(2)
      QVEC(3)=RVEC(3)
      QVEC(4)=RVEC(4)
      END
