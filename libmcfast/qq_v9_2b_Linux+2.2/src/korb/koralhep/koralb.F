*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:27  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:01  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/00 21/01/93  15.41.59  by  Alan Weinstein
*-- Author :
      SUBROUTINE KORALB(MMODE,KFB1,PPB1,EE1,KFB2,PPB2,EE2,XPAR,NPAR)
C     **************************************************************
C=======================================================================
C=======================================================================
C============================KORAL-B====================================
C=======================================================================
C=======================================================================
C
C     ****************************************************************
C     *          *************************************               *
C     *          ***           KORAL-B             ***               *
C     *          ***         VERSION 2.2           ***               *
C     *          ***       DECEMBER 1992           ***               *
C     *          *************************************               *
C     *                                                              *
C     *                      AUTHORS                                 *
C     *           STANISLAW JADACH AND  ZBIGNIEW WAS                 *
C     *         JAGELLONIAN UNIVERSITY, KRAKOW, POLAND               *
C     *                                                              *
C     *     THE MONTE CARLO PROGRAM SIMULATING   THE   PROCESS       *
C     *         E+  E-   INTO   TAU+  TAU-  ( PHOTON )               *
C     *     IN QED TO ORDER  ALPHA**3  INCLUDING ALL EFFECTS         *
C     *     DUE TO SPIN AND FINITE MASS OF TAU. Z0 CONTRIBUTION      *
C     *     INCLUDED   IN   THE   LOW   ENERGY  APPROXIMATION.       *
C     ****************************************************************
C
C
C    IMPORTANT NOTE:
C    THIS PROGRAM WILL BE SLOWLY BUT GRADUALLY IMPROVED.
C    BEFORE USING THIS PROGRAM YOU MAY CONTACT Z. WAS
C    THROUGH EARNET/BITNET, WASM AT CERNVM,
C    AND, PERHAPS, YOU WILL GET  A BETTER VERSION.
C    ANY REMARK ON THE PROGRAM,
C    ON ANY NOTICED ERROR OR ANY OTHER PROBLEM IS WELCOMED.
C=================
C PARAMETERS:   =
C=================
C MODE=-1 INITIALIZATION OR REINITIALIZATION MODE,
C         PRIOR TO GENERATION, OBLIGATORY.
C     = 0 GENERATION MODE, M.C. EVENT IS GENERATED.
C     = 1 POSTGENERATION MODE, PRONTOUTS, OPTIONAL.
C
C IF MODE=-1 THEN ALL PARAMETERS ARE INPUT DATA:
C    =======
C KFB1 =11,-11 FLAVOUR CODE OF FIRST BEAM, KF1=11  FOR ELECTRON.
C KFB2 =11,-11 FLAVOUR CODE OF SECOND BEAM, KF2=-11 FOR POSITRON.
C PB1 = FOUR MOMENTUM OF THE FIRST BEAM.
C PB2 = FOUR MOMENTUM OF THE SECOND BEAM.
C EE1 = SPIN POLARIZATION VECTOR FOR THE FIRST BEAM.
C EE2 = SPIN POLARIZATION VECTOR FOR THE SECOND BEAM,
C       BOTH IN THE CORRESPONDING BEAM PARTICLE REST FRAME
C       AND IN BOTH CASES THIRD AXIS DIRECTED ALONG FIRST BEAM,
C       I.E. EE1(3) AND -EE2(3) ARE HELICITIES.
C       POLARIZATION MAY BE LONGITUDINAL TRANSVERSE AND ANY OTHER.
C
C OTHER INPUT PARAMETERS ARE HIDEN IN XPAR AND NPAR.
C NPAR(1)=ISPIN
C NPAR(2)=INRAN
C NPAR(3)=KEYGSW
C NPAR(4)=KEYRAD
C NPAR(5)=JAK1
C NPAR(6)=JAK2
C NPAR(7)=TYPE OF THE FINAL STATE FERMION  =(1,2,501,506) DEFINES
C         TAU,MU AND QUARKS.
C NPAR(8)=BREMSSTRAHLUNG IN DECAYS ON/OFF (1/0)
C XPAR( 1)=AMZ     =MASS OF Z0 BOSON
C XPAR( 4)=GV
C XPAR( 5)=AV
C XPAR( 6)=SINW2, ONLY FOR KEYGSW=1,
C XPAR( 8)=AMNUTA, MASS OF TAU NEUTRINO IN DECAY.
C XPAR(11)=XK0, THE INFRARED CUTOFF.
C XPAR(14)=AMFIN, FINAL STATE MASS (ONLY FOR ITFIN=501-506 NOT DUMMY)
C -------
C ISPIN =0,1  SPIN EFFECTS IN DECAY SWITCHED OFF,ON.
C INRAN = INITIALISATION CONSTANT FOR RAND. NUM. GEN. RNF100, POSITIVE.
C KEYGSW, IMPLEMENTATION LEVEL OF GLASHOW-SALAM-WEINBERG MODEL:
C = 0, N0 Z0, ONLY PHOTON EXCHANGE,
C = 1, PHOTON - Z0 INTERFERENCE
C KEYRAD=0, NO QED BREMSSTRAHLUNG,
C       =1, WITH QED BREMSSTRAHLUNG.
C JAK1,JAK2, DECAY TYPE FOR TAU+ AND TAU-.
C DECAY MODES INCLUDED ARE:
C JAK=1 ELECTRON DECAY
C JAK=2 MU  DECAY,
C JAK=3 PI DECAY,
C JAK=4 RHO DECAY,
C JAK=5 A1  DECAY
C JAK=6 K DECAY,
C JAK=7 K* DECAY,
C JAK=8 NPI DECAY
C JAK=0 INCLUSIVE:  JAK=1,2,3,4,5,6,7,8
C JAK=-1 NO DECAY.
C GV AND GA ARE COUPLING CONSTANTS OF W-BOSON OF TO TAU LEPTON,
C GV=1,GA=-1 REPRESENT THE STANDARD V-A COUPLING.
C XK0  IS THE INFRARED CUTOFF IN THE PROGRAM, IT IS A DUMMY
C PARAMETER AND NONE OF RESULTS SHOULD DEPEND ON IT,
C ITS VALUE MAY BE CHOOSEN IN THE RANGE 0.001 TO 0.05 ROUGHLY.
C
C ELSE IF MODE=0 THEN ALL PARAMETERS ARE IGNORED
C         ======
C ELSE IF MODE=1 THEN
C         ======
C NPAR(20)= NEVTOT, NO. OF GENERATED EVENTS,
C XPAR(20)= CSTCM,  INTEGRATED TOTAL CROSS SECTION IN CM**2 UNITS,
C ARE OUTPUT INFORMATION PROVIDED FOR THE USER.
C ENDIF
      IMPLICIT LOGICAL(A-H,O-Z)
      REAL*4 PPB1(4),EE1(3),PPB2(4),EE2(3),XPAR(40)
      INTEGER*4 NPAR(40)
