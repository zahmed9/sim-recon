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
      SUBROUTINE AMPLIT(T1,T2)
C********************************************************************
C  IN THIS ROUTINE THE COMPLEX SPIN AMPLITUDES FOR THE TAU          *
C  PRODUCTION PROCESS ARE CALCULATED                                *
C********************************************************************
      IMPLICIT REAL*8(A-H,O-Z)
C
      COMMON / CONST / PI,ALFA,ALF1,QE2,QF2,QEF
      COMMON / WEAK  / QCE,QCF,CVE,CVF,CAE,CAF,ZPROP
      COMMON / UTIL1 / XK,C1,S1,C2,S2,CF,SF,CG,SG,V
      COMMON / BOXY  / Z1,Z2,Z3
      COMMON / ENERG / ENE,AEL2,AMF2,AMF,ALGEL,ALGMF,BETI,BT1,ATH2
      COMMON / SIGMA / SIG0,SIG0CM,SOFT,SOF1,F2RE,BRM,BOX
      COMPLEX*16 T1(4,4),T2(4,4),ZERO,FAC,TCI(4,4),TCF(4,4)
      COMPLEX*16 ONEC,IMAG,F2,ZH,Z1,Z2,Z3
      ZERO=DCMPLX(0.D0,0.D0)
      IMAG=DCMPLX(0.D0,1.D0)
      ONEC=DCMPLX(1.D0,0.D0)
C
      IF(XK.GT.0.) GOTO 300
C  ********************************************
C  *                                          *
C  *       SOFT PHOTON CASE                   *
C  *                                          *
C  ********************************************
      C=C1
      S=S1
      DO 10 I=1,4
      DO 10 IJ=1,4
 10   T1(I,IJ)=ZERO
C-----BORN AMPLITUDE
      T1(1,1)=       ONEC
      T1(2,2)=     C*ONEC
      T1(2,4)= AMF*S*IMAG
C     TERMS PROPORTIONAL TO BORN
      A=ALF1*QEF
      FAC=(1.+SOF1+A*BRM)*ONEC
      DO 20 I=1,4
      DO 20 J=1,4
 20   T2(I,J)=T1(I,J)*FAC
C-----BOX CONTRIBUTIONS
      T2(1,1)=T2(1,1)+A*Z1
      T2(2,2)=T2(2,2)+A*Z2
      T2(2,4)=T2(2,4)+A*Z3*IMAG*AMF
C-----FINAL FERMION F2-VERTEX CONTRIBUTION
      F2IM=-QF2*ALF1*PI*AMF2/(4.*BT1)
      F2=DCMPLX(F2RE,F2IM)
      T2(1,1)=T2(1,1)+2.*F2
      T2(2,2)=T2(2,2)+2.*C*F2
      T2(2,4)=T2(2,4)+2.*S/AMF*IMAG*F2
C-----WEAK BOSON Z0 CONTRIBUTION GIVES GAMMA-Z0 INTERFERENCE
C-----THIS CAN BE REASONABLE FOR ENE .LE. 20 GEV
      IF (QEF.EQ.0.) RETURN
      ZFAC=ZPROP/QCE/QCF*2.
      T2(1,1)=T2(1,1)+ZFAC*(CVE*CVF+C*CAE*CAF)*ONEC
      T2(1,2)=T2(1,2)+ZFAC*(CVE*CAF+C*CAE*CVF)*ONEC
      T2(2,1)=T2(2,1)+ZFAC*(CAE*CVF+C*CVE*CAF)*ONEC
      T2(2,2)=T2(2,2)+ZFAC*(CAE*CAF+C*CVE*CVF)*ONEC
      RETURN
  300 CONTINUE
C  *******************************************
C  *                                         *
C  *       HARD PHOTON CASE                  *
C  *                                         *
C  *******************************************
      Y=SQRT(1.-XK)
      BB=.5*XK/Y
      GB=(1.-.5*XK)/Y
      AM=AMF/Y
      HINI= QCE/Y/BB/(AEL2+S1**2)
      HFIN= QCF/BB/(AM**2+V**2*S2**2)
