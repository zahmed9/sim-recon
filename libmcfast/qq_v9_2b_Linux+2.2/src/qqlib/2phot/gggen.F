*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:33  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:35  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 22/09/94  00.22.51  by  Paul Avery
*CMZ :  1.03/15 25/04/91  18.09.47  by  R.A.FULTON
*-- Author :
* 16/10/96 Lynn Garren: Add double precision conditionals.
      SUBROUTINE GGGEN(PRTEPA)
C****************************************************************
C two-photon generation in the equivalent photon approximation.
C transverse momenta for all states are included. the photon
C spectrum is keyed to the hadronic model requested. this im-
C proves the efficiency of the overall monte carlo.
C****************************************************************
#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqevnt.inc"
#include "qqlib/gggseq/ggconst.inc"
#include "qqlib/gggseq/ggmodl.inc"
#include "qqlib/gggseq/ggprms.inc"
#include "qqlib/gggseq/sintag.inc"
#include "qqlib/gggseq/fragmt.inc"
#include "qqlib/gggseq/wgtsum.inc"
#include "qqlib/gggseq/genarg.inc"
C..PRTEPA  - Locical to printout EPA statistics
C..G14V      - 1st gamma 4-vector
C..G24V      - 2nd gamma 4-vector
C..E14V      - 1st electron 4-vector
C..E24V      - 2nd electron 4-vector
C..IC1       - 1st electron charge
C..IC2       - 2nd electron charge

        LOGICAL  PRTEPA

        LOGICAL  FIRST, LANG
#if defined(NONCLEO_DOUBLE)
        DOUBLE PRECISION     THET1,THET2, OM1,OM2, YL2G
        INTEGER  I
        DOUBLE PRECISION     ANGCUT, ST1, ST2, STMP
        DOUBLE PRECISION     AC12, AG1, BETA, BOUND, C12, CORR
        DOUBLE PRECISION     CT1, CT2, CTST, DUM, DW, E1PT, E2PT
        DOUBLE PRECISION     E13, E1P, E2P
        DOUBLE PRECISION     EPSM, FRAC, FI1, FI2
        DOUBLE PRECISION     FI12, G1TM2, GAM, GFAC, OTMP
        DOUBLE PRECISION     PE, PE1, PE2, PHASE, PP, PSGN, PTE1, PTE2
        DOUBLE PRECISION     QQ1, QQ2, RHO, TDIF, TAGCOR
        DOUBLE PRECISION     WCMS, W2CMS, W2GPRE, WGT, WTEST
        DOUBLE PRECISION     WTST, WW, XX, YMAX

        DOUBLE PRECISION     QGCM
        COMMON /QFF/ QGCM
#else
        REAL     THET1,THET2, OM1,OM2, YL2G
        INTEGER  I
        REAL     ANGCUT, ST1, ST2, STMP
        REAL     AC12, AG1, BETA, BOUND, C12, CORR
        REAL     CT1, CT2, CTST, DUM, DW, E1PT, E2PT
        REAL     E13, E1P, E2P
        REAL     EPSM, FRAC, FI1, FI2
        REAL     FI12, G1TM2, GAM, GFAC, OTMP
        REAL     PE, PE1, PE2, PHASE, PP, PSGN, PTE1, PTE2
        REAL     QQ1, QQ2, RHO, TDIF, TAGCOR
        REAL     WCMS, W2CMS, W2GPRE, WGT, WTEST
        REAL     WTST, WW, XX, YMAX

        REAL     QGCM
        COMMON /QFF/ QGCM
#endif

C..EXTERNAL::
        REAL       RANP, GGLKUP, EPA, EPA1TG, EPA2TG
        EXTERNAL   RANP, GGLKUP, EPA, EPA1TG, EPA2TG

        DATA FIRST /.TRUE./
C*****************************************************
C Get initial beam energies
      EPB1  = ECM/2.
      EPB2  = ECM/2.
      WCMS  = 2.*EPB1
      W2CMS = WCMS**2


