*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:38  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:27  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 22/09/94  00.24.06  by  Paul Avery
*CMZ :  1.01/00 01/11/90  18.43.21  by  Paul Avery
*CMZ :  1.00/01 06/09/90  12.40.28  by  Paul Avery
*CMZ :  1.00/00 26/07/90  13.29.10  by  Paul Avery
*CMZ :          19/05/90  14.41.36  by  Jorge L. Rodriguez
*>> Author :
* 17/10/96 Lynn Garren:  Add double precision conditionals.
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION FUNCTION GETMAS(I)
#else
      REAL FUNCTION GETMAS(I)
#endif
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C -----------------------------------------------------------------------------
C   Generates mass of the finite width particle of type I
C -----------------------------------------------------------------------------

#include "seq/clinc/qqpars.inc"
#include "qqlib/seq/qqcntl.inc"
#include "seq/clinc/qqprop.inc"

C     CALLING ARGUMENTS
      INTEGER I
*
C     Local variables
*
C     External declarations
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION QQBRWG
#else
      REAL QQBRWG
#endif
      EXTERNAL QQBRWG
C -----------------------------------------------------------------------------

C   skip finite width if not requested or if particle has zero width
      IF(LWIDE .AND. RWIDTH(I).GT.0.) THEN
        GETMAS = QQBRWG(AMASS(I), RWIDTH(I), RMASMN(I), RMASMX(I))
      ELSE
        GETMAS = AMASS(I)
      ENDIF

      RETURN
      END