C COMMONS COMMUNICATING WITH PRODUCTION PART
      COMMON / CONTRL/ SWT(6),ISPIN
      REAL*8           SWT
      REAL*8           CSTCMT,ERREL
C THESE COMMUNICATE WITH DECAY PACKAGE TAUOLA
      COMMON / BEAMS / XPB1(4),XPB2(4),KF1,KF2
      REAL*4           XPB1,   XPB2
      COMMON / IDFC  / IDFF
      COMMON / DECPAR / GFERMI,GV,GA,CCABIB,SCABIB,GAMEL
      REAL*4            GFERMI,GV,GA,CCABIB,SCABIB,GAMEL
      COMMON / PARMAS / AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
C
      REAL*4            AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
C
      COMMON / TAURAD / XK0DEC,ITDKRC
      REAL*8            XK0DEC
      COMMON / JAKI   /  JAK1,JAK2,JAKP,JAKM,KTOM
      COMMON / INOUT / NINP,NOUT
      REAL*8  PB1(4), E1(3), PB2(4), E2(3)
      REAL*8 SINW2,ENE,CSTCM,SUMPT,EM1,EM2,XK0
      REAL*8 AMZ,DUMMY,AMFIN
      REAL*8 HDUM(4)
      DATA IWARM/0/
      MODE =MMODE
      IF(MODE.EQ.-1) THEN
C     ===================
C     ===================
        IEVEN=0
        IF(IWARM.NE.0) GOTO 910
        NINP=5
        NOUT=6
        IWARM=IWARM+1
        KF1=KFB1
        KF2=KFB2
        ISPIN1=    NPAR(1)
        INRAN=    NPAR(2)
        KEYGSW=   NPAR(3)
        KEYRAD=   NPAR(4)
        JAK1  =   NPAR(5)
        JAK2  =   NPAR(6)
        ITFIN =   NPAR(7)
        ITDKRC=   NPAR(8)
        AMZ   = DBLE(XPAR(1))
        SINW2 = DBLE(XPAR(6))
