*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:21  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  18:00:21  nk
* Consolidation
*
* Revision 1.1  1995/07/31 19:42:33  nk
* Added typscn
*
* Revision 1.1.1.1  1994/10/05  13:45:41  zfiles
* first version of typscn in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/06 26/02/90  22.26.30  by  Ian C. Brock
*CMZ :  1.00/07 13/02/90  17.47.24  by  Ian C. Brock
*CMZ :  1.00/06 19/01/90  16.21.58  by  Ian C. Brock
*-- Author :
C
      INTEGER FUNCTION IQSTYP(LWAIT,IDELIM,STRING)
      SAVE
C
C     IQSTYP gets a quoted string from the current TYPSCN buffer
C     STRING is output character string
C     IQSTYP is the length of the string
C     No upper case conversion is done
C     If the string is not delimited by '' then it is returned up to
C     the next delimiter. If it is in quotes the string without the
C     quotes is returned. To get a ' inside '...' use ''.
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
      INTEGER IQSSCN
C
      CTYPNM = 'COMMAND'
C     signals waiting for TTY input
      IQSTYP = -2
      STRING = ' '

      CALL GETLIN(LWAIT)
C
      IF (.NOT.LASYNC) THEN
          IQSTYP = IQSSCN(IPOINT,NCHARS,IDELIM,STRING)
      END IF
C
      RETURN
      END
