*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:31  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:02  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/00 21/01/93  15.42.29  by  Alan Weinstein
*-- Author :
      SUBROUTINE DEXAY(KTO,POL)
C ----------------------------------------------------------------------
C THIS 'DEXAY' IS A ROUTINE WHICH GENERATES DECAY OF THE SINGLE
C POLARIZED TAU,  POL IS A POLARIZATION VECTOR (NOT A POLARIMETER
C VECTOR AS IN DEKAY) OF THE TAU AND IT IS AN INPUT PARAMETER.
C KTO=0 INITIALISATION (OBLIGATORY)
C KTO=1 DENOTES TAU+ AND KTO=2 TAU-
C DEXAY(1,POL) AND DEXAY(2,POL) ARE CALLED INTERNALLY BY MC GENERATOR.
C DECAY PRODUCTS ARE TRANSFORMED READILY
C TO CMS AND WRITEN IN THE  LUND RECORD IN /LUJETS/
C KTO=100, PRINT FINAL REPORT (OPTIONAL).
C
C     called by : KORALZ
C ----------------------------------------------------------------------
      COMMON / TAUBMC / GAMPMC(30),GAMPER(30),NEVDEC(30)
      REAL*4            GAMPMC    ,GAMPER
      COMMON / JAKI   /  JAK1,JAK2,JAKP,JAKM,KTOM
      COMMON / IDFC  / IDFF
      COMMON / INOUT / INUT,IOUT
      REAL  POL(4)
      REAL  PDUM1(4),PDUM2(4),PDUM3(4),PDUM4(4),PDUM5(4)
      REAL  PDUM(4)
      REAL  PDUMI(4,6)
      DATA IWARM/0/
      KTOM=KTO
C
      IF(KTO.EQ.-1) THEN
C     ==================
C       INITIALISATION OR REINITIALISATION
        IWARM=1
        WRITE(IOUT, 7001) JAK1,JAK2
        NEVTOT=0
        NEV1=0
        NEV2=0
        IF(JAK1.NE.-1.OR.JAK2.NE.-1) THEN
          CALL DEXEL(-1,IDUM,PDUM,PDUM1,PDUM2,PDUM3,PDUM4,PDUM5)
          CALL DEXMU(-1,IDUM,PDUM,PDUM1,PDUM2,PDUM3,PDUM4,PDUM5)
          CALL DEXPI(-1,IDUM,PDUM,PDUM1,PDUM2)
          CALL DEXRO(-1,IDUM,PDUM,PDUM1,PDUM2,PDUM3,PDUM4)
          CALL DEXAA(-1,IDUM,PDUM,PDUM1,PDUM2,PDUM3,PDUM4,PDUM5,IDUM)
          CALL DEXKK(-1,IDUM,PDUM,PDUM1,PDUM2)
          CALL DEXKS(-1,IDUM,PDUM,PDUM1,PDUM2,PDUM3,PDUM4,IDUM)
          CALL DEX4PI(-1,IDUM,PDUM,PDUM1,PDUM2,PDUMI,IDUM)
          CALL DEXNPI(-1,IDUM,PDUM,PDUM1,PDUMI,IDUM)
          CALL DEXPK(-1,IDUM,PDUM,PDUM1,PDUM2,PDUM3,PDUM4,PDUM5,IDUM)
        ENDIF
        DO 21 I=1,30
        NEVDEC(I)=0
        GAMPMC(I)=0
 21     GAMPER(I)=0
      ELSEIF(KTO.EQ.1) THEN
C     =====================
C DECAY OF TAU+ IN THE TAU REST FRAME
        NEVTOT=NEVTOT+1
        NEV1=NEV1+1
        IF(IWARM.EQ.0) GOTO 902
        ISGN=IDFF/IABS(IDFF)
CAM     CALL DEXAY1(POL,ISGN)
        CALL DEXAY1(KTO,JAK1,JAKP,POL,ISGN)
      ELSEIF(KTO.EQ.2) THEN