C W-BOSON COUPLINGS TO FINAL STATE FERMION (IN DECAY) FROM INPUT
        GV=XPAR( 4)
        GA=XPAR( 5)
C TAU-NEUTRINO MASS
        AMNUTA= XPAR(8)
C INFRARED CUT-OFF
        XK0= DBLE(XPAR(11))
        XK0DEC=XK0
        IF(XK0.LT.1D-3.OR.XK0.GT.1D-1) GOTO 908
C FINAL STATE QUAR MASS
        IF(ITFIN.GT.100)  AMFIN=XPAR(14)
        DO 15 I=1,4
        XPB1(I)=PPB1(I)
        XPB2(I)=PPB2(I)
        PB1(I)=PPB1(I)
   15   PB2(I)=PPB2(I)
        ENE=PB1(4)
        DO 26 I=1,3
        E1(I)=EE1(I)
   26   E2(I)=EE2(I)
C PRINT INPUT PARAMETERS
        WRITE(NOUT,7000) KF1,KF2,PB1(3),PB1(4),PB2(3),PB2(4)
     &  ,E1(1),E1(2),E1(3),E2(1),E2(2),E2(3)
        WRITE(NOUT,7001)
     $  ITFIN,ISPIN1,INRAN,KEYGSW,KEYRAD,JAK1,JAK2,ITDKRC
        WRITE(NOUT,7002) AMZ,SINW2,GV,GA,AMNUTA,XK0
C CHECKS
        IF(IABS(KF1).NE.11.OR.IABS(KF2).NE.11) GOTO 900
        IF(KF1*KF2.GT.0) GOTO 900
        IF(DABS(SINW2).GT.1D0) GOTO 905
        IF(KEYRAD.LT.0.OR.KEYRAD.GT.1) GOTO 907
        SUMPT=0.
        DO 20 I=1,2
        SUMPT=SUMPT+PB1(I)
  20    SUMPT=SUMPT+PB2(I)
        IF(SUMPT.GT.0.0001) GOTO 902
        IF (DABS(PB1(3)).NE.DABS(PB1(4))
     &  .OR.DABS(PB2(3)).NE.DABS(PB2(4))
     &  .OR.PB1(4).NE.PB2(4).OR.PB1(3).NE.(-PB2(3)) ) GOTO 903
        EM1=DSQRT(E1(1)**2+E1(2)**2+E1(3)**2)
        EM2=DSQRT(E2(1)**2+E2(2)**2+E2(3)**2)
        IF(EM1.GT.1D0.OR.EM2.GT.1D0) GOTO 904
C INITIALISATION OF TAU DECAY PACKAGE TAUOLA
C ******************************************
        CALL INIMAS
        CALL INITDK
        CALL INIPHY(XK0DEC)
C INITIALIZATION OF PHOTOS
        CALL PHOINI
C DETERMINE WHETHER BEAM ALONG Z-AXIS IS AN ELECTR. OR POSITRON
C FOR IDE<0 PB1 (ALONG Z-AXIS) REPRESENTS POSITRON
        IDE= 2*KFB1/IABS(KFB1)
