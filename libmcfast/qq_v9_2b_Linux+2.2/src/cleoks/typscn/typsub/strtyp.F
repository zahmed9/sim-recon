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
* Revision 1.1  1995/07/31 19:42:42  nk
* Added typscn
*
* Revision 1.1.1.1  1994/10/05  13:45:40  zfiles
* first version of typscn in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/00 12/05/89  16.55.34  by  Ian C. Brock
*-- Author :
C
C---------------------------------------------------------------------------
C Return next NCHGET characters into CARRAY.
C
      SUBROUTINE STRTYP(NCHGET, CARRAY)
      SAVE
C
#include "cleoks/typscn/typcde/typpar.inc"
#include "cleoks/typscn/typcde/typchr.inc"
#include "cleoks/typscn/typcde/typscn.inc"
#include "cleoks/typscn/typcde/typstr.inc"
#include "cleoks/typscn/typcde/typctl.inc"
C
      INTEGER  NCHGET
      CHARACTER*(*) CARRAY
C
      KPOINT = IPOINT
      KCHARS = NCHARS
      CALL STRSCN(IPOINT,NCHARS,NCHGET,CARRAY)
      RETURN
      END
