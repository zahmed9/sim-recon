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
* Revision 1.1  1995/07/31 19:39:24  nk
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
C------------------------------------------------------------------------
C Store up to DIMSYM-62 additional legal symbols for commands.
C
      SUBROUTINE ICMSYM(CQUOTE)
      SAVE
C
      INTEGER  I
      INTEGER  L
C
#include "cleoks/typscn/typcde/typpar.inc"
#include "cleoks/typscn/typcde/typchr.inc"
#include "cleoks/typscn/typcde/typscn.inc"
#include "cleoks/typscn/typcde/typstr.inc"
#include "cleoks/typscn/typcde/typctl.inc"
C
      CHARACTER*(*) CQUOTE
C
      L = MIN(LEN(CQUOTE),DIMSYM-62) + 62
      NSYMBL = 62
      DO 10 I=63,L
      CSYMBL(I:I) = CQUOTE(I-62:I-62)
      NSYMBL = NSYMBL + 1
10    CONTINUE
      RETURN
      END
