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
*CMZ :  1.04/00 22/09/94  00.19.14  by  Paul Avery
*CMZ :  1.03/75 14/02/94  23.11.27  by  Peter C Kim
*CMZ :  1.03/49 25/09/92  17.11.01  by  Peter C Kim
*CMZ :  1.03/47 03/09/92  11.58.35  by  Peter C Kim
*CMZ :  1.03/34 05/12/91  14.47.36  by  Peter C Kim
*CMZ :  1.03/23 23/09/91  15.17.36  by  Peter C Kim
*CMZ :  1.03/11 20/06/91  14.05.25  by  Peter C Kim
*CMZ :  1.03/00 29/03/91  14.08.45  by  Peter C Kim
*CMZ :  1.02/00 11/02/91  15.08.46  by  Peter C Kim
*-- Author :    Peter C Kim   11/02/91
* 16/10/96 Lynn Garren: Add double precision conditionals.
* 19/11/96 Rob Kutschke: Total rewrite of 3-body kinematics to allow
*                        for lepton masses.
*
      SUBROUTINE SEMIL1(NP,NQ,KID,XM,KQ,KPAR,CMAS,T,IT,ND,PQ,MATRX,IER)
C======================================================================
C
C   Semileptonic decays of the heavy mesons.
C   ***************************************
C
C                   Isgur/Wise model  written by M. Artuso
C
C  Parameter to enter into the subroutine
C
C     ND            number of daughters
C     KQ            flavour of daughters
C     PQ            momentum of daughters
C     MATRX 51      not  polarized
C     MATRX 52      polarized  (TRANS)
C     MATRX 53      polarized  (LONG)
C
C  In DECAY.DEC   Particle #1 = nu
C                          #2 = lepton
C                          #3 = meson
C.
C. Calls     : QQDCS
C. Called    : DECADD
C. Author    : Peter C Kim  11/02/91  14.08.51
C.
C.     Modification to accomodate various b->u exclisive channels
C.                                                   MSW   3/09/92
C
C.     Rearranged to accomodate all B/D decays modes
C.                                                   PCK  14/02/94
C
C.     Changed /TIMER/ to /TTIMER/ to avoid conflicts with an Isajet subroutine
C.          and an IRIX function
C.                                                   LAG  11/03/94
C======================================================================

C--- Calling arguments

      INTEGER NP,NQ,KID(30),KQ(2,5),KPAR,IT,ND,MATRX,IER
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION XM(30),CMAS,T(4),PQ(4,30)
#else
      REAL XM(30),CMAS,T(4),PQ(4,30)
#endif

C--- External declarations

#if defined(NONCLEO_DOUBLE)
      REAL RANP
      DOUBLE PRECISION QQDCS,GETMAS
#else
      REAL RANP,GETMAS
      DOUBLE PRECISION QQDCS
#endif
      EXTERNAL RANP,GETMAS,QQDCS

C-- Common variables  (shared with the function QQDCS)

      LOGICAL LTRAN,LLONG
      COMMON /POL/ LTRAN,LLONG

      INTEGER FLAG
      DOUBLE PRECISION XMM,BM,X,SHIFT,KPA
      LOGICAL TRAN
      COMMON /MASS/ SHIFT(3),KPA(3),XMM,BM,X,FLAG,TRAN

      DOUBLE PRECISION BB,BX,MB,MQ,MD,KAPA,LSIGN
      COMMON /FFT/ BB,BX,MB,MQ,MD,KAPA,LSIGN

C-- Local variables

#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION XMT(3),TO(4),MBTEM,QQGEN,PCM(4,30),PW(4),QSQ
      DOUBLE PRECISION XGEN,YGEN,Q0,EE,EEX,ENU,ROOT,PPX,PPD
#else
      REAL XMT(3),TO(4),MBTEM,QQGEN,PCM(4,30),PW(4),QSQ
      REAL XGEN,YGEN,Q0,EE,EEX,ENU,ROOT,PPX,PPD