C     =================================
C DECAY OF TAU- IN THE TAU REST FRAME
        NEVTOT=NEVTOT+1
        NEV2=NEV2+1
        IF(IWARM.EQ.0) GOTO 902
        ISGN=-IDFF/IABS(IDFF)
CAM     CALL DEXAY2(POL,ISGN)
        CALL DEXAY1(KTO,JAK2,JAKM,POL,ISGN)
      ELSEIF(KTO.EQ.100) THEN
C     =======================
        IF(JAK1.NE.-1.OR.JAK2.NE.-1) THEN
          CALL DEXEL( 1,IDUM,PDUM,PDUM1,PDUM2,PDUM3,PDUM4,PDUM5)
          CALL DEXMU( 1,IDUM,PDUM,PDUM1,PDUM2,PDUM3,PDUM4,PDUM5)
          CALL DEXPI( 1,IDUM,PDUM,PDUM1,PDUM2)
          CALL DEXRO( 1,IDUM,PDUM,PDUM1,PDUM2,PDUM3,PDUM4)
          CALL DEXAA( 1,IDUM,PDUM,PDUM1,PDUM2,PDUM3,PDUM4,PDUM5,IDUM)
          CALL DEXKK( 1,IDUM,PDUM,PDUM1,PDUM2)
          CALL DEXKS( 1,IDUM,PDUM,PDUM1,PDUM2,PDUM3,PDUM4,IDUM)
          CALL DEX4PI( 1,IDUM,PDUM,PDUM1,PDUM2,PDUMI,IDUM)
          CALL DEXNPI( 1,IDUM,PDUM,PDUM,PDUMI,IDUM)
          CALL DEXPK( 1,IDUM,PDUM,PDUM1,PDUM2,PDUM3,PDUM4,PDUM5,IDUM)
          WRITE(IOUT,7010) NEV1,NEV2,NEVTOT
          WRITE(IOUT,7011) (NEVDEC(I),GAMPMC(I),GAMPER(I),I= 1,11)
          WRITE(IOUT,7012) (NEVDEC(I),GAMPMC(I),GAMPER(I),I=12,19)
        ENDIF
      ELSE
        GOTO 910
      ENDIF
      RETURN
 7001 FORMAT(///1X,15(5H*****)
     $ /,' *',     25X,'*****TAUOLA LIBRARY: VERSION 2.4 ******',9X,1H*,
     $ /,' *',     25X,'***********NOVEMBER 1992***************',9X,1H*,
     $ /,' *',     25X,'**AUTHORS: S.JADACH, Z.WAS*************',9X,1H*,
     $ /,' *',     25X,'**R. DECKER, M. JEZABEK, J.H.KUEHN*****',9X,1H*,
     $ /,' *',     25X,'**AVAILABLE FROM: WASM AT CERNVM ******',9X,1H*,
     $ /,' *',     25X,'***** PUBLISHED IN COMP. PHYS. COMM.***',9X,1H*,
     $ /,' *',     25X,'*******CERN-TH-5856 SEPTEMBER 1990*****',9X,1H*,
     $ /,' *',     25X,'*******CERN-TH-6195 SEPTEMBER 1991*****',9X,1H*,
     $ /,' *',     25X,'*******CERN-TH-     NOVEMBER  1992*****',9X,1H*,
     $ /,' *',     25X,'******DEXAY ROUTINE: INITIALIZATION****',9X,1H*
     $ /,' *',I20  ,5X,'JAK1   = DECAY MODE FERMION1 (TAU+)    ',9X,1H*
     $ /,' *',I20  ,5X,'JAK2   = DECAY MODE FERMION2 (TAU-)    ',9X,1H*
     $  /,1X,15(5H*****)/)