C......START OF LOOP
 1    TRY2G = TRY2G + 1.
 3    CONTINUE
      XX    = RANP(DUM)
C TARGET FOR THROW-AWAY FAILURES
      ANGCUT = 2.0*(XME/ECM)**2
      GFAC   = LOG((SSQMX+ANGCUT)/(SSQMN+ANGCUT))

C*****
C MODEL DEPENDENT SECTION COMES FIRST. GENERATE
C W2G (MASS**2, I.E. S) ACCORDING TO MODE2G.

      IF((MODE2G .EQ. 0) .OR.
     +         (MODE2G .EQ. 5 .AND. X2G1 .EQ. 0.0))THEN
C      1/S spectrum
         IF(MODE2G.NE.5)THEN
            W2G=WMN2G*EXP(XX*D2GW)
         ELSE
            W2G=WMN2G*EXP(XX*D2GW/X2G0)
            IF(F2TYPE.EQ.4)W2G=1./(1./(WMN2G)-XX*D2GW/X2G0)
         ENDIF
         IF(W2G .GE. W2CMS)GOTO 1
      ELSEIF((MODE2G.EQ.1) .OR. (MODE2G.EQ.2))THEN
C          point pair spectrum that includes point cross section.
C          solution is interpolated from table.
         FRAC  = XX*GGAREA/YLTH2G
         BOUND = 1./WMX2G
         W2G   = 1./GGLKUP(FRAC,BOUND)
      ELSEIF(MODE2G.EQ.3)THEN
C      Breit Wigner for resonance. interpolated from table.
         W2G=XMRS2G**2
         IF(WMRS2G .GT. 0.0001)THEN
            FRAC=XX*XSINT(NSTPSD)
            PHASE=GGLKUP(FRAC,TBMI2G)
            W2G=XMRS2G**2+WMRS2G*TAN(PHASE)
         ENDIF
      ELSE
C      combination of 1/w and 1/w**2. use newton method to invert
C      integral eqt'n.
         W2G=1./WMN2G-XX*(1./WMN2G-1./WMX2G)
         W2G=1./W2G
         W2GPRE=W2G
         DO 10 I=1,5
           DW=X2G0/W2G+X2G1/W2G**2
           WW=X2G0*ALOG(W2G/WMN2G)+X2G1*(1./WMN2G-1./W2G)-XX*D2GW
           W2G=(W2G*DW-WW)/DW
           IF(ABS(W2GPRE/W2G-1.).LT.0.005)GOTO 11
           W2GPRE=W2G
 10      CONTINUE
      ENDIF
 11   CONTINUE

C     now generate rapidity variable
      YL2G = (0.5-RANP(DUM))*YLTH2G
      BETA = TANH(YL2G)
      GAM  = (1.-BETA)/(1.+BETA)
C*****
C COMPUTE REMAINDER OF THE SPECTRUM. USE THROW-AWAY TECHNIQUE
C ON EPA FORMULAE.
C*****
C BRANCH TO FORMULA APPROPRIATE TO GIVEN LEVEL OF TAGGING
      IC1 = 1
      IF(RANP(DUM).GT.0.5)IC1 = -1
      PSGN = -FLOAT(IC1)
      IC2 = -IC1
      GOTO (100,200,300),NTAG2G + 1
C
C NO TAG CASE. USE FACTORIZED EPA (DALITZ-YENNIE).
C PHOTONS ARE ASSUMED TO BE MASSLESS
  100 CONTINUE
C PHOTON ANGLES FROM BKT EQ'TN 3.7
      ST1 = XME*EXP(D2GTH*RANP(DUM))/EPB1
      ST2 = XME*EXP(D2GTH*RANP(DUM))/EPB2
      T1  = ASIN( ST1 )
      T2  = ASIN( ST2 )
      CT1  =  PSGN*COS(T1)
      CT2  = -PSGN*COS(T2)
      FI1  = TWOPI*RANP(DUM)
      FI2  = TWOPI*RANP(DUM)
      FI12 = FI1 - FI2