#endif

      INTEGER ICHANB,ICHAND,ITYPEQ,ITIMER
      INTEGER IPARTY,KIDP,J,MATPS

      DOUBLE PRECISION FMAXB(50),FMAXD(50),FMAX
      DOUBLE PRECISION Z,D1,D,C1,C2
      DOUBLE PRECISION CONST
      DOUBLE PRECISION XMIN,XMAX,YMIN,YMAX
      DOUBLE PRECISION XRAN,YRAN,FRAN,BOUND

      DOUBLE PRECISION FMIN,QTEM


      DOUBLE PRECISION FFUN
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION FFUN1

      DOUBLE PRECISION PHI,CPHI,SPHI,THETA,COSTH
      DOUBLE PRECISION COSTH1,COSTH2,SINTH1,SINTH2
#else
      REAL FFUN1

      REAL PHI,CPHI,SPHI,THETA,COSTH
      REAL COSTH1,COSTH2,SINTH1,SINTH2
#endif

      DOUBLE PRECISION MIN

C--  Common variables used in testing paramters.

      COMMON /PLOT/   CONST
      COMMON /KINVAR/ XGEN,YGEN,EE,EEX,PPX
      COMMON /EXTR/   XMIN,XMAX,YMIN,YMAX,FMIN,QTEM
#if defined(NONCLEO_DOUBLE)
      COMMON /TTIMER/ FFUN1,ITIMER
#else
      COMMON /TTIMER/  ITIMER,FFUN1
#endif
C----------------------------------------------------


      DATA FMAXB /
     *            0.399E14,0.120E15,0.120E15,0.520E14,0.350E13,
     *            0.750E13,0.150E14,0.320E13,0.0     ,0.0     ,
     *            0.510E13,0.983E13,0.148E14,0.810E14,0.810E14,
     *            0.280E14,0.500E14,0.200E14,0.350E13,0.650E13,
     *            0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,
     *            0.171E14,0.130E15,0.130E15,0.595E14,0.350E13,
     *            0.120E14,0.150E14,0.500E13,0.0     ,0.0     ,
     *            0.394E13,0.930E14,0.930E14,0.370E14,0.500E14,
     *            0.140E14,0.270E13,0.630E13,0.0     ,0.0      /

      DATA FMAXD /
     *            0.700E12,0.170E13,0.170E13,0.745E12,0.600E11,
     *            0.135E12,0.400E11,0.500E10,0.0     ,0.0     ,
     *            0.320E12,0.600E12,0.690E12,0.290E13,0.290E13,
     *            0.105E13,0.375E12,0.230E12,0.680E11,0.400E10,
     *            0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,
     *            0.270E12,0.220E13,0.220E13,0.930E12,0.440E12,
     *            0.265E12,0.950E11,0.185E11,0.0     ,0.0     ,
     *            0.325E12,0.500E12,0.210E13,0.210E13,0.965E12,
     *            0.675E11,0.350E12,0.740E11,0.410E11,0.0      /


