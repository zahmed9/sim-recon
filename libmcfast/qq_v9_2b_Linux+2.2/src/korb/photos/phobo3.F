*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:29  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:06  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/05 21/10/93  17.43.05  by  Alan Weinstein
*-- Author :
* 15/10/96 Lynn Garren: Add double precision conditionals.
      SUBROUTINE PHOBO3(ANGLE,PVEC)
C.----------------------------------------------------------------------
C.
C.    PHOTOS:   PHOton radiation in decays BOost routine '3'
C.
C.    Purpose:  Boost  vector PVEC  along z-axis where ANGLE = EXP(ETA),
C.              ETA is the hyperbolic velocity.
C.
C.    Input Parameters:  ANGLE, PVEC
C.
C.    Output Parameter:  PVEC
C.
C.    Author(s):  S. Jadach                       Created at:  01/01/89
C.                B. van Eijk                     Last Update: 02/01/90
C.
C.----------------------------------------------------------------------
C--   IMPLICIT NONE
      DOUBLE PRECISION QPL,QMI,ANGLE
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION PVEC(4)
#else
      REAL PVEC(4)
#endif
      QPL=(PVEC(4)+PVEC(3))*ANGLE
      QMI=(PVEC(4)-PVEC(3))/ANGLE
      PVEC(3)=(QPL-QMI)/2.
      PVEC(4)=(QPL+QMI)/2.
      RETURN
      END
