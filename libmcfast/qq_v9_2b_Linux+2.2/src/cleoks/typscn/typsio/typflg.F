*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:20  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  18:00:16  nk
* Consolidation
*
* Revision 1.1  1995/07/31 19:40:39  nk
* Added typscn
*
* Revision 1.1.1.1  1994/10/05  13:45:41  zfiles
* first version of typscn in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
#if defined(CLEO_VAX)
*CMZ :  1.00/08 14/08/90  14.41.46  by  J. D. Lewis
*CMZ :  1.00/04 11/12/89  10.59.34  by  Ian C. Brock
*CMZ :  1.00/00 12/05/89  17.29.21  by  Ian C. Brock
*-- Author :
C************************************************************************
C VAX IBM, APOLLO and MACINTOSH I/O ROUTINES
C Flags to select them are VAX, IBM, APOLLO and MACINTOSH
C Only the Vax supports asynchronous I/O
C------------------------------------------------------------------------
C Sets which event flag gets lit when waiting for typin
C
      SUBROUTINE TYPFLG(JEVFLG)
C
      INTEGER  JEVFLG
C
#include "cleoks/typscn/typcde/typpar.inc"
#include "cleoks/typscn/typcde/typchr.inc"
#include "cleoks/typscn/typcde/typscn.inc"
#include "cleoks/typscn/typcde/typstr.inc"
#include "cleoks/typscn/typcde/typctl.inc"
C
      IEVFLG = JEVFLG
      RETURN
      END
#endif