C================================================================
C
C        1    B -> D
C        2    B -> D*  no pol.
C        3    B -> D*  tran. pol.  (Matrix 52)
C        4    B -> D*  long. pol.  (Matrix 53)
C        5    B -> 3P0
C        6    B -> 3P1
C        7    B -> 1P1
C        8    B -> 3P2
C
C       11    B -> pi
C       12    B -> eta
C       13    B -> eta'
C       14    B -> rho/omega  no pol.
C       15    B -> rho/omega  tran. pol.  (Matrix 52)
C       16    B -> rho/omega  long. pol.  (Matrix 53)
C       17    B -> a1/f1/f1'  (1++)
C       18    B -> b1/h1/h1'  (1+-)
C       19    B -> a0/f0/f0'  (0++)
C       20    B -> a2/f2/f2'  (2++)
C
C       31    B_s -> D
C       32    B_s -> D*  no pol.
C       33    B_s -> D*  tran. pol.  (Matrix 52)
C       34    B_s -> D*  long. pol.  (Matrix 53)
C       35    B_s -> 3P0
C       36    B_s -> 3P1
C       37    B_s -> 1P1
C       38    B_s -> 3P2
C
C       41    B_s -> K
C       42    B_s -> K*  no pol.
C       43    B_s -> K*  tran. pol.  (Matrix 52)
C       44    B_s -> K*  long. pol.  (Matrix 53)
C       45    B_s -> K1(1270)
C       46    B_s -> K1(1400)
C       47    B_s -> K*_0(1430)
C       48    B_s -> K*_2(1430)
C
C================================================================
C
C        1    D -> K
C        2    D -> K*  no pol.
C        3    D -> K*  tran. pol.  (Matrix 52)
C        4    D -> K*  long. pol.  (Matrix 53)
C        5    D -> K1(1270)
C        6    D -> K1(1400)
C        7    D -> K*_0(1430)
C        8    D -> K*_2(1430)
C
C       11    D -> pi
C       12    D -> eta
C       13    D -> eta'
C       14    D -> rho/omega  no pol.
C       15    D -> rho/omega  tran. pol.  (Matrix 52)
C       16    D -> rho/omega  long. pol.  (Matrix 53)
C       17    D -> a1/f1/f1'
C       18    D -> b1/h1/h1'
C       19    D -> a0/f0/f0'
C       20    D -> a2/f2/f2'
C
C       31    D_s -> K
C       32    D_s -> K*  no pol.
C       33    D_s -> K*  tran. pol.  (Matrix 52)
C       34    D_s -> K*  long. pol.  (Matrix 53)
C       35    D_s -> K1(1270)
C       36    D_s -> K1(1400)
C       37    D_s -> K*_0(1430)
C       38    D_s -> K*_2(1430)
C
C       41    D_s -> eta
C       42    D_s -> eta'
C       43    D_s -> phi  no pol.
C       44    D_s -> phi  tran. pol.  (Matrix 52)
C       45    D_s -> phi  long. pol.  (Matrix 53)
C       46    D_s -> f1/f1'
C       47    D_s -> h1/h1'
C       48    D_s -> f0/f0'
C       49    D_s -> f2/f2'
C
C

      IER = 0

C-- Choose TRANSVERSE or not

      IF(MATRX.EQ.51)THEN
           LTRAN=.FALSE.
           LLONG=.FALSE.
      ENDIF
      IF(MATRX.EQ.52) THEN
           LTRAN=.TRUE.
           LLONG=.FALSE.
      ENDIF
      IF(MATRX.EQ.53) THEN
           LTRAN=.FALSE.
           LLONG=.TRUE.
      ENDIF


C-- Set up necessary constants to calculate differential cross section
C   according to Isgur formalism.
C
      XMM = DBLE(XM(3))
      IPARTY = KID(3)
C     IF(IPARTY.GT.210)XMM=DBLE(GETMAS(IPARTY))
C     TYPE * , 'IPARTY ', IPARTY

C                          KPAR  = particle # in DECAY.DEC
C                          MBTEM = mass of decaying particle

      KIDP=KPAR
      MBTEM=GETMAS(KIDP)
      BM=DBLE(MBTEM)


C                                                   B decays
      IF(KPAR.GE.33.AND.KPAR.LE.36) THEN
        ITYPEQ = 1
        MD = 0.33D0
        GOTO 100
      ENDIF
C                                                   B_s decays
      IF(KPAR.GE.37.AND.KPAR.LE.38) THEN
        ITYPEQ = 1
        MD = 0.55D0
        GOTO 200
      ENDIF
C                                                   D decays
      IF(KPAR.GE.27.AND.KPAR.LE.30) THEN
        ITYPEQ = 2
        MD = 0.33D0
        GOTO 300
      ENDIF
C                                                   D_s decays
      IF(KPAR.GE.31.AND.KPAR.LE.32) THEN
        ITYPEQ = 2
        MD = 0.55D0
        GOTO 400
      ENDIF


C---------------------------------------------- Set up for B decays
 100  CONTINUE
C                                                 b ---> c
C                                                ==========


C 1s  decays  B -> D
      IF ( IPARTY.GE.27 .AND.IPARTY.LE.30) THEN
         FLAG = 0
         ICHANB = 1
         BX = 0.39D0
         MQ = 1.82D0
         GOTO 1000
      ENDIF

C 3s  decays  B -> D*
      IF ( IPARTY.GE.67 .AND. IPARTY.LE.70) THEN
         FLAG = 2
                   ICHANB = 2
         IF(LTRAN) ICHANB = 3
         IF(LLONG) ICHANB = 4
         BX = 0.39D0
         MQ = 1.82D0
         GOTO 1000
      ENDIF