C COSINE OF ANGLE BETWEEN PHOTONS
      C12=ST1*ST2*COS(FI1-FI2)+CT1*CT2
C COMPUTE PHOTON ENERGIES
      OM1=SQRT(W2G/(2.*GAM*(1.-C12)))
      OM2=GAM*OM1
C
C...MORE GENERAL RELATIONSHIP BETWEEN ANGLES AND ENERGIES
C     RHO = BETA
C     RHO = 2*RHO*(1.+C12)/((1.-C12)*(1.+RHO))
C     OM1 = SQRT((RHO*(1-C12)-(1.+GAM)*(1.+C12))**2+
C    +   2.*(1.-C12)*GAM*(2.*(1.+C12)*(1.+RHO)+W2G/(EPB1*EPB2)))
C     OM1 = OM1-(1.+GAM)*(1.+C12)+RHO*(1.-C12)
C     OM1 = EPB1*OM1/(2.*(1.-C12)*GAM)
C     OM2 = GAM*OM1-RHO*EPB2
C
C THROW-AWAY INCOMPATABLY THROWN VARIABLES
      IF(OM1.GT.EPB1-XME)GOTO 1
      IF(OM2.GT.EPB2-XME)GOTO 1
C...    STUFF FOR MORE GENERAL MODELS
      T1 = EPB1**2 - XME**2
      T1 = T1 + OM1**2 - PSGN*2.0*SQRT(T1)*OM1*CT1
      IF(T1.LE.0.0)T1 = 0.0
      T1 = SQRT(T1)
      IF(T1.GT.0.0)THEN
        T1 = OM1*ST1/T1
        IF(ABS(T1).LE.1.0)T1 = ASIN( T1 )
        IF(ABS(T1).GT.1.0)T1 = PI/2.0
      ENDIF
      T2 = EPB2**2 - XME**2
      T2 = T2 + OM2**2 + PSGN*2.0*SQRT(T2)*OM2*CT2
      IF(T2.LE.0.0)T2 = 0.0
      T2 = SQRT(T2)
      IF(T2.GT.0.0)THEN
        T2 = OM2*ST2/T2
        IF(ABS(T2).LE.1.0)T2 = ASIN( T2 )
        IF(ABS(T2).GT.1.0)T2 = PI/2.0
      ENDIF
      IF(T1.LT.T2)THEN
        STMP  = T1
        T1    = T2
        T2    = STMP
        OTMP  = OM1
        OM1   = OM2
        OM2   = OTMP
      ENDIF
        IF(T1 .LT. T3MIN)T3MIN = T1
        IF(T1 .GT. T3MAX)T3MAX = T1
C...
C EPA WEIGHT
      WGT=EPA(EPB1,EPB2,W2G,OM1,OM2)*WGTCOR
      IF(WGT.LE.0.0)GOTO 1
      WGTVAL = DBLE(WGT)
      WSUM = WSUM + DBLE(WGT)
      WSUMSQ = WSUMSQ + DBLE(WGT*WGT)
      WTST=RANP(DUM)*EPAMAX
      IF(WTST.GE.WGT)GOTO 1
C THESE LOOK O.K....COMPUTE 4-VECTORS
C       PRINT *,'  T1, T2 = ',T1,T2
C**********************************************************
C...NEW FOUR VECTOR DEFINITIONS                           *
C**********************************************************
      E14V(4) =  EPB1-OM1
      PE1   =  SQRT(E14V(4)**2-XME**2)
      PTE1  =  PE1*SIN(T1)
      E14V(1) = -PTE1*COS(FI1)
      E14V(2) = -PTE1*SIN(FI1)
      E14V(3) =  PSGN*PE1*COS(T1)
      E14V(4) =  SQRT(E14V(1)**2+E14V(2)**2+E14V(3)**2+XME**2)

      E24V(4) =  EPB2-OM2
      PE2   =  SQRT(E24V(4)**2-XME**2)
      PTE2  =  PE2*SIN(T2)
      E24V(1) = -PTE2*COS(FI2)
      E24V(2) = -PTE2*SIN(FI2)
      E24V(3) = -PSGN*PE2*COS(T2)
      E24V(4) =  SQRT(E24V(1)**2+E24V(2)**2+E24V(3)**2+XME**2)

      G14V(1) =  -E14V(1)
      G14V(2) =  -E14V(2)
      G14V(3) =   PSGN*EPB1 - E14V(3)
      G14V(4) =   EPB1 - E14V(4)

      G24V(1) =  -E24V(1)
      G24V(2) =  -E24V(2)
      G24V(3) =  -PSGN*EPB2 - E24V(3)
      G24V(4) =   EPB2 - E24V(4)

