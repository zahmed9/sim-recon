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
*CMZ :  1.04/00 08/01/94  17.39.03  by  Paul Avery
*CMZ :          09/10/93  11.46.56  by  Paul Avery
*>> Author :
      SUBROUTINE QQRCON

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C  Process the CONSTANT command to read in constants which affect particle
C  decays, such as quark popping fractions, PS/V ratios, etc.
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqprop.inc"
#include "qqlib/seq/readinp.inc"
#include "qqlib/seq/mcgen.inc"
#include "qqlib/seq/mcjet.inc"

C     Calling arguments
*
C     Local variables
      INTEGER ITYP1, ITYP2, NDDEF, IDDEF(10)

      DATA NDDEF, IDDEF /10, 3, 1, 1, 7*2/
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      CALL QQRGLN(NDDEF, IDDEF, NREAD, LIST, CLIST, LERROR)
      IF(LERROR) GOTO 9995
      IF(NREAD .LT. NDDEF-3) GOTO 9996

C     See if particle types are legal
      ITYP1 = LIST(2)
      ITYP2 = LIST(3)
      IF(ITYP1.LT.-20 .OR. ITYP1.GT.MCNUM ) GOTO 9997
      IF(ITYP2.LT. -1 .OR. ITYP2.GT.MCSTBL) GOTO 9998
      NPMNQQ = MIN(ITYP1, NPMNQQ)
      NPMXQQ = MAX(ITYP1, NPMXQQ)

C     Fill in properties
      PNAME(ITYP1) = CLIST(1)
      IDMC(ITYP1) = ITYP2
      AMASS(ITYP1) = XLIST(4)
      CHARGE(ITYP1) = XLIST(5)
      SPIN(ITYP1) = XLIST(6)
      CTAU(ITYP1) = XLIST(7)

C      Width properties only filled in if all read in
      IF(NREAD .EQ. NDDEF) THEN
        RWIDTH(ITYP1) = XLIST(8)
        RMASMN(ITYP1) = XLIST(9)
        RMASMX(ITYP1) = XLIST(10)
      ENDIF

C     Normal exit
      RETURN

C     Error exits
9995  CALL ZERTYP('.TRUE.')
      LERROR = .TRUE.
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
