*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:21  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  18:00:25  nk
* Consolidation
*
* Revision 1.1  1995/07/31 19:42:45  nk
* Added typscn
*
* Revision 1.1.1.1  1994/10/05  13:45:41  zfiles
* first version of typscn in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/00 12/05/89  16.55.34  by  Ian C. Brock
*-- Author :
C
C----------------------------------------------------------------------------
C Initializes wait message.
C
      SUBROUTINE WAITYP(CTYPE)
      SAVE
C
C     If CTYPE = '.FALSE.', none is output.
C     If CTYPE = '.TRUE.', standard message is output.
C     Otherwise, CTYPE is the wait message and gets stored.
C
#include "cleoks/typscn/typcde/typpar.inc"
#include "cleoks/typscn/typcde/typchr.inc"
#include "cleoks/typscn/typcde/typscn.inc"
#include "cleoks/typscn/typcde/typstr.inc"
#include "cleoks/typscn/typcde/typctl.inc"
C
      CHARACTER*(*) CTYPE
C
C
      IF (CTYPE.EQ.'.FALSE.') THEN
      CWTYPE = '.FALSE.'
      NWTYPE = 7

      ELSE IF (CTYPE.EQ.'.TRUE.') THEN
      CWTYPE = '.TRUE.'
      NWTYPE = 6

      ELSE
      NWTYPE = MIN(LEN(CTYPE),DIMWTY)
      CWTYPE = CTYPE(1:NWTYPE)

      END IF
C
      RETURN
      END