C D** 3P0
      IF (IPARTY.EQ.221 .OR. IPARTY.EQ.225 .OR.
     *    IPARTY.EQ.229 .OR. IPARTY.EQ.233)     THEN
         FLAG = 1
         ICHANB = 5
         BX = 0.34D0
         MQ = 1.82D0
         GOTO 1000
      ENDIF

C D** 3P1
      IF (IPARTY.EQ.222 .OR. IPARTY.EQ.226 .OR.
     *    IPARTY.EQ.230 .OR. IPARTY.EQ.234)     THEN
         FLAG = 4
         ICHANB = 6
         BX = 0.34D0
         MQ = 1.82D0
         GOTO 1000
      ENDIF

C D** 1P1
      IF (IPARTY.EQ.223 .OR. IPARTY.EQ.227 .OR.
     *    IPARTY.EQ.231 .OR. IPARTY.EQ.235)     THEN
         FLAG = 5
         ICHANB = 7
         BX = 0.34D0
         MQ = 1.82D0
         GOTO 1000
      ENDIF

C D** 3P2
      IF (IPARTY.EQ.224 .OR. IPARTY.EQ.228 .OR.
     *    IPARTY.EQ.232 .OR. IPARTY.EQ.236)     THEN
         FLAG = 3
         ICHANB = 8
         BX = 0.34D0
         MQ = 1.82D0
         GOTO 1000
      ENDIF
C                                                 b ---> u
C                                                ==========


C  1s  decays  B -> PION
      IF (IPARTY.EQ.21 .OR. IPARTY.EQ.22 .OR. IPARTY.EQ.51) THEN
         FLAG = 0
         ICHANB = 11
         BX = 0.31D0
         MQ = 0.33D0
         GOTO 1000
      ENDIF

C  1s  decays  B -> ETA
      IF (IPARTY.EQ.52) THEN
         FLAG = 0
         ICHANB = 12
         BX = 0.31D0
         MQ = 0.33D0
         GOTO 1000
      ENDIF

C  1s  decays  B -> ETA'
      IF (IPARTY .EQ.53) THEN
         FLAG = 0
         ICHANB = 13
         BX = 0.31D0
         MQ = 0.33D0
         GOTO 1000
      ENDIF

C  3s  decays  B -> RHO or OMEGA
      IF ( IPARTY.EQ.61 .OR. IPARTY.EQ.62 .OR. IPARTY.EQ.91
     *                  .OR. IPARTY.EQ.92 ) THEN
         FLAG = 2
                   ICHANB = 14
         IF(LTRAN) ICHANB = 15
         IF(LLONG) ICHANB = 16
         BX = 0.31D0
         MQ = 0.33D0
         GOTO 1000
      ENDIF

C 3P1 decays  B -> a1,f1,f1' (1++)
      IF ((IPARTY.GE.107.AND.IPARTY.LE.109) .OR.
     *     IPARTY.EQ.259 .OR. IPARTY.EQ.260) THEN
         FLAG = 4
         ICHANB = 17
         BX = 0.31D0
         MQ = 0.33D0
         GOTO 1000
      ENDIF

C  1P1 DECAYS  B -> b1,h1,h1' (1+-)
      IF((IPARTY.GE.265.AND.IPARTY.LE.267) .OR.
     *    IPARTY.EQ.263 .OR. IPARTY.EQ.264) THEN
         FLAG = 5
         ICHANB = 18
         BX = 0.31D0
         MQ = 0.33D0
         GOTO 1000
      ENDIF

C 3P0 DECAYS  B -> a0, f0, f0' (0++)
      IF ((IPARTY.GE.251.AND.IPARTY.LE.253) .OR.
     *     IPARTY.EQ.257 .OR. IPARTY.EQ.258) THEN
         FLAG = 1
         ICHANB = 19
         BX = 0.31D0
         MQ = 0.33D0
         GOTO 1000
      ENDIF

