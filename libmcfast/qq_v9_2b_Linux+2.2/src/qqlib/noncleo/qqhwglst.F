*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:39  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:38  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 22/03/94  19.21.14  by  Lynn Garren
*-- Author :
      SUBROUTINE QQHWGLST
C
C    compare particle ID for QQ and Herwig
C
#include "qqlib/seq/qqluns.inc"
#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqprop.inc"

      INTEGER ID1,IT1,ITT1,I
      INTEGER QQ2HWG
      CHARACTER*16 CNAM1,CNAM2
      CHARACTER*20 HNAM1

C...special cases
      WRITE(LOUTQQ,1001)
      DO 100 I=NPMNQQ,NPMXQQ
        ID1=I
        CNAM1 = PNAME(ID1)
        IT1=QQ2HWG(ID1,1)
        ITT1=QQ2HWG(IT1,2)
        CALL HEPNAM(IT1,HNAM1)
        CNAM2 = ' '
        IF(ITT1.GT.-20) CNAM2 = PNAME(ITT1)
        WRITE(LOUTQQ,1101) ID1,CNAM1,IT1,HNAM1,ITT1,CNAM2
 100  CONTINUE
      RETURN
 1001 FORMAT(//10X,'Particles'
     1       /5X,'IQQ  QNAME',14X,'IHWG  HNAME',15X,'IQQ  QNAME')
 1101 FORMAT(1X,I7,2X,A15,1X,I7,2X,A15,1X,I7,2X,A15)
      END

