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
      SUBROUTINE DADMPI(MODE,ISGN,HV,PPI,PNU)
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
      REAL  PPI(4),PNU(4),HV(4)
      DATA PI /3.141592653589793238462643/
C
      IF(MODE.EQ.-1) THEN
C     ===================
        NEVTOT=0
      ELSEIF(MODE.EQ. 0) THEN
C     =======================
        NEVTOT=NEVTOT+1
        EPI= (AMTAU**2+AMPI**2-AMNUTA**2)/(2*AMTAU)
        ENU= (AMTAU**2-AMPI**2+AMNUTA**2)/(2*AMTAU)
        XPI= SQRT(EPI**2-AMPI**2)
C PI MOMENTUM
        CALL SPHERA(XPI,PPI)
        PPI(4)=EPI
C TAU-NEUTRINO MOMENTUM
        DO 30 I=1,3
30      PNU(I)=-PPI(I)
        PNU(4)=ENU
        PXQ=AMTAU*EPI
        PXN=AMTAU*ENU
        QXN=PPI(4)*PNU(4)-PPI(1)*PNU(1)-PPI(2)*PNU(2)-PPI(3)*PNU(3)
        BRAK=(GV**2+GA**2)*(2*PXQ*QXN-AMPI**2*PXN)
     &      +(GV**2-GA**2)*AMTAU*AMNUTA*AMPI**2
        DO 40 I=1,3
40      HV(I)=-ISGN*2*GA*GV*AMTAU*(2*PPI(I)*QXN-PNU(I)*AMPI**2)/BRAK
        HV(4)=1
C
      ELSEIF(MODE.EQ. 1) THEN
C     =======================
        IF(NEVTOT.EQ.0) RETURN
        FPI=0.1284
        GAMM=(GFERMI*FPI)**2/(16.*PI)*AMTAU**3*
     *       (BRAK/AMTAU**4)**2
        ERROR=0
        RAT=GAMM/GAMEL
        WRITE(IOUT, 7010) NEVTOT,GAMM,RAT,ERROR
        GAMPMC(3)=RAT
        GAMPER(3)=ERROR
CAM     NEVDEC(3)=NEVTOT
      ENDIF
C     =====
      RETURN
 7010 FORMAT(///1X,15(5H*****)
     $ /,' *',     25X,'******** DADMPI FINAL REPORT  ******** ',9X,1H*
     $ /,' *',I20  ,5X,'NEVTOT = NO. OF PI  DECAYS TOTAL       ',9X,1H*
     $ /,' *',E20.5,5X,'PARTIAL WTDTH ( PI DECAY) IN GEV UNITS ',9X,1H*
     $ /,' *',F20.9,5X,'IN UNITS GFERMI**2*MASS**5/192/PI**3   ',9X,1H*
     $ /,' *',F20.8,5X,'RELATIVE ERROR OF PARTIAL WIDTH (STAT.)',9X,1H*
     $  /,1X,15(5H*****)/)
      END