CHBU  format 7010 had more than 19 continuation lines
CHBU  split into two
 7010 FORMAT(///1X,15(5H*****)
     $ /,' *',     25X,'*****TAUOLA LIBRARY: VERSION 2.4 ******',9X,1H*,
     $ /,' *',     25X,'***********NOVEMBER 1992***************',9X,1H*,
     $ /,' *',     25X,'**AUTHORS: S.JADACH, Z.WAS*************',9X,1H*,
     $ /,' *',     25X,'**R. DECKER, M. JEZABEK, J.H.KUEHN*****',9X,1H*,
     $ /,' *',     25X,'**AVAILABLE FROM: WASM AT CERNVM ******',9X,1H*,
     $ /,' *',     25X,'***** PUBLISHED IN COMP. PHYS. COMM.***',9X,1H*,
     $ /,' *',     25X,'*******CERN-TH-5856 SEPTEMBER 1990*****',9X,1H*,
     $ /,' *',     25X,'*******CERN-TH-6195 SEPTEMBER 1991*****',9X,1H*,
     $ /,' *',     25X,'*******CERN-TH-     NOVEMBER  1992*****',9X,1H*,
     $ /,' *',     25X,'******DEXAY ROUTINE: FINAL REPORT******',9X,1H*
     $ /,' *',I20  ,5X,'NEV1   = NO. OF TAU+ DECS. ACCEPTED    ',9X,1H*
     $ /,' *',I20  ,5X,'NEV2   = NO. OF TAU- DECS. ACCEPTED    ',9X,1H*
     $ /,' *',I20  ,5X,'NEVTOT = SUM                           ',9X,1H*
     $ /,' *','    NOEVTS ',
     $   ' PART.WIDTH     ERROR       ROUTINE    DECAY MODE    ',9X,1H*)
 7011 FORMAT(1X,'*'
     $       ,I10,2F12.7       ,'     DADMEL     ELECTRON      ',9X,1H*
     $ /,' *',I10,2F12.7       ,'     DADMMU     MUON          ',9X,1H*
     $ /,' *',I10,2F12.7       ,'     DADMPI     PION          ',9X,1H*
     $ /,' *',I10,2F12.7,       '     DADMRO     RHO (->2PI)   ',9X,1H*
     $ /,' *',I10,2F12.7,       '     DADMAA     A1  (->3PI)   ',9X,1H*
     $ /,' *',I10,2F12.7,       '     DADMKK     KAON          ',9X,1H*
     $ /,' *',I10,2F12.7,       '     DADMKS     K*            ',9X,1H*
     $ /,' *',I10,2F12.7,       '     DAD4PI     PI- 2PI+ PI0  ',9X,1H*
     $ /,' *',I10,2F12.7,       '     DAD4PI     PI- 3PI0      ',9X,1H*
     $ /,' *',I10,2F12.7,       '     DADNPI     3PI- 2PI+     ',9X,1H*
     $ /,' *',I10,2F12.7,       '     DADNPI     3PI- 2PI+ PI0 ',9X,1H*)
 7012 FORMAT(1X,'*'
     $       ,I10,2F12.7,       '     DADMPK     K+ K- PI+     ',9X,1H*
     $ /,' *',I10,2F12.7,       '     DADMPK     K0B K0 PI+    ',9X,1H*
     $ /,' *',I10,2F12.7,       '     DADMPK     K+ K0B PI0    ',9X,1H*
     $ /,' *',I10,2F12.7,       '     DADMPK     K+ PI0 PI0    ',9X,1H*
     $ /,' *',I10,2F12.7,       '     DADMPK     K+ PI- PI+    ',9X,1H*
     $ /,' *',I10,2F12.7,       '     DADMPK     K0 PI0 PI+    ',9X,1H*
     $ /,' *',I10,2F12.7,       '     DADMPK     ET PI- PI0    ',9X,1H*
     $ /,' *',I10,2F12.7,       '     DADMPK     PI-PI0 GAM    ',9X,1H*
     $ /,' *',20X,'THE ERROR IS RELATIVE AND  PART.WIDTH      ',10X,1H*
     $ /,' *',20X,'IN UNITS GFERMI**2*MASS**5/192/PI**3       ',10X,1H*
     $  /,1X,15(5H*****)/)
 902  WRITE(IOUT, 9020)
 9020 FORMAT(' ----- DEXAY: LACK OF INITIALISATION')
      STOP
 910  WRITE(IOUT, 9100)
 9100 FORMAT(' ----- DEXAY: WRONG VALUE OF KTO ')
      STOP
      END
