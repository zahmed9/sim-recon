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
*CMZ :  2.00/00 21/01/93  15.42.13  by  Alan Weinstein
*-- Author :
      SUBROUTINE SETCUP(IDF,SIN2,QC,CV,CA)
C     ************************************
C SETCUP CALCULATES CV,CA WHICH CORRESPOND TO A GIVEN VALUE
C OF TEH WEINBERG ANGLE.
C NOTE THAT SIGN OF AXIAL COUPL CONST. MAY BE DIFFERENT FROM CHOICES IN
C THE LITERATURE. IT IS OPPOSITE TO THAT IN CERN BOOKLET.
C IDF IS QUARK OR LEPTON IDENTIFIER, QC ITS CHARGE  (S.J.)
      IMPLICIT REAL*8(A-H,O-Z)
      B=1./SQRT(16.*SIN2*(1.-SIN2))
      IDFERM=IABS(IDF)
      GO TO (1,2,3,4), IDFERM
C     NOT USED  ( NEUTRINO )
    1 QC=0.
      CV=B
      CA=B
      GO TO 500
C     ELECTRON, MUON ...
    2 QC=-1.
      CV=(-1.+4.*SIN2)*B
      CA=-B
      GO TO 500
C     UP QUARKS
    3 QC=2./3.
      CV=(1.-8./3.*SIN2)*B
      CA=B
      GO TO 500
C     DOWN QUARKS
    4 QC=-1./3.
      CV=(-1.+4./3.*SIN2)*B
      CA=-B
  500 IF(IDF.GT.0) RETURN
C     ANTIPARTICLES
      QC=-QC
      CV=-CV
      CA=+CA
      RETURN
      END
