*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:40  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:31  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.02/00 05/06/90  15.41.34  by  Jorge L. Rodriguez
*-- Author :
* 17/10/96 Lynn Garren:  Add double precision conditionals.
      SUBROUTINE PTDIST(PX,PY,SIGMA)
C.......................................................................
C.
C. PTDIST -
C.
C. Inputs    : SIGMA
C. Outputs   : PX PY
C.
C. Called    : GGGJET
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
*- Argument declarations
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION PX, PY, SIGMA
#else
      REAL PX, PY, SIGMA
#endif
*
*- External declarations
      REAL     RANP
      EXTERNAL RANP
*
*- Sequence declarations
*
      INTEGER ISEED
      COMMON/RANDM/ISEED
*
*- Local variable declarations
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'PTDIST' )
*
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION R, PHI, PT
#else
      REAL R, PHI, PT
#endif
*
*- Executable code starts here
*
*
C-- Give PX and PY according to independent gaussian distributions

20    R = RANP(ISEED)
      IF(R .EQ. 0)GOTO 20
#if defined(NONCLEO_DOUBLE)
      PT=SIGMA*SQRT(-DLOG(R))
#else
      PT=SIGMA*SQRT(-ALOG(R))
#endif
      PHI=6.283186308*RANP(ISEED)
      PX=PT*COS(PHI)
      PY=PT*SIN(PHI)

      RETURN
      END
