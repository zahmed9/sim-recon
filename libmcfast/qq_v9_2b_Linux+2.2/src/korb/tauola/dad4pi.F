*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:30  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:04  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/00 21/01/93  15.42.35  by  Alan Weinstein
*-- Author :
      SUBROUTINE DAD4PI(MODE,ISGN,HV,PNU,PWB,PNPI,JNPI)
C ----------------------------------------------------------------------
      COMMON / PARMAS / AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
C
      REAL*4            AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
      COMMON / DECPAR / GFERMI,GV,GA,CCABIB,SCABIB,GAMEL
      REAL*4            GFERMI,GV,GA,CCABIB,SCABIB,GAMEL
      COMMON / TAUBMC / GAMPMC(30),GAMPER(30),NEVDEC(30)
      REAL*4            GAMPMC    ,GAMPER
      COMMON / INOUT / INUT,IOUT
      PARAMETER (NMODE=4)
      COMMON / TAUNPI / CBRNPI       ,AMAS
     &                 ,KPI(6,NMODE) ,MULT(NMODE)
      REAL*4            CBRNPI(NMODE),AMAS(6,NMODE)
      REAL*4 PNU(4),PWB(4),PNPI(4,6),HV(4)
      REAL*4 PDUM1(4),PDUM2(4),PDUMI(4,6)
      REAL*4 RRR(3)
      REAL*4 WTMAX(NMODE)
      REAL*8              SWT(NMODE),SSWT(NMODE)
      DIMENSION NEVRAW(NMODE),NEVOVR(NMODE),NEVACC(NMODE)
      CHARACTER TITLE(4)*31
C
      DATA PI /3.141592653589793238462643/
      DATA IWARM/0/
C
      IF(MODE.EQ.-1) THEN
C     ===================
C -- AT THE MOMENT ONLY TWO DECAY MODES OF MULTIPIONS HAVE M. ELEM
        NMOD=2
        IWARM=1
        TITLE(1)='  TAU-  --> 2PI-,  PI0,  PI+   '
        TITLE(2)='  TAU-  --> 3PI0,        PI-   '
        TITLE(3)='  TAU-  --> 3PI-, 2PI+,        '
        TITLE(4)='  TAU-  --> 3PI-, 2PI+,  PI0   '
C       PRINT 7003
        DO 1 JNPI=1,NMOD
        NEVRAW(JNPI)=0
        NEVACC(JNPI)=0
        NEVOVR(JNPI)=0
        SWT(JNPI)=0
        SSWT(JNPI)=0
        WTMAX(JNPI)=-1.
        DO 3 I=1,500
        CALL DPH4PI(WT,HV,PDUM1,PDUM2,PDUMI,JNPI)
        IF(WT.GT.WTMAX(JNPI)/1.2) WTMAX(JNPI)=WT*1.2
3       CONTINUE
C       CALL HBOOK1(801,'WEIGHT DISTRIBUTION  DADNPI    $',100,0.,2.,.0)
C       PRINT 7004,WTMAX(JNPI)
1       CONTINUE
        WRITE(IOUT,7005)
C
      ELSEIF(MODE.EQ. 0) THEN
C     =======================
        IF(IWARM.EQ.0) GOTO 902
C
300     CONTINUE
        CALL DPH4PI(WT,HV,PNU,PWB,PNPI,JNPI)
C       CALL HFILL(801,WT/WTMAX(JNPI))
        NEVRAW(JNPI)=NEVRAW(JNPI)+1
        SWT(JNPI)=SWT(JNPI)+WT
        SSWT(JNPI)=SSWT(JNPI)+WT**2
        CALL RANMAR(RRR,3)
        RN=RRR(1)
        IF(WT.GT.WTMAX(JNPI)) NEVOVR(JNPI)=NEVOVR(JNPI)+1
        IF(RN*WTMAX(JNPI).GT.WT) GOTO 300
C ROTATIONS TO BASIC TAU REST FRAME
        COSTHE=-1.+2.*RRR(2)
        THET=ACOS(COSTHE)
        PHI =2*PI*RRR(3)
        CALL ROTOR2(THET,PNU,PNU)
        CALL ROTOR3( PHI,PNU,PNU)
        CALL ROTOR2(THET,PWB,PWB)
        CALL ROTOR3( PHI,PWB,PWB)
        CALL ROTOR2(THET,HV,HV)
        CALL ROTOR3( PHI,HV,HV)
        ND=MULT(JNPI)
        DO 301 I=1,ND
        CALL ROTOR2(THET,PNPI(1,I),PNPI(1,I))
        CALL ROTOR3( PHI,PNPI(1,I),PNPI(1,I))
301     CONTINUE
        NEVACC(JNPI)=NEVACC(JNPI)+1
C
      ELSEIF(MODE.EQ. 1) THEN
C     =======================
        DO 500 JNPI=1,NMOD
          IF(NEVRAW(JNPI).EQ.0) GOTO 500
          PARGAM=SWT(JNPI)/FLOAT(NEVRAW(JNPI)+1)
          ERROR=0
          IF(NEVRAW(JNPI).NE.0)
     &    ERROR=SQRT(SSWT(JNPI)/SWT(JNPI)**2-1./FLOAT(NEVRAW(JNPI)))
          RAT=PARGAM/GAMEL
          WRITE(IOUT, 7010) TITLE(JNPI),
     &     NEVRAW(JNPI),NEVACC(JNPI),NEVOVR(JNPI),PARGAM,RAT,ERROR
CC        CALL HPRINT(801)
          GAMPMC(8+JNPI-1)=RAT
          GAMPER(8+JNPI-1)=ERROR
CAM       NEVDEC(8+JNPI-1)=NEVACC(JNPI)
  500     CONTINUE
      ENDIF
C     =====
      RETURN
 7003 FORMAT(///1X,15(5H*****)
     $ /,' *',     25X,'******** DAD4PI INITIALISATION ********',9X,1H*
     $ )
 7004 FORMAT(' *',E20.5,5X,'WTMAX  = MAXIMUM WEIGHT  ',9X,1H*/)
 7005 FORMAT(
     $  /,1X,15(5H*****)/)
 7010 FORMAT(///1X,15(5H*****)
     $ /,' *',     25X,'******** DAD4PI FINAL REPORT  ******** ',9X,1H*
     $ /,' *',     25X,'CHANNEL:',A31                           ,9X,1H*
     $ /,' *',I20  ,5X,'NEVRAW = NO. OF DECAYS TOTAL           ',9X,1H*
     $ /,' *',I20  ,5X,'NEVACC = NO. OF DECAYS ACCEPTED        ',9X,1H*
     $ /,' *',I20  ,5X,'NEVOVR = NO. OF OVERWEIGHTED EVENTS    ',9X,1H*
     $ /,' *',E20.5,5X,'PARTIAL WTDTH IN GEV UNITS             ',9X,1H*
     $ /,' *',F20.9,5X,'IN UNITS GFERMI**2*MASS**5/192/PI**3   ',9X,1H*
     $ /,' *',F20.8,5X,'RELATIVE ERROR OF PARTIAL WIDTH        ',9X,1H*
     $  /,1X,15(5H*****)/)
 902  WRITE(IOUT, 9020)
 9020 FORMAT(' ----- DADNPI: LACK OF INITIALISATION')
      STOP
      END
