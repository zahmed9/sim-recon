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
*CMZ :  1.03/15 04/03/91  09.25.42  by  R.A.FULTON
*-- Author :
      FUNCTION EPA1TG(EB1, EB2, W, O1, O2, T)
C**********************************************
C SINGLE TAGGED EQUIVALENT PHOTON LUMINOSITY.
C O1 IS THE PHOTON EMITTED FROM THE TAGGED ELECTRON.
C**********************************************
      REAL       EPA1TG

      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'EPA1TG' )

#include "qqlib/gggseq/ggconst.inc"
#include "qqlib/gggseq/ggprms.inc"
#include "qqlib/gggseq/ggmodl.inc"
#include "qqlib/gggseq/sintag.inc"
#include "qqlib/gggseq/fragmt.inc"

C LOCALS:
        REAL   EB1, EB2, W, O1, O2, T
        REAL   E, X, X1, X2, QQ1, QQ2, WW, RK

        REAL      WGTMOD
        EXTERNAL  WGTMOD

      EPA1TG = 0.0
      X1     = O1/EB1
      X2     = O2/EB2

C        BE SURE TO SET FOR RESONANCE HELICITY 1 !
      IF(MODE2G.EQ.3.AND.LHRS2G.EQ.1)THEN
C                SPECIAL HELICITY ONE LUMINOSITY
C        NORMALIZED Q**2 OF TAGGED PHOTON
         QQ1=0.5*(1.-X1)*(1.-COS(T))
         WW=W/(EB1+EB2)**2

C        FORMULA FROM J.FIELD OR EQTN (28) FROM BONNEAU NUCL.PHYS.B54,573.
         RK=WW+QQ1
         E=ALOG(2.*EB2*(1.-X2)*SIN(ANGUNT/2.)/(X2*XME))
         E=E*((RK-2.*(X1+QQ1))**2/RK+RK)-2.*RK*(1.-X2)/X2**2
     +          +RK*(XME/EB2)**2/((1.-X2)*SIN(ANGUNT/2.)**2*2.)
         E=E*((RK-2.*X2)**2/RK-RK)/(1.+QQ1/WW)
         E=E/(2.*(1.+COS(T)))

C        FLUX FACTOR OF VIRTUAL PHOTONS =1/(1+QQ1/WW)
C        QED SUPRESSION FACTOR
         EPA1TG=E*WGTMOD(EB1,EB2,W,O1,O2)

      ELSE
C        NORMALIZED Q**2 OF TAGGED PHOTON
         QQ1=(1.-X1)*(SIN(T/2.))**2 + (XME*X1/(2.*EB1*(1.-X1)))**2
         QQ2=(1.-X2)*(SIN(T2/2.))**2 + (XME*X2/(2.*EB2*(1.-X2)))**2
         WW=W/(EB1+EB2)**2
         X     = QQ1/(WW + QQ1 + QQ2)
         IF(X .LT. XSMIN .OR. X .GT. XSMAX)RETURN

C        FORMULA FROM J.FIELD OR EQTN (28) FROM BONNEAU NUCL.PHYS.B54,573.
         RK = WW + QQ1
         E=ALOG(2.*EB2*(1.-X2)*SIN(ANGUNT/2.)/(X2*XME))
         E=E*((RK-2.*(X1+QQ1))**2/RK+RK)-2.*RK*(1.-X2)/X2**2
     +              +RK*(XME/EB2)**2/((1.-X2)*SIN(ANGUNT/2.)**2*2.)
         EPS1=(RK-2.*X2)**2/RK+RK*(1.-(XME/EB1)**2/QQ1)
         WGTCOR = 1./(1.+QQ1/WW)
         E=E*EPS1
         E=E/(2.*(1.+COS(T)))

C        RATIO TRANSVERSE-LONGITUDINAL/TRANSVERSE-TRANSVERSE LUMINOSITIES.
         EPS1=((RK-2.*X2)**2/RK-RK)/EPS1
         EPA1TG=E*WGTMOD(EB1,EB2,W,O1,O2)

C*************************************************************************
C                 NEW SECTION TO GET POLARIZATION RATIOS
         RK = WW + QQ1 + QQ2

C        FORMULA (9) FROM J.FIELD OR EQT'N (28) FROM BONNEAU ET.AL.
         EPS2 = 0.0
         EPS3 = 0.0

      ENDIF
      RETURN
      END
