*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:38  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:28  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 22/09/94  00.25.22  by  Paul Avery
*-- Author :
      SUBROUTINE QQPFIL(CFILE)

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C    Read in particle properties from file CFILE
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqprop.inc"

      CHARACTER*(*) CRNAME
      PARAMETER (  CRNAME = 'QQPFIL')

C     Calling argument
      CHARACTER*(*) CFILE

C     Local variables
      INTEGER I, J, LUNQ
      LOGICAL LOPEN
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C     Loop through units until we find one that's available
C     Do not use GETLUN since we are independent of CLEO here
      CALL QQGLUN(LUNQ)
      IF(LUNQ .EQ. 0) GOTO 9999

#if defined(CLEO_VAX)
      OPEN(UNIT=LUNQ, FILE=CFILE, STATUS='OLD',READONLY,SHARED,
     *     ERR=9999)
#endif
#if defined(CLEO_UNIX)
      OPEN(UNIT=LUNQ, FILE=CFILE, STATUS='OLD', ERR=9999)
#endif
#if defined(CLEO_IBM)
      OPEN(UNIT=LUNQ, FILE=CFILE, STATUS='OLD', ERR=9999)
#endif

      READ(LUNQ, 5009) NPMNQQ, NPMXQQ
5009  FORMAT(2I5)
      DO 200 I=NPMNQQ,NPMXQQ
        READ(LUNQ, 5010) J, IDMC(I), PNAME(I), AMASS(I), CHARGE(I),
     *                      CTAU(I), SPIN(I), RWIDTH(I), RMASMN(I),
     *                      RMASMX(I)
5010    FORMAT(I4,I3,1X,A10, G12.5, 0PF5.0, G12.4, 0PF5.1, 3F9.4)
200   CONTINUE

      CLOSE(UNIT=LUNQ)

9999  CONTINUE

      RETURN
      END
