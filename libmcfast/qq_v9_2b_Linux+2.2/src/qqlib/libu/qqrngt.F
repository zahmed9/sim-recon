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
*CMZ :  1.02/00 12/03/91  10.13.35  by  Peter C Kim
*CMZ :  1.01/00 22/09/90  09.49.27  by  Paul Avery
*CMZ :  1.00/00 06/06/90  12.18.42  by  Paul Avery
*-- Author :
      SUBROUTINE QQRNGT(IRAND1, IRAND2)

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C    Returns the random seeds IRAND1 and IRAND2.
C
C *IRAND1       integer variable (write)
C               First seed
C
C *IRAND2       integer variable (write)
C               Second seed
C
C   Argument for RANECQ changed from  'Q' to 'R'    PCK  12/03/91
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C     Calling arguments
      INTEGER IRAND1, IRAND2

C     Local variables
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      CALL RANECQ(IRAND1, IRAND2, 1, 'R')

      RETURN
      END
