*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:43  eugenio
* Initial revision
*
* Revision 1.2  1996/05/01 07:31:09  zfiles
* Initialize XANGQQ, BDISPX, BDISPY.
*
* Revision 1.1.1.1  1994/10/08  02:21:27  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 16/09/94  02.28.24  by  Paul Avery
*-- Author :    Lynn Garren   06/12/93
      SUBROUTINE QBEVNT
C.......................................................................
C.
C. QBEVNT - Initilization of variables.
C             (replaces  BLOCK DATA QQDATA)
C.
C. Inputs    : NONE
C. Outputs   : NONE
C.
C. COMMON    : QQEVNT.
C.
C. Called    : QBINIT
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
#include "seq/clinc/qqevnt.inc"

C---------------------------------------------------------------------

C=== QQEVNT /QQEVT2/

      ECM = 10.0

      XANGQQ = 0.0
      BDISPX = 0.0
      BDISPY = 0.0

      CALL VZERO(P4PRQ1,4)
      CALL VZERO(P4PRQ2,4)

      RETURN
      END
