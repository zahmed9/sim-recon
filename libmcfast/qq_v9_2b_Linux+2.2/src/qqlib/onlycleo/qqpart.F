*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:39  eugenio
* Initial revision
*
* Revision 1.3  1996/07/10 06:35:17  clib
* Change MESLOG call to provide an info message instead of error.
*
* Revision 1.2  1996/07/05 11:37:33  clib
* Use MESLOG to write out messages to the log file.
*
* Revision 1.1.1.1  1994/10/08  02:21:37  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 04/10/94  22.54.10  by  Paul Avery
*CMZ :  1.03/12 02/07/91  11.31.00  by  Peter C Kim
*CMZ :  1.03/06 01/05/91  13.36.35  by  Peter C Kim
*CMZ :  1.03/02 04/04/91  07.28.26  by  Peter C Kim
*CMZ :  1.03/01 03/04/91  15.53.59  by  Peter C Kim
*CMZ :  1.03/00 02/04/91  15.45.41  by  Peter C Kim
*CMZ :  1.02/00 05/02/91  22.46.11  by  Paul Avery
*-- Author :
      SUBROUTINE QQPART

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C    Read in QQPART.INI to get particle properties
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqprop.inc"
#include "seq/clinc/cluns.inc"
#include "seq/clutil/mesrep.inc"

      CHARACTER*(*) CRNAME
      PARAMETER (  CRNAME = 'QQPART')

C     Local variables
      INTEGER I, J, LUNQ
      CHARACTER*80 FILIN, FULNAM

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      FILIN = 'QQPART.INI'

      CALL GFUFNM( FILIN, FULNAM, CRNAME)

#if defined(CLEO_VAX)
      OPEN(UNIT=LUNTMP, FILE=FULNAM, STATUS='OLD',READONLY,SHARED)
#endif
#if defined(CLEO_UNIX)
      OPEN(UNIT=LUNTMP, FILE=FULNAM, STATUS='OLD')
#endif
#if defined(CLEO_IBM)
      OPEN(UNIT=LUNTMP, FILE=FULNAM, STATUS='OLD')
#endif

CXX      WRITE(LUNTTO, 5000) FILIN(:40)
CXX5000  FORMAT(/,' Reading ',A)

         WRITE(CHMESS,901) 
         CALL MESLOG(CRNAME, 1, MSINFO )
 901     FORMAT('  READING in qqpart.ini ')


      READ(LUNTMP, 5009) NPMNQQ, NPMXQQ
5009  FORMAT(2I5)
      DO 100 I=NPMNQQ,NPMXQQ
        READ(LUNTMP, 5010) J, IDMC(I), PNAME(I), AMASS(I), CHARGE(I),
     *                     CTAU(I), SPIN(I), RWIDTH(I), RMASMN(I),
     *                     RMASMX(I)
5010    FORMAT(I4,I3,1X,A10, G12.5, 0PF5.0, G12.4, 0PF5.1, 3F9.4)
100   CONTINUE

      CLOSE(UNIT=LUNTMP)

      RETURN
      END
