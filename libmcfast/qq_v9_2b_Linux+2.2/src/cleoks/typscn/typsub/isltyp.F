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
* Revision 1.1  1995/07/31 19:42:34  nk
* Added typscn
*
* Revision 1.1.1.1  1994/10/05  13:45:41  zfiles
* first version of typscn in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/06 15/05/90  11.14.21  by  Ian C. Brock
*CMZ :  1.00/07 13/02/90  17.49.40  by  Ian C. Brock
*-- Author :
C
C--------------------------------------------------------------------------
C Find commands
C
      INTEGER FUNCTION ISLTYP(LWAIT,IDELIM,STRING)
      SAVE
C
C     This routine is the  same as ISTTYP except that it does no case
C     conversion
C     ISLTYP gets number of characters in the character string
C     STRING is output character string without upper case conversion
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
      INTEGER ISLSCN
C
      CTYPNM = 'COMMAND'
C     signals waiting for TTY input
      ISLTYP = -2
      STRING = ' '

      CALL GETLIN(LWAIT)
C
      IF (.NOT.LASYNC) THEN
          ISLTYP = ISLSCN(IPOINT,NCHARS,IDELIM,STRING)
      END IF
C
      RETURN
      END
