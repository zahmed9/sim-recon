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
*CMZ :  2.00/07 30/01/94  16.25.01  by  Alan J. Weinstein
* Protect DTRIAN=SQRT.
*CMZ :  2.00/05 21/10/93  17.43.05  by  Alan Weinstein
*-- Author :
* 15/10/96 Lynn Garren: Add double precision conditionals.
      FUNCTION PHOTRI(A,B,C)
C.----------------------------------------------------------------------
C.
C.    PHOTOS:   PHOton radiation in decays calculation of TRIangle fie
C.
C.    Purpose:  Calculation of triangle function for phase space.
C.
C.    Input Parameters:  A, B, C (Virtual) particle masses.
C.
C.    Output Parameter:  Function value =
C.                       SQRT(LAMBDA(A**2,B**2,C**2))/(2*A)
C.
C.    Author(s):  B. van Eijk                     Created at:  15/11/89
C.                                                Last Update: 02/01/90
C.
C.----------------------------------------------------------------------
C--   IMPLICIT NONE
      DOUBLE PRECISION DA,DB,DC,DAPB,DAMB,DTRIAN
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION A,B,C,PHOTRI
#else
      REAL A,B,C,PHOTRI
#endif
      DA=A
      DB=B
      DC=C
      DAPB=DA+DB
      DAMB=DA-DB
CAJWMOD      DTRIAN=SQRT((DAMB-DC)*(DAPB+DC)*(DAMB+DC)*(DAPB-DC))
      DTRIAN=SQRT(MAX(0.D0,(DAMB-DC)*(DAPB+DC)*(DAMB+DC)*(DAPB-DC)))
      PHOTRI=DTRIAN/(DA+DA)
      RETURN
      END
