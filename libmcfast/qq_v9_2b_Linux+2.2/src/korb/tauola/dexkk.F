*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:31  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:03  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/00 21/01/93  15.42.32  by  Alan Weinstein
*-- Author :
      SUBROUTINE DEXKK(MODE,ISGN,POL,PKK,PNU)
C ----------------------------------------------------------------------
C TAU DECAY INTO KAON  AND TAU-NEUTRINO
C IN TAU REST FRAME
C OUTPUT FOUR MOMENTA: PNU   TAUNEUTRINO,
C                      PKK   KAON CHARGED
C ----------------------------------------------------------------------
      REAL  POL(4),HV(4),PNU(4),PKK(4)
C
      IF(MODE.EQ.-1) THEN
C     ===================
        CALL DADMKK(-1,ISGN,HV,PKK,PNU)
CC      CALL HBOOK1(815,'WEIGHT DISTRIBUTION  DEXPI    $',100,0,2)
C
      ELSEIF(MODE.EQ. 0) THEN
C     =======================
300     CONTINUE
        CALL DADMKK( 0,ISGN,HV,PKK,PNU)
        WT=(1+POL(1)*HV(1)+POL(2)*HV(2)+POL(3)*HV(3))/2.
CC      CALL HFILL(815,WT)
        CALL RANMAR(RN,1)
        IF(RN.GT.WT) GOTO 300
C
      ELSEIF(MODE.EQ. 1) THEN
C     =======================
        CALL DADMKK( 1,ISGN,HV,PKK,PNU)
CC      CALL HPRINT(815)
      ENDIF
C     =====
      RETURN
      END
