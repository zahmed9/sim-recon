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
*CMZ :  1.03/34 05/12/91  14.29.20  by  Peter C Kim
*CMZ :  1.03/33 05/12/91  11.14.23  by  Peter C Kim
*-- Author :    Daniela Bortoletto  14/10/91
* 16/10/96 Lynn Garren: Add double precision conditionals.
* 28/10/96 Lynn Garren: Remove getmas external declaration - getmas is unused.
      SUBROUTINE SEMIL2(NP,NQ,KID,XM,KQ,KPAR,CMAS,T,IT,ND,PQ,MATRX,IER)
C.......................................................................
C
C  Koerner/Schuler model for semileptonic decays
C
C
C  Parameter to enter into the subroutine
C
C  ND            number of daughters
C  KQ            flavour of daughters
C  PQ            momentum of daughters
C  MTRX 61       polarized
C  MTRX 62       polarized
C  db modification for new qq
C
C. Calls     : DCSKS2
C. Called    : DECAY
C. Author    : Daniela Bortoletto  14/10/91
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'SEMIL2' )

C--- Calling arguments

      INTEGER NP,NQ,KID(30),KQ(2,5),KPAR,IT,ND,MATRX,IER
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION XM(30),CMAS,T(4),PQ(4,30)
#else
      REAL XM(30),CMAS,T(4),PQ(4,30)
#endif

C--- External declarations

      REAL RANP
      DOUBLE PRECISION DCSKS2
      EXTERNAL RANP, DCSKS2

C--- Common variables

      INTEGER ND1, ND2
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION SUBMS2,SUBMS1
#else
      REAL SUBMS2,SUBMS1
#endif
      COMMON/BLOB1/ND1,ND2,SUBMS1,SUBMS2

#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION TRANCO,LONGCO,TRANP,TRANM,RATIO
#else
      REAL TRANCO,LONGCO,TRANP,TRANM,RATIO
#endif
      COMMON/COMPO/TRANCO,LONGCO,TRANP,TRANM,RATIO

      INTEGER ISEED
      COMMON/RANDM/ISEED

      DOUBLE PRECISION FMAXST(4)

      DOUBLE PRECISION OVER,MFF
      COMMON /MODPAR/OVER,MFF

      DOUBLE PRECISION XMM,BM,X,YMAX,COST
      COMMON /MASDB/ XMM,BM,X,YMAX,COST

      INTEGER IDECC,IDECAY
      COMMON/SELE/IDECC,IDECAY


C--- Local variables

      INTEGER I,L,J,ICHAN
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION TO(4),MBTEM,COSTH1,COSTH2,SINTH1,SINTH2
#else
      REAL TO(4),MBTEM,COSTH1,COSTH2,SINTH1,SINTH2
#endif

      DOUBLE PRECISION CONST


      DOUBLE PRECISION FMAX,Z,D1,D,C1,C2,FMIN,QTEM,MIN


      COMMON /KINVAR/ XGEN,YGEN,EE,EEX,PPX

#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION COSTH,THETA,PPD,EELAB,PPXLAB,EEXLAB
      DOUBLE PRECISION PCM(4,30),PHI,CPHI,SPHI
      DOUBLE PRECISION QQGEN,YGEN,XGEN,Q0,EE,EEX,ENU,ROOT,PPX
#else
      REAL COSTH,THETA,PPD,EELAB,PPXLAB,EEXLAB
      REAL PCM(4,30),PHI,CPHI,SPHI
      REAL QQGEN,YGEN,XGEN,Q0,EE,EEX,ENU,ROOT,PPX
#endif

      DOUBLE PRECISION SHIFT(3),KPA(3)
      DOUBLE PRECISION XMIN,XMAX,YMIN
      DOUBLE PRECISION XRAN,YRAN,FRAN,BOUND

      INTEGER IPARTY

#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION  FFUN1
#else
      REAL  FFUN1
