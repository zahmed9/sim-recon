*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:28  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:02  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/00 21/01/93  15.42.12  by  Alan Weinstein
*-- Author :
      SUBROUTINE STARB(ENE1,AMF1,IDE1,IDF1,AMZ1,SINW1,INRAN,XK1)
C     **********************************************************
C     ****************************************************************
C     *                                                              *
C     *  START IS ROUTINE SETING INITIAL VALUES TO CERTAIN VARIABLES *
C     *  AND PRINTING SOME USEFULL OUTPUT                            *
C     *  MUST BE CALLED BY USER BEFORE FIRST EVENT IS GENERATED      *
C     *  ENE=ABS(ENE1) IS BEAM ENERY IN GEV UNITS, NEGATIVE VALUE    *
C     *  CAUSES SWITCHING OFF RADIATIVE CORRECTIONS. SINW2 IN THE    *
C     *  SQUARE OF THE WEINBERG ANGLE, SWITCHING OFF Z0 CONTRIBUTION *
C     *  MAY BE ACHIEVED BY SETING SINW2=-0.5   .                    *
C     *  INRAN -INITIALISATION CONSTANT FOR RANDOM NUMBER GENERATOR  *
C     *  ANY POSITIVE INTEGER.                                       *
C     ****************************************************************
C
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON / CONST / PI,ALFA,ALF1,QE2,QF2,QEF
      COMMON / UTIL1 / XK,C1,S1,C2,S2,CF,SF,CG,SG,V
      COMMON / UTIL2 / XK0,XKMIN,XKMAX
      COMMON / ENERG / ENE,AEL2,AMF2,AMF,ALGEL,ALGMF,BETI,BT1,ATH2
      COMMON / SIGMA / SIG0,SIG0CM,SOFT,SOF1,F2RE,BRM,BOX
      COMMON / WEAK  / QCE,QCF,CVE,CVF,CAE,CAF,ZPROP
      COMMON / INOUT / NINP,NOUT
      COMMON / CONTRL/ SWT(6),ISPIN
      COMMON / RNF   / INIRAN,NGEN
C     ****************************************************************
C     *  FIRST VERSION WRITTEN   20.04.1982, NO SPIN YET.            *
C     *  SECOND VERSION  20.03.1983,                                 *
C     *  SPIN CORRELATIONS IN THE DOUBLE DECAY INCLUDED.             *
C     *  THIRD VERSION 22.12.1983,                                   *
C     *  INITIAL SPIN INCLUDED.                                      *
C     ****************************************************************
C
      ENE=ABS(ENE1)
C-----PHOTON MINIMUM AND MAXIMUM ENERGY IN UNITS OF BEAM ENERGY ENE
      XKMIN=0.0
      XKMAX=1.0
C;;   XK0=0.01
      XK0=XK1
      INIRAN=INRAN
      PI=4.*ATAN(1.)
      ALFA=1./137.036
      ALF1=ALFA/PI
C-----SWITCHING OFF RADIATIVE CORRECTIONS
      IF(ENE1.LT.0.) ALF1=0.
      IF(ENE1.LT.0.) XKMAX=.9*XK0
      CMTR=389.385E-30
      DO 6 I=1,6
   6  SWT(I)=1.
C.....WARNING, THE ABOVE ASIGNMENTS IS NOT AN ERROR, IT IS FOR PURPOSE.
      ISPIN=1
      NGEN=9
      DUMMY=RNF100(-2)
      AEL=.51110034E-3/ENE
C     FINAL FERMION MASS
C;;   AMFIN=1.782
      AMFIN=AMF1
      AMF=AMFIN/ENE
      AEL2=AEL**2
      AMF2=AMF**2
      BT1=SQRT(1.-AMF)*SQRT(1.+AMF)
      SVAR=4.*ENE**2
      ALGEL= LOG(4./AEL2)
      ALGMF= LOG(4./AMF2)
C     ****************************************************************
C     *   FERMION CHARGES                                            *
C     *   QCE  INCOMING (BEAM)   FERMION CHARGE                      *
C     *   QCF  OUTGOING FERMION  ( HEAVY LEPTON )  CHARGE            *
C     *   SINW2  SIN OF WEIBERG ANGLE SQUARED                        *
C     *   ELECTRON COUPLING CONSTANTS  CVE , CAE                     *
C     *   AND TAU COUPLING CONSTANTS   CVF , CAF                     *
C     ****************************************************************
C     FOR QUARK PRODUCTION IDFIN SCHOULD BE CHANGED APROPRIATELY
C;;   IDFIN=-2
C;;   CALL SETWS(   -2,SINW2,QCE,CVE,CAE,AMZ,GAMM)
C;;   CALL SETWS(IDFIN,SINW2,QCF,CVF,CAF,AMZ,GAMM)
 