C 3P2 DECAYS  B -> a2,f2,f2' (2++)
      IF((IPARTY.GE.254.AND.IPARTY.LE.256) .OR.
     *    IPARTY.EQ.261 .OR. IPARTY.EQ.262) THEN
         FLAG = 3
         ICHANB = 20
         BX = 0.31D0
         MQ = 0.33D0
         GOTO 1000
      ENDIF

C---------------------------------------------- Set up for B_s decays
 200  CONTINUE
C                                                 b ---> c
C                                                ==========


C 1s  decays  B_s -> D_s
      IF ( IPARTY.GE.31 .AND.IPARTY.LE.32) THEN
         FLAG = 0
         ICHANB = 31
         BX = 0.39D0
         MQ = 1.82D0
         GOTO 1000
      ENDIF

C 3s  decays  B_s -> D_s*
      IF ( IPARTY.GE.71 .AND. IPARTY.LE.72) THEN
         FLAG = 2
                   ICHANB = 32
         IF(LTRAN) ICHANB = 33
         IF(LLONG) ICHANB = 34
         BX = 0.39D0
         MQ = 1.82D0
         GOTO 1000
      ENDIF

C D_s** 3P0
      IF (IPARTY.EQ.237 .OR. IPARTY.EQ.241) THEN
         FLAG = 1
         ICHANB = 35
         BX = 0.34D0
         MQ = 1.82D0
         GOTO 1000
      ENDIF

C D_s** 3P1
      IF (IPARTY.EQ.238 .OR. IPARTY.EQ.242) THEN
         FLAG = 4
         ICHANB = 36
         BX = 0.34D0
         MQ = 1.82D0
         GOTO 1000
      ENDIF

C D_s** 1P1
      IF (IPARTY.EQ.239 .OR. IPARTY.EQ.243) THEN
         FLAG = 5
         ICHANB = 37
         BX = 0.34D0
         MQ = 1.82D0
         GOTO 1000
      ENDIF

C D_s** 3P2
      IF (IPARTY.EQ.240 .OR. IPARTY.EQ.244) THEN
         FLAG = 3
         ICHANB = 38
         BX = 0.34D0
         MQ = 1.82D0
         GOTO 1000
      ENDIF
C                                                 b ---> u
C                                                ==========


C  1s  decays  B_s -> K
      IF (IPARTY.GE.23 .AND. IPARTY.LE.26) THEN
         FLAG = 0
         ICHANB = 41
         BX = 0.31D0
         MQ = 0.33D0
         GOTO 1000
      ENDIF

C 3s  decays  B_s -> K*
      IF ( IPARTY.GE.63 .AND. IPARTY.LE.66) THEN
         FLAG = 2
                   ICHANB = 42
         IF(LTRAN) ICHANB = 43
         IF(LLONG) ICHANB = 44
         BX = 0.31D0
         MQ = 0.33D0
         GOTO 1000
      ENDIF

C 3P1 decays   B_s -> K1(1270)
      IF ((IPARTY.GE. 59.AND.IPARTY.LE.60) .OR.
     *    (IPARTY.EQ.201.AND.IPARTY.LE.202)     ) THEN
         FLAG = 4
         ICHANB = 45
         BX = 0.31D0
         MQ = 0.33D0
         GOTO 1000
      ENDIF

C  1P1 DECAYS  B_s -> K1(1400)
      IF ((IPARTY.GE. 19.AND.IPARTY.LE. 20) .OR.
     *    (IPARTY.EQ.203.AND.IPARTY.LE.204)     )  THEN
         FLAG = 5
         ICHANB = 46
         BX = 0.31D0
         MQ = 0.33D0
         GOTO 1000
      ENDIF

C 3P0 DECAYS   B_s -> K*_0(1430)
      IF (IPARTY.GE.268.AND.IPARTY.LE.271) THEN
         FLAG = 1
         ICHANB = 47
         BX = 0.31D0
         MQ = 0.33D0
         GOTO 1000
      ENDIF

C 3P2 DECAYS   B_s -> K*_2(1430)
      IF (IPARTY.GE.272.AND.IPARTY.LE.275) THEN
         FLAG = 3
         ICHANB = 48
         BX = 0.31D0
         MQ = 0.33D0
         GOTO 1000
      ENDIF

