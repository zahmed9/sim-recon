*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:21  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  18:00:24  nk
* Consolidation
*
* Revision 1.1  1995/07/31 19:42:44  nk
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
C
C************************************************************************
C GENERIC I/O ROUTINES
C---------------------------------------------------------------------------
C User changes teletype input unit to IACC and output to ITYP
C
      SUBROUTINE UNITYP(IACC,ITYP)
      SAVE
C
#include "cleoks/typscn/typcde/typpar.inc"
#include "cleoks/typscn/typcde/typchr.inc"
#include "cleoks/typscn/typcde/typscn.inc"
#include "cleoks/typscn/typcde/typstr.inc"
#include "cleoks/typscn/typcde/typctl.inc"
C
      INTEGER  IACC
      INTEGER  ITYP
C
C     Cancel outstanding async I/O if unit number is changing
CJB      CALL ASYNCN
      IF (IACC.NE.IUNACC) CALL ASYNCN
      LASYIN = .TRUE.
      IUNACC = IACC
      IUNTYP = ITYP
      IPOINT = NCHACC
      NCHARS = -1
      RETURN
      END
