*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:36  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:31  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 15/10/93  09.57.26  by  Paul Avery
*CMZ :  1.01/02 13/11/90  11.13.08  by  Paul Avery
*CMZ :  1.01/00 03/11/90  17.35.56  by  Paul Avery
*CMZ :          29/10/90  19.52.08  by  Paul Avery
*>> Author :
      SUBROUTINE QQRINI

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C  Initialize some parameters for a decay channel
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "seq/clinc/qqpars.inc"
#include "qqlib/seq/qqbrat.inc"
#include "qqlib/seq/readinp.inc"

C     Calling arguments
*
C     Local variables
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      CALL VZERO(ANGS, 7)

      NPRB = 0
      CALL VZERO(PROBH, MPRB)
      CALL VZERO(HEL, MPRB*20)

      NHEL = 0
      CALL VZERO(ANGH, 8*MHEL)

      LCPEIG = .FALSE.
      LCPTG = .FALSE.
      SINPHI = 0.

      RETURN
      END
