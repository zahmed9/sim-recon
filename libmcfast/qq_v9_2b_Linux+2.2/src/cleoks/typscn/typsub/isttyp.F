*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:21  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  18:00:22  nk
* Consolidation
*
* Revision 1.1  1995/07/31 19:42:37  nk
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
C
C--------------------------------------------------------------------------
C Find commands
C
      INTEGER FUNCTION ISTTYP(LWAIT,IDELIM,STRING)
      SAVE
C
C     ISTTYP gets number of characters in the character string
C     STRING is output character string
C
#include "cleoks/typscn/typcde/typpar.inc"
#include "cleoks/typscn/typcde/typchr.inc"
#include "cleoks/typscn/typcde/typscn.inc"
#include "cleoks/typscn/typcde/typstr.inc"
#include "cleoks/typscn/typcde/typctl.inc"
C
      CHARACTER*(*) STRING
      INTEGER IDELIM
      LOGICAL LWAIT
      INTEGER ISTSCN
C
      CTYPNM = 'COMMAND'
C     signals waiting for TTY input
      ISTTYP = -2
      STRING = ' '

      CALL GETLIN(LWAIT)
C
      IF (.NOT.LASYNC) THEN
      ISTTYP = ISTSCN(IPOINT,NCHARS,IDELIM,STRING)
      END IF
C
      RETURN
      END
