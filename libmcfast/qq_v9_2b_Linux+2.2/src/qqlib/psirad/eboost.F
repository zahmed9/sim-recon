*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:40  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:37  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 04/10/94  22.13.05  by  Paul Avery
*CMZ :  1.03/57 15/02/93  16.00.16  by  Peter C Kim
*-- Author :    D. Coffman   15/02/93
      SUBROUTINE EBOOST(MASSA, P4A, P4B)
C.......................................................................
C. This subroutine boosts the 4-momentum of B along the 4-momentum
C. of A.
C.
C.      Arguments:  Massa =>     mass of A
C.                  P4a   =>     momentum vector of A
C.                  P4b   =>     momentum vector of B
C.
C. Author    : D. Coffman     1/29/93
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
*
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'EBOOST' )
C
C Define the masses and 4-momenta.
C
      DOUBLE PRECISION MASSA, P4A(4), P4B(4)
      DOUBLE PRECISION EBLAB, F

C Boost P4b to the lab frame, with the direction given by P4a.

      EBLAB = (P4A(1)*P4B(1) + P4A(2)*P4B(2) + P4A(3)*P4B(3)
     *       + P4A(4)*P4B(4)) / MASSA
      F     = (P4B(4) + EBLAB) / (P4A(4) + MASSA)

      P4B(1) = P4B(1) + P4A(1)*F
      P4B(2) = P4B(2) + P4A(2)*F
      P4B(3) = P4B(3) + P4A(3)*F
      P4B(4) = EBLAB

      RETURN
      END

