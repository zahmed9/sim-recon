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
*CMZ :  1.04/00 04/10/94  22.55.10  by  Paul Avery
*CMZ :  1.03/31 11/11/91  20.48.00  by  Unknown
*CMZ :  1.03/12 02/07/91  11.40.59  by  Peter C Kim
*CMZ :  1.01/00 13/10/90  17.59.01  by  Paul Avery
*CMZ :  1.00/00 24/08/90  00.17.51  by  Paul Avery
*-- Author :    Jorge L. Rodriguez   05/06/90
      SUBROUTINE QQSRUN(IRUN)

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C     Read the file which contains the current QQ run number, reads
C     in the number, and increments the number in the file by 1. If the
C     file is missing, the number 1 is returned.
C
C  Note: the file is assumed to be unprotected so that many users can
C        write to it.
C
C *IRUN      integer variable (write)
C            Run number
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "qqlib/seq/qqluns.inc"

      CHARACTER*(*) CRNAME
      PARAMETER (  CRNAME = 'QQSRUN' )

C     Calling arguments
      INTEGER IRUN

C     Local variables
      CHARACTER*80  CFILE, FULNAM

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C     1. Open the file
C     1. Read the run number
C     2. Rewind the file
C     3. Write the new run into the file
C     4. Close the file

      CFILE = 'QQSEQ.INI'

      CALL GFUFNM( CFILE, FULNAM, CRNAME )


#if defined(CLEO_VAX)
      OPEN(UNIT=LTMPQQ, FILE=FULNAM, STATUS='OLD',ERR=9999)
#endif
#if defined(CLEO_UNIX)
      OPEN(UNIT=LTMPQQ, FILE=FULNAM, STATUS='OLD',ERR=9999)
#endif
#if defined(CLEO_IBM)
      OPEN(UNIT=LTMPQQ, FILE=FULNAM, STATUS='OLD',ERR=9999)
#endif

      READ(LTMPQQ, 5051) IRUN
5051  FORMAT(I10)
      IRUN = IRUN + 1
      REWIND LTMPQQ
      WRITE(LTMPQQ, 5051) IRUN
      CLOSE(LTMPQQ)

C     Normal exit
      RETURN

C     Come here if file is missing
9999  IRUN = 1
      RETURN
      END