#endif
      DOUBLE PRECISION FFUN

      DATA FMAXST /0.1215E3,0.2984E2,0.265E3,2.56E3/

      IER = 0
C
C SET UP NECESSARY CONSTANTS TO CALCULATE DIFFERENTIAL CROSS SECTION
C ACCORDING TO ISGUR FORMALISM
C
         XMM = DBLE(XM(3))
         IPARTY = KID(3)
C         TYPE * , 'IPARTY ', IPARTY
C
C CHOOSE EXCLUSIVE DECAY MODE
C
C B ---> C
C  3s  decays  D*
         IF ( IPARTY .EQ.67.OR.IPARTY.EQ.68.OR.IPARTY.EQ.69.
     1.OR. IPARTY .EQ. 70) THEN
           ICHAN=1
           IDECC=5
           OVER=0.7D0
           MFF=6.34D0
         ENDIF
C  1s  decays  D
         IF ( IPARTY .EQ.27 .OR. IPARTY .EQ. 28 .OR.IPARTY.EQ.29
     1  .OR.IPARTY.EQ.30) THEN
           ICHAN=2
           IDECC=4
           OVER=0.7D0
           MFF=6.34D0
         ENDIF

C B ---> U
C  3s  decays  RHO or OMEGA
         IF ( IPARTY .EQ.61 .OR. IPARTY .EQ. 62.OR.IPARTY.EQ.91
     1 .OR.IPARTY.EQ.92) THEN
           ICHAN=3
           IDECC=5
           OVER=0.33D0
           MFF=5.33D0
         ENDIF
C  1s  decays  PION
         IF ( IPARTY .EQ.21 .OR. IPARTY .EQ. 22.OR.IPARTY.EQ.51) THEN
           ICHAN=4
           IDECC=4
           OVER=0.33D0
           MFF=5.33D0
         ENDIF

      MBTEM=5.28
      BM=DBLE(MBTEM)
         CONST=1.D0
         XMIN = 0.D0
         YMIN = 0.D0
         FMIN = 0.D0
         FMAX = FMAXST(ICHAN)
C
C      GENERATE X , Y , GAMMA (X,Y)
C      X = P_E/M_B
C      Y = Q^2/M_B^2
C      GAMMA(X,Y) = DIFFERENTIAL CROSS SECTION ACCORDING TO ISGUR MODEL
C

600    QTEM = 1.D0-(XMM/BM)**2
       XMAX = QTEM/2.D0
       YMAX = 1.D0 + (XMM/BM)*((XMM/BM)-2.D0)
       XRAN = RANP(ISEED) * (XMAX - XMIN) + XMIN
       BOUND = 2.D0*XRAN*(QTEM-2.D0*XRAN)/(1.D0-2.D0*XRAN)
       YRAN = RANP(ISEED) * (YMAX-YMIN)+YMIN
C
C SELECT DALIZT PLOT ALLOWED KINEMATICAL REGION
C
       IF (YRAN.GT.BOUND) GO TO 600
       FRAN = RANP(ISEED)
       X=XRAN
       FFUN = CONST*DCSKS2(YRAN)
       IF(FFUN1.LT.FFUN)THEN
            FFUN1=FFUN
       ENDIF
       IF(FFUN.GT.FMAX)THEN
C        type * ,' FMAX',' ffun','X','Y',FMAX,ffun,X,YRAN,XMM
       ENDIF
C      type * ,'fMIN','fMAX',fMIN,fMAX
       FFUN = FFUN/FMAX
       IF(FRAN.GT.FFUN)GO TO 600
C
C GENERATE KINEMATICS IN THE REST FRAME l^- AND NU
C
C           CALL SCAT(25,XRAN,YRAN)
C
C GENERATE KINEMATICS IN THE REST FRAME B MESON REST FRAME
C
#if defined(NONCLEO_DOUBLE)
         XGEN=X
         YGEN=YRAN
           QQGEN = YRAN*BM**2
           Q0 = (MBTEM**2+QQGEN-XM(3)**2)*.5/MBTEM
           EE = XRAN*BM
