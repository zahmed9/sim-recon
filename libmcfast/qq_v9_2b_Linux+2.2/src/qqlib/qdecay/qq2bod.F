*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:42  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:30  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 22/09/94  00.16.54  by  Paul Avery
*CMZ :          18/03/94  14.09.25  by  Paul Avery
* 16/10/96 Lynn Garren:  Add double precision conditionals.
      SUBROUTINE QQ2BOD(KPRNT, TPRNT, T, CMAS, XMATRX, XM, PQ)

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C   Decay a particle into two daughters using correct angular
C   distribution.
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C     Calling arguments
      INTEGER KPRNT
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION TPRNT(4), T(4), CMAS, XMATRX(*), XM(2), PQ(4,2)
#else
      REAL TPRNT(4), T(4), CMAS, XMATRX(*), XM(2), PQ(4,2)
#endif

C     Local variables
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION TNEW(4)
#else
      REAL TNEW(4)
#endif
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C     If nonuniform angular distribution, use rest frame of parent to
C     define coordinate system. Do NOT use lab frame because that shifts
C     the direction of the quantization axis.
      IF((XMATRX(2).NE.0 .OR. XMATRX(3).NE.0 .OR.
     *    XMATRX(4).NE.0 .OR. XMATRX(5).NE.0 .OR.
     *    XMATRX(6).NE.0 .OR. XMATRX(7).NE.0) .AND. KPRNT.GT.0)THEN
#if defined(NONCLEO_DOUBLE)
        CALL DBOOSB(TPRNT,1,T,TNEW)
        CALL QQGEN2(TNEW, CMAS, XMATRX, XM, PQ)
        CALL DBOOSF(TPRNT,2,PQ,PQ)
#else
        CALL RBOOSB(TPRNT,1,T,TNEW)
        CALL QQGEN2(TNEW, CMAS, XMATRX, XM, PQ)
        CALL RBOOSF(TPRNT,2,PQ,PQ)
#endif

      ELSE
        CALL QQGEN2(T, CMAS, XMATRX, XM, PQ)
      ENDIF

      RETURN
      END
