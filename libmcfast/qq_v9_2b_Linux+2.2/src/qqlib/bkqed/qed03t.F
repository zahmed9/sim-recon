*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:34  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:28  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/00 04/06/90  18.55.48  by  Jorge L. Rodriguez
*-- Author :

      SUBROUTINE QED03T(Q)
      IMPLICIT DOUBLE PRECISION(A-H,K-Z)

      DIMENSION Q(4)
      COMMON / OUT11 / K,Z,ZM,ZP,SZ,FG,SFG,CFG
      COMMON / INV1 / EPLMN,PYPLMN,PZPLMN,BOOST1,BOOST2,BOOST3,IPLUS
      QX=Q(1)
      QY=Q(2)
      QZ=Q(3)
      QE=Q(4)
      IF(K.EQ.0.D0) GOTO 411
C
C first rotate such that if
C Q(1..4) were = (0,0,PPPLMN,EPLMN) then it would be rotated into
C                (0,PYPLMN,PZPLMN,EPLMN)
C
C any incoming angular distribution with respect to the 3-axis
C is changed into one w.r.to the E(+) [ or the E(-)] axis
C in the hadron C.O.M. system
C
      QQ=QY
      QY=PZPLMN*QQ+PYPLMN*QZ
      QZ=PZPLMN*QZ-PYPLMN*QQ
C
C now boost back from the hadron C.O.M. system to the lab system0
C
      QDOT=(QY*BOOST2+QZ*BOOST3)
      QEEE=BOOST1*QE+QDOT
      QDOT=QE+QDOT/(BOOST1+1.)
      QY=QY+BOOST2*QDOT
      QZ=QZ+BOOST3*QDOT
      QE=QEEE
C
C
C now rotate by fi around the lab-z-axis
C  (originally, 'K' in the Y/Z plane)
C
411   QQ=QY
      QY=QQ*CFG-QX*SFG
      QX=QQ*SFG+QX*CFG
C
C
      Q(1)=QX
      Q(2)=QY
      Q(3)=QZ
      Q(4)=QE
      RETURN
      END
