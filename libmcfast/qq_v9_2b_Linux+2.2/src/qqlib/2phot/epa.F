*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:33  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:35  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.03/15 04/12/90  12.54.06  by  R.A.FULTON
*-- Author :
      FUNCTION EPA(EB1,EB2,W,O1,O2)
C************************************************
C FACTORIZED EPA LUMINOSITY  (DALITZ-YENNIE FORMULA)
C************************************************
       REAL    EPA

#include "qqlib/gggseq/ggconst.inc"
       REAL    EPA1, EPA2, WGTCOR

       REAL    EB1, EB2, W, O1, O2
       REAL    X1, X2, EX, A1, A2, A3

        REAL       WGTMOD
        EXTERNAL    WGTMOD
C*************************************************

      X1 = O1/EB1
      EX=1.0-X1
      A1=ALOG(EB1/XME)-0.5
      A1=(1.0+EX**2)*A1
      A2=ALOG(2.0*EX/X1)+1.0
      A2=0.5*(X1**2)*A2
      A3=ALOG(2.0*EX/(1.0+EX))
      A3=0.5*((1.0+EX)**2)*A3
      EPA1=A1+A2+A3

      X2 = O2/EB2
      EX=1.0-X2
      A1=ALOG(EB2/XME)-0.5
      A1=(1.0+EX**2)*A1
      A2=ALOG(2.0*EX/X2)+1.0
      A2=0.5*(X2**2)*A2
      A3=ALOG(2.0*EX/(1.0+EX))
      A3=0.5*((1.0+EX)**2)*A3
      EPA2=A1+A2+A3

      EPA = EPA1*EPA2
      WGTCOR = 1.0
      EPA = EPA*WGTMOD(EB1,EB2,W,O1,O2)

      RETURN
      END
