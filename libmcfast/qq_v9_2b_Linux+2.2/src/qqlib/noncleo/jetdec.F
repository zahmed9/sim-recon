*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:39  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:38  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 22/03/94  19.21.47  by  Lynn Garren
*-- Author :
* 16/10/96 Lynn Garren: Add double precision conditionals.
      SUBROUTINE JETDEC(IPD,CMAS,LAST,MATRX,NDAU,IER)
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "qqlib/seq/mcgen.inc"
#include "qqlib/seq/qqluns.inc"

C     Calling arguments
      INTEGER IPD, LAST, MATRX, NDAU, IER
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION CMAS
#else
      REAL CMAS
#endif
*
C     Local variables
      INTEGER NCOLD, J, I1, I
      REAL PCSAV(4,4)
      REAL BETAX, BETAY, BETAZ
C ---------------------------------------------------------------------------

      WRITE(LOUTQQ,*) ' DUMMY version of JETDEC called'

      RETURN
      END
