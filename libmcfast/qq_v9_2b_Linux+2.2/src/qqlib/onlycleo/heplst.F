*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:39  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:37  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 04/10/94  23.00.36  by  Paul Avery
*-- Author :
*-- Author :    Alan Weinstein 21/07/93
      SUBROUTINE HEPLST(LUN)
C.......................................................................
C.
C. HEPLST - Dump contents of HEPEVT common for one event.
C.
C. COMMON    : HEPEVT

C. Calls     :
C. Called    :
C. Author    : Alan Weinstein 21/07/93
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C- Argument  declarations

      INTEGER LUN

C- Sequences

#include "seq/clinc/mcpars.inc"
#include "seq/clinc/mccoms.inc"
#include "qqlib/seq/hepevt.inc"

C- External declarations

C-- Local variables

      INTEGER I,J
      REAL PTOT(4)

C-- Executable code starts here-----------------------------------------------

      CALL DMPMCC(1,LUN)

      CALL VZERO (PTOT,4)
      DO 10 I=1,NTRKQQ
        IF (NDAUTV(I).EQ.0) THEN
          PTOT(1) = PTOT(1)+P4QQ(1,I)
          PTOT(2) = PTOT(2)+P4QQ(2,I)
          PTOT(3) = PTOT(3)+P4QQ(3,I)
          PTOT(4) = PTOT(4)+P4QQ(4,I)
        END IF
  10  CONTINUE
      WRITE (6,987) PTOT
 987  FORMAT(' TOTAL STABLE PX,PY,PZ,E =',4F10.6)

      WRITE(LUN,1) NEVHEP,NHEP
   1  FORMAT(/,' CONTENTS OF HEPEVT COMMON, NEVHEP =',I6
     $        ,', NHEP =',I6,':'
     $      ,/,'     N   IST    ID  JMO1  JMO2  JDA1  JDA2'
     $        ,'      PX      PY      PZ       E       M')

      CALL VZERO (PTOT,4)
      DO 20 I=1,NHEP
        WRITE(LUN,2) I,ISTHEP(I),IDHEP(I),JMOHEP(1,I),JMOHEP(2,I),
     $               JDAHEP(1,I),JDAHEP(2,I),(PHEP(J,I),J=1,5)
   2    FORMAT(7I6,5F8.3)

        IF (JDAHEP(1,I).EQ.0) THEN
          PTOT(1) = PTOT(1)+PHEP(1,I)
          PTOT(2) = PTOT(2)+PHEP(2,I)
          PTOT(3) = PTOT(3)+PHEP(3,I)
          PTOT(4) = PTOT(4)+PHEP(4,I)
        END IF
  20  CONTINUE
      WRITE (6,987) PTOT

9001  RETURN
      END
