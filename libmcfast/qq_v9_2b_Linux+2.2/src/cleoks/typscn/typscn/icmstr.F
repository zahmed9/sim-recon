*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:18  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  18:00:07  nk
* Consolidation
*
* Revision 1.1  1995/07/31 19:39:23  nk
* Added typscn
*
* Revision 1.1.1.1  1994/10/05  13:45:39  zfiles
* first version of typscn in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/00 12/05/89  16.52.48  by  Ian C. Brock
*-- Author :
C
C******************************************************************************
C
C All SCAN level subroutine subprograms here.
C Namely ICMSTR, ICMSYM, RCHSCN, SDLSCN.
C
C******************************************************************************
C Returns the latest command.
C
      SUBROUTINE ICMSTR(CSTRNG)
      SAVE
C
      INTEGER  L
C
#include "cleoks/typscn/typcde/typpar.inc"
#include "cleoks/typscn/typcde/typchr.inc"
#include "cleoks/typscn/typcde/typscn.inc"
#include "cleoks/typscn/typcde/typstr.inc"
#include "cleoks/typscn/typcde/typctl.inc"
C
      CHARACTER*(*) CSTRNG
C
      L = MIN(NCHUSE,LEN(CSTRNG))
      IF (NCHUSE.GT.0) CSTRNG = CCBUF(1:L)
      RETURN
      END
