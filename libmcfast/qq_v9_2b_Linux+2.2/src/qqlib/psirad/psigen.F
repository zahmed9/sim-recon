*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:40  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:37  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 04/10/94  22.12.57  by  Paul Avery
*CMZ :  1.03/60 16/03/93  11.56.38  by  Peter C Kim
*CMZ :  1.03/57 15/02/93  15.56.28  by  Peter C Kim
*-- Author :         D. Coffman              15/02/93
      SUBROUTINE PSIGEN(P4PSI, MPSI, MATRX,
     *                  KLOW,  ML,   P4LP,
     *                  P4LM,  P4G,  ND,
     *                  LMODE)
C.......................................................................
C. PSIGEN - Generate 4-momenta for the decay J/psi --> l+ l- (photon)
C.
C. Inputs    :
C.      MPSI    Mass of J/psi
C.      P4PSI   Four momentum of J/psi
C.      MATRX   Specification of polarization
C.      KLOW    Low energy cut-off parameter
C.      ML      Mass of lepton
C.      LMODE   Flag for type of leptons to be produced
C.
C. Outputs   :
C.      P4LP    Four momentum of positive lepton
C.      P4LM    Four momentum of negative lepton
C.      P4G     Four momentum of photon (if generated)
C.      ND      No. of daughters produced
C.
C. Calls     : DKPSIS, DKPSIH
C. Called    : PSILLG
C.
C... This routine decays a (possibly) polarized J/psi to a lepton pair.
C... O(alpha) radiative corrections are included.
C... The polarization is specified through the value of MATRX:
C...   MATRX = 41 ==> No polarization
C...   MATRX = 42 ==> Transverse polarization   (helicity = +/- 1)
C...   MATRX = 43 ==> Longitudinal polarization (helicity = 0)
C...
C...        D. Coffman 1/29/93
C.......................................................................
#if defined(CLEO_TYPECHECK)
      IMPLICIT NONE
#endif
C
C Declare the arguments
C

      DOUBLE PRECISION P4PSI(4)
      DOUBLE PRECISION MPSI
      INTEGER          MATRX
      DOUBLE PRECISION KLOW
      DOUBLE PRECISION ML
      DOUBLE PRECISION P4LP(4)
      DOUBLE PRECISION P4LM(4)
      DOUBLE PRECISION P4G(4)
      INTEGER          ND
      INTEGER          LMODE

C
C Declare the random number generator
C

      INTEGER  ISEED
      COMMON/RANDM/ISEED
      REAL     RANP
      EXTERNAL RANP

C
C If the same random number is needed more than once, its value is stored
C in the variable rho
C

      REAL RHO

C
C P0 is the 4-momentum of the J/psi in its own rest frame.
C

      DOUBLE PRECISION P0(4)

C
C The J/psi helicity is given by the parameter
C     lambda = inner_product_of J/psi momentum and spin_direction
C

      INTEGER   LAMBDA
      REAL      ONEOF3,           TWOOF3
      PARAMETER(ONEOF3 = 1.0/3.0, TWOOF3 = 2.0/3.0)

C
C The approximate --- guessed! --- values of the soft and hard decay
C rates are given here. Note that the values are in fact a guess at the
C RATIO of these rates.  The values given, as long as they are not
C zero, do not effect the final result, just the efficiency of the
C final weighted-rejection step.  (This step is indicated in the code.)
C The values given here are appropriate for a soft photon cut-off
C of 1 MeV.
C

      DOUBLE PRECISION GS(2) / 0.5D0, 0.8D0 /
      DOUBLE PRECISION GH(2) / 0.8D0, 0.2D0 /
      SAVE GS, GH

C
C These functions do the actual simulation:
C    DKPSIS = decay J/psi without an additional photon
C    DKPSIH = decay J/psi with an additional photon of energy greater
C             than the cut-off value.
C The values returned are appropriate weights.
C

      DOUBLE PRECISION DKPSIS, DKPSIH

C
C These two variables are used for the final weighted-rejection step.
C    weight is based on the value returned by decay function.
C    maxwgt is the maximum value of this weight; its value is determined
C    by trial-and-error.  In other words, its value was set to a very
C    small value, and a very large sample of events generated.
C

      DOUBLE PRECISION WEIGHT
      DOUBLE PRECISION MAXWGT(2) / 0.01342D0, 0.01300D0 /
      SAVE   MAXWGT

C
C The final state momenta have to be rotated into the lab frame coordinate
C system.  The magnitude of the rotation is given in these variables.
C

      DOUBLE PRECISION PAMAG
      DOUBLE PRECISION COSTHA, SINTHA
      DOUBLE PRECISION COSPHA, SINPHA
      DOUBLE PRECISION PCX, PCY, PCZ

C
C This common was used during the above procedure.  In normal operation,
C it should remain "commented out".
C

C      DOUBLE PRECISION MAXWGT(2)
C      COMMON /WGTMAX/ MAXWGT

C
C This common is testing, debugging,  purposes
C

      DOUBLE PRECISION PSVOL, SUMPS
      DOUBLE PRECISION GAM0,  GAMS,  GAMH
      DOUBLE PRECISION SUM0,  SUMS,  SUMH
      DOUBLE PRECISION SUM20, SUM2S, SUM2H
      INTEGER           NUMW,  NUMS,  NUMH
      COMMON /TESTIT/ GAM0,   GAMS,  GAMH,
     +                SUM0,   SUMS,  SUMH,
     +                SUM20,  SUM2S, SUM2H,
     +                PSVOL,  SUMPS,
     +                NUMW,   NUMS,  NUMH


