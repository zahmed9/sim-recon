*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:43  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:27  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 16/09/94  02.30.57  by  Paul Avery
*CMZ :          07/12/93  15.01.03  by  Lynn Garren
      SUBROUTINE QQIRND

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C   Initialize QQ
C           Setup random number seeds
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "qqlib/seq/qqcntl.inc"
#include "qqlib/seq/qqluns.inc"

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C-- If IRAN=0, set random seed based on time of day
C
      IF (IRAN .EQ. 0) THEN
         CALL QQSRAN(IRAND)
         IRAND = IRAND
      ELSE
         IRAND = IRAN
      ENDIF

C     Make sure random seeds are different if this is distributed job.
C     IDQQ is the ID number of this particular QQ process.
      IRAND = IRAND + IDQQ

      CALL QQRNST(IRAND, 1)

      WRITE(LTTOQQ,5007) IRAND
5007  FORMAT(' Starting Random Number Seed = ',I11)

      RETURN
      END