C-----
      TCI(1,1)= (-BB*SF                              )*HINI*ONEC
      TCI(1,2)= ( BB*C2*CF                           )*HINI*IMAG
      TCI(1,3)=                                             ZERO
      TCI(1,4)= ( AM*BB*S2*CF                        )*HINI*ONEC
      TCI(2,1)= ( BB*C1*CF                           )*HINI*IMAG
      TCI(2,2)= (-BB*C1*C2*SF                        )*HINI*ONEC
      TCI(2,3)=                                             ZERO
      TCI(2,4)= ( AM*BB*C1*S2*SF                     )*HINI*IMAG
      TCI(3,1)= (-GB*CF                              )*HINI*ONEC
      TCI(3,2)= (-GB*C2*SF                           )*HINI*IMAG
      TCI(3,3)=                                             ZERO
      TCI(3,4)= (-AM*GB*S2*SF                        )*HINI*ONEC
      TCI(4,1)= (-GB*C1*SF                           )*HINI*IMAG
      TCI(4,2)= (-GB*C1*C2*CF+S1*S2                  )*HINI*ONEC
      TCI(4,3)=                                             ZERO
      TCI(4,4)= ( AM*(GB*C1*S2*CF+S1*C2)             )*HINI*IMAG
C-----
      TCF(1,1)= (-BB*V*S2*SF                         )*HFIN*ONEC
      TCF(1,2)= ( BB*V*S2*C2*CF                      )*HFIN*IMAG
      TCF(1,3)= ( AM*BB*SF                           )*HFIN*IMAG
      TCF(1,4)= (-AM*BB*V*C2*C2*CF                   )*HFIN*ONEC
      TCF(2,1)= ( BB*V*S2*C1*CF                      )*HFIN*IMAG
      TCF(2,2)= (-BB*V*S2*C2*C1*SF                   )*HFIN*ONEC
      TCF(2,3)= ( AM*BB*C1*CF                        )*HFIN*ONEC
      TCF(2,4)= (-AM*BB*V*C2*C2*C1*SF                )*HFIN*IMAG
      TCF(3,1)= (-GB*V*S2*CF                         )*HFIN*ONEC
      TCF(3,2)= (-GB*V*S2*C2*SF                      )*HFIN*IMAG
      TCF(3,3)= ( AM*BB*CF                           )*HFIN*IMAG
      TCF(3,4)= (-AM*V*(GB*S2*S2-BB)*SF              )*HFIN*ONEC
      TCF(4,1)= (-GB*V*S2*C1*SF                      )*HFIN*IMAG
      TCF(4,2)= (-V*S2*(GB*C1*C2*CF-S1*S2)           )*HFIN*ONEC
      TCF(4,3)= (-AM*BB*C1*SF                        )*HFIN*ONEC
      TCF(4,4)= ( AM*V*((GB*S2*S2-BB)*C1*CF+S2*C2*S1))*HFIN*IMAG
      DO 140 K=1,4
      DO 140 I=1,2
      ZH=TCF(I,K)
      TCF(I  ,K)=    ZH*CF-TCF(I+2,K)*SF
  140 TCF(I+2,K)=    ZH*SF+TCF(I+2,K)*CF
 
C-----
*$ CORRECTION 16 11 87 Z.W.
      SGX=C1*SQRT(AEL2)
*$ CORRECTION 16 11 87 Z.W.
      SGX1= SGX*BB/GB
      DO 150 K=1,4
      T1(1,K)= S1*TCI(1,K)+TCF(1,K)
      T1(2,K)=(S1*TCI(2,K)+TCF(2,K))*IMAG
*$ CORRECTION 16 11 87 Z.W.
      T1(3,K)=-SGX*TCI(1,K)*IMAG*C1
      T1(4,K)=-SGX*TCI(2,K)
C-----
      T2(1,K)= S1*TCI(3,K)+TCF(3,K)
      T2(2,K)=(S1*TCI(4,K)+TCF(4,K))*IMAG
*$ CORRECTION 16 11 87 Z.W.
      T2(3,K)=-SGX1*TCI(3,K)*IMAG*C1
 150  T2(4,K)=-SGX1*TCI(4,K)
      RETURN
      END