C;;;  WEAK COUPLING CONSTANTS
C     IDE IS THE INCOMING FERMION IDENTIFIER
C     IDF IS THE OUTGOING FERMION IDENTIFIER
C     IDF=2   MUON,TAU...
C     IDF=3   UP QUARK   ( U,C,T...)
C     IDF=4   DOWN QUARK  ( D,S,B...)
C     IDF NEGATIVE DENOTES ANTIPARTICLE
C     IDE=-2   INCOMING POSITRON
      IDE= IDE1
      IDF= IDF1
      SINW2=ABS(SINW1)
      CALL SETCUP(-IDE,SINW2,QCE,CVE,CAE)
      CALL SETCUP(-IDF,SINW2,QCF,CVF,CAF)
      AMZ=AMZ1
 
C-----SWITCHING OFF Z0 CONTRIBUTION FOR TESTS
      IF(SINW1.GT. 0D0) GOTO 15
      AMZ=10000.
      CAE=0.
      CVE=0.
   15 ZPROP=1./(1.-AMZ**2/ENE**2/4.)
      QE2=QCE**2
      QF2=QCF**2
      QEF=QCE*QCF
      COLR=1.
      IF(IABS(IDF).NE.2) COLR=3.
      SIG0=COLR*4.*QE2*QF2*PI*ALFA**2/3./SVAR
C------------------   SOFT PHOTON PARAMETERS
      ALK0= LOG(XK0)
      BETI=QE2*2.*ALF1*(ALGEL-1.)
      DSXI=BETI*ALK0+QE2*ALF1*(1.5*ALGEL-2.+PI*PI/3.)
      Y= LOG((1.+BT1)**2/AMF2)
      ATH2=QF2*Y
      BETF=QF2*2*ALF1*((1.+BT1**2)/(2.*BT1)*Y-1.)
      DSXF=BETF*(ALK0+.5*ALGMF)+QF2*ALF1*((3.+2.*BT1**2)/(2.*BT1)*Y
     $-2.-(1.+BT1**2)/(2.*BT1)*(Y**2+4.*DILOG(2.*BT1/(1.+BT1))-PI**2))
      F2RE=-QF2*ALF1*.25*AMF2/BT1*Y
      PIREL=ALF1*(5./9.-1./3.*ALGEL)
      PIRMU=ALF1*(5./9.-1./3.* LOG(SVAR/.10566**2))
      PIRTA=ALF1*(8./9.-BT1**2/3.-BT1/6.*(3.-BT1**2)*Y)
      PIRE=PIREL+PIRTA+PIRMU+PIRET(SVAR)
      IF(ALF1.EQ.0.) PIRE=0.
      ZCON=2.*ZPROP/QCE/QCF*CVE*CVF
      SOFT=DSXI+DSXF-2.*PIRE+ZCON
      SOF1=DSXI+DSXF-2.*PIRE
C
      IF(XKMIN.LT.XK0) XKMIN=0.
      XKMAX= MAX (XKMAX,XK0)
      XKMAX= MIN (XKMAX,(1.-AMF2))
C
      WRITE(NOUT,1000) ENE,SINW2,INIRAN
      WRITE(NOUT,1004) AMZ,CVE,CAE,CVF,CAF
C
      CSOFT=0.
      IF(XKMIN.EQ.0.) CSOFT=XKDEF(XK0)
      CSTOT=XKDEF(XKMAX)-XKDEF(XKMIN)
      WRITE(NOUT,1006) CSOFT,CSTOT
C
      SIG0CM=SIG0*CMTR
      WRITE(NOUT,1010)    SIG0CM
      IF(ALF1.EQ.0.) WRITE(NOUT,1017)
C
      RETURN
 1000 FORMAT(//,1H0,10(10H**********)//
     -  /20X,    40HSTART PARAMETERS ARE ...                ,
     -  /50X,    10HENERGY    ,F10.4,10H  GEV     ,
     -  /50X,    10HSINW2     ,F10.4,
     -  /50X,    10HINRAN     ,I10)
 1004 FORMAT(1H0,
     -  /20X,    40HMASS OF ELECTROWEAK BOSON Z0 IS  (GEV)  ,F10.4,
     -  /20X,    30HCOUPLIG CONSTANTS: CVE, CAE    ,2F10.4,
     -  /20X,    30H                   CVF, CAF    ,2F10.4)
 1006 FORMAT(1H0,
     -  /20X,    40HCONTRIBUTIONS TO SOFT CROSS SECT. ARE...,
     -  /20X,    40HBORN + SOFT PHOTON + VERTEX CORR. INIT. ,F10.4,
     -  /20X,    40HTOTAL CROSS SECTION - APPROXIMATE       ,F10.4)
 1010 FORMAT(1H ,
     -  /20X,    40HALL ABOVE CROSS SECTIONS ARE GIVEN IN   ,
     -  /20X,    40HUNITS OF THE LOWEST ORDER ( POINTLIKE ) ,
     -  /20X,    40HONE PHOTON CROSS-SECTION  SIG0 WHICH IS ,
     -  /20X,    10HEQUAL TO  ,E20.5,6H CM**2)
 1017 FORMAT(1H0,
     -  /20X,    40HNO RAD. CORRECTIONS, ONLY LOWEST ORDER    )
      END
