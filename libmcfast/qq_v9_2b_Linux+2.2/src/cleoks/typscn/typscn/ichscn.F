*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:18  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  18:00:06  nk
* Consolidation
*
* Revision 1.1  1995/07/31 19:39:16  nk
* Added typscn
*
* Revision 1.1.1.1  1994/10/05  13:45:39  zfiles
* first version of typscn in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/00 12/05/89  16.52.47  by  Ian C. Brock
*-- Author :
C****************************************************************************
C SCNSUB routines
C****************************************************************************
C Casual user routines
C
C All SCAN level helper function subprograms here,
C namely ICHSCN, CCHSCN, ICMLST, LCHSCN, NCHSCN, NCHLFT
C
*****************************************************************************
C Returns value of next character.
C
      INTEGER FUNCTION ICHSCN(JPOINT,JCHARS)
      SAVE
C
      INTEGER  JCHARS
      INTEGER  JPOINT
C
#include "cleoks/typscn/typcde/typpar.inc"
#include "cleoks/typscn/typcde/typchr.inc"
#include "cleoks/typscn/typcde/typscn.inc"
#include "cleoks/typscn/typcde/typstr.inc"
#include "cleoks/typscn/typcde/typctl.inc"
C
      JCHARS = JCHARS - 1
      JPOINT = JPOINT + 1
      IF (JCHARS.GE.0) THEN
      ICHSCN = ICHAR(CTYDAT(JPOINT:JPOINT))
      ELSE
      ICHSCN = -1
      END IF
C
      RETURN
      END
