*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:43  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:27  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 16/09/94  02.29.01  by  Paul Avery
*CMZ :  1.03/70 04/11/93  14.56.57  by  Lynn Garren
*-- Author :    Lynn Garren   04/11/93
      SUBROUTINE QBSNGL
C.......................................................................
C.
C. QBSNGL - Initilization of variables in QQSNGL.
C.
C. Inputs    : NONE
C. Outputs   : NONE
C.
C. COMMON    : QQSNGL
C.
C. Calls     : none
C. Called    : QBINIT
C. Author    : Lynn Garren  04/11/93
C.
C. Detailed description
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
#include "qqlib/seq/qqsngl.inc"

C---------------------------------------------------------------------

C=== QQSNGL

C---  Single particle generation
C
C                           CSINGL    : Particle name
C                           PSINGL(2) : Low,high bounds on P_mom
C                           STHET(2)  : Low,high bounds on Theta
C                           SPHI(2)   : Low,high bounds on PHI
C
      CSINGL  = ' '
      PSINGL(1) = 0.0
      PSINGL(2) = 0.0
      STHET(1)  = 0.0
      STHET(2)  = 0.0
      SPHI(1)   = 0.0
      SPHI(2)   = 0.0

      RETURN
      END