C------------------------------------------- Set up for D0/D+ decays

 300  CONTINUE
C                                                 c ---> s
C                                                ==========

C 1s  decays  D -> K
      IF (IPARTY.GE.23 .AND. IPARTY.LE.26) THEN
         FLAG = 0
         ICHAND = 1
         BX = 0.34D0
         MQ = 0.55D0
         GOTO 1000
      ENDIF

C 3s  decays  D -> K*
      IF ( IPARTY.GE.63 .AND. IPARTY.LE.66) THEN
         FLAG = 2
                   ICHAND = 2
         IF(LTRAN) ICHAND = 3
         IF(LLONG) ICHAND = 4
         BX = 0.34D0
         MQ = 0.55D0
         GOTO 1000
      ENDIF

C 3P1 decays   D -> K1(1270)
      IF ((IPARTY.GE. 59.AND.IPARTY.LE.60) .OR.
     *    (IPARTY.EQ.201.AND.IPARTY.LE.202)     ) THEN
         FLAG = 4
         ICHAND = 5
         BX = 0.34D0
         MQ = 0.55D0
         GOTO 1000
      ENDIF

C  1P1 DECAYS  D -> K1(1400)
      IF ((IPARTY.GE. 19.AND.IPARTY.LE. 20) .OR.
     *    (IPARTY.EQ.203.AND.IPARTY.LE.204)     )  THEN
         FLAG = 5
         ICHAND = 6
         BX = 0.34D0
         MQ = 0.55D0
         GOTO 1000
      ENDIF

C 3P0 DECAYS   D -> K*_0(1430)
      IF (IPARTY.GE.268.AND.IPARTY.LE.271) THEN
         FLAG = 1
         ICHAND = 7
         BX = 0.34D0
         MQ = 0.55D0
         GOTO 1000
      ENDIF

C 3P2 DECAYS   D -> K*_2(1430)
      IF (IPARTY.GE.272.AND.IPARTY.LE.275) THEN
         FLAG = 3
         ICHAND = 8
         BX = 0.34D0
         MQ = 0.55D0
         GOTO 1000
      ENDIF
C
C                                                 c ---> d
C                                                ==========

C  1s  decays  D -> PION
      IF (IPARTY.EQ.21 .OR. IPARTY.EQ.22 .OR. IPARTY.EQ.51) THEN
         FLAG = 0
         ICHAND = 11
         BX = 0.31D0
         MQ = 0.33D0
         GOTO 1000
      ENDIF

C  1s  decays  D -> ETA
      IF (IPARTY.EQ.52) THEN
         FLAG = 0
         ICHAND = 12
         BX = 0.31D0
         MQ = 0.33D0
         GOTO 1000
      ENDIF

C  1s  decays  D -> ETA'
      IF (IPARTY .EQ.53) THEN
         FLAG = 0
         ICHAND = 13
         BX = 0.31D0
         MQ = 0.33D0
         GOTO 1000
      ENDIF

C  3s  decays  D -> RHO or OMEGA
      IF ( IPARTY.EQ.61 .OR. IPARTY.EQ.62 .OR. IPARTY.EQ.91
     *                  .OR. IPARTY.EQ.92 ) THEN
         FLAG = 2
                   ICHAND = 14
         IF(LTRAN) ICHAND = 15
         IF(LLONG) ICHAND = 16
         BX = 0.31D0
         MQ = 0.33D0
         GOTO 1000
      ENDIF

C 3P1 decays  D -> a1,f1,f1' (1++)
      IF ((IPARTY.GE.107.AND.IPARTY.LE.109) .OR.
     *     IPARTY.EQ.259 .OR. IPARTY.EQ.260) THEN
         FLAG = 4
         ICHAND = 17
         BX = 0.31D0
         MQ = 0.33D0
         GOTO 1000
      ENDIF

C  1P1 DECAYS D -> b1,h1,h1' (1+-)
      IF((IPARTY.GE.265.AND.IPARTY.LE.267) .OR.
     *    IPARTY.EQ.263 .OR. IPARTY.EQ.264) THEN
         FLAG = 5
         ICHAND = 18
         BX = 0.31D0
         MQ = 0.33D0
         GOTO 1000
      ENDIF

