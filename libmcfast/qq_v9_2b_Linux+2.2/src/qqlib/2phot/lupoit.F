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
*CMZ :  1.03/76 15/08/94  23.12.20  by  Peter C Kim
*CMZ :  1.03/15 25/04/91  18.09.49  by  R.A.FULTON
*-- Author :

      SUBROUTINE LUPOIT
C
C...Loads scattered electrons and particle pair produced by gamma-gamma
C   into LUND common blocks.
#include "qqlib/gggseq/ggmodl.inc"
#include "geant/gcdes/lujets.inc"
#include "geant/gcdes/ludat1.inc"
#include "qqlib/seq/ludat2.inc"
#include "qqlib/gggseq/genarg.inc"
C.................LOCALS
      INTEGER   J2, KF, NC, KCRES, NZ
      REAL      BETA(3), ECMC, EPNT, PHI2, PHIGZ, PXY
      REAL      TH2, THEGZ, PGG(4)

C..EXTERNAL::
      INTEGER   LUCOMP
      REAL      ULANGL, ULMASS
      EXTERNAL  LUCOMP, ULANGL, ULMASS

      KCRES = LUCOMP(KFRES)

      NC = 0

C     scattered electron stored, for possible further interactions
      DO 14 J2 = 1,2
        NC = NC + 1
        K(NC, 1)  = 1
  14  P(NC, 5)    = ULMASS(11)

      DO 15 J2 = 1,4
        P(NC-1, J2) = E14V(J2)
  15  P(NC, J2)   = E24V(J2)
      K(NC-1, 2)  = -11*IC1
      K(NC, 2)    = -11*IC2

      DO 17 J2 = 1,4
  17  PGG(J2) = G14V(J2) + G24V(J2)

C.    calculate invariant gg mass
      ECMC = PGG(4)**2 - (PGG(1)**2 + PGG(2)**2 + PGG(3)**2)
      IF(ECMC .LT. 0.)ECMC = 0.
      ECMC = SQRT(ECMC)

C     Each final-state particle takes half of GG invariant mass
      EPNT = 0.5*ECMC

C.    calculate boost vector beta
      DO 121 J2 = 1,3
        BETA(J2) = PGG(J2)/PGG(4)
 121  CONTINUE

C.    calculate rotation angle from gg system to cms system
      MSTU(1) = NC - 1
      N       = MSTU(1)
      CALL LUROBO(0.,0.,-BETA(1),-BETA(2),-BETA(3))
      PHIGZ  = ULANGL(P(N,1),P(N,2))
      PXY    = SQRT(P(N,1)**2 + P(N,2)**2)
      THEGZ  = ULANGL(P(N,3), PXY)
      CALL LUROBO(0.,0.,BETA(1),BETA(2),BETA(3))

C.    outgoing point particles, store as generated in gg cm system
      KF = KFRES
      TH2 = PARU(1) - THPNT
      PHI2 = PHIPNT + PARU(1)
      IF(PHI2 .GT. PARU(2))PHI2 = PHI2 - PARU(2)
      MSTU(10) = 1

      NC = NC + 1
      P(NC,5) = PMAS(KCRES, 1)
      CALL LU1ENT(NC, KF, EPNT, THPNT, PHIPNT)
      NC = NC + 1
      P(NC,5) = PMAS(KCRES, 1)
      CALL LU1ENT(NC, -KF, EPNT, TH2, PHI2)

      K(NC - 1, 1) = NC - 2
      K(NC, 1)     = NC - 2
      K(NC - 1, 2) = KF
      K(NC, 2)     = -KF
      MSTU(10)     = 2
C
C        set actions to affect only last two entries
C
      MSTU(1) = NC - 1
      CALL LUROBO(THEGZ,PHIGZ,BETA(1),BETA(2),BETA(3))
      MSTU(1) = 0

      RETURN
      END
