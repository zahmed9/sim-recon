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
*CMZ :  1.03/66 28/06/93  17.34.34  by  Peter C Kim
*CMZ :  1.03/34 05/12/91  12.42.31  by  Peter C Kim
*CMZ :  1.03/33 05/12/91  12.00.05  by  Peter C Kim
*-- Author :    Daniela Bortoletto  14/10/91
      DOUBLE PRECISION FUNCTION DCSWSB(Y)
C.......................................................................
C
C  modification for Wirbel  Stech and Bauer model ( D. Bortoletto)
C
C. Calls     : XGAMWS
C. Called    : SEMIL3
C. Author    : Daniela Bortoletto  14/10/91
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'DCSWSB' )

      COMMON /MASDB/ XM,BM,X,YMAX,COST
      COMMON/SELE3/IDECC,IDECAY,ICHAN

      INTEGER IDECC,IDECAY,ICHAN
      INTEGER K,J
      DOUBLE PRECISION Y,Q2,BM,XM,X,YMAX,COST,ELEPT

      DOUBLE PRECISION XGAMWS
      EXTERNAL XGAMWS

      DCSWSB=0.D0
C.. LOOP OVER DIFFERENT DECAYS(J)
      Q2=Y*BM**2
      ELEPT=X*BM
      IF(IDECC.GT.4)THEN
      DO 5 J=1,3
        IDECAY = J
C IDECAY =1,2,3 CORRESPONDS TO GAMMA U, L, P, 0
        DCSWSB =DCSWSB + XGAMWS(ELEPT,Q2)
  5   CONTINUE
      ELSE
      IDECAY=IDECC
        DCSWSB =DCSWSB + XGAMWS(ELEPT,Q2)
      ENDIF

C        DCSWSB =DCSWSB + XGAMWS(ELEPT,Q2)
      RETURN
      END
