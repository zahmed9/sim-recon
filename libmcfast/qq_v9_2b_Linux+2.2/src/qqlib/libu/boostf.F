*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:38  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:27  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.02/00 14/03/91  17.18.38  by  Peter C Kim
*-- Author :    Peter C Kim   14/03/91
* 16/10/96 Lynn Garren: Add double precision conditionals.
        SUBROUTINE BOOSTF(T,N,PO,PN)

C  ------------------------------------------------------------------
C   Routine to boost N 4-vectors PO(4,1-N) to PN(4,1-N) using
C   the 4-vextor T to define the direction and magnitude of boost, i.e.
C   boost is done assuming T must be boosted from rest to its current value
C   Note: mass of T must be > 0
C
C   copied from old AVELIB.FOR   (used in SEMIL1)
C
C  ------------------------------------------------------------------

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

        INTEGER N
#if defined(NONCLEO_DOUBLE)
        DOUBLE PRECISION T(4),PO(4,*),PN(4,*),ETA(4)
        DOUBLE PRECISION M,G,TEMP,EDOTP
#else
        REAL T(4),PO(4,*),PN(4,*),ETA(4)
        REAL M,G,TEMP,EDOTP
#endif
        INTEGER L,J

        IF(N.LE.0)RETURN

        M=SQRT(T(4)**2-T(2)**2-T(3)**2-T(1)**2)
        DO 5 L=1,4
  5     ETA(L)=T(L)/M
        G=ETA(4)+1
        DO 20 J=1,N
        EDOTP=ETA(1)*PO(1,J)+ETA(2)*PO(2,J)+ETA(3)*PO(3,J)+
     *  ETA(4)*PO(4,J)
        TEMP=(EDOTP+PO(4,J))/G
        PN(4,J)=EDOTP
        DO 10 L=1,3
 10     PN(L,J)=PO(L,J)+ETA(L)*TEMP
 20     CONTINUE
        RETURN
        END
