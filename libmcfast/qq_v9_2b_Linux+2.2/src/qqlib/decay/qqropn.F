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
*CMZ :  1.04/00 28/10/93  13.15.29  by  Paul Avery
*CMZ :  1.03/31 11/11/91  20.48.00  by  Unknown
*CMZ :  1.03/12 02/07/91  12.19.11  by  Peter C Kim
*CMZ :  1.03/09 07/05/91  14.21.53  by  Manoj Thulasidas
*CMZ :  1.03/00 02/04/91  11.43.04  by  Peter C Kim
*CMZ :  1.01/00 01/11/90  17.56.20  by  Paul Avery
*CMZ :  1.00/01 18/10/90  17.52.45  by  Paul Avery
*-- Author :    Paul Avery   21/08/89
      SUBROUTINE QQROPN

C >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C     Processes the INCLUDE command by reading a new file at this point
C >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "seq/clinc/qqpars.inc"
#include "qqlib/seq/qqbrat.inc"
#include "qqlib/seq/readinp.inc"
#include "qqlib/seq/qqluns.inc"

C     External routines
      INTEGER LENOCC
      EXTERNAL LENOCC

C     Calling arguments

C     Local variables
      INTEGER ITMP, LENG

C >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      IF(CFILE .EQ. ' ') GOTO 1000

      IF(ILUN .GE. MLUNS) GOTO 9989

C     Replace GETLUN call to get rid of CLEO specific call
      CALL QQGLUN(LUN)
      IF(LUN .EQ. 0) GOTO 9988

#if defined(CLEO_VAX)
      OPEN(UNIT=LUN,FILE=CFILE,STATUS='OLD',READONLY,SHARED,ERR=9985)
#endif
#if defined(CLEO_UNIX)
      OPEN(UNIT=LUN,FILE=CFILE,STATUS='OLD',ERR=9985)
#endif
#if defined(CLEO_IBM)
      OPEN(UNIT=LUN,FILE=CFILE,STATUS='OLD',ERR=9985)
#endif

      ILUN = ILUN + 1
      LUNS(ILUN) = LUN
      IF(NFDECA .LE. MFDECA) THEN
        NFDECA = NFDECA + 1
        CFDECA(NFDECA) = CFILE
      ENDIF

C     Normal exit
1000  LERROR = .FALSE.
      RETURN

C     Error opening file
9985  LENG = LENOCC(CFILE)
      WRITE(LTTOQQ, 5001) CFILE(:LENG)
5001  FORMAT(' QQROPN:  Could not open file: ',A)
      CALL ZERTYP('.FALSE.')
      LUN = LUNS(ILUN)
      LERROR = .TRUE.
      RETURN

C     No more unit numbers available
9988  WRITE(LTTOQQ, 5002)
5002  FORMAT(' QQROPN:  Could not get unit number')
      CALL ZERTYP('.FALSE.')
      LUN = LUNS(ILUN)
      LERROR = .TRUE.
      RETURN

C     Too many files open at one time
9989  WRITE(LTTOQQ, 5003)
5003  FORMAT(' QQROPN:  Too many files open at one time')
      CALL ZERTYP('.FALSE.')
      LERROR = .TRUE.
      RETURN

      END
