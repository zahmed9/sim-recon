*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:19  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  18:00:12  nk
* Consolidation
*
* Revision 1.1  1995/07/31 19:39:42  nk
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
C----------------------------------------------------------------------------
C Store up to DIMDEL-2 legal delimiter characters. Space and tab are always
C the first two.
C
      SUBROUTINE SDLSCN(CUSDEL)
      SAVE
C
C     CUSDEL defines users delimiters (input).
C
#include "cleoks/typscn/typcde/typpar.inc"
#include "cleoks/typscn/typcde/typchr.inc"
#include "cleoks/typscn/typcde/typscn.inc"
#include "cleoks/typscn/typcde/typstr.inc"
#include "cleoks/typscn/typcde/typctl.inc"
C
      CHARACTER*(*) CUSDEL
      INTEGER  I
      INTEGER  L
C
      L = MIN(LEN(CUSDEL),DIMDEL-2) + 2
      NDELIM = 2
      DO 10 I=3,L
      IF (INDEX(CTABSP,CUSDEL(I-2:I-2)).EQ.0) THEN
              CDELIM(I:I) = CUSDEL(I-2:I-2)
              NDELIM = NDELIM + 1
      END IF
10    CONTINUE
      RETURN
      END