C 3P0 DECAYS  D -> a0, f0, f0' (0++)
      IF ((IPARTY.GE.251.AND.IPARTY.LE.253) .OR.
     *     IPARTY.EQ.257 .OR. IPARTY.EQ.258) THEN
         FLAG = 1
         ICHAND = 19
         BX = 0.31D0
         MQ = 0.33D0
         GOTO 1000
      ENDIF

C 3P2 DECAYS  D -> a2,f2,f2' (2++)
      IF((IPARTY.GE.254.AND.IPARTY.LE.256) .OR.
     *    IPARTY.EQ.261 .OR. IPARTY.EQ.262) THEN
         FLAG = 3
         ICHAND = 20
         BX = 0.31D0
         MQ = 0.33D0
         GOTO 1000
      ENDIF

C---------------------------------------------- Set up for D_s decays
C
 400  CONTINUE
C                                                 c ---> d
C                                                ==========

C 1s  decays  D_s -> K
      IF (IPARTY.GE.23 .AND. IPARTY.LE.26) THEN
         FLAG = 0
         ICHAND = 31
         BX = 0.31D0
         MQ = 0.33D0
         GOTO 1000
      ENDIF

C 3s  decays  D_s -> K*
      IF ( IPARTY.GE.63 .AND. IPARTY.LE.66) THEN
         FLAG = 2
                   ICHAND = 32
         IF(LTRAN) ICHAND = 33
         IF(LLONG) ICHAND = 34
         BX = 0.31D0
         MQ = 0.33D0
         GOTO 1000
      ENDIF

C 3P1 decays   D_s -> K1(1270)
      IF ((IPARTY.GE. 59.AND.IPARTY.LE.60) .OR.
     *    (IPARTY.EQ.201.AND.IPARTY.LE.202)     ) THEN
         FLAG = 4
         ICHAND = 35
         BX = 0.31D0
         MQ = 0.33D0
         GOTO 1000
      ENDIF

C  1P1 DECAYS  D_s -> K1(1400)
      IF ((IPARTY.GE. 19.AND.IPARTY.LE. 20) .OR.
     *    (IPARTY.EQ.203.AND.IPARTY.LE.204)     )  THEN
         FLAG = 5
         ICHAND = 36
         BX = 0.31D0
         MQ = 0.33D0
         GOTO 1000
      ENDIF

C 3P0 DECAYS   D_s -> K*_0(1430)
      IF (IPARTY.GE.268.AND.IPARTY.LE.271) THEN
         FLAG = 1
         ICHAND = 37
         BX = 0.31D0
         MQ = 0.33D0
         GOTO 1000
      ENDIF

C 3P2 DECAYS   D_s -> K*_2(1430)
      IF (IPARTY.GE.272.AND.IPARTY.LE.275) THEN
         FLAG = 3
         ICHAND = 38
         BX = 0.31D0
         MQ = 0.33D0
         GOTO 1000
      ENDIF

C                                                 c ---> s
C                                                ==========
C  1s  decays  D_s -> ETA
      IF (IPARTY.EQ.52) THEN
         FLAG = 0
         ICHAND = 41
         BX = 0.34D0
         MQ = 0.55D0
         GOTO 1000
      ENDIF

C  1s  decays  D_s -> ETA'
      IF (IPARTY .EQ.53) THEN
         FLAG = 0
         ICHAND = 42
         BX = 0.34D0
         MQ = 0.55D0
         GOTO 1000
      ENDIF

C  3s  decays  D_s -> PHI
      IF ( IPARTY.EQ.93) THEN
         FLAG = 2
                   ICHAND = 43
         IF(LTRAN) ICHAND = 44
         IF(LLONG) ICHAND = 45
         BX = 0.34D0
         MQ = 0.55D0
         GOTO 1000
      ENDIF

C 3P1 decays  D_s -> f1,f1' (1++)
      IF (IPARTY.EQ.259 .OR. IPARTY.EQ.260) THEN
         FLAG = 4
         ICHAND = 46
         BX = 0.34D0
         MQ = 0.55D0
         GOTO 1000
      ENDIF

