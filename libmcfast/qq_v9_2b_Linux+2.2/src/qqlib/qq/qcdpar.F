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
*CMZ :  1.04/00 16/09/94  02.26.34  by  Paul Avery
*CMZ :  1.03/45 27/04/92  18.44.26  by  Peter C Kim
*CMZ :  1.01/00 03/11/90  16.58.30  by  Paul Avery
*CMZ :  1.00/00 21/08/90  21.08.21  by  Paul Avery
*CMZ :          21/05/90  17.20.56  by  Jon Urheim
*-- cosmetic mods to adapt to CLEO2 software standards
*CMZ :          20/05/90  13.38.51  by  Jorge L. Rodriguez
*CMZ :          19/05/90  15.07.54  by  Jorge L. Rodriguez
*>> Author :
      SUBROUTINE QCDPAR
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif


C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C     Type the parameters and common blocks of QQ
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#include "qqlib/seq/mcjet.inc"
#include "qqlib/seq/mcgen.inc"
#include "qqlib/seq/qqcntl.inc"
#include "qqlib/seq/qqluns.inc"

C-- Local variables
      INTEGER I

      WRITE(LOUTQQ,109)
109   FORMAT(/,15X,' Parameters in LUND Common blocks')

      WRITE(LOUTQQ,111)IST,IFR,PUD,PS1,SIGMA,FLIP,WBAR
111   FORMAT('0   IST',4X,'IFR',4X,'PUD',18X,'PS1',2X,'SIGMA',3X,
     *  'FLIP',3X,'WBAR',/,2I7,F7.3,14X,4F7.3)

      WRITE(LOUTQQ,112)(I,I=1,6),PBFL
112   FORMAT('0   PBFL(6)',6I10,/,11X,6F10.1)

      WRITE(LOUTQQ,113)(I,I=1,6),KBRFLV
113   FORMAT('0  KBRFLV(6,4)',6I10,/,(14X,6I10))

      WRITE(LOUTQQ,114)(I,I=1,7),QMAS
114   FORMAT('0   QMAS(15)',/,7I9,/,7F9.3,/,8F9.3)

      WRITE(LOUTQQ,115)(I,I=1,10),PAR
115   FORMAT('0  PAR(25)',/,10I8,/,(10F8.4))

      WRITE(LOUTQQ,116)(I,I=1,15),CZF
116   FORMAT('0  CZF(15)',/,3X,15I5,/,3X,15F5.2)

      WRITE(LOUTQQ,117)(I,I=1,20),MESO
117   FORMAT('0  MESO(36)',/,(20I4))

      WRITE(LOUTQQ,118)(I,I=1,6),CMIX
118   FORMAT('0  CMIX(6,2)',6I10,/,(12X,6F10.3))

      WRITE(LOUTQQ,121) CND
121   FORMAT('0   CND(3) = ',3F10.2)

C-- what is wtcor? - JU 5/21/90
C      WRITE(LOUTQQ,122) (I,I=1,10), WTCOR
C122   FORMAT('0  WTCOR(10)= ',/,I4,9I8,/,(10G8.1))

      WRITE(LOUTQQ,123)(I,I=1,10), PSPIN
123   FORMAT('0   PSPIN(10)',10I10,/,(12X,10F10.2))

      WRITE(LOUTQQ,124)(I,I=1,3),CMIX1
124   FORMAT('0  CMIX1(3,6)',3I10,/,(12X,3F10.2))

      WRITE(LOUTQQ,125)CMLT1
125   FORMAT('0  CMLT1(5)',5F10.3)

      WRITE(LOUTQQ,126)CMLT2
126   FORMAT('0  CMLT2(5)',5F10.3)

      RETURN
      END
