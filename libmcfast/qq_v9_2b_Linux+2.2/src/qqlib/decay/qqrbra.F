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
*CMZ :  1.03/39 14/01/92  16.23.20  by  Peter C Kim
*CMZ :  1.01/02 19/11/90  18.00.45  by  Paul Avery
*CMZ :  1.01/00 05/11/90  22.15.12  by  Paul Avery
*CMZ :          30/10/90  12.03.20  by  Paul Avery
*>> Author :
      SUBROUTINE QQRBRA

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C  Finish up decay sequence for a particle (when ENDDECAY encountered)
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqprop.inc"
#include "qqlib/seq/qqbrat.inc"
#include "qqlib/seq/readinp.inc"
#include "qqlib/seq/qqluns.inc"

C     Calling arguments
*
C     Local variables
      REAL SCALE
      INTEGER I, IPOS
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      IF(IDECAY.NE.-100.AND.NCHAN .EQ. 0) THEN
        IPLIST(1,IDECAY) = 0
        IPLIST(3,IDECAY) = 0
      ENDIF

      IF(IDECAY.LT.NPMNQQ .OR. NCHAN.EQ.0) GOTO 1000

      IPOS = IPLIST(1,IDECAY) - 1

C     Make cumulative list of branching fractions for this decay
      DO 1030 I=2,NCHAN
        BRLIST(IPOS+I) = BRLIST(IPOS+I) + BRLIST(IPOS+I-1)
1030  CONTINUE
      IF(BRLIST(IPOS+NCHAN) .EQ. 0.) GOTO 9999
      SCALE = 1. / BRLIST(IPOS+NCHAN)
      DO 1040 I=1,NCHAN
        BRLIST(IPOS+I) = BRLIST(IPOS+I) * SCALE
1040  CONTINUE
      IPLIST(2,IDECAY) = NCHAN

C     Now do the same for CP eigenstate BR's
      IF(NCHNCP .EQ. 0) THEN
        IPLIST(3,IDECAY) = 0
        GOTO 1000
      ENDIF
      IPOS = IPLIST(3,IDECAY) - 1

C     Make cumulative list of branching fractions for this decay
      DO 1130 I=2,NCHNCP
        CPLIST(IPOS+I) = CPLIST(IPOS+I) + CPLIST(IPOS+I-1)
1130  CONTINUE
      IF(CPLIST(IPOS+NCHNCP) .EQ. 0.) GOTO 9999
      SCALE = 1. / CPLIST(IPOS+NCHNCP)
      DO 1140 I=1,NCHNCP
        CPLIST(IPOS+I) = CPLIST(IPOS+I) * SCALE
1140  CONTINUE
      IPLIST(4,IDECAY) = NCHNCP

C     Normal exit
1000  NCHAN = 0
      NCHNCP = 0
      RETURN

C     Error exit
9999  WRITE(LTTOQQ, 5000)
5000  FORMAT(' QQRBRA: All the branching fractions are 0')
      LERROR = .TRUE.
      NCHAN = 0
      NCHNCP = 0
      RETURN

      END