C---------------------------------------------------------------
C Executable code starts here
C---------------------------------------------------------------

C
C Select the helicity based on the value of MATRX supplied
C

      IF(MATRX .EQ. 43) THEN
        LAMBDA = 0

      ELSE IF(MATRX .EQ. 42) THEN
        IF(RANP(ISEED) .GE. 0.5) THEN
          LAMBDA =  1
        ELSE
          LAMBDA = -1
        ENDIF

      ELSE IF(MATRX .EQ. 41) THEN
        RHO = RANP(ISEED)

        IF(RHO .LE. ONEOF3) THEN
          LAMBDA =  1
        ELSE IF(RHO .LE. TWOOF3) THEN
          LAMBDA =  0
        ELSE
          LAMBDA = -1
        ENDIF

      ENDIF

C
C This is the top of the event generation loop:
C

 100  CONTINUE
      NUMW = NUMW + 1

C
C Load up the initial momentum
C

      P0(1) = 0.0D0
      P0(2) = 0.0D0
      P0(3) = 0.0D0
      P0(4) = MPSI

C
C Decide whether to generate a soft or hard event, then perform the
C generation.
C

        IF(RANP(ISEED) .LE. GS(LMODE)/(GS(LMODE) + GH(LMODE))) THEN


C
C "Soft" or non-radiative event:
C

          WEIGHT = DKPSIS(P0,    MPSI, LAMBDA,
     +                    KLOW,  ML,   P4LP,   P4LM)

C
C Update the counters
C

          SUM0  = SUM0  + GAM0
          SUM20 = SUM20 + GAM0**2
          SUMS  = SUMS  + GAMS
          SUM2S = SUM2S + GAMS**2
          NUMS  = NUMS  + 1

C
C Correct the weight
C

          WEIGHT = WEIGHT * (GS(LMODE) + GH(LMODE))/GS(LMODE)

C
C Save the number of daughter particles
C

          ND = 2

        ELSE

C
C "Hard" or radiative event:
C

          WEIGHT = DKPSIH(P0,    MPSI, LAMBDA,
     +                    KLOW,  ML,   P4LP,
     +                    P4LM,  P4G)

          SUMH  = SUMH  + GAMH
          SUM2H = SUM2H + GAMH**2
          SUMPS = SUMPS + PSVOL
          NUMH  = NUMH + 1

          WEIGHT = WEIGHT * (GS(LMODE) + GH(LMODE))/GH(LMODE)
          ND     = 3

        ENDIF


C
C The next line is used for determining the maximum weight
C

C        MAXWGT(LMODE) = DMAX1(MAXWGT(LMODE), WEIGHT)

C
C This is the final weighted-rejection step
C

        IF(RANP(ISEED) .GT. WEIGHT/MAXWGT(LMODE)) GOTO 100

C
C The event is accepted!
C So far, all quantities have been defined in the J/psi rest frame.
C Now rotate the 4-momenta into the lab frame coordinate system.
C

      PAMAG = DSQRT(P4PSI(1)**2 + P4PSI(2)**2 + P4PSI(3)**2)
      IF(PAMAG .NE. 0.0D0) THEN

        COSTHA  = P4PSI(3)/PAMAG
        SINTHA  = DMAX1(-1.0D0, DMIN1(1.0D0, DSQRT(1.0D0 - COSTHA**2)))
        COSPHA  = P4PSI(1)/(PAMAG*SINTHA)
        SINPHA  = P4PSI(2)/(PAMAG*SINTHA)

        PCX     = P4LP(1)
        PCY     = P4LP(2)
        PCZ     = P4LP(3)

        P4LP(1) =  PCX*COSTHA*COSPHA - PCY*SINPHA + PCZ*SINTHA*COSPHA
        P4LP(2) =  PCX*COSTHA*SINPHA + PCY*COSPHA + PCZ*SINTHA*SINPHA
        P4LP(3) = -PCX*SINTHA                     + PCZ*COSTHA


        PCX     = P4LM(1)
        PCY     = P4LM(2)
        PCZ     = P4LM(3)

        P4LM(1) =  PCX*COSTHA*COSPHA - PCY*SINPHA + PCZ*SINTHA*COSPHA
        P4LM(2) =  PCX*COSTHA*SINPHA + PCY*COSPHA + PCZ*SINTHA*SINPHA
        P4LM(3) = -PCX*SINTHA                     + PCZ*COSTHA

        IF(ND .EQ. 3) THEN

          PCX     = P4G(1)
          PCY     = P4G(2)
          PCZ     = P4G(3)

          P4G(1)  =  PCX*COSTHA*COSPHA - PCY*SINPHA + PCZ*SINTHA*COSPHA
          P4G(2)  =  PCX*COSTHA*SINPHA + PCY*COSPHA + PCZ*SINTHA*SINPHA
          P4G(3)  = -PCX*SINTHA                     + PCZ*COSTHA

        ENDIF

      ENDIF

C
C Boost the momenta to the lab frame.
C

      CALL EBOOST(MPSI, P4PSI, P4LP)
      CALL EBOOST(MPSI, P4PSI, P4LM)

      IF(ND .EQ. 3) THEN
        CALL EBOOST(MPSI, P4PSI, P4G)
      ENDIF


C
C That's it!
C

      RETURN
      END

