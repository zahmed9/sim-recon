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
*CMZ :  1.04/00 16/09/94  02.30.09  by  Paul Avery
*CMZ :          07/12/93  12.18.17  by  Lynn Garren
      SUBROUTINE QQINIC

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C   Initialize QQ
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "qqlib/seq/mcjet.inc"

C-- Local variables
      INTEGER I, L
      REAL      CTOT


C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C-- Make cumulative list for SU(3) mixing (uu,dd,ss)

      DO 5576 I=1,6
        CTOT=CMIX1(1,I)+CMIX1(2,I)+CMIX1(3,I)
        DO 5577 L=1,3
          CMIX1(L,I)=CMIX1(L,I)/CTOT
 5577   CONTINUE
        CMIX1(2,I)=CMIX1(1,I)+CMIX1(2,I)
        CMIX1(3,I)=CMIX1(2,I)+CMIX1(3,I)
 5576 CONTINUE

      RETURN
      END
