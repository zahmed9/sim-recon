*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:41  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:30  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.03/33 05/12/91  11.19.17  by  Peter C Kim
*-- Author :  Daniela Bortoletto 14/10/91
      DOUBLE PRECISION FUNCTION DCSKS2(Y)
C.......................................................................
C.
C. Calls     : XGAMKS
C. Called    : SEMIL2
C. Author    : Daniela Bortoletto 14/10/91
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'DCSKS2' )

      COMMON /MASDB/ XM,BM,X,YMAX,COST
      COMMON/SELE/IDECC,IDECAY

      INTEGER IDECC, IDECAY, K,J
      DOUBLE PRECISION XM,BM,X,YMAX,COST

      DOUBLE PRECISION Y,Q2,ELEPT

      DOUBLE PRECISION XGAMKS
      EXTERNAL XGAMKS

      DCSKS2=0.D0
C.. LOOP OVER DIFFERENT DECAYS(J)
      Q2=Y*BM**2
      ELEPT=X*BM
      IF(IDECC.GT.4)THEN
      DO 5 J=1,3
        IDECAY = J
C IDECAY =1,2,3 CORRESPONDS TO GAMMA U, L, P, 0
        DCSKS2 =DCSKS2 + XGAMKS(ELEPT,Q2)
  5   CONTINUE
      ELSE
      IDECAY=IDECC
        DCSKS2=DCSKS2 + XGAMKS(ELEPT,Q2)
      ENDIF
      RETURN
      END
