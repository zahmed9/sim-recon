*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:27  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:01  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/00 21/01/93  15.41.59  by  Alan Weinstein
*-- Author :
      SUBROUTINE BTOHEP
C ----------------------------------------------------------------------
C
C Koral-B to HEPEVT
C
C this routine fills the HEPEVT common block
C with event kinematics from Koral-B:
C *  initial beam particles (positions 1,2)
C *  primary fermions of final state (3,4)
C *  radiative photon (5)
C
C WRITTEN BY MARTIN W. GRUENEWALD AND Z. WAS (91/02/02)
C
C called by KORAL-B
C
C ----------------------------------------------------------------------
C
      COMMON / UTIL4 / QP(4),QM(4),PH(4)
      COMMON / BEAMS / XPB1(4),XPB2(4),KFB1,KFB2
      COMMON / IDFC  / IDFF
      COMMON /TAUPOS / NPA,NPB
C
      AMEL=0.511E-3
      AM=AMEL
C
C --- Position of first and second tau in LUND common
      NPA=3
      NPB=4
C initial state (1,2)
      CALL FILHEP(1,3,KFB1,0,0,0,0,XPB1,AM,.FALSE.)
      CALL FILHEP(2,3,KFB2,0,0,0,0,XPB2,AM,.FALSE.)
C
C primary final state fermions (3,4)
      AM=QP(4)**2-QP(1)**2-QP(2)**2-QP(3)**2
      IF(AM.LT.0.0) THEN
C
C only due to rounding errors
        AM=0.0
      ELSE
        AM=SQRT(AM)
      ENDIF
      CALL FILHEP(3,1, IDFF,1,2,0,0,QP,AM,.FALSE.)
      CALL FILHEP(4,1,-IDFF,1,2,0,0,QM,AM,.FALSE.)
C
C radiative photon (5) (PDG-code for gamma is 22)
      IF (PH(4).GT.0.0) CALL FILHEP(5,1,22,1,2,0,0,PH,0.0,.true.)
C
      RETURN
      END
