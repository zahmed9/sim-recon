*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:42  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:30  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 22/09/94  00.16.46  by  Paul Avery
*CMZ :          21/03/94  23.24.29  by  Paul Avery
      SUBROUTINE QQCHEX(TYPE, ND, KID, FOUND)

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C    Check to see if any exclusive modes are included in inclusive modes
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
C
#include "seq/clinc/qqpars.inc"
#include "qqlib/seq/qqbrat.inc"
*
C     Calling arguments
      INTEGER TYPE, ND, KID(ND), FOUND

C     Local variables
      INTEGER KFSUM, I1, I2, I3, I4, I5, IFIRST, KFIRST, NDAUK
      INTEGER IFSORT(30), IKSORT(30)
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


      KFSUM = 0
      DO 4010 I1=1,ND
        KFSUM = KFSUM + KID(I1)
4010  CONTINUE

      IFIRST = IPLIST(1,TYPE)
      DO 4020 I2=1,IPLIST(2,TYPE)

        KFIRST = MLLIST(2,IFIRST+I2-1)
        NDAUK  = MLLIST(1,IFIRST+I2-1)

        IF(MLLIST(9,IFIRST+I2-1).EQ.KFSUM .AND. NDAUK.EQ.ND) THEN

          DO 4030 I3=1,ND
            IFSORT(I3) = KID(I3)
4030      CONTINUE
          CALL INTSOR(IFSORT,ND)

          DO 4040 I4=1,NDAUK
            IKSORT(I4) = IDLIST(KFIRST+I4-1)
4040      CONTINUE
          CALL INTSOR(IKSORT,NDAUK)

          DO 4050 I5=1,ND
            IF(IKSORT(I5).NE.IFSORT(I5)) GOTO 4020
4050      CONTINUE

          GOTO 9999

        ENDIF

4020  CONTINUE

C     Exclusive decay not done. OK
      FOUND = 0
      RETURN

C     Exclusive decay already done. Try again.
9999  FOUND = 1
      RETURN
      END
