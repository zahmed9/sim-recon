*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:30  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:03  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/00 21/01/93  15.42.31  by  Alan Weinstein
*-- Author :
      SUBROUTINE DADMAA(MODE,ISGN,HHV,PNU,PAA,PIM1,PIM2,PIPL,JAA)
C ----------------------------------------------------------------------
* A1 DECAY UNWEIGHTED EVENTS
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
      REAL  HHV(4)
      REAL  HV(4),PAA(4),PNU(4),PIM1(4),PIM2(4),PIPL(4)
      REAL  PDUM1(4),PDUM2(4),PDUM3(4),PDUM4(4),PDUM5(4)
      REAL*4 RRR(3)
      REAL*8 SWT, SSWT
      DATA PI /3.141592653589793238462643/
      DATA IWARM/0/
C
      IF(MODE.EQ.-1) THEN
C     ===================
        IWARM=1
        NEVRAW=0
        NEVACC=0
        NEVOVR=0
        SWT=0
        SSWT=0
        WTMAX=1E-20
        DO 15 I=1,500
        CALL DPHSAA(WT,HV,PDUM1,PDUM2,PDUM3,PDUM4,PDUM5,JAA)
        IF(WT.GT.WTMAX/1.2) WTMAX=WT*1.2
15      CONTINUE
CC      CALL HBOOK1(801,'WEIGHT DISTRIBUTION  DADMAA    $',100,0,2)
C
      ELSEIF(MODE.EQ. 0) THEN
C     =======================
300     CONTINUE
        IF(IWARM.EQ.0) GOTO 902
        CALL DPHSAA(WT,HV,PNU,PAA,PIM1,PIM2,PIPL,JAA)
CC      CALL HFILL(801,WT/WTMAX)
        NEVRAW=NEVRAW+1
        SWT=SWT+WT
        SSWT=SSWT+WT**2
        CALL RANMAR(RRR,3)
        RN=RRR(1)
        IF(WT.GT.WTMAX) NEVOVR=NEVOVR+1
        IF(RN*WTMAX.GT.WT) GOTO 300
C ROTATIONS TO BASIC TAU REST FRAME
        COSTHE=-1.+2.*RRR(2)
        THET=ACOS(COSTHE)
        PHI =2*PI*RRR(3)
        CALL ROTPOL(THET,PHI,PNU)
        CALL ROTPOL(THET,PHI,PAA)
        CALL ROTPOL(THET,PHI,PIM1)
        CALL ROTPOL(THET,PHI,PIM2)
        CALL ROTPOL(THET,PHI,PIPL)
        CALL ROTPOL(THET,PHI,HV)
        DO 44 I=1,3
 44     HHV(I)=-ISGN*HV(I)
        NEVACC=NEVACC+1
C
      ELSEIF(MODE.EQ. 1) THEN
C     =======================
        IF(NEVRAW.EQ.0) RETURN
        PARGAM=SWT/FLOAT(NEVRAW+1)
        ERROR=0
        IF(NEVRAW.NE.0) ERROR=SQRT(SSWT/SWT**2-1./FLOAT(NEVRAW))
        RAT=PARGAM/GAMEL
        WRITE(IOUT, 7010) NEVRAW,NEVACC,NEVOVR,PARGAM,RAT,ERROR
CC      CALL HPRINT(801)
        GAMPMC(5)=RAT
        GAMPER(5)=ERROR
CAM     NEVDEC(5)=NEVACC
      ENDIF
C     =====
      RETURN
 7003 FORMAT(///1X,15(5H*****)
     $ /,' *',     25X,'******** DADMAA INITIALISATION ********',9X,1H*
     $ /,' *',E20.5,5X,'WTMAX  = MAXIMUM WEIGHT                ',9X,1H*
     $  /,1X,15(5H*****)/)
 7010 FORMAT(///1X,15(5H*****)
     $ /,' *',     25X,'******** DADMAA FINAL REPORT  ******** ',9X,1H*
     $ /,' *',I20  ,5X,'NEVRAW = NO. OF A1  DECAYS TOTAL       ',9X,1H*
     $ /,' *',I20  ,5X,'NEVACC = NO. OF A1   DECS. ACCEPTED    ',9X,1H*
     $ /,' *',I20  ,5X,'NEVOVR = NO. OF OVERWEIGHTED EVENTS    ',9X,1H*
     $ /,' *',E20.5,5X,'PARTIAL WTDTH (A1  DECAY) IN GEV UNITS ',9X,1H*
     $ /,' *',F20.9,5X,'IN UNITS GFERMI**2*MASS**5/192/PI**3   ',9X,1H*
     $ /,' *',F20.8,5X,'RELATIVE ERROR OF PARTIAL WIDTH        ',9X,1H*
     $  /,1X,15(5H*****)/)
 902  WRITE(IOUT, 9020)
 9020 FORMAT(' ----- DADMAA: LACK OF INITIALISATION')
      STOP
      END
