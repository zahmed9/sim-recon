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
*CMZ :  1.03/76 15/08/94  23.10.23  by  Peter C Kim
*CMZ :  1.03/15 05/06/91  01.34.20  by  R.A.FULTON
*-- Author :
      SUBROUTINE GGGEN3
C...Loads scattered electrons and resonance produced by gamma-gamma
C   into LUND common blocks.
#include "qqlib/gggseq/ggmodl.inc"
#include "geant/gcdes/lujets.inc"
#include "geant/gcdes/ludat1.inc"
#include "qqlib/gggseq/genarg.inc"
C.................LOCALS
       INTEGER   J2, KF, NC, KCRES, NTRY, NZ
       REAL      BETA(3), ECMC
       REAL      THEGZ, PGG(4)

C..EXTERNAL::
       REAL      ULMASS, ULANGL
       EXTERNAL  ULMASS, ULANGL

C.    Reset lund particle counters
      NC  = 0

C     scattered electron stored, for possible further interactions
      DO 14 J2=1,2
        NC = NC + 1
        K(NC,1)  =  1
  14  P(NC,5)    =  ULMASS(11)

      DO 15 J2=1,4
        P(NC - 1,J2)  = E14V(J2)
  15  P(NC,J2)    = E24V(J2)
      K(NC-1,2)   = -11*IC1
      K(NC,2)     = -11*IC2

C     scattered electrons theta and phi

      DO 17 J2=1,4
  17  PGG(J2)    = G14V(J2) + G24V(J2)

C     calculate invariant gg mass
      ECMC = PGG(4)**2 - ( PGG(1)**2 + PGG(2)**2 + PGG(3)**2 )
      IF(ECMC .LT. 0.)ECMC=0.
      ECMC = SQRT(ECMC)
C
C     produced resonance
C
         NC = NC + 1
         KF = KFRES
C
C        keep mass value stored in P(NC,5)
C
         MSTU(10) = 1
         P(NC,5)  = ECMC
         CALL LU1ENT(NC, KF, ECMC, 0., 0.)
C
C        enter as an undecayed particle
C
         K(NC,1)  = 1
C
C        parent = GOD
C
         K(NC,3)  = 0
C
C        use mass in table as usual
C
         MSTU(10) = 2
C
C        boost to cms system
C        calculate boost vector beta
C
         DO 121 J2 = 1,3
           BETA(J2) = PGG(J2)/PGG(4)
 121     CONTINUE
C
C        set actions to affect only last entry
C
         MSTU(1)  =  NC
         CALL LUROBO(0.,0.,BETA(1),BETA(2),BETA(3))
C
C        set actions affect all listed particles
C
         MSTU(1)  = 0

      RETURN
      END
