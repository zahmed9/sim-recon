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
*CMZ :  1.03/15 04/12/90  12.57.01  by  R.A.FULTON
*-- Author :
      FUNCTION EPA2TG(EB1,EB2,W,O1,O2,FI12)
C**********************************************
C DOUBLE TAGGED EPA LUMINOSITY
C**********************************************

      REAL  EPA2TG

#include "qqlib/gggseq/ggconst.inc"

C INTERNAL PARAMETERS FOR TWO-PHOTON GENERATOR GGDEPA.
#include "qqlib/gggseq/ggprms.inc"
#include "qqlib/gggseq/sintag.inc"


      REAL     EB1, EB2, W, O1, O2, FI12
      REAL     X1, X2, WW, RK, TSI
      REAL     E, EA, EB, EC, ED
      REAL     CT1, CT2, AT1, AT2, AC12, QQ1, QQ2
      REAL     COR1, COR2, C12

      REAL     WGTMOD
      EXTERNAL WGTMOD

      EPA2TG = 0.0

C**********************************************
      X1=O1/EB1
      X2=O2/EB2
      CT1=COS(T1)
      CT2=COS(T2)
      AT1 = SIN(T1/2.)**2
      AT2 = SIN(T2/2.)**2
      C12=SIN(T1)*SIN(T2)*COS(FI12)-CT1*CT2
      AC12=(1.-C12)/2.
C NORMALIZED Q**2 OF PHOTONS
      QQ1 = (1.-X1)*AT1 + (XME*X1/(2.*EB1))**2/(1.-X1)
      QQ2 = (1.-X2)*AT2 + (XME*X2/(2.*EB2))**2/(1.-X2)
      WW=W/(EB1+EB2)**2
      RK=WW+QQ1+QQ2
C     X     = QQ1/(RK - 4.*QQ1*QQ2/RK)
C FORMULA (9) FROM J.FIELD OR EQT'N (28) FROM BONNEAU ET.AL.
      TSI=SQRT(RK**2-4.*QQ1*QQ2)
      EA=(RK-2.*(X2+QQ2))**2/TSI+TSI*(1.-(XME**2/(QQ1*EB1**2)))
      EB=(RK-2.*(X1+QQ1))**2/TSI+TSI*(1.-(XME**2/(QQ2*EB2**2)))
      EC=(RK-2.*(X2+QQ2))**2/TSI-TSI
      ED=(RK-2.*(X1+QQ1))**2/TSI-TSI
      IF(QQ1.LE.1.0E-6)EC = 0.0
      IF(QQ2.LE.1.0E-6)ED = 0.0
      EPS1 = EC/EA
      EPS2 = ED/EB
      EPS3 = (EC*ED)/(EA*EB)
      WGTCOR = (1.+(QQ1+QQ2)/WW)*SQRT(1.-4.*QQ1*QQ2/RK**2)
      WGTCOR = 1.0/WGTCOR
C
      COR1 = (AT1 + DTCNST)/(AT1 + (XME*X1/(2.*EB1*(1.-X1)))**2 )
      COR2 = (AT2 + DTCNST)/(AT2 + (XME*X2/(2.*EB2*(1.-X2)))**2 )
      E = EA*EB*COR1*COR2/(4.*AC12)
      EPA2TG = E*WGTMOD(EB1,EB2,W,O1,O2)
      RETURN
      END
