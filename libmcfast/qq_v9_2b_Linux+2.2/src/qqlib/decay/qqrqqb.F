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
*CMZ :  1.04/00 09/10/93  11.46.56  by  Paul Avery
*CMZ :  1.01/01 06/11/90  17.36.05  by  Paul Avery
*CMZ :          30/10/90  12.03.20  by  Paul Avery
*>> Author :
      SUBROUTINE QQRQQB

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C  Process the QQBAR command to define a new qqbar pair
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqprop.inc"
#include "qqlib/seq/qqbrat.inc"
#include "qqlib/seq/readinp.inc"

C     Calling arguments
*
C     Local variables
      INTEGER ITYP, NDDEF, IDDEF(2)

      DATA NDDEF, IDDEF /2, 3, 1/
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      CALL QQRGLN(NDDEF, IDDEF, NREAD, LIST, CLIST, LERROR)
      IF(LERROR) GOTO 9996
      IF(NREAD .LT. NDDEF-3) GOTO 9997

C     See if qqbar types are legal
      ITYP = LIST(2)
      IF(ITYP.LE.0 .OR. ITYP.GT.37) GOTO 9998

C     Fill in properties
      QNAME(ITYP) = CLIST(1)

C     Normal exit
      RETURN

9996  CALL ZERTYP('.TRUE.')
      LERROR = .TRUE.
      RETURN

9997  CALL ZERTYP('.TRUE.')
      LERROR = .TRUE.
      RETURN

9998  CALL ZERTYP('.TRUE.')
      LERROR = .TRUE.
      RETURN

      END
