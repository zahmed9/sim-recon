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
* 16/10/96 Lynn Garren: Add double precision conditionals.
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION FUNCTION FMAS2(XMIN,XMAX,CEN,FWID)
#else
      REAL FUNCTION FMAS2(XMIN,XMAX,CEN,FWID)
#endif
C.......................................................................
C.
C. FMAS2 -
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
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION XMIN, XMAX, CEN, FWID
#else
      REAL XMIN, XMAX, CEN, FWID
#endif
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
*
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'FMAS2' )
*
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION YMIN, AREA
#else
      REAL YMIN, AREA
#endif
*
*- Executable code starts here
*
      IF (FWID.GT.0) GOTO 10
      FMAS2 = XMIN
      RETURN

10    YMIN  = ATAN(2.*(XMIN-CEN)/FWID)
      AREA  = ATAN(2.*(XMAX-CEN)/FWID)-YMIN
      FMAS2 = CEN+FWID/2.*TAN(RANP(ISEED)*AREA+YMIN)

      RETURN
      END
