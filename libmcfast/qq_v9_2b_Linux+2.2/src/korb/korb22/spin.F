*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:28  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:02  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/00 21/01/93  15.42.12  by  Alan Weinstein
*-- Author :
      SUBROUTINE SPIN(V,E,F)
C     **********************
      IMPLICIT REAL*8(A-H,O-Z)
      COMPLEX*16 V(4,4)
      DIMENSION E(4),F(4)
      DATA ZER/0./
C
      V(1,1)=DCMPLX( E(4)*F(4) -E(1)*F(1) +E(2)*F(2) +E(3)*F(3),  ZER)
      V(2,2)=DCMPLX( E(4)*F(4) +E(1)*F(1) -E(2)*F(2) +E(3)*F(3),  ZER)
      V(3,3)=DCMPLX( E(4)*F(4) -E(1)*F(1) -E(2)*F(2) -E(3)*F(3),  ZER)
      V(4,4)=DCMPLX( E(4)*F(4) +E(1)*F(1) +E(2)*F(2) -E(3)*F(3),  ZER)
      V(1,2)=DCMPLX( E(3)*F(4) +E(4)*F(3), E(1)*F(2) +E(2)*F(1))
      V(3,4)=DCMPLX( E(3)*F(4) -E(4)*F(3),-E(1)*F(2) +E(2)*F(1))
      V(1,3)=DCMPLX( E(4)*F(1) -E(1)*F(4),-E(2)*F(3) +E(3)*F(2))
      V(2,4)=DCMPLX( E(4)*F(1) +E(1)*F(4), E(2)*F(3) +E(3)*F(2))
      V(1,4)=DCMPLX( E(3)*F(1) +E(1)*F(3), E(4)*F(2) +E(2)*F(4))
      V(2,3)=DCMPLX( E(3)*F(1) -E(1)*F(3), E(4)*F(2) -E(2)*F(4))
      V(2,1)=DCONJG(V(1,2))
      V(4,3)=DCONJG(V(3,4))
      V(3,1)=DCONJG(V(1,3))
      V(4,1)=DCONJG(V(1,4))
      V(4,2)=DCONJG(V(2,4))
      V(3,2)=DCONJG(V(2,3))
      RETURN
      END
