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
*CMZ :  2.00/00 21/01/93  15.42.13  by  Alan Weinstein
*-- Author :
      SUBROUTINE BRMBOX
C     *****************
      IMPLICIT REAL*8(A-H,O-Z)
C     ****************************************************************
C     *                                                              *
C     *  CONTRIBUTIONS FROM THE SOFT BREMSSTRAHLUNG AD BOX DIAGR.    *
C     *  SPIN AMPLITUDES FOR FINITE PART OF BOX CONTIBUTIONS         *
C     ****************************************************************
      COMMON / CONST / PI,ALFA,ALF1,QE2,QF2,QEF
      COMMON / ENERG / ENE,AEL2,AMF2,AMF,ALGEL,ALGMF,BETI,BT1,ATH2
      COMMON / SIGMA / SIG0,SIG0CM,SOFT,SOF1,F2RE,BRM,BOX
      COMMON / UTIL1 / XK,C1,S1,C2,S2,CF,SF,CG,SG,V
      COMMON / UTIL2 / XK0,XKMIN,XKMAX
      COMMON / BOXY  / Z1,Z2,Z3
      COMPLEX*16 Z1,Z2,Z3,ZERO,AA,BB,FD,FQ,ALP,ALM
      EQUIVALENCE (ALGEL,AE),(ALGMF,AF)
      DATA ENIT/0./
C
      IF(ENIT.EQ.ENE) GO TO 10
      ENIT=ENE
      ALK0= LOG(XK0)
      ZERO=DCMPLX(0.D0,0.D0)
      ALP=DCMPLX(AE+AF,2.D0*PI)
      ALM=DCMPLX(AE-AF,0.D0)
      BTR=(1.+BT1)**2/AMF2
      FDRE=.5*(AE*AE+PI*PI/3.)
      FQRE=.5*( LOG(BTR)**2+PI*PI/3.+4.*DILOG(-1./BTR))/BT1
      FD=DCMPLX(FDRE,-PI*AE)
      FQ=DCMPLX(FQRE,-PI* LOG(BTR))
   10 CONTINUE
      BRM=0.
      Z1=ZERO
      Z2=ZERO
      Z3=ZERO
      V=BT1
      DO 20 I=1,2
      SGN=1.
      IF(I.NE.1) SGN=-1.
      C=SGN*C1
      S=SGN*S1
      TR=2.-2.*C*V-AMF2
      DL=.5*TR/S/S/V/V
      RO=(V-C)/TR
      X=(1.-C*V)/SQRT(TR)
      X2=X*X
      Y=.5*(SQRT(TR)+AMF2/(1.+V))
      BRM=BRM+SGN*(
     $   2.*(DILOG(-X/(1.-Y))-DILOG((1.-X)/(1.-Y))-DILOG((1.+X)/Y)
     $  +DILOG(X/Y))+ LOG(Y/(1.-Y))**2-DILOG(X2)+.5* LOG(X2)**2
     $   - LOG(X2)* LOG(1.-X2)   )
      A1=2.* LOG(.5*(1.-C*V))+AE+AF
      B1= LOG(.5*(1.-C*V))**2-2.*DILOG(.5*TR/(1.-C*V))
     $                                       -.5*AE*AE-.5*AF*AF
      AA=DCMPLX(A1,0.D0)
      BB=DCMPLX(B1,PI*A1)
      Z1=Z1+(        V*RO*AA    +(DL-1.)*BB            +DL*FD
     $       +(1.-V*C*DL)*FQ        -.5*ALP   +.5*AMF2/TR*ALM )*SGN
      Z2=Z2           +RO*AA       -C*DL*BB     +C*(1.-DL)*FD
     $        +(V*DL+C-V)*FQ      -.5/V*ALP +.5*AMF2/TR/V*ALM
      Z3=Z3         -S/TR*AA-.5*TR/S/V/V*BB     +S*(1.-DL)*FD
     $       +.5*C*TR/V/S*FQ                       +S/TR*ALM
   20 CONTINUE
      BRM=BRM+4.* LOG((1.-V*C1)/(1.+V*C1))*ALK0
      BOX=DREAL(Z1+C1*Z2+AMF2*S1*Z3)
      RETURN
      END
