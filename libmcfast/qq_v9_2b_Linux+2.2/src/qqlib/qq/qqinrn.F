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
*CMZ :  1.04/00 05/10/94  02.49.39  by  Peter C Kim
*CMZ :          07/12/93  14.31.48  by  Lynn Garren
      SUBROUTINE QQINRN(LERROR)
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C   Initialize QQ run and event numbers
C   Read ctl file
C
C                       NAMELIST  -->  FFREAD
C                       Calls QQINPT for reading in QQ control parameters
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "seq/clinc/qqevnt.inc"
#include "qqlib/seq/qqcntl.inc"
#include "seq/clinc/qqinfo.inc"
#include "qqlib/seq/qqluns.inc"

C-- Calling arguments
      LOGICAL LERROR

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      LERROR = .TRUE.

C-- Update run number
      IEVTQQ = 0
      CALL QQSRUN(IRUNQQ)

C-- Read in any changes to the control variables via FFREAD

      CALL QQINPT(LERROR)
      IF(LERROR) THEN
        WRITE(LTTOQQ, 5065)
        WRITE(LOUTQQ, 5065)
 5065   FORMAT(/,' QQINRN: Error reading QQ control file',/)
        GOTO 9999
      ENDIF

C   Write run number, date and time first
      WRITE(LOUTQQ, 5731) IRUNQQ, DATEQQ, TIMEQQ
5731  FORMAT(' QQ run number',I6,' started at ',A,A)

C     Normal exit
      LERROR = .FALSE.
      RETURN

C     Error exit
9999  RETURN
      END
