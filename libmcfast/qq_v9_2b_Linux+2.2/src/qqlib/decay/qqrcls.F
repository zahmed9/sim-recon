*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:36  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:31  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 28/10/93  15.19.36  by  Paul Avery
*CMZ :  1.01/00 01/11/90  17.56.20  by  Paul Avery
*CMZ :  1.00/01 15/06/90  11.59.44  by  Paul Avery
*-- Author :    Paul Avery   21/08/89
      SUBROUTINE QQRCLS

C >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C     Close a unit if EOF reached in a file
C >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "qqlib/seq/readinp.inc"

C     External routines

C     Calling arguments

C     Local variables
C >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      IF(ILUN .EQ. 0) GOTO 1000

      CLOSE(UNIT=LUN)
      ILUN = ILUN - 1
      IF(ILUN .GT. 0) LUN = LUNS(ILUN)

C     Only exit
1000  RETURN
      END