C**********************************************************
      WTEST = ( G14V(4)+G24V(4) )**2 - ( G14V(1)+G24V(1) )**2
     +         -( G14V(2)+G24V(2) )**2 - ( G14V(3)+G24V(3) )**2
      IF(WTEST.LT.WMN2G)GOTO 100
      W2G = WTEST
      GOTO 500
C
C SINGLE TAG CASE. GENERATE TAGGED ELECTRON ANGLE AS 1/THETA.
C THEN USE FORMULA (11) FROM J. FIELD, DESY 79/78.
  200 CONTINUE
C...MODELS F2TYPE = 3,4,6,7,8 ARE THE SAME, SO TAKE THEM AS DEFAULT.
      IF(F2TYPE.NE.1 .AND. F2TYPE.NE.2 .AND. F2TYPE.NE. 5)THEN
      THET1 = 2.*ASIN(STBEGN*EXP(RANP(DUM)*DTAG1))
      ENDIF
      IF(F2TYPE.EQ.1)THET1=2.*ASIN(STBEGN/SQRT(1.-RANP(DUM)*DTAG1))
      IF(F2TYPE.EQ.2)THET1=2.*ASIN(STBEGN/(1.-RANP(DUM)*DTAG1))
      IF(F2TYPE.EQ.5)THET1=2.*ASIN(STBEGN/SQRT(1.-RANP(DUM)*DTAG1))
      T1 = THET1
      IF(T1.LT.0.0)T1 = PI + T1
      CT1=COS(T1)
      ST1=SIN(T1)
  201  T2= ((SSQMN + ANGCUT)*EXP(RANP(DUM)*GFAC) - ANGCUT)/2.
       IF(T2.LE.0.0)T2 = 0.0
       IF(T2.GT.0.0)T2 = 2.*ASIN(SQRT(T2))
      LANG = .FALSE.
      ST2=SIN(T2)
      CT2=-COS(T2)
      FI1=TWOPI*RANP(DUM)
      FI2=TWOPI*RANP(DUM)
C ANGLE BETWEEN OUTGOING ELECTRONS
      C12  = ST1*ST2*COS(FI1-FI2)+CT1*CT2
      AC12 = (1.+C12)/2.
      YMAX = 0.5*ABS(LOG( AC12+(1.-AC12)*W2G/(4.*EPB1*EPB2) ))
C PUT IN INTEGRATION BOUNDARIES FOR "RAPIDITY"
      IF( ABS(YL2G).GT.YMAX )GOTO 1
C GENERALIZE RAPIDITY TO INCLUDE Q**2 OF TAGGED PHOTON. NOTE
C THIS DOES NOT INVOLVE ANY FURTHER APPROXIMATIONS.
      RHO=BETA
      RHO=2*RHO*(1.+C12)/((1.-C12)*(1.+RHO))
      OM1=SQRT((RHO*(1-C12)-(1.+GAM)*(1.+C12))**2+
     +   2.*(1.-C12)*GAM*(2.*(1.+C12)*(1.+RHO)+W2G/(EPB1*EPB2)))
      OM1=OM1-(1.+GAM)*(1.+C12)+RHO*(1.-C12)
      OM1=EPB1*OM1/(2.*(1.-C12)*GAM)
      OM2=GAM*OM1-RHO*EPB2
