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
*CMZ :  1.03/69 14/09/93  14.28.58  by  Peter C Kim
*CMZ :  1.00/01 06/09/90  11.42.14  by  Paul Avery
*CMZ :  1.00/00 14/06/90  14.26.28  by  Paul Avery
*CMZ :          19/05/90  14.51.03  by  Jorge L. Rodriguez
*>> Author :
* 16/10/96 Lynn Garren: Add double precision conditionals.
      SUBROUTINE ETADLZ(PETA,PDAUTS,MATRX)
C.......................................................................
C.
C. ETADLZ -
C.
C. Inputs    : PETA MATRX
C. Outputs   : PDAUTS
C.
C. Calls     : PHSP RBOOSB
C. Called    : ETADEC
C.
C For an eta with lab momentum PETA, return the lab momenta PDAUTS
C   for the daughters after doing the proper Dalitz decay
C   PDAUTS as follows: daughters 1,2,3 = pi+pi-pi0 (MATRX=17)
C                                      = pi+pi-gamma (MATRX=18)
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

*- Argument declarations
      INTEGER MATRX
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION    PETA(4), PDAUTS(4,3)
#else
      REAL    PETA(4), PDAUTS(4,3)
#endif
*
*- Commons
      INTEGER ISEED
      COMMON/RANDM/ISEED
C     COMMON//HLIM(50000)
*
*- Local declarations
*
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'ETADEC' )

#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION       XMSETA, XMSPI0, XMSPIC, XMRHO2
#else
      REAL       XMSETA, XMSPI0, XMSPIC, XMRHO2
#endif
      PARAMETER (XMSETA=.54745 )
      PARAMETER (XMSPI0=.13497 )
      PARAMETER (XMSPIC=.13957 )
CX      PARAMETER (XMRHO2=.5929)
      PARAMETER (XMRHO2=.5900)

C-- We will do decay ourselves
      INTEGER    MXPHSP
      PARAMETER (MXPHSP=0)
*
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION XMDAUS(3), PDAUT1(4,3)
      DOUBLE PRECISION QETA, FNORM, T1, T2, T3, PIMOM, CROSS, RMPIPI
      DOUBLE PRECISION RHOSUP, A2
#else
      REAL       XMDAUS(3), PDAUT1(4,3)
      REAL       QETA, FNORM, T1, T2, T3, PIMOM, CROSS, RMPIPI
      REAL       RHOSUP, A2
#endif
*
*- External declarations
      REAL     RANP
      EXTERNAL RANP
*
*- Executable code starts here
*
      XMDAUS(1)=.13957
      XMDAUS(2)=.13957

      IF (MATRX.EQ.18) THEN
         XMDAUS(3)=0.0
         QETA=0.27
         FNORM=1.0E-3
      ELSE
        XMDAUS(3)=.13497
        QETA=.136
        FNORM=1.0
      ENDIF

      A2=0.

C     UNTIL(FNORM*RANP(ISEED).LE.A2)
  100 IF (FNORM*RANP(ISEED).LE.A2) GOTO 101

C-- Decay eta
         CALL PHSP(PETA,XMSETA,MXPHSP,3,XMDAUS,PDAUTS)

C-- Boost into eta frame
#if defined(NONCLEO_DOUBLE)
         CALL DBOOSB(PETA,3,PDAUTS,PDAUT1)
#else
         CALL RBOOSB(PETA,3,PDAUTS,PDAUT1)
#endif

         T1=PDAUT1(4,1)-XMSPIC
         T2=PDAUT1(4,2)-XMSPIC

         IF (MATRX.EQ.18) THEN

        PIMOM = SQRT(PDAUT1(1,1)**2 + PDAUT1(2,1)**2 + PDAUT1(3,1)**2)
        CROSS = (PIMOM**2 *
     *   (PDAUT1(1,3)**2 + PDAUT1(2,3)**2 + PDAUT1(3,3)**2)) -
     *   (PDAUT1(1,1)*PDAUT1(1,3) + PDAUT1(2,1)*PDAUT1(2,3) +
     *    PDAUT1(3,1)*PDAUT1(3,3))**2
        RMPIPI = (PDAUT1(4,1)+PDAUT1(4,2))**2 -
     *   (PDAUT1(1,1)+PDAUT1(1,2))**2
     *   -  (PDAUT1(2,1)+PDAUT1(2,2))**2 - (PDAUT1(3,1)+PDAUT1(3,2))**2
        RHOSUP = (RMPIPI - XMRHO2)**2 + 7.43*XMRHO2*(PIMOM**6)
        A2=CROSS*SQRT(RMPIPI)/RHOSUP

         ELSE
            T3=PDAUT1(4,3)-XMSPI0
            A2=1.0-(1.5*T3/QETA)
         ENDIF

C        IF(A2.GT.FNORM)TYPE *,' A2>FNORM:',A2,FNORM

         GOTO 100
  101 CONTINUE

      RETURN
      END
