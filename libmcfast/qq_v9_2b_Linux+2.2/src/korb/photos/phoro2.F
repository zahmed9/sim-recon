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
      SUBROUTINE PHORO2(ANGLE,PVEC)
C.----------------------------------------------------------------------
C.
C.    PHOTOS:   PHOton radiation in decays ROtation routine '2'
C.
C.    Purpose:  Rotate  x and z components  of vector PVEC  around angle
C.              'ANGLE'.
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
      DOUBLE PRECISION CS,SN,ANGLE
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION PVEC(4)
#else
      REAL PVEC(4)
#endif
      CS=COS(ANGLE)*PVEC(1)+SIN(ANGLE)*PVEC(3)
      SN=-SIN(ANGLE)*PVEC(1)+COS(ANGLE)*PVEC(3)
      PVEC(1)=CS
      PVEC(3)=SN
      RETURN
      END