C
C THROW-AWAY INCOMPATABLE RESULTS
      IF(OM1.GT.EPB1-XME)GOTO 1
      IF(OM2.GT.EPB2-XME)GOTO 1
      IF(OM1.LE.0.)GOTO 1
      IF(OM2.LE.0.)GOTO 1
C
      E14V(4)=EPB1-OM1
      E24V(4)=EPB2-OM2
C*******************CORRECTION FOR ANGULAR DEPENDENCE*****
C     IF(.NOT.LANG)GOTO 202
      CORR = 2.*(SIN(T2/2.))**2
      EPSM = (XME*OM2)**2/(2.*EPB2*E24V(4)**3)
      CORR = (ANGCUT + CORR)/(EPSM + CORR)
      IF(EPSM.LT.ANGCUT)LANG = .TRUE.
      IF(LANG) ANGCUT = EPSM
      IF(LANG) GFAC   = LOG((SSQMX+ANGCUT)/(SSQMN+ANGCUT))
      IF(LANG)GOTO 201
      CTST=RANP(DUM)
      IF(CTST.LE.CORR)GOTO 202
      ANGCUT = EPSM
      GFAC   = LOG((SSQMX+ANGCUT)/(SSQMN+ANGCUT))
      GOTO 201
C*********************************************************
 202  CONTINUE
      PE=SQRT(E14V(4)**2-XME**2)
      E1PT=PE*ST1
      QQ1=-2.*(EPB1-XME)*PE*(1.-CT1)
      G1TM2=QQ1+E1PT**2
      IF(OM1**2.LT.G1TM2)GOTO 1
C
      PP=SQRT(E24V(4)**2-XME**2)
      E2PT=PP*ST2
C ELECTRON AND PHOTON 4-VECTORS. RANDOMLY SELECT E+ OR E- TAG
      E14V(1)=E1PT*COS(FI1)
      E14V(2)=E1PT*SIN(FI1)
      E13=PSGN*PE*CT1
C
      E24V(1)=E2PT*COS(FI2)
      E24V(2)=E2PT*SIN(FI2)
      E24V(3)=PSGN*PP*CT2
C G14V IS PHOTON EMITTED FROM TAGGED LEPTON
      G14V(1) = -E14V(1)
      G14V(2) = -E14V(2)
      G14V(3) =  EPB1*PSGN  - E13
      G14V(4) =  OM1
C
      G24V(1) = -E24V(1)
      G24V(2) = -E24V(2)
      G24V(3) = -EPB2*PSGN  - E24V(3)
      G24V(4) =  OM2
      E1P = E14V(4)
      E2P = E24V(4)

      THET2=ATAN2(SQRT(E24V(1)**2+E24V(2)**2),-PSGN*E24V(3))
C     WRITE(6,301)T2,THET2
C 301 FORMAT(1X,' GGGEN: UNTAGGED ANGLES = ',2(G12.6,2X))
      TDIF = 100.*(THET1 - T1 )/T1
      IF(THET2.GT. ANGUNT)GOTO 1
      IF(T1 .LT. T3MIN)T3MIN = T1
      IF(T1 .GT. T3MAX)T3MAX = T1
      TAGCOR = 1.0
C...EPA WEIGHT
      WGT=EPA1TG(EPB1,EPB2,W2G,OM1,OM2,T1)
      WGT=WGT*TAGCOR*WGTCOR
      IF(WGT.LE.0.0) WGT = 0.0
      IF(WGT.EQ.0.0)GOTO 1
      WGTVAL = DBLE(WGT)
      WSUM = WSUM + DBLE(WGT)
      WSUMSQ = WSUMSQ + DBLE(WGT*WGT)
      WTST=RANP(DUM)*EPAMAX
      IF(WTST.GE.WGT)GOTO 1
      IF(T1 .LT. T1MIN)T1MIN = T1
      IF(T2 .GT. T2MAX)T2MAX = T2
      EPB1=ECM/2.
      EPB2=ECM/2.

      GOTO 500
