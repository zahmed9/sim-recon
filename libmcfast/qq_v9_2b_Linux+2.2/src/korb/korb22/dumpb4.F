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
      SUBROUTINE DUMPB4
C     ****************
C PRINTS FINAL STATE TAU AND PHOTON   MOMENTA
C CALLED OPTIONALY BY THE USER
      COMMON / UTIL4  / QP(4),QM(4),PH(4)
      COMMON / INOUT / NINP,NOUT
      DIMENSION SUM(4)
      DATA ICONT/0/
      ICONT=ICONT+1
      DO 30 I=1,4
  30  SUM(I)=QP(I)+QM(I)+PH(I)
      WRITE(NOUT,1100) ICONT
      AQP=     QP(4)**2-QP(3)**2-QP(2)**2-QP(1)**2
      AQM=     QM(4)**2-QM(3)**2-QM(2)**2-QM(1)**2
      APH=     PH(4)**2-PH(3)**2-PH(2)**2-PH(1)**2
      IF(AQP.GT.0.) AQP=SQRT(AQP)
      IF(AQM.GT.0.) AQM=SQRT(AQM)
      WRITE(NOUT,1501) (QP(I),I=1,4),AQP
      WRITE(NOUT,1502) (QM(I),I=1,4),AQM
      WRITE(NOUT,1503) (PH(I),I=1,4),APH
      WRITE(NOUT,1600) ( SUM(I),I=1,4)
 1100 FORMAT(///20X,'MOMENTA FROM KORAL,     EVENT NO.  ',I5/
     &40X,'  P(1)',7X,'  P(2)',7X,'  P(3)',7X,'  P(4)',7X,'  MASS')
 1501 FORMAT(20X,'QP  ',9X,5(1X,F12.5))
 1502 FORMAT(20X,'QM  ',9X,5(1X,F12.5))
 1503 FORMAT(20X,'PH  ',9X,5(1X,F12.5))
 1600 FORMAT(20X,'SUM ',9X,5(1X,F12.5),/)
      RETURN
      END