#else
         XGEN=SNGL(X)
         YGEN=SNGL(YRAN)
           QQGEN = SNGL(YRAN*BM**2)
           Q0 = (MBTEM**2+QQGEN-XM(3)**2)*.5/MBTEM
           EE = SNGL(XRAN*BM)
#endif
           ENU = Q0 - EE
           EEX = (MBTEM**2+XM(3)**2-QQGEN)/(2.*MBTEM)
           ROOT = EEX**2 - XM(3)**2
           IF(ROOT.LT.0) GO TO 600
           IF(ROOT.GT.0.)PPX = SQRT(ROOT)
           IF(ROOT.EQ.0.)PPX = 0.
C-------------------------------------------------------------------------------
                Z=QTEM+YRAN
                D1=Z*Z -4.D0*YRAN

                MIN = 0.D0

                IF(MIN.LT.D1)THEN
                 IF(XRAN.EQ.XMIN)THEN
                  COSTH2=-1.
                 ELSE
                  D=XRAN*DSQRT(D1)
                  C1=(YRAN-XRAN*Z)/D
                 ENDIF
                ELSE
                 IF(X.EQ.MIN)THEN
                  C2=3.D0
                 ELSE
                  C1=2.D0
                 ENDIF
                ENDIF
C-------------------------------------------------------------------------------
         IF(PPX.GT.0.)THEN
#if defined(NONCLEO_DOUBLE)
           COSTH1=C1
#else
           COSTH1=SNGL(C1)
#endif
         ELSE
             COSTH1 = 1.
           SINTH1= 0.
         ENDIF
           IF(COSTH1.GT.1.OR.COSTH1.LT.-1.)GO TO 600
           IF(ABS(COSTH1).LT.1.)THEN
          SINTH1 = SQRT(1-COSTH1**2)
         ELSE
          SINTH1=0.
          IF(COSTH1.EQ.1.)COSTH2=-1.
         ENDIF
         IF (COSTH2.EQ.-1.)THEN
            SINTH2=0.
         ENDIF

         PHI=6.283185307*RANP(ISEED)
         CPHI=COS(PHI)
         SPHI=SIN(PHI)
C LEPTON
           PCM(1,2) = EE*SINTH1*CPHI
           PCM(2,2) = EE*SINTH1*SPHI
           PCM(3,2) = EE*COSTH1
           PCM(4,2) = EE
C MESON
           PCM(1,3) = 0.
           PCM(2,3) = 0.
           PCM(3,3) = PPX
           PCM(4,3) = EEX

C NEUTRINO
           PCM(1,1) = -PCM(1,2)
           PCM(2,1) = -PCM(2,2)
           PCM(3,1) = -PCM(3,3)-PCM(3,2)
           PCM(4,1) = ENU


C ROTATION

400        COSTH = 2*RANP(ISEED)-1.
C           TYPE *,'PCM ' ,(PCM(J,3),J=1,4)
           PHI = 2.*3.141592654*RANP(ISEED)
           THETA = ACOS(COSTH)
C          CHI = 2.*3.141592654*RANP(ISEED)
C
      CALL ROTAT(PHI,THETA,-PHI,3,PCM,PCM)

C LORENTZ TRANSFORMATION TO LABORATORY SYSTEM
           DO 666 J=1,4
              TO(J)=T(J)
666        CONTINUE
C           TYPE *,'TO ' ,(TO(J),J=1,4)
           PPD = SQRT(TO(1)**2+TO(2)**2+TO(3)**2)
           IF(PPD.EQ.0)RETURN

           CALL BOOSTF(TO,3,PCM,PQ)

C           TYPE *,'PQ ' ,(PQ(J,3),J=1,4)

            EELAB=PQ(4,1)
            PPXLAB=SQRT(PQ(1,3)**2+PQ(2,3)**2+PQ(3,3)**2)
            EEXLAB=PQ(4,3)
      ND=3
        RETURN
        END
