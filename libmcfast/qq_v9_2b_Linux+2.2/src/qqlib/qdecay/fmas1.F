*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:41  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:30  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/00 14/06/90  14.26.28  by  Paul Avery
*CMZ :          19/05/90  14.51.03  by  Jorge L. Rodriguez
*>> Author :
      REAL FUNCTION FMAS1(XMIN,XMAX,CEN,FWID)
C.......................................................................
C.
C. FMAS1 -
C.
C. Inputs    : XMIN XMAX CEN FWID
C.
C. Called    :
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

*- Argument declarations
      REAL XMIN, XMAX, CEN, FWID
*
*- External declarations
      REAL     RANP
      EXTERNAL RANP
*
*- Sequence declarations
      INTEGER ISEED
      COMMON/RANDM/ISEED
*
*- Local declarations
      REAL YMIN, YMAX
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'FMAS1' )
*
*- Executable code starts here
*
      IF (FWID.GT.0) GOTO 10
      FMAS1 = XMIN
      RETURN

10    YMIN  = ATAN(2.*(XMIN-CEN)/FWID)
      YMAX  = ATAN(2.*(XMAX-CEN)/FWID)
      FMAS1 = CEN+FWID/2.*TAN(RANP(ISEED)*(YMAX-YMIN)+YMIN)

      RETURN
      END
