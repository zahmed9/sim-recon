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
*CMZ :  1.04/00 16/09/94  02.28.35  by  Paul Avery
*-- Author :    Lynn Garren   06/12/93
      SUBROUTINE QBWJET
C.......................................................................
C.
C. QBWJET - Initilization of variables.
C.
C. Inputs    : NONE
C. Outputs   : NONE
C.
C. Called    : QBINIT
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
#include "qqlib/seq/qqwjet.inc"

C---------------------------------------------------------------------

C=== /WWJET/  for Subroutine WJET

      BQMAS(1) = 0.14
      BQMAS(2) = 0.14
      BQMAS(3) = 0.5
      BQMAS(4) = 1.6
      BQMAS(5) = 5.0
      BQMAS(6) = 35.0
      BQMAS(7) = 0.0

      RETURN
      END
