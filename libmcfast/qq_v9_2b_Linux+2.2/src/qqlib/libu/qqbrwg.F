*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:38  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:28  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.01/00 07/09/90  04.01.38  by  CLEO II Librarian
*CMZ :  1.00/01 06/09/90  16.21.09  by  Paul Avery
*-- Author :
* 17/10/96 Lynn Garren:  Add double precision conditionals.
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION FUNCTION QQBRWG(CEN, FWID, XMIN, XMAX)
#else
      REAL FUNCTION QQBRWG(CEN, FWID, XMIN, XMAX)
#endif
C
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C   Generate exact Breit Wigner distribution with Mean=CEN, FWHM=FWID
C   between the limits XMIN, XMAX.
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
C     Calling arguments
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION CEN, FWID, XMIN, XMAX
#else
      REAL CEN, FWID, XMIN, XMAX
#endif
C
      INTEGER ISEED
      COMMON/RANDM/ISEED

C     External declarations
      REAL RANP

C     Local variables
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION YMIN, YMAX
#else
      REAL YMIN, YMAX
#endif
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C
      IF(FWID .EQ. 0) THEN
        QQBRWG = XMIN
      ELSE
#if defined(NONCLEO_DOUBLE)
        YMIN = DATAN(2.*(XMIN-CEN)/FWID)
        YMAX = DATAN(2.*(XMAX-CEN)/FWID)
        QQBRWG = CEN + FWID/2. * DTAN(RANP(ISEED)*(YMAX-YMIN)+YMIN)
#else
        YMIN = ATAN(2.*(XMIN-CEN)/FWID)
        YMAX = ATAN(2.*(XMAX-CEN)/FWID)
        QQBRWG = CEN + FWID/2. * TAN(RANP(ISEED)*(YMAX-YMIN)+YMIN)
#endif
      ENDIF

C     Only exit point
1000  RETURN
      END
