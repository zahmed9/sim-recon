*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:21  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  18:00:23  nk
* Consolidation
*
* Revision 1.1  1995/07/31 19:42:40  nk
* Added typscn
*
* Revision 1.1.1.1  1994/10/05  13:45:40  zfiles
* first version of typscn in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/00 12/05/89  16.55.33  by  Ian C. Brock
*-- Author :
C**************************************************************************
C
C Fixed up for VAX-KL-IBM use by C.Bebek 22-March-85
C
C Uses character strings wherever appropriate.
C Notes:
C     1. Calls to ZERTYP and WAITYP can have special case character
C        string arguments '.TRUE.' and '.FALSE.' instead of .TRUE.
C        and .FALSE..  The former method is preferred because it
C        is transportable under FORTRAN-77.  The latter method makes
C        use of a trick on the VAX for backwards compatibility.
C     2. The third argument for ICMTYP must be a character array.
C        No more than three arguments are accepted by the subroutine.
C        The end of the character array is delimited by a blank string.
C        A -1 is returned for a terminator-only or a blank string
C        type-in.  For asynchrnous operation, a -2 is returned if
C        there has been no keyboard activity.
C
C What's what
C     NCHACC  number of read characters
C     NCHARS  number of characters remaining (-1 means done with string)
C     IPOINT  positioned before next character to scan
C     KCHARS  number of characters remaining at beginning of last scan
C     KPOINT  positioned before character of last scan
C
C***************************************************************************
C
C All TYPE level TYPSCN function subprograms are here,
C namely RELTYP, INTTYP, IOCTYP, IHXTYP, ICMTYP, ICHTYP, ISTTYP
C
C***************************************************************************
C Find real number
C
      REAL FUNCTION RELTYP(LWAIT,IDELIM)
      SAVE
C
#include "cleoks/typscn/typcde/typpar.inc"
#include "cleoks/typscn/typcde/typchr.inc"
#include "cleoks/typscn/typcde/typscn.inc"
#include "cleoks/typscn/typcde/typstr.inc"
#include "cleoks/typscn/typcde/typctl.inc"
C
      INTEGER IDELIM
      LOGICAL LWAIT
      REAL    RELSCN
C
      CTYPNM = 'REAL'
      CALL GETLIN(LWAIT)
      RELTYP = RELSCN(IPOINT,NCHARS,IDELIM)
      RETURN
      END
