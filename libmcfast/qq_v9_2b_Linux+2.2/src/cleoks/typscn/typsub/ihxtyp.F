*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:20  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  18:00:20  nk
* Consolidation
*
* Revision 1.1  1995/07/31 19:42:29  nk
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
C---------------------------------------------------------------------------
C Find hexidecimal number
C
      INTEGER FUNCTION IHXTYP(LWAIT,IDELIM)
      SAVE
C
#include "cleoks/typscn/typcde/typpar.inc"
#include "cleoks/typscn/typcde/typchr.inc"
#include "cleoks/typscn/typcde/typscn.inc"
#include "cleoks/typscn/typcde/typstr.inc"
#include "cleoks/typscn/typcde/typctl.inc"
C
      INTEGER IHXSCN
      INTEGER IDELIM
      LOGICAL LWAIT
C
      CTYPNM = 'HEX'
      CALL GETLIN(LWAIT)
      IHXTYP = IHXSCN(IPOINT,NCHARS,IDELIM)
      RETURN
      END
