*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:26  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:01  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/00 21/01/93  15.55.29  by  Alan Weinstein
*-- Author :
      SUBROUTINE INITDK
C ----------------------------------------------------------------------
C     INITIALISATION OF TAU DECAY PARAMETERS  and routines
C
C     called by : KORALZ
C ----------------------------------------------------------------------
      COMMON / DECPAR / GFERMI,GV,GA,CCABIB,SCABIB,GAMEL
      REAL*4            GFERMI,GV,GA,CCABIB,SCABIB,GAMEL
      COMMON / PARMAS / AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
C
      REAL*4            AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
      COMMON / TAUBRA / GAMPRT(30),JLIST(30),NCHAN
      COMMON / TAUKLE / BRA1,BRK0,BRK0B,BRKS
      REAL*4            BRA1,BRK0,BRK0B,BRKS
      PARAMETER (NMODE=4)
      COMMON / TAUNPI / CBRNPI       ,AMAS
     &                 ,KPI(6,NMODE) ,MULT(NMODE)
      REAL*4            CBRNPI(NMODE),AMAS(6,NMODE)
      COMMON /TAUPK / IDKPI(3,8)
C      dimension IDKPI(3,8)
      REAL*4 PI
C
C LIST OF BRANCHING RATIOS
CAM normalised to e nu nutau channel
CAM   DATA NCHAN   / 8 /
CAM                  enu   munu   pinu  rhonu   A1nu   Knu    K*nu   pi'
CAM   DATA JLIST  /    1,     2,     3,     4,     5,     6,     7,
CAM   DATA GAMPRT /1.000,0.9730,0.6054,1.2432,0.8432,0.0432,O.O811,0.616
CAM
CAM  multipion decays
      DIMENSION NOPI(6,NMODE),NPI(NMODE)
      DIMENSION IDFPIK(3,8)
CAM   OUTGOING  MULTIPLICITY
      DATA NPI /            4,           4,             5,             6
     &/
      DATA NOPI/-1,-1,1,2,0,0,2,2,2,-1,0,0,-1,-1,-1,1,1,0,-1,-1,-1,1,1,2
     &/
C FLAVORS OF FINAL STATES IN 3K(PI) DECAYS OF TAU-
C                 K-,K+,P-,  K0,KB,P-,  K-,K0,P0
C                 K-,P0,P0,  K-,P+,P-,  KB,P0,P-
C     DATA IDFPIK/ 3,-3, 1  , 4,-4, 1  , 3, 2, 4  ,
C    $             3, 2, 2  , 3,-1, 1  ,-4, 2, 1  /
C                 K-,P-,K+,  K0,P-,KB,  K-,P0,K0
C                 P0,P0,K-,  K-,P-,P+,  P-,KB,P0
C                 ET,P-,P0   P-,P0,GM
      DATA IDFPIK/ 3, 1,-3  , 4, 1,-4  , 3, 2, 4  ,
     $             2, 2, 3  , 3, 1,-1  , 1,-4, 2  ,
     $             9, 1, 2  , 1, 2, 8             /
C
C LIST OF BRANCHING RATIOS
      NCHAN = 19
      DO 1 I = 1,30
      IF (I.LE.NCHAN) THEN
        JLIST(I) = I
        IF(I.EQ. 1) GAMPRT(I) = 1.0000
        IF(I.EQ. 2) GAMPRT(I) = 1.0000
        IF(I.EQ. 3) GAMPRT(I) = 1.0000
        IF(I.EQ. 4) GAMPRT(I) = 1.0000
        IF(I.EQ. 5) GAMPRT(I) = 1.0000
        IF(I.EQ. 6) GAMPRT(I) = 1.0000
        IF(I.EQ. 7) GAMPRT(I) = 1.0000
        IF(I.EQ. 8) GAMPRT(I) = 1.0000
        IF(I.EQ. 9) GAMPRT(I) = 1.0000
        IF(I.EQ.10) GAMPRT(I) = 1.0000
        IF(I.EQ.11) GAMPRT(I) = 1.0000
        IF(I.EQ.12) GAMPRT(I) = 1.0000
        IF(I.EQ.13) GAMPRT(I) = 1.0000
        IF(I.EQ.14) GAMPRT(I) = 1.0000
        IF(I.EQ.15) GAMPRT(I) = 1.0000
        IF(I.EQ.16) GAMPRT(I) = 1.0000
        IF(I.EQ.17) GAMPRT(I) = 1.0000
        IF(I.EQ.18) GAMPRT(I) = 1.0000
        IF(I.EQ.19) GAMPRT(I) = 1.0000
        IF(I.EQ. 3) GAMPRT(I) = 10 .0000
      ELSE
        JLIST(I) = 0
        GAMPRT(I) = 0.
      ENDIF
   1  CONTINUE
C --- initialization of multipions
      DO 3 I=1,NMODE
C --- multiplicity of the channel I
      MULT(I)=NPI(I)
C --- mass and LUND-type of the J'th pi of decay channel I
      DO 3 J=1,MULT(I)
      IPI=NOPI(J,I)
      IF     (IPI.EQ. 1) THEN
C --- pi+
        KPI (J,I) = 211
        AMAS(J,I) =AMPI
      ELSEIF (IPI.EQ.-1) THEN
C --- pi-
        KPI (J,I) =-211
        AMAS(J,I) =AMPI
      ELSEIF (IPI.EQ. 2) THEN
C --- pi0
        KPI (J,I) = 111
        AMAS(J,I) =AMPIZ
      ENDIF
 3    CONTINUE
C --- idenfifiers for 3K(pi) decay modes
      DO 5 I=1,3
      DO 5 J=1,8
 5    IDKPI(I,J)=IDFPIK(I,J)
C
C --- COEFFICIENTS TO FIX RATIO OF:
C --- A1 3CHARGED/ A1 1CHARGED 2 NEUTRALS MATRIX ELEMENTS (MASLESS LIM.)
C --- PROBABILITY OF K0 TO BE KS
C --- PROBABILITY OF K0B TO BE KS
C --- RATIO OF COEFFICIENTS FOR K*--> K0 PI-
C --- ALL COEFFICENTS SHOULD BE IN THE RANGE (0.0,1.0)
C --- THEY MEANING IS PROBABILITY OF THE FIRST CHOICE ONLY IF ONE
C --- NEGLECTS MASS-PHASE SPACE EFFECTS
      BRA1=0.5
      BRK0=0.5
      BRK0B=0.5
      BRKS=0.6667
C
C --- remaining constants
      PI =4.*ATAN(1.)
      GFERMI = 1.16637E-5
      CCABIB = 0.975
C GV,GA KORALB reads from input
C     GV     = 1.0
C     GA     =-1.0
C ZW 13.04.89 HERE WAS AN ERROR
      SCABIB = SQRT(1.-CCABIB**2)
      GAMEL  = GFERMI**2*AMTAU**5/(192*PI**3)
C
C      CALL DEXAY(-1)
C
      RETURN
      END
