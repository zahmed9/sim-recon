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
*CMZ :  1.04/00 22/09/94  00.16.39  by  Paul Avery
*CMZ :  1.03/68 30/08/93  14.08.35  by  Peter C Kim
*CMZ :  1.03/50 19/10/92  21.13.17  by  Peter C Kim
*CMZ :  1.03/48 03/09/92  14.52.51  by  Unknown
*CMZ :  1.03/46 23/06/92  09.13.15  by  Unknown
*CMZ :  1.03/46 04/06/92  11.11.26  by  Peter C Kim
*CMZ :  1.03/34 05/12/91  14.34.33  by  Peter C Kim
*CMZ :  1.03/33 05/12/91  11.57.33  by  Peter C Kim
*-- Author :    Daniela Bortoletto 14/10/91
* 16/10/96 Lynn Garren: Add double precision conditionals.
* 28/10/96 Lynn Garren: Remove getmas external declaration - getmas is unused.
      SUBROUTINE SEMIL3(NP,NQ,KID,XM,KQ,KPAR,CMAS,T,IT,ND,PQ,MATRX,IER)
C.......................................................................
C
C
C...
C  Parameter to enter into the subroutine
C
C  ND            number of daughters
C  KQ            flavour of daughters
C  PQ            momentum of daughters
C  MTRX 71       not  polarized
C  MTRX 72-73    are handled the same as 71, for now
C  db modification for new qq
C.
C. Calls     : DCSWSB
C. Called    : DECAY
C. Author    :    Daniela Bortoletto 14/10/91
C.
C. Modified to correct previous modifications for b->u
C.                                                  M. Witherell 26.5.91
C. Changed /TIMER/ to /TTIMER/ to avoid conflicts with Isajet and IRIX.
C.                                                  LAG     11/03/94
C.......................................................................
CAF      IMPLICIT NONE

      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'SEMIL3' )

C     External declarations
      REAL RANP
      DOUBLE PRECISION DCSWSB
      EXTERNAL RANP, DCSWSB

C local variables
      INTEGER I, L, J, IDC, IDCSAV, IPOL, KPRNT, IWORD, IANG
      INTEGER NDAU, JPPAR, IERR, IT, NP, ND, NQ, IER, MATRX
      INTEGER KID(30), KQ(2,5),KPAR
      INTEGER NEV
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION TBR, CMAS
      DOUBLE PRECISION PQ(4,30), XM(30), T(4), TPRNT(4), TNEW(4)

      DOUBLE PRECISION TO(4)
      DOUBLE PRECISION XMT(3)
#else
      REAL TBR, CMAS
      REAL PQ(4,30), XM(30), T(4), TPRNT(4), TNEW(4)

      REAL TO(4)
      REAL XMT(3)
#endif

#if defined(NONCLEO_DOUBLE)
      COMMON/TEMPO/MBTEM
      DOUBLE PRECISION TRANCO,LONGCO,TRANP,TRANM,RATIO
      COMMON/COMPO/TRANCO,LONGCO,TRANP,TRANM,RATIO
      DOUBLE PRECISION MBTEM,COSTH1,COSTH2,SINTH1,SINTH2
#else
      COMMON/TEMPO/MBTEM
      REAL TRANCO,LONGCO,TRANP,TRANM,RATIO
      COMMON/COMPO/TRANCO,LONGCO,TRANP,TRANM,RATIO
      REAL MBTEM,COSTH1,COSTH2,SINTH1,SINTH2
#endif


      DOUBLE PRECISION FMAXST(4)

      DOUBLE PRECISION FMAX,Z,D1,D,C1,C2,FMIN,QTEM,MIN

      COMMON/RANDM/ISEED
      INTEGER ISEED

      COMMON /MASDB/ XMM,BM,X,YMAX,COST
      DOUBLE PRECISION COST
      COMMON /MODPAR/OVER,MFF
      DOUBLE PRECISION OVER,MFF
      COMMON/SELE3/IDECC,IDECAY,ICHAN
      INTEGER IDECC,IDECAY,ICHAN

      COMMON /FFT/ BB,BX,MB,MQ,MD,KAPA,LSIGN
      COMMON /PLOT/ CONST
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
      DOUBLE PRECISION BB,BX,BM,MQ,MD,KAPA,MB,XMM,X,YMAX
      DOUBLE PRECISION LSIGN,SHIFT(3),KPA(3)
      DOUBLE PRECISION CONST
      DOUBLE PRECISION XMIN,XMAX,YMIN
      DOUBLE PRECISION XRAN,YRAN,FRAN,BOUND

      INTEGER IPARTY
      LOGICAL TRAN
      DOUBLE PRECISION TDCS
      COMMON /PHASE/ TDCS
#if defined(NONCLEO_DOUBLE)
      COMMON /TTIMER/ FFUN1,ITIMER
      INTEGER ITIMER
      DOUBLE PRECISION FFUN
      DOUBLE PRECISION FFUN1
#else
      COMMON /TTIMER/ ITIMER,FFUN1
      INTEGER ITIMER
      DOUBLE PRECISION FFUN
      REAL FFUN1
#endif

C      DATA FMAXST/0.1215E3,0.2984E2,0.265E3,2.56E3/
      DATA FMAXST/3.6,2.2984,8.0,0.8/
      DATA NEV/0/
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
            IDECC=4
            OVER=0.7D0
            MFF=6.34D0
            ICHAN=2
         ENDIF

C B ---> U
C  3s  decays  RHO or OMEGA
         IF ( IPARTY .EQ.61 .OR. IPARTY .EQ. 62.OR.IPARTY.EQ.91
     1 .OR.IPARTY.EQ.92) THEN
          IDECC=5
          ICHAN=3
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
C SELECT DALITZ PLOT ALLOWED KINEMATICAL REGION
C
       IF (YRAN.GT.BOUND) GO TO 600
       NEV = NEV+1
       FRAN = RANP(ISEED)
       X=XRAN
       FFUN = CONST*DCSWSB(YRAN)
       IF(FFUN1.LT.FFUN)THEN
            FFUN1=FFUN
       ENDIF
       IF(FFUN.GT.FMAX)THEN
CAF            type * ,' FMAX',' ffun','X','Y',FMAX,ffun,X,YRAN,XMM
       FMAXST(ICHAN) = FFUN
       ENDIF
C       type * ,'fMIN','fMAX','ffun',fMIN,fMAX,ffun
       FFUN = FFUN/FMAX
CAF       IF(NEV.lt.20) type *, 'fmax,ffun',fmax,ffun
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