C
C DOUBLE TAG CASE
C GENERATE ELECTRON ANGLES WITH 1/THETA AND ISOTROPIC
C RELATIVE AZIMUTH. THEN USE EQT'N (9) FROM J. FIELD. NOTE: IN
C THIS GAME T1 AND T2 ARE MEASURED WRT INCIDENT LEPTON DIRECTION.
  300 CONTINUE
      T1=2.*ASIN(SQRT(DT1BGN*EXP(RANP(DUM)*D1GTH) - DTCNST))
      T2=2.*ASIN(SQRT(DT2BGN*EXP(RANP(DUM)*D2GTH) - DTCNST))
C---
      IF(T1.LT.T2)THEN
        STMP = T1
        T1   = T2
        T2   = STMP
      ENDIF
      CT1  =  COS(T1)
      CT2  = -COS(T2)
      FI12 = TWOPI*RANP(DUM)
C COS OF ANGLE BETWEEN OUTGOING ELECTRONS
      C12  = SIN(T1)*SIN(T2)*COS(FI12) + CT1*CT2
      AC12 = (1.+C12)/2.
C---
      YMAX = 0.5*ABS(LOG( AC12+(1.-AC12)*W2G/(4.*EPB1*EPB2) ))
C PUT IN INTEGRATION BOUNDARIES FOR "RAPIDITY"
      IF( ABS(YL2G).GT.YMAX )GOTO 1
C GENERALIZE RAPIDITY TO INCLUDE Q**2 OF TAGGED PHOTON. NOTE
C THIS DOES NOT INVOLVE ANY FURTHER APPROXIMATIONS.
      RHO=BETA
      RHO=2*RHO*(1.+C12)/((1.-C12)*(1.+RHO))
      OM1=SQRT((RHO*(1-C12)-(1.+GAM)*(1.+C12))**2+
     +   2.*(1.-C12)*GAM*(2.*(1.+C12)*(1.+RHO)+W2G/(EPB1*EPB2)))
      OM1=OM1-(1.+GAM)*(1.+C12)+RHO*(1.-C12)
      OM1=EPB1*OM1/(2.*(1.-C12)*GAM)
      OM2=GAM*OM1-RHO*EPB2
C THROW-AWAY INCOMPATABLE RESULTS
      IF(OM1.GT.EPB1-XME)GOTO 1
      IF(OM2.GT.EPB2-XME)GOTO 1
      IF(OM1.LE.0.)GOTO 1
      IF(OM2.LE.0.)GOTO 1
      E14V(4)=EPB1-OM1
      PE1=SQRT(E14V(4)**2-XME**2)
      QQ1=2.*(EPB1-XME)*PE1*(1.-CT1)+(XME*OM1/EPB1)**2/(1.-OM1/EPB1)
C EPA WEIGHT
C---
      IF(T1 .LT. T3MIN)T3MIN = T1
      IF(T1 .GT. T3MAX)T3MAX = T1
C COMPUTE EVERYTHING ELSE. FIRST PICK OVERALL AZIMUTH.
C ALSO FIX SIGN OF T2.
      FI1=TWOPI*RANP(DUM)
      FI2=FI1-FI12
      THET1 = T1
      THET2 = T2
      IF(T1 .LT. T1MIN)T1MIN = T1
      IF(T2 .GT. T2MAX)T2MAX = T2
C  FOLLOWING LINE MUST BE MOVED AFTER FUNCTION CALL TO EPA2TG  TCJ
C      T2=PI-T2
C
C FILL IN 4-VECTORS. WE TAGGED BOTH, SO NO NEED TO FOOL AROUND
C SYMETRIZING THE PROCESS.
C
      PTE1  = PE1*SIN(T1)
      E14V(1) = PTE1*COS(FI1)
      E14V(2) = PTE1*SIN(FI1)
      E14V(3) = PSGN*PE1*CT1

      E24V(4) = EPB2-OM2
      PE2   = SQRT(E24V(4)**2-XME**2)
      PTE2  = PE2*SIN(T2)
