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
* Revision 1.1  1995/07/31 19:42:36  nk
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
C----------------------------------------------------------------------------
C Find commands
C
      INTEGER FUNCTION ISTRNG(LWAIT,STRING,NCHAR)
      SAVE
C
C     ICMD gets sequence number of interpreted command, or error code.
C     CCMD is input array of command names.
C
#include "cleoks/typscn/typcde/typpar.inc"
#include "cleoks/typscn/typcde/typchr.inc"
#include "cleoks/typscn/typcde/typscn.inc"
#include "cleoks/typscn/typcde/typstr.inc"
#include "cleoks/typscn/typcde/typctl.inc"
C
      CHARACTER*(*) STRING
      LOGICAL LWAIT
      INTEGER NCHAR
      INTEGER NCHLFT
C
      CTYPNM = 'STRING'
C     signals waiting for TTY input
      ISTRNG = -2
      CALL GETLIN(LWAIT)
C
      IF (.NOT.LASYNC) THEN
              KPOINT = IPOINT
              KCHARS = NCHARS
              NCHAR = MIN(NCHLFT(),LEN(STRING))
              CALL STRSCN(IPOINT,NCHARS,NCHAR,STRING)
              ISTRNG = 0
      END IF
C
      RETURN
      END
