*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:21  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  18:00:23  nk
* Consolidation
*
* Revision 1.1  1995/07/31 19:42:39  nk
* Added typscn
*
* Revision 1.1.1.1  1994/10/05  13:45:41  zfiles
* first version of typscn in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/02 15/07/89  10.22.24  by  Ian C. Brock
*CMZ :  1.00/00 12/05/89  16.55.34  by  Ian C. Brock
*-- Author :
C
C---------------------------------------------------------------------------
C User can supply his own 'teletype' line to interpret in LQUOTE
C
      SUBROUTINE QUOTYP(CQUOTE)
      SAVE
C
#include "cleoks/typscn/typcde/typpar.inc"
#include "cleoks/typscn/typcde/typchr.inc"
#include "cleoks/typscn/typcde/typscn.inc"
#include "cleoks/typscn/typcde/typstr.inc"
#include "cleoks/typscn/typcde/typctl.inc"
C
      INTEGER  N
      INTEGER  NN
      CHARACTER*(*) CQUOTE
C
C       Cancel asyncrounous read if any outstanding
      CALL ASYNCN
C
C     Strip trailing blanks and tabs
      DO 10 NN=LEN(CQUOTE),1,-1
      N = NN
      IF (INDEX(CTABSP,CQUOTE(N:N)).EQ.0) GO TO 1
10    CONTINUE
      N = 0
1     CONTINUE
C
C     Load work string with user string
      NCHACC = MIN(N,DIMTYD)
      CTYDAT = ' '
      IF(NCHACC.GT.0) CTYDAT = CQUOTE(1:NCHACC)
      IPOINT = 0
      NCHARS = NCHACC
      KCHARS = NCHARS
      KPOINT = IPOINT
      RETURN
      END
