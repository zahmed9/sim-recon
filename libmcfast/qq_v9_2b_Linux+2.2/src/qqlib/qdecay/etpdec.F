*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:41  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:29  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.03/16 23/07/91  02.51.07  by  Peter C Kim
*-- Author :    Peter C Kim   23/07/91
* 16/10/96 Lynn Garren: Add double precision conditionals.
      SUBROUTINE ETPDEC(NP,NQ,KID,XM,KQ,ID,CMAS,T,IT,ND,PQ,MATRX,IER)
C.......................................................................
C.
C. ETPDEC - Decay of eta' --> rho gamma with proper matrix element
C.
C. Calls     : PHSP
C. Called    : DECAY
C. Author    : Peter C Kim  23/07/91  02.44.38
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

*- Argument declarations
      INTEGER KID(30),KQ(2,5)
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION    T(4),XM(30),PQ(4,30)
      INTEGER NP, NQ, ID, IT, ND, MATRX, IER
      DOUBLE PRECISION    CMAS
#else
      REAL    T(4),XM(30),PQ(4,30)
      INTEGER NP, NQ, ID, IT, ND, MATRX, IER
      REAL    CMAS
#endif
*
*- Local declarations
*
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'ETPDEC' )

C  Local Variables

      INTEGER I, J
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION XMT1(2),XMT2(2),PT1(4,2),PT2(4,2)
      DOUBLE PRECISION PTMRHO(4),PGAM(4),PPI1(4),PPI2(4),P2PI(4)
      DOUBLE PRECISION PGAMR(4),PPIR(4)
      DOUBLE PRECISION RHOMX,RHOMN,RMDIFF,TMRHO
      DOUBLE PRECISION MRHO,MRHO2,WRHO,WRHO2,M2PISQ,PMPI,PMPI2
      DOUBLE PRECISION WIDTH,WEIGHT,WMAX
      DOUBLE PRECISION PPI0,PPI02,RANDM
#else
      REAL XMT1(2),XMT2(2),PT1(4,2),PT2(4,2)
      REAL PTMRHO(4),PGAM(4),PPI1(4),PPI2(4),P2PI(4)
      REAL PGAMR(4),PPIR(4)
      REAL RHOMX,RHOMN,RMDIFF,TMRHO
      REAL MRHO,MRHO2,WRHO,WRHO2,M2PISQ,PMPI,PMPI2,WIDTH,WEIGHT,WMAX
      REAL PPI0,PPI02,RANDM
#endif

      REAL  RANP
      EXTERNAL RANP
*
C--- Do we have an eta' ?

      IER = 1
      IF (ID .NE. 53)  RETURN

C---  3-body phase space  :  eta' --> gamma pi+ pi-

      XMT1(1) = 0.0

      XMT2(1) = 0.1396
      XMT2(2) = 0.1396

      WMAX = 0.313
      MRHO = 0.7683
      WRHO = 0.149
      PPI0 = 0.358
      MRHO2 = MRHO*MRHO
      WRHO2 = WRHO*WRHO
      PPI02 = PPI0*PPI0

      RHOMX = 0.957
      RHOMN = 0.2792
      RMDIFF = RHOMX - RHOMN

 1    CONTINUE

      TMRHO = RHOMN + RANP(0)*RMDIFF
      XMT1(2) = TMRHO

      CALL PHSP(T,CMAS,0,2,XMT1,PT1)

      DO 10 I=1,4
        PGAM(I)   = PT1(I,1)
        PTMRHO(I) = PT1(I,2)
 10   CONTINUE

      CALL PHSP(PTMRHO,TMRHO,0,2,XMT2,PT2)

      DO 11 I=1,4
        PPI1(I) = PT2(I,1)
        PPI2(I) = PT2(I,2)
        P2PI(I) = PT2(I,1) + PT2(I,2)
 11   CONTINUE

      M2PISQ = P2PI(4)*P2PI(4)
     *         - P2PI(1)*P2PI(1) - P2PI(2)*P2PI(2) - P2PI(3)*P2PI(3)

#if defined(NONCLEO_DOUBLE)
      CALL DLOREN4(P2PI,PGAM,PGAMR)
      CALL DLOREN4(P2PI,PPI1,PPIR)
#else
      CALL LOREN4(P2PI,PGAM,PGAMR)
      CALL LOREN4(P2PI,PPI1,PPIR)
#endif

      PMPI2 = PPIR(1)*PPIR(1)+PPIR(2)*PPIR(2)+PPIR(3)*PPIR(3)
      PMPI = SQRT(PMPI2)

      WIDTH = WRHO*2.0*PMPI*PMPI2/PPI0/(PMPI2+PPI02)
      WEIGHT = PMPI2*PGAMR(4)**2*M2PISQ
     *         / ( (MRHO2 - M2PISQ)**2 + MRHO2*WIDTH*WIDTH )


      WEIGHT = WEIGHT / WMAX

      RANDM = RANP(0)
      IF(RANDM.GT.WEIGHT) GOTO 1

      DO 20 I=1,4
        PQ(I,1) = PGAM(I)
        PQ(I,2) = P2PI(I)
 20   CONTINUE


C--- Save the selected RHO mass.  Angular dist. of the RHO decay is
C    handled via HELICITY card in DECAY.DEC.

      XM(2) = SQRT(M2PISQ)

      IER = 0
      RETURN
      END
