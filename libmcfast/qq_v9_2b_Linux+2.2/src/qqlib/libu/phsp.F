*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:38  eugenio
* Initial revision
*
* Revision 1.2  1995/02/18  02:54:10  zfiles
* Fixed bug.
*
* Revision 1.1.1.1  1994/10/08  02:21:27  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.01/00 08/10/90  14.04.55  by  Paul Avery
*CMZ :  1.00/00 23/08/90  15.50.56  by  Paul Avery
*-- Author :
* 16/10/96 Lynn Garren:  Add double precision conditionals.
      SUBROUTINE PHSP(T, CMAS, MATRX, ND, XM, P)

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C     Do N body phase space
C
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C     External declarations
      REAL RANP
      EXTERNAL RANP

C     Calling arguments
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION T(4), CMAS, XM(*), P(4,*)
#else
      REAL T(4), CMAS, XM(*), P(4,*)
#endif
      INTEGER MATRX, ND

C     Local variables
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION PM(5,30), RND(30), U(3), BE(4), WTCOR(25)
      DOUBLE PRECISION TO(4), RAND
      DOUBLE PRECISION R, COSTH, SINTH, EE, PP, PPD, PHI, THETA
      DOUBLE PRECISION PMIN, PMAX, PSUM
      DOUBLE PRECISION BEP, TEMP, PA, A, B, C, WT, WTMAX, WTEMP
      DOUBLE PRECISION PAWT, FOUR
#else
      REAL PM(5,30), RND(30), U(3), BE(4), WTCOR(25), TO(4), RAND
      REAL R, COSTH, SINTH, EE, PP, PPD, PHI, THETA, PMIN, PMAX, PSUM
      REAL BEP, TEMP, PA, A, B, C, WT, WTMAX, WTEMP
      REAL PAWT, FOUR
#endif
      INTEGER I, I1, L, J, IL, IL1, IL2, IL1U, IL2R, ILR, ILU

      DATA WTCOR/16.,150.,2.,5.,15.,60.,250.,1500.,1.2E4,1.2E5,
     *  8.E5,8.E6,1.E8,1.E9,1.E10,
     *  1.E11,1.E12,1.E13,1.E14,1.E15,1.E16,1.E17,1.E18,1.E19,1.E20/
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      PAWT(A,B,C) = SQRT((A**2-(B+C)**2)*(A**2-(B-C)**2))/(2.*A)
      FOUR(I,J) = P(4,I)*P(4,J) - P(1,I)*P(1,J) - P(2,I)*P(2,J) -
     *            P(3,I)*P(3,J)

      IF(ND-2) 1000,2000,3000

C     ND = 1
1000  DO 1010 I=1,4
        P(I,1) = T(I)
1010  CONTINUE
      RETURN

C   ND = 2
2000  CONTINUE
      DO 2005 I=1,4
        TO(I) = T(I)
2005  CONTINUE
400      COSTH = 2*RANP(0) - 1
      R = RANP(0)
      GOTO (600,410,420,430,440,450,460,470,480,490),MATRX+1
410      IF(2.*R.GT.1.+COSTH**2)GOTO 400
      GOTO 600
420      IF(R.GT.1-COSTH**2)GOTO 400
      GOTO 600
430      IF(1.5*R.GT.1+.5*COSTH**2)GOTO 400
      GOTO 600
440      IF(R.GT.1-.5*COSTH**2)GOTO 400
      GOTO 600
450      IF(4./3.*R.GT.1+COSTH**2/3.)GOTO 400
      GOTO 600
460      IF(R.GT.1-COSTH**2/3.)GOTO 400
      GOTO 600
470      IF(4.*R.GT.(1+COSTH)**2)GOTO 400
      GOTO 600
480      IF(4.*R.GT.(1-COSTH)**2)GOTO 400
      GOTO 600
490      IF(R.GT.COSTH**2)GOTO 400
      GOTO 600

600      PHI = 2.*3.141592654*RANP(0)
      SINTH = SQRT(1-COSTH**2)
      EE = (CMAS**2+XM(1)**2-XM(2)**2)/2./CMAS
      PP = SQRT(EE**2-XM(1)**2)
      P(1,1) = PP*SINTH*COS(PHI)
      P(2,1) = PP*SINTH*SIN(PHI)
      P(3,1) = PP*COSTH
      P(4,1) = EE
      DO 610 L=1,3
610      P(L,2) = -P(L,1)
      P(4,2) = CMAS - EE
      PPD = SQRT(TO(1)**2 + TO(2)**2 + TO(3)**2)

C   If parent momentum is 0, we are done
      IF(PPD .EQ. 0) RETURN

C   If we have an angular distribution, must reference it to particle
C   direction. we will rotate to this direction before we boost to lab
      IF(MATRX .EQ. 0) GOTO 620
      THETA = ACOS(TO(3) / PPD)
      IF(TO(1).EQ.0. .AND. TO(2).EQ.0.) THEN
        PHI = 0.
      ELSE
        PHI = ATAN2(TO(2),TO(1))
      ENDIF