C
C       DETERMINE WHETHER QP REPRESENT PARTICLE OR  ANTIPART.
C                                      (IDF<0)  OR   (IDF>0
C
C       FINAL FERMION  TYPE ETC.
        IF(ITFIN .EQ. 1) THEN
C TAU CASE
C TAU MASS
        AMFIN=AMTAU
        AMTAU=AMFIN
C*MWG* TAU  CASE: PDG-CODE OF TAU- IS 15
          IDF= 2*KFB1/IABS(KFB1)
          IDFF = 15*IDF/IABS(IDF)
        ELSEIF(ITFIN .EQ. 2) THEN
C MUON CASE
        AMFIN=AMMU
C*MWG* MUON CASE: PDG-code of mu- is 13
          IDF= 2*KFB1/IABS(KFB1)
          IDFF = 13*IDF/IABS(IDF)
C DECAY SUPRESSED
          JAK1=-1
          JAK2=-1
        ELSE
C QUARK CASE, MASS FROM THE INPUT (AMFIN WAS OVERWRITTEN IN
C                                  INITIALIZATION OF TAUOLA)
          AMFIN=XPAR(14)
          JAK1=-1
          JAK2=-1
          IAA  = ABS(ITFIN)-500
          IF (IAA .EQ. 2 .OR. IAA .EQ. 4 .OR. IAA .EQ. 6) THEN
            IDF= 3*KFB1/IABS(KFB1)
          ELSE
            IDF= 4*KFB1/IABS(KFB1)
          END IF
          IDFF = SIGN(IAA,IDF)
        ENDIF
 
        WRITE(NOUT,7003) AMFIN
C SWITCHING OFF Z0
        IF(KEYGSW.EQ.0) SINW2=-.5
C SWITCHING OFF BREMSSTRAHLUNG
        IF(KEYRAD.EQ.0) ENE=-ABS(ENE)
C PRODUCTION PART INITIALIZATION
        CALL STARB(ENE,AMFIN,IDE,IDF,AMZ,SINW2,INRAN,XK0)
C       -------------------------------------------------
C ISPIN REDEFINED
        ISPIN=   ISPIN1
        IF(ISPIN.LT.0.OR.ISPIN.GT.1) GOTO 906
        CALL DEKAY(-1,HDUM)
      ELSEIF(MODE.EQ.0) THEN
C     ======================
C     ======================
        IF(IWARM.EQ.0) GOTO 911
        IEVEN=IEVEN+1
        CALL KORAL(E1,E2)
C       -----------------
        CALL KINCOP
C*MWG* FILLING HEPEVT RECORD WITH BEAMS FERMIONS AND PHOTON
C TAU CASE
        CALL BTOHEP
C       -----------
C TAU DECAYS, REST OF ADMINISTRATION
        KTO=11
        CALL DEKAY(KTO,HDUM)
C       --------------------
        KTO=12
        CALL DEKAY(KTO,HDUM)
C       --------------------
        IF (ITDKRC.EQ.1) THEN
         CALL PHOTOS(3)
         CALL PHOTOS(4)
        ENDIF
      ELSEIF(MODE.EQ.1) THEN
C     ======================
C     ======================
        CALL FINISB(CSTCMT,ERREL)
C       ------------------
C CALCULATE PARTIAL DECAY WIDTHS
        CALL DEKAY(100,HDUM)
C       --------------------
        NPAR(10)=IEVEN
        XPAR(10)=CSTCMT
        WRITE(NOUT,7010) IEVEN,CSTCMT,ERREL
      ELSE
C     ====
        GOTO 901
      ENDIF
C     =====
      RETURN
  900 PRINT 9900
 9900 FORMAT(' KORALB: NONSENSE VALUE OF BEAM IDENTIFIER')
      STOP
  901 PRINT 9901
 9901 FORMAT(' KORALB: NONSENCE VALUE OF MODE ')
      STOP
  902 PRINT 9902
 9902 FORMAT(' KORALB: NO TRANSV. MOM. ALLOWED FOR BEAMS ')
      STOP
  903 PRINT 9903
 9903 FORMAT(' KORALB: SOME WRONG BEAM MOM. COMPONENT    ')
      STOP
  904 PRINT 9904
 9904 FORMAT(' KORALB: BAD POLARISATION VECTORS ')
      STOP
  905 PRINT 9905
 9905 FORMAT(' KORALB: BAD SINW2 ')
      STOP
  906 PRINT 9906
 9906 FORMAT(' KORALB: BAD ISPIN ')
      STOP
  907 PRINT 9907
 9907 FORMAT(' KORALB: BAD KEYRAD')
      STOP
  908 PRINT 9908
 9908 FORMAT(' KORALB: BAD XK0   ')
      STOP
  910 PRINT 9910
 9910 FORMAT(' KORALB: REINITIALISATION NOT ALLOWED')
      STOP
  911 PRINT 9911
 9911 FORMAT(' KORALB: LACK OF INITIALISATION')
      STOP
 7000 FORMAT(//1H1,15(5H*****)
     $ /,' *',     25X,'=KORALB VERSION 2.2 INPUT PARAMETERS ==',9X,1H*,
     $ /,' *',     25X,'========DECEMBER  1992=================',9X,1H*,
     $ /,' *',I20  ,5X,'KF1    =  FIRST BEAM IDENTIFIER        ',9X,1H*,
     $ /,' *',I20  ,5X,'KF2    =  SECOND BEAM IDENTIFIER       ',9X,1H*,
     $ /,' *',     25X,'==== FOUR MOMENTA OF THE BEAMS ========',9X,1H*,
     $ /,' *',F20.9,5X,'PB1(3) =  FIRST BEAM, 3-RD COMPONENT   ',9X,1H*,
     $ /,' *',F20.9,5X,'PB1(4) =              0-TH COMPONENT   ',9X,1H*,
     $ /,' *',F20.9,5X,'PB2(3) = SECOND BEAM, 3-RD COMPONENT   ',9X,1H*,
     $ /,' *',F20.9,5X,'PB2(4) =              0-TH COMPONENT   ',9X,1H*,
     $ /,' *',     25X,'==== SPIN VECTORS OF THE BEAMS ========',9X,1H*,
     $ /,' *',F20.9,5X,'E1(1)  =  FIRST BEAM, 1-ST COMPONENT   ',9X,1H*,
     $ /,' *',F20.9,5X,'E1(2)  =              2-ND COMPONENT   ',9X,1H*,
     $ /,' *',F20.9,5X,'E1(3)  =              3-RD COMPONENT   ',9X,1H*,
     $ /,' *',F20.9,5X,'E2(1)  = SECOND BEAM  1-ST COMPONENT   ',9X,1H*,
     $ /,' *',F20.9,5X,'E2(2)  =              2-ND COMPONENT   ',9X,1H*,
     $ /,' *',F20.9,5X,'E2(3)  =              3-RD COMPONENT   ',9X,1H*)
 7001 FORMAT(
     $   ' *',     25X,'==== INPUT PARAMS IN NPAR =============',9X,1H*,
     $ /,' *',I20  ,5X,'ITFIN  =  TYPE OF THE FINAL STATE      ',9X,1H*,
     $ /,' *',I20  ,5X,'ISPIN  =  SPIN EFFECTS SWITCH          ',9X,1H*,
     $ /,' *',I20  ,5X,'INRAN  =  RANDOM NUMB. INITIALISATION  ',9X,1H*,
     $ /,' *',I20  ,5X,'KEYGSW =  GSW IMPLEMENTATION LEVEL     ',9X,1H*,
     $ /,' *',I20  ,5X,'KEYRAD =  BREMSSTRAHLUNG   SWITCH      ',9X,1H*,
     $ /,' *',I20  ,5X,'JAK1   =  DECAY TYPE TAU+              ',9X,1H*,
     $ /,' *',I20  ,5X,'JAK2   =  DECAY TYPE TAU-              ',9X,1H*,
     $ /,' *',I20  ,5X,'ITDKRC =  BREM. IN DECAY SWITCH        ',9X,1H*)
 7002 FORMAT(
     $   ' *',     25X,'==== INPUT PARAMS IN XPAR =============',9X,1H*,
     $ /,' *',F20.9,5X,'AMZ   = MASS OF Z0 BOSON               ',9X,1H*,
     $ /,' *',F20.9,5X,'SINW2 =  SIN**2(THETAWEINBERG)         ',9X,1H*,
     $ /,' *',F20.9,5X,'GV    = VECTOR COUPLING CONST. IN DECAY',9X,1H*,
     $ /,' *',F20.9,5X,'GA    = AXIAL  COUPLING CONST. IN DECAY',9X,1H*,
     $ /,' *',F20.9,5X,'AMNUTA= MASS OF TAU-NEUTRINO  IN DECAY ',9X,1H*,
     $ /,' *',F20.9,5X,'XK0   = SOFT/HARD PHOTON CUT OFF       ',9X,1H*,
     $  /,1X,15(5H*****)/)
 7003 FORMAT(
     $   ' *',     25X,'==KORALB-INITIALIZATION THROUGH TAUOLA=',9X,1H*,
     $ /,' *',F20.9,5X,'AMFIN = MASS OF FINAL STATE FERMION    ',9X,1H*,
     $  /,1X,15(5H*****)/)
 7010 FORMAT(///1X,15(5H*****)
     $ /,' *',     25X,'==KORALB VERSION 2.2 FINAL REPORT======',9X,1H*,
     $ /,' *',     25X,'========DECEMBER 1992==================',9X,1H*,
     $ /,' *',I20  ,5X,'NUMBER OF THE GENERATED EVENTS         ',9X,1H*,
     $ /,' *',E20.5,5X,'TOTAL CROSS SECTION   CM**2            ',9X,1H*,
     $ /,' *',F20.9,5X,'RELATIVE ERROR                         ',9X,1H*,
     $  /,1X,15(5H*****)/)
      END
