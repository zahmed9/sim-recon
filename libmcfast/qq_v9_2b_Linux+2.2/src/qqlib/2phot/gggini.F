*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:33  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:35  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 22/09/94  00.23.02  by  Paul Avery
*CMZ :  1.03/31 11/11/91  20.48.01  by  Unknown
*CMZ :  1.03/15 22/07/91  21.03.30  by  Peter C Kim
*-- Author :
      SUBROUTINE GGGINI

C..*   This routine is used to initialize the 2-photon MC generator.    *
C..* 4-March-1991 is the first attempts to modify it to use FFREAD      *
C..* FFKEY, etc...  for inputs and remove the archaic NML method.       *
C..*                                             Roger A Fulton         *

#include "seq/clinc/qqevnt.inc"
#include "qqlib/seq/qqluns.inc"
#include "qqlib/gggseq/ggprms.inc"
#include "qqlib/seq/jetscl.inc"

C
C  Get unit numbers -- Eliminate 10-9-93 (PA)
CPA      CALL DVLUNS(LTTIQQ, LTTOQQ, LOUTQQ, LTMPQQ, LTINQQ, LTOUQQ)
C
      WRITE(LTTOQQ,1)IRUNQQ
      WRITE(LOUTQQ,1)IRUNQQ
   1  FORMAT(' GGGINI: 2-Photon Monte Carlo run ',I5)
C
      WRITE(LTTOQQ,2)
      WRITE(LOUTQQ,2)
   2  FORMAT('GGGINI:',T11,'Vers-4.0',T21,'1-JAN-91',T31,'R.A.Fulton',
     *  T42,'MC 2-Photon Event generator')
C

C--- Update the particle list and decay table

      IF(LUDTAB .NE. ' ') THEN

#if defined(CLEO_VAX)
      OPEN(UNIT=LTMPQQ, FILE=LUDTAB, STATUS='OLD',READONLY,SHARED)
#endif
#if defined(CLEO_UNIX)
      OPEN(UNIT=LTMPQQ, FILE=LUDTAB, STATUS='OLD')
#endif
#if defined(CLEO_IBM)
      OPEN(UNIT=LTMPQQ, FILE=LUDTAB, STATUS='OLD')
#endif

        WRITE(LTTOQQ,201) LUDTAB
 201    FORMAT(/,' LUND Decay table :  ',A)
        CALL LUUPDA(2,LTMPQQ)

      ENDIF
C-------------------------------------------------------
C
      CALL GGPAR(LTMPQQ)
      CLOSE(UNIT=LTMPQQ)
C
C     model dependent initialization
      CALL GGINIT
C
      WRITE(LTTOQQ,17) EPAMAX
      WRITE(LOUTQQ,17) EPAMAX
 17     FORMAT(1X,/,'   EPAMAX = ',G12.6)
C
      RETURN
      END