C  THIS IS OK SINCE SIN(T2) = SIN(PI-T2)   TCJ 3-24-89
      E24V(1) = PTE2*COS(FI2)
      E24V(2) = PTE2*SIN(FI2)
      E24V(3) = PSGN*PE2*CT2
C AND THE PHOTONS
      G14V(1) = -E14V(1)
      G14V(2) = -E14V(2)
      G14V(3) =  PSGN*SQRT(EPB1**2-XME**2) - E14V(3)
      IF(THET1.LT.0.001)THEN
        AG1 = OM1*SQRT(1. + (XME/EPB1)**2/(1.-OM1/EPB1))
        IF(G14V(3) .GT. 0.) THEN
          G14V(3) = MAX(AG1,G14V(3))
        ELSEIF (G14V(3).LE. 0.)THEN
          AG1   = -AG1
          G14V(3) = MIN(AG1,G14V(3))
        ENDIF
      ENDIF
      G14V(4)=OM1
C
      QQ2=2.*(EPB2-XME)*PE2*(1.+CT2)+(XME*OM2/EPB2)**2/(1.-OM2/EPB2)
      G24V(1) = -E24V(1)
      G24V(2) = -E24V(2)
      G24V(3) = -PSGN*SQRT(EPB2**2-XME**2) - E24V(3)
      IF(THET2.LT.0.001)THEN
        AG1 = OM2*SQRT(1. + (XME/EPB2)**2/(1.-OM2/EPB2))
        IF(G24V(3) .GT. 0.) THEN
          G24V(3) = MAX(AG1,G24V(3))
        ELSEIF (G24V(3).LE. 0.)THEN
          AG1   = -AG1
          G24V(3) = MIN(AG1,G24V(3))
        ENDIF
      ENDIF
      G24V(4)=OM2
C
C  NORMALIZED MAGNITUDE OF VIRTUAL PHOTON MOMENTUM IN CM
C  NEEDED FOR FORM FACTOR IN WGTMOD
      QGCM = G14V(4)*G24V(4)-G14V(3)*G24V(3)-
     +                       G14V(2)*G24V(2)-G14V(1)*G24V(1)
      QGCM = 2.*SQRT((QGCM**2-QQ1*QQ2)/W2G)
      WGT = EPA2TG(EPB1,EPB2,W2G,OM1,OM2,FI12)*WGTCOR
C  T2 IS IN INCLUDE SINTAG.INC  IT IS USED IN EPA2TG WHERE THE SIGN
C  IS IMPORTANT.  THEREFORE IT WAS NECESSARY TO MOVE THE FOLLOWING LINE
C  TO BE AFTER THE FUNCTION CALL TO EPA2TG
      T2=PI-T2
C
      IF(WGT.LE.0.0) WGT = 0.0
      IF(WGT.LE.0.0)GOTO 1
      WGTVAL = DBLE(WGT)
      WSUM = WSUM + DBLE(WGT)
      WSUMSQ = WSUMSQ + DBLE(WGT*WGT)
      WTST   = RANP(DUM)*EPAMAX
      IF(WTST .GE. WGT)GOTO 1
C
C*****
  500 CONTINUE
C DO WE NEED TO BOOST EPAMAX?
      IF(WGT .GT. EPAUPS)EPAUPS = WGT
      IF(WGT .GT. EPAMAX)THEN
        IF(PRTEPA)WRITE(6,501)EPAMAX,WGT
        IF(OK2G.GT.1. .AND. PRTEPA)CALL GGACUM(5)
        NEPAUP = NEPAUP+1
        EPAMAX = WGT*1.5
      ENDIF
      RETURN
 501  FORMAT(1X,'EPAMAX = ',G12.6,'  WGT = ',G12.6,'  EPAMAX BOOST ')
      END