C  1P1 DECAYS D_s -> h1,h1' (1+-)
      IF(IPARTY.EQ.263 .OR. IPARTY.EQ.264) THEN
         FLAG = 5
         ICHAND = 47
         BX = 0.34D0
         MQ = 0.55D0
         GOTO 1000
      ENDIF

C 3P0 DECAYS  D_s -> f0, f0' (0++)
      IF (IPARTY.EQ.257 .OR. IPARTY.EQ.258) THEN
         FLAG = 1
         ICHAND = 48
         BX = 0.34D0
         MQ = 0.55D0
         GOTO 1000
      ENDIF

C 3P2 DECAYS  D_s -> f2,f2' (2++)
      IF(IPARTY.EQ.261 .OR. IPARTY.EQ.262) THEN
         FLAG = 3
         ICHAND = 49
         BX = 0.34D0
         MQ = 0.55D0
         GOTO 1000
      ENDIF


 1000 CONTINUE

C--  Return, if the decay channel is not installed





C-- INITIAL MESON B

      IF(KIDP.GE.33.AND.KIDP.LE.38)THEN
        BB = 0.41D0
        LSIGN  = -1.D0
        MB = 5.12D0
      ELSE IF(KIDP.GE.27.AND.KIDP.LE.32)THEN
        BB=0.39D0
        MB=1.82D0
        LSIGN=+1.D0
      ENDIF

      CONST=2.0853215D11
      CONST=CONST*(BM**4)
      KAPA = 0.70D0
      SHIFT(1) = 1.D0
      SHIFT(2) = 1.D0
      SHIFT(3) = 1.D0
      KPA(1) = 0.7D0
      KPA(2) = 0.7D0
      KPA(3) = 0.7D0
      XMIN = 0.D0
      YMIN = 0.D0
      FMIN = 0.D0

      IF(ITYPEQ.EQ.1) THEN
        FMAX = FMAXB(ICHANB)
      ELSE
        FMAX = FMAXD(ICHAND)
      ENDIF

C
C       GENERATE X , Y , GAMMA (X,Y)
C       X = P_E/M_B
C       Y = Q^2/M_B^2
C       GAMMA(X,Y) = DIFFERENTIAL CROSS SECTION ACCORDING TO ISGUR MODEL
C
      ITIMER=0

C     FIRST GENERATE DAUGHTERS IN B REST FRAME AND FLAT ACROSS
C     THE DALITZ PLOT.  THIS USES THE CORRECT DAUGHTER MASSES.
      TO(1) = 0.
      TO(2) = 0.
      TO(3) = 0.
      TO(4) = BM
      MATPS = 0
 600  CALL PHSP( TO, BM, MATPS, ND, XM, PCM )

C     X AND YRAN ARE NEEDED BY QQDCS
      QSQ = (PCM(4,1)+PCM(4,2))**2 - (PCM(1,1)+PCM(1,2))**2 - 
     +      (PCM(2,1)+PCM(2,2))**2 - (PCM(3,1)+PCM(3,2))**2
      IF ( QSQ .LT. 0. ) QSQ = 0.
      X = PCM(4,2)/BM
      YRAN = QSQ/(BM)**2

C     COMPUTE NORMALIZED MATRIX ELEMENT SQUARED AND SAVE SOME STATS.
      FFUN = CONST*QQDCS(YRAN)
      FFUN = FFUN/FMAX
      ITIMER=ITIMER+1
#if defined(NONCLEO_DOUBLE)
      FFUN1=FFUN
#else
      FFUN1=SNGL(FFUN)
#endif

C     DO WE KEEP THIS CONFIGURATION?
      FRAN = RANP(0)
      IF(FRAN.GT.FFUN)GO TO 600

C LORENTZ TRANSFORMATION TO LABORATORY SYSTEM
      DO 666 J=1,4
        TO(J)=T(J)
666   CONTINUE
C     TYPE *,'TO ' ,(TO(J),J=1,4)
      PPD = SQRT(TO(1)**2+TO(2)**2+TO(3)**2)
      IF(PPD.EQ.0)RETURN

      CALL BOOSTF(TO,3,PCM,PQ)

C     TYPE *,'PQ ' ,(PQ(J,3),J=1,4)
      ND=3
      RETURN
      END