#if defined(NONCLEO_DOUBLE)
      CALL D4ROTA(PHI, THETA, 0.D0, 2, P, P)
620   CALL DBOOSF(TO, 2, P, P)
#else
      CALL R4ROTA(PHI, THETA, 0., 2, P, P)
620   CALL RBOOSF(TO, 2, P, P)
#endif
      RETURN

C   ND > 2
3000  DO 3010 I=1,4
        PM(I,1) = T(I)
3010  CONTINUE
      PM(5,1) = CMAS
      DO 3015 I=1,4
        TO(I) = T(I)
3015  CONTINUE

      PSUM = 0.
      DO 201 J=1,ND
        PSUM = PSUM + XM(J)
201   CONTINUE
      PM(5,ND) = XM(ND)

C     Calculate maximum weight
      WTMAX = 1. / WTCOR(ND)
      PMAX = CMAS - PSUM + XM(ND)
      PMIN = 0.
      DO 210 ILR=2,ND
        IL = ND + 1 - ILR
        PMAX = PMAX + XM(IL)
        PMIN = PMIN + XM(IL+1)
        WTMAX = WTMAX * PAWT(PMAX,PMIN,XM(IL))
210   CONTINUE

C  M-generator gives weight, if rejected try again
  220 RND(1) = 1.
      IL1U = ND - 1
      DO 240 IL1=2,IL1U
      RAND = RANP(0)
      DO 230 IL2R=2,IL1
        IL2 = IL1 + 1 - IL2R
        IF(RAND .LE. RND(IL2)) GOTO 239
230     RND(IL2+1) = RND(IL2)
239     RND(IL2+1) = RAND
240   CONTINUE

      RND(ND) = 0.
      WT = 1.
      DO 250 ILR=2,ND
        IL = ND + 1 - ILR
        PM(5,IL) = PM(5,IL+1) + XM(IL) +
     *             (RND(IL)-RND(IL+1)) * (CMAS-PSUM)
        WT = WT * PAWT(PM(5,IL),PM(5,IL+1),XM(IL))
250   CONTINUE
C                   Protect against infinite loop from 8-body decay
C                                                              2/95
      IF(WT .LE. 0. .AND. CMAS-PSUM.LE.1.E-6) GOTO 260

      IF(WT .LT. RANP(0)*WTMAX) GOTO 220

C     Perform two-particle decays in cm frame
  260 ILU = ND - 1
      DO 280 IL=1,ILU
        PA = PAWT(PM(5,IL),PM(5,IL+1),XM(IL))
        COSTH = 2. * RANP(0) - 1.
        SINTH = SQRT(1.  - COSTH**2)
        PHI = 6.283185308*RANP(0)
        P(1,IL) = PA*SINTH*COS(PHI)
        P(2,IL) = PA*SINTH*SIN(PHI)
        P(3,IL) = PA*COSTH
        DO 270 J=1,3
          PM(J,IL+1) = -P(J,IL)
270     CONTINUE
        P(4,IL) = SQRT(PA**2 + XM(IL)**2)
        PM(4,IL+1) = SQRT(PA**2 + PM(5,IL+1)**2)
280   CONTINUE

C     Lorentz transform decay products to lab frame
      DO 290 J=1,4
        P(J,ND) = PM(J,ND)
290   CONTINUE
      DO 320 ILR=2,ND
      IL = ND+1-ILR
      DO 300 J=1,4
  300 BE(J) = PM(J,IL) / PM(5,IL)
        DO 320 I1=IL,ND
        BEP = BE(1)*P(1,I1) + BE(2)*P(2,I1) + BE(3)*P(3,I1) +
     *        BE(4)*P(4,I1)
        TEMP = (P(4,I1)+BEP)/(BE(4)+1.)
        DO 310 J=1,3
          P(J,I1) = P(J,I1) + TEMP*BE(J)
310     CONTINUE
        P(4,I1) = BEP
320   CONTINUE

      GOTO (5000,3200,3300),MATRX+1

C     Semileptonic decays
3200  WT = FOUR(2,3)*(TO(4)*P(4,1) - TO(1)*P(1,1) - TO(2)*P(2,1)-
     *     TO(3)*P(3,1))
      IF(WT .LT. RANP(0)*CMAS**4/16.) GOTO 220
      RETURN

C     Omega, phi decays
C                            WTMAX variable was wrongly used here.
C                                Changed to WTEMP             2/95
C
3300  WTEMP = (CMAS**2-3*XM(1)**2)**2 * (CMAS**2-12*XM(1)**2)/108.
      WT = (XM(1)*XM(2)*XM(3))**2 - (XM(1)*FOUR(2,3))**2 -
     *     (XM(2)*FOUR(1,3))**2 - (XM(3)*FOUR(1,2))**2 +
     *     2.*FOUR(1,2)*FOUR(1,3)*FOUR(2,3)
      IF(WT .LT. RANP(0)*WTEMP)GOTO 220

5000  RETURN
      END
