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
      COMPLEX FUNCTION BWIGS(S,M,G)
C **********************************************************
C     P-WAVE BREIT-WIGNER  FOR K*
C **********************************************************
      REAL S,M,G
      REAL PI,PIM,QS,QM,W,GS,MK
      DATA INIT /0/
      P(A,B,C)=SQRT(ABS(ABS(((A+B-C)**2-4.*A*B)/4./A)
     $                    +(((A+B-C)**2-4.*A*B)/4./A))/2.0)
C ------------ PARAMETERS --------------------
      IF (INIT.EQ.0) THEN
      INIT=1
      PI=3.141592654
      PIM=.139
      MK=.493667
C -------  BREIT-WIGNER -----------------------
         ENDIF
         QS=P(S,PIM**2,MK**2)
         QM=P(M**2,PIM**2,MK**2)
         W=SQRT(S)
         GS=G*(M/W)*(QS/QM)**3
         BWIGS=M**2/CMPLX(M**2-S,-M*GS)
      RETURN
      END
