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
* Revision 1.1  1995/07/31 19:42:38  nk
* Added typscn
*
* Revision 1.1.1.1  1994/10/05  13:45:40  zfiles
* first version of typscn in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/03 29/11/89  17.42.52  by  J. D. Lewis
*CMZ :  1.00/00 12/05/89  16.55.33  by  Ian C. Brock
*-- Author :
C
C---------------------------------------------------------------------------
C Get last scanned character
C
      INTEGER FUNCTION LCHTYP()
      SAVE
C
#include "cleoks/typscn/typcde/typpar.inc"
#include "cleoks/typscn/typcde/typchr.inc"
#include "cleoks/typscn/typcde/typscn.inc"
#include "cleoks/typscn/typcde/typstr.inc"
#include "cleoks/typscn/typcde/typctl.inc"
C
      INTEGER LCHSCN
C
      LCHTYP = LCHSCN(IPOINT,NCHARS)
      RETURN
      END
