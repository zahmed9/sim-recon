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
*CMZ :  1.00/00 14/06/90  14.26.27  by  Paul Avery
*CMZ :          19/05/90  14.51.03  by  Jorge L. Rodriguez
*>> Author :
      INTEGER FUNCTION KPART(KI1,ISPIN1)
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
#include "qqlib/seq/mcjet.inc"
#include "qqlib/seq/mcgen.inc"

C-- Local variables
      INTEGER KI1, ISPIN1
      INTEGER KIM1, ISPIN, KM, ICL
      REAL    TMIX
*
C-- External declarations
      INTEGER ISEED
      REAL     RANP
      EXTERNAL RANP
*
      COMMON/RANDM/ISEED

C  RENUMBER MESON FLAVOURS, ADD SPIN AND MIX DIAGONAL MESON FLAVOURS
C   CHOOSE SPIN DEPENDING ON QQ COMBINATION
C   UU,UD,DD          CLASS 1
C   US,DS             CLASS 2
C   UC,DC,SC          CLASS 3
C   UB,DB,SB,CB       CLASS 4
C   UT,DT,ST,CT,BT    CLASS 5
C   SS                CLASS 6
C   CC                CLASS 7
C   BB                CLASS 8
C   TT                CLASS 9
C ---------------------------------------------------------------------------
      KIM1=MESO(KI1)
      ISPIN=1-INT(PSPIN(ICLASS(KIM1))+RANP(ISEED))
      KPART=20+40*ISPIN+KIM1
      IF(KIM1.LT.31.OR.KIM1.GT.33)RETURN
      TMIX=RANP(ISEED)
      KM=KIM1-30+3*ISPIN

C   FOR UU,DD,SS COMBS, DECIDE BETWEEN VARIOUS SU(3) POSSIBILITIES
C   UU,DD,SS (SPIN 0)    PI0, ETA, OR ETAP
C   UU,DD,SS (SPIN 1)    RHO, OMEGA, OR PHI
C   CMIX1 CONTAINS CUMULATIVE PROBABILITIES FOR EACH QQ COMB

      ICL=0
      IF(TMIX.GT.CMIX1(1,KM))ICL=1
      IF(TMIX.GT.CMIX1(2,KM))ICL=2
      KPART=51+40*ISPIN+ICL

      RETURN
      END
