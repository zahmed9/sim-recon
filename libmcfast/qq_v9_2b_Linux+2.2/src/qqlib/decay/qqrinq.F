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
*CMZ :  1.04/00 16/12/93  16.32.54  by  Lynn Garren
*CMZ :  1.01/00 31/10/90  22.52.49  by  Paul Avery
*CMZ :          29/10/90  10.16.03  by  Paul Avery
*>> Author :
      INTEGER FUNCTION QQRINQ(NAME)

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C  Returns the qqbar number corresponding to the quark pair name NAME
C
C  FILE        character variable (read)
C              Name of quark pair (e.g., *ud*, *dd*, ...)
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqprop.inc"

C     Calling arguments
      CHARACTER*(*) NAME
*
C     Local variables
      INTEGER I
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C     Loop over qqbar list until we find the combination
      DO 100 I=1,37
        IF(NAME .EQ. QNAME(I)) THEN
          QQRINQ = I
          GOTO 1000
        ENDIF
100   CONTINUE
      QQRINQ = 0

C     Only exit
1000  RETURN
      END
