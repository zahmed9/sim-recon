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
*CMZ :  1.02/00 06/03/91  16.58.01  by  Peter C Kim
*-- Author :    Peter C Kim   06/03/91
* 16/10/96 Lynn Garren: Add double precision conditionals.
      SUBROUTINE OMG3PI(NP,NQ,KID,XM,KQ,ID,CMAS,PMOM,IT,ND,PQ,MATRX,IER)
C.......................................................................
C.
C. DKV3PI - Decay of omega --> pi+ pi- pi0
C.
C. Calls     : NONE
C. Called    : DECAY
C. Author    : Peter C Kim  06/03/91  15.47.43
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C-- Calling arguments

      INTEGER KID(30),KQ(2,5)
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION    PMOM(4),XM(30),PQ(4,30), CMAS
#else
      REAL    PMOM(4),XM(30),PQ(4,30), CMAS
#endif
      INTEGER NP, NQ, ID, IT, ND, MATRX, IER

C-- External decalaration

       REAL RANP
       EXTERNAL RANP

C-- Local Variables

#if defined(NONCLEO_DOUBLE)
       DOUBLE PRECISION RATIO,RSQ,X1,X2,X3,TH,Z,GR,TWOPI
       DOUBLE PRECISION CT,ST,PHI,CF,SF,DOT,EP,FACT
       DOUBLE PRECISION KSQ(3),VMOM(3),KMOM(4,3)
#else
       REAL RATIO,RSQ,X1,X2,X3,TH,Z,GR,TWOPI
       REAL CT,ST,PHI,CF,SF,DOT,EP,FACT
       REAL KSQ(3),VMOM(3),KMOM(4,3)
#endif
       INTEGER I,J

       TWOPI = 6.28319
       RATIO = 0.139/CMAS
       RSQ = RATIO*RATIO

 100   X1 = 0.5*RANP(0)
       X2 = 0.5*RANP(0)
       IF(X1+X2.LT.0.5) THEN
         X1 = 0.5 - X1
         X2 = 0.5 - X2
       ENDIF
       X3 = 1.0 - X1 - X2
#if defined(NONCLEO_DOUBLE)
       IF(DMIN1(X1,X2,X3).LT.RATIO) GOTO 100
#else
       IF(AMIN1(X1,X2,X3).LT.RATIO) GOTO 100
#endif

       KSQ(1) = X1*X1 - RSQ
       KSQ(2) = X2*X2 - RSQ
       KSQ(3) = X3*X3 - RSQ
       Z = (KSQ(3)-KSQ(1)-KSQ(2)) / (2.0*SQRT(KSQ(1)*KSQ(2)))
       IF(ABS(Z).GT.1.0) GOTO 100

       GR = KSQ(1)*KSQ(2)*(1.0-Z*Z) / (0.1111111-RSQ)**2 / 0.75
       IF(RANP(0).GE.GR) GOTO 100

C  We found a point in the Dalitz plot.

       KMOM(3,1) = CMAS*SQRT(KSQ(1))
       KMOM(2,1) = 0.0
       KMOM(1,1) = 0.0
       TH  = CMAS*SQRT(KSQ(2))
       PHI = TWOPI*RANP(0)
       KMOM(3,2) = TH*Z
       KMOM(1,2) = TH*SQRT(1.0-Z*Z)
       TH   = KMOM(1,2)
       KMOM(1,2) = TH*COS(PHI)
       KMOM(2,2) = TH*SIN(PHI)
       CT  = 2.0*RANP(0) - 1.0
       ST  = SQRT(1.0 - CT*CT)
       PHI = TWOPI*RANP(0)
       CF  = COS(PHI)
       SF  = SIN(PHI)

       DO 10 J=1,2

         DO 20 I=1,3
           VMOM(I) = KMOM(I,J)
  20     CONTINUE

         KMOM(1,J) =  VMOM(1)*CT*CF - VMOM(2)*SF + VMOM(3)*ST*CF
         KMOM(2,J) =  VMOM(1)*CT*SF - VMOM(2)*CF + VMOM(3)*ST*SF
         KMOM(3,J) = -VMOM(1)*ST                 + VMOM(3)*CT

         KMOM(4,J) = CMAS*SQRT(KSQ(J)+RSQ)
         DOT = PMOM(1)*KMOM(1,J) + PMOM(2)*KMOM(2,J) + PMOM(3)*KMOM(3,J)
         EP  = (DOT+PMOM(4)*KMOM(4,J)) / CMAS
         FACT = (KMOM(4,J)+EP) / (PMOM(4)+CMAS)

         DO 30 I=1,3
           KMOM(I,J) = KMOM(I,J) + FACT*PMOM(I)
  30     CONTINUE

         KMOM(4,J) = EP

  10   CONTINUE

       DO 40 I=1,4
         PQ(I,1) = KMOM(I,1)
         PQ(I,2) = KMOM(I,2)
         PQ(I,3) = PMOM(I) - KMOM(I,1) - KMOM(I,2)
  40   CONTINUE

       RETURN
       END
