*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:43  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:26  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 16/09/94  02.26.03  by  Paul Avery
*CMZ :  1.03/62 23/03/93  16.12.27  by  Brian Heltsley
* put in FPAIR (mumuggg)
*CMZ :          22/11/91  13.08.00  by  B. Heltsley
* put in BHLUMI
*CMZ :          21/08/90  21.08.22  by  Paul Avery
*CMZ :          19/05/90  15.07.54  by  Jorge L. Rodriguez
*>> Author :
      SUBROUTINE MODFIN
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C  ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C     Finishes up events depending on the models
C  ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#include "qqlib/seq/qqcntl.inc"


      IF (MODEL.LT.2) RETURN


C-- qed models

      IF     (MODEL .EQ. 2) THEN
                                   CALL QED013
      ELSEIF (MODEL .EQ. 3) THEN
                                   CALL QED023
      ELSEIF (MODEL .EQ. 4) THEN
                                   CALL QED033
      ELSEIF (MODEL .EQ. 5) THEN
                                   CALL QED043
      ELSEIF (MODEL .EQ. 6) THEN
                                   CALL GGGFIN
      ELSEIF (MODEL .EQ. 7) THEN
                                   CALL KORBER
      ELSEIF (MODEL .EQ. 8) THEN
                                   CALL BHLUEJ
      ELSEIF (MODEL .EQ. 9) THEN
                                   CALL FPAREJ
      ELSEIF (MODEL .EQ.10) THEN
                                   CALL MODFNU

      ELSEIF (MODEL.GE.11.AND.MODEL.LE.20) THEN

                                   CALL QFLUND
      ENDIF

      RETURN
      END
