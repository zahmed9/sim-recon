*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:40  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:30  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 22/09/94  00.10.29  by  Paul Avery
*CMZ :  1.02/00 05/06/90  15.41.33  by  Jorge L. Rodriguez
*-- Author :
* 28/10/96 Lynn Garren:  Add double precision conditionals.
      SUBROUTINE DECGEN(KI2)
C.......................................................................
C.
C. DECGEN -
C.
C. Inputs    : KI2
C. COMMON    : QQPROP QQGEN
C.
C. Called    :
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

*- Argument declarations
      INTEGER KI2

*- External declarations
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION GETMAS
#else
      REAL     GETMAS
#endif
      EXTERNAL GETMAS

*- Sequence declarations
#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqprop.inc"
#include "qqlib/seq/mcgen.inc"

*- Local declarations
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'DECGEN' )
*
*
*- Executable code starts here

C-- Allow a particle at rest to decay
      NC=0
      K(LASTN+1,1)=38
      K(LASTN+1,2)=KI2
      P(LASTN+1,1)=0.
      P(LASTN+1,2)=0.
      P(LASTN+1,3)=0.
      P(LASTN+1,4)=GETMAS(KI2)
      P(LASTN+1,5)=P(LASTN+1,4)
      N=LASTN+1
C     CALL DECAYS

      RETURN
      END
