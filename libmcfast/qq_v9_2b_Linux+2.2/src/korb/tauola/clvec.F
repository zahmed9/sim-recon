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
*CMZ :  2.00/00 21/01/93  15.42.34  by  Alan Weinstein
*-- Author :
      SUBROUTINE CLVEC(HJ,PN,PIV)
C ----------------------------------------------------------------------
* CALCULATES THE "VECTOR TYPE"  PI-VECTOR  PIV
* NOTE THAT THE NEUTRINO MOM. PN IS ASSUMED TO BE ALONG Z-AXIS
C
C     called by : DAMPAA
C ----------------------------------------------------------------------
      REAL PIV(4),PN(4)
      COMPLEX HJ(4),HN
C
      HN= HJ(4)*CMPLX(PN(4))-HJ(3)*CMPLX(PN(3))
      HH= REAL(HJ(4)*CONJG(HJ(4))-HJ(3)*CONJG(HJ(3))
     $        -HJ(2)*CONJG(HJ(2))-HJ(1)*CONJG(HJ(1)))
      DO 10 I=1,4
   10 PIV(I)=4.*REAL(HN*CONJG(HJ(I)))-2.*HH*PN(I)
      RETURN
      END
