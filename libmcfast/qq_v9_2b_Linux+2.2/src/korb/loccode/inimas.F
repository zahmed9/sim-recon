*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:28  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:01  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.02/00 17/11/94  10.06.24  by  Alan J. Weinstein
*CMZ :  1.02/00 23/12/90  00.00.00  by  Alan Weinstein
*-- Author :    Alan Weinstein  23/12/90
      SUBROUTINE INIMAS
C.......................................................................
C.
C. INIMAS - INITIALISATION OF MASSES IN KORALB
C.
C. Inputs    : None
C.           :
C. Outputs   : None
C.
C. COMMON    :
C.
C. Calls     : None
C. Called    : by KORALB.
C. Author    : Alan Weinstein 23/12/90
C.
C. Detailed description
C.   Fill PARMAS common of KORALB with masses from MCPROP.
C.......................................................................
*SELF,IF=TYPECHEK.
      IMPLICIT NONE
*SELF.
* -------------------- Argument declarations ---------------
 
* -------------------- EXTERNAL declarations ---------------
*
* -------------------- SEQUENCE declarations ---------------
* MC info
#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqprop.inc"
#include "qqlib/seq/qqbrat.inc"
*
* -------------------- Local    declarations ---------------
*
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'INIMAS' )
*
      COMMON / PARMAS / AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
C
      REAL              AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
*
      COMMON / ADDMAS / PMAS(18),PWID(18),PPRB(2,20)
      REAL              PMAS,    PWID,    PPRB
      INTEGER I
*
* -------------------- SAVE     declarations ---------------
*
* -------------------- DATA  initializations ---------------
*
* ----------------- Executable code starts here ------------
C
C IN-COMING / OUT-GOING  FERMION MASSES
      AMTAU  = AMASS(15)
      AMEL   = AMASS(7)
      AMNUE  = AMASS(9)
      AMMU   = AMASS(11)
      AMNUMU = AMASS(13)
C MASSES USED IN TAU DECAYS
      AMPIZ  = AMASS(51)
      AMPI   = AMASS(21)
      AMRO   = AMASS(61)
      GAMRO  = RWIDTH(61)
      AMA1   = AMASS(107)
      GAMA1  = RWIDTH(107)
      AMK    = AMASS(23)
      AMKZ   = AMASS(57)
      AMKST  = AMASS(63)
      GAMKST = RWIDTH(63)
C
C Now some initialization of masses for CHOICE and FORM*:
C These are not used anymore; it is not trivial to change
C the mass/width parameters in FORM* and CHOICE.
C But I'm leaving this code around anyway...    AJW, 2/93.
      PMAS(1) = 1.57
      PWID(1) = 0.9
      PMAS(2) = 1.57
      PWID(2) = 0.9
      PMAS(3) = 1.27
      PWID(3) = 0.3
      PMAS(4) = 1.27
      PWID(4) = 0.3
      PMAS(5) = 1.27
      PWID(5) = 0.3
      PMAS(6) = 1.27
      PWID(6) = 0.3
      PMAS(7) = 1.27
      PWID(7) = 0.9
      PMAS(8) = 1.10
      PWID(8) = 0.36
      PMAS(9) = 1.20
      PWID(9) = 0.46
      PMAS(10) = 1.40
      PWID(10) = 0.6
C
      PMAS(11) = 1.37
      PWID(11) = 0.51
      PMAS(12) = 1.37
      PWID(12) = 0.114
      PMAS(13) = 1.680
      PWID(13) = 0.150
      PMAS(14) = 1.680
      PWID(14) = 0.450
C rho'(1700), K1(1270), k1(1406), omega"
      PMAS(15) = AMASS(205)
      PWID(15) = RWIDTH(205)
      PMAS(16) = AMASS(201)
      PWID(16) = RWIDTH(201)
      PMAS(17) = AMASS(203)
      PWID(17) = RWIDTH(203)
      PMAS(18) = AMASS(92)
      PWID(18) = RWIDTH(92)
 
      DO 10 I=1,14
#if defined(NONCLEO_DOUBLE)
      IF (AMASS(36+I).LT.3.D0) THEN
#else
      IF (AMASS(36+I).LT.3.) THEN
#endif
        PMAS(I) = AMASS(36+I)
        PWID(I) = RWIDTH(36+I)
      END IF
  10  CONTINUE
C
C Now store parameters for 4pi form-factor:
      IF (IPLIST(2,282).EQ.5) THEN
        PPRB(1,1) = BRLIST(IPLIST(1,282)+0)
        PPRB(1,2) = BRLIST(IPLIST(1,282)+1)-BRLIST(IPLIST(1,282)+0)
        PPRB(1,3) = BRLIST(IPLIST(1,282)+2)-BRLIST(IPLIST(1,282)+1)
        PPRB(1,4) = BRLIST(IPLIST(1,282)+3)-BRLIST(IPLIST(1,282)+2)
        PPRB(1,5) = BRLIST(IPLIST(1,282)+4)-BRLIST(IPLIST(1,282)+3)
        PPRB(1,6) = BRLIST(IPLIST(1,283)+0)
        PPRB(1,7) = BRLIST(IPLIST(1,283)+1)-BRLIST(IPLIST(1,283)+0)
        PRINT *,' KORB: 3PI-PI0 PARAMS:',(PPRB(1,I),I=1,5)
        PRINT *,' KORB: PI-3PI0 PARAMS:',(PPRB(1,I),I=6,7)
      ELSE
C default corresponds to ratio 0:1:1:1/sqrt(3):1 and 0:1
        PPRB(1,1) = 0.
        PPRB(1,2) = 0.28
        PPRB(1,3) = 0.28
        PPRB(1,4) = 0.16
        PPRB(1,5) = 0.28
        PPRB(1,6) = 0.
        PPRB(1,7) = 1.0
      END IF
C
      RETURN
      END
