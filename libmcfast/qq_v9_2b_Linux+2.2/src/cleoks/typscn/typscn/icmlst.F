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
* Revision 1.1  1995/07/31 19:39:18  nk
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
C
C-----------------------------------------------------------------------------
C Returns the number and a list of command matches found.
C
      INTEGER FUNCTION ICMLST(NLIST,ILIST)
      SAVE
C
      INTEGER  I
      INTEGER  N
      INTEGER  NLIST
      INTEGER  ILIST(NLIST)
C
C     NLIST is dimension of ILIST (input variable).
C     ILIST is output array of matching command numbers.
C
#include "cleoks/typscn/typcde/typpar.inc"
#include "cleoks/typscn/typcde/typchr.inc"
#include "cleoks/typscn/typcde/typscn.inc"
#include "cleoks/typscn/typcde/typstr.inc"
#include "cleoks/typscn/typcde/typctl.inc"
C
      ICMLST = NMATCH
      N = MIN(NMATCH, NLIST)
      DO 10 I=1,N
      ILIST(I) = ICLIST(I)
10    CONTINUE
      RETURN
      END
