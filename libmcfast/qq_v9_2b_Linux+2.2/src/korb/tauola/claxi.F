*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:30  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:03  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/00 21/01/93  15.42.35  by  Alan Weinstein
*-- Author :
      SUBROUTINE CLAXI(HJ,PN,PIA)
C ----------------------------------------------------------------------
* CALCULATES THE "AXIAL TYPE"  PI-VECTOR  PIA
* NOTE THAT THE NEUTRINO MOM. PN IS ASSUMED TO BE ALONG Z-AXIS
C SIGN is chosen +/- for decay of TAU +/- respectively
C     called by : DAMPAA, CLNUT
C ----------------------------------------------------------------------
      COMMON / JAKI   /  JAK1,JAK2,JAKP,JAKM,KTOM
      COMMON / IDFC  / IDFF
      REAL PIA(4),PN(4)
      COMPLEX HJ(4),HJC(4)
C     DET2(I,J)=AIMAG(HJ(I)*HJC(J)-HJ(J)*HJC(I))
C -- here was an error (ZW, 21.11.1991)
      DET2(I,J)=AIMAG(HJC(I)*HJ(J)-HJC(J)*HJ(I))
C -- it was affecting sign of A_LR asymmetry in a1 decay.
C -- note also collision of notation of gamma_va as defined in
C -- TAUOLA paper and J.H. Kuhn and Santamaria Z. Phys C 48 (1990) 445
* -----------------------------------
      IF     (KTOM.EQ.1.OR.KTOM.EQ.-1) THEN
        SIGN= IDFF/ABS(IDFF)
      ELSEIF (KTOM.EQ.2) THEN
        SIGN=-IDFF/ABS(IDFF)
      ELSE
        PRINT *, 'STOP IN CLAXI: KTOM=',KTOM
        STOP
      ENDIF
C
      DO 10 I=1,4
 10   HJC(I)=CONJG(HJ(I))
      PIA(1)= -2.*PN(3)*DET2(2,4)+2.*PN(4)*DET2(2,3)
      PIA(2)= -2.*PN(4)*DET2(1,3)+2.*PN(3)*DET2(1,4)
      PIA(3)=  2.*PN(4)*DET2(1,2)
      PIA(4)=  2.*PN(3)*DET2(1,2)
C ALL FOUR INDICES ARE UP SO  PIA(3) AND PIA(4) HAVE SAME SIGN
      DO 20 I=1,4
  20  PIA(I)=PIA(I)*SIGN
      END
