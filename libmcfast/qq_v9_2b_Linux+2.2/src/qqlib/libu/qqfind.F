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
*CMZ :  1.04/00 22/09/94  00.25.11  by  Paul Avery
*CMZ :  1.00/00 26/07/90  13.29.10  by  Paul Avery
*-- Author :
      SUBROUTINE QQFIND(ITYP, NUM, LIST)

C  ---------------------------------------------------------------------
C  Find all particles in QQ list of type "ITYP".
C
C  ITYP    integer (read)
C          Type of particle (as given by ITYPEV(I,1))
C
C *NUM     integer (read/write)
C          Input:  max number of particles to find
C          Output: number of particles found
C
C *LIST    integer (write)
C          Positions of particles in QQ list
C  ---------------------------------------------------------------------
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqtrak.inc"
C
C     Calling arguments
      INTEGER ITYP, NUM, LIST(*)
C
C     Local variables
      INTEGER I, NSUM
C  ---------------------------------------------------------------------

      NSUM = 0
      DO 100 I=1,NTRKMC
        IF(ITYPEV(I,1) .NE. ITYP) GOTO 100
        IF(NSUM .GE. NUM) GOTO 1000
        NSUM = NSUM + 1
        LIST(NSUM) = I
100   CONTINUE

C     Only exit
1000  NUM = NSUM

      RETURN
      END
