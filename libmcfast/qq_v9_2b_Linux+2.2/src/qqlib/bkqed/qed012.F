*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:34  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:28  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.01/00 17/09/90  23.22.39  by  Paul Avery
*CMZ :  1.00/00 04/06/90  18.55.45  by  Jorge L. Rodriguez
*-- Author :

      SUBROUTINE QED012(QP,QM,QK)

      IMPLICIT DOUBLE PRECISION(A-H,K,O-Z)
      REAL RANP
      EXTERNAL RANP
      DIMENSION QP(4),QM(4),QK(4)
      COMMON / BAPARM / SIG0,SIGS,SIGH,SIGT,WT(18)
     *                 ,YSOFT,K0,KRAT,DMIN,DMAX,XLCMIN,XM2,TWOPI
     *                  ,EM2,CMIN,CMAX,WMAX,ZSOFT,EBEAM
     *                  ,SIGSW,WTWT(2)
        DATA NERR/10/
C-------------------------------------------- CHOOSE HARD OR SOFT -----
    6 IF(RANP(0).GT.YSOFT) GOTO 11
C-------------------------------------------- SOFT PHOTON PART --------
      WT(7)=WT(7)+1.D0
C-------------------------------------------- GENERATE C VALUE --------
      OMC=1.D0/(DMIN+RANP(0)*(DMAX-DMIN))
      C=1.D0-OMC
C-------------------------------------------- CALCULATE WEIGHT --------
      CALL VIRSOF(EBEAM,K0,OMC,BORN,CORR,CORR3)
      W=BORN*(1.D0+CORR)*OMC**2*ZSOFT
      WZ0=W*CORR3/(1.D0+CORR)
      WT(8)=WT(8)+W
      WT(9)=WT(9)+W*W
      WTWT(1)=WTWT(1)+WZ0
      WTWT(2)=WTWT(2)+WZ0*WZ0
      IF(W.LT.0.D0)   WT(15)=WT(15)+1.D0
      IF(W.GT.WMAX)   WT(16)=WT(16)+1.D0
      IF(W.LT.WT(17)) WT(17)=W
      IF(W.GT.WT(18)) WT(18)=W
C-------------------------------------------- REJECT W VALUES ---------
        IF(W.LE.WMAX) GOTO 313
                IF(NERR.LE.0) GOTO 313
                NERR=NERR-1
C*****          TYPE *, ' ',('*',J=1,80)
C*****          TYPE *,' SOFT WEIGHT IS TOO LARGE',W,WMAX
C*****          TYPE *,' OMC =',OMC
C*****          TYPE *,' ',('*',J=1,80)
                IF(NERR.NE.0) GOTO 313
C*****          TYPE *,' NO MORE MESSAGES WILL BE PRINTED'
313     IF(W.LT.WMAX*RANP(0)) GOTO 6
      WT(10)=WT(10)+1.D0
C-------------------------------------------- CONSTRUCT MOMENTA -------
      SC=DSQRT(OMC*(2.D0-OMC))
      K=0.D0
      X=1.D0
      QK1=0.
      QK2=0.
      QK3=0.
      GOTO 311
C-------------------------------------------- HARD PHOTON PART --------
   11 WT(1)=WT(1)+1.D0
C-------------------------------------------- GENERATE K VALUE --------
C   DN/DK === 1/K
      K=K0*KRAT**RANP(0)
C-------------------------------------------- GENERATE C VALUE --------
C   DN/DC === (1-C)**-2 * FF(1-C)/FF(1-CMIN) WITH FF(X)=LN(2*X/ME**2)
    7 OMC=1.D0/(DMIN+RANP(0)*(DMAX-DMIN))
      WT(2)=WT(2)+1.D0
      REJFUN=DLOG(2.D0*OMC/XM2)/XLCMIN
      IF(RANP(0).GT.REJFUN) GOTO 7
      C=1.D0-OMC
      SC=DSQRT(OMC*(2.D0-OMC))
C-------------------------------------------- GENERATE U VALUE --------
C   DN/DU === (1+D-U)**-1 + (U+D)**-1
      CM=2.D0*OMC
      D=XM2/CM
      R=-1.D0+2.D0*RANP(0)
      V=(1.D0+1.D0/D)**DABS(R)
      U=D*(V-1.D0)
      OMU=1.D0-U
      IF(R.GE.0.D0) OMU=U
      IF(R.GE.0.D0) U=1.D0-OMU
      E2=U*OMU*CM
      EV=DSQRT(1.D0-E2)
      E2=XM2+E2
C-------------------------------------------- GENERATE C1 VALUE -------
      R=RANP(0)
      VC=2.D0*E2*(1.D0-R)/(E2+2.D0*EV*(EM2+EV)*R)
      C1=1.D0-VC
      SC1=DSQRT(VC*(2.D0-VC))
C-------------------------------------------- GENERATE F1 VALUE -------
      F1=TWOPI*RANP(0)
      CF1=DCOS(F1)
      SF1=DSIN(F1)
C-------------------------------------------- CONSTRUCT QK DIRECTION --
      UC=-OMU-U*C
      QK1=(UC*SC1*CF1-U*SC*C1)/EV
      QK2=SC1*SF1
      QK3=(U*SC*SC1*CF1+UC*C1)/EV
      CG=C*QK3+SC*QK1
C-------------------------------------------- REJECT CT VALUES --------
      KM=1.D0-K
      OMX=K*(1.+CG)/(2.-K+K*CG)
      OMXT=K-OMX
      X=1.-OMX
      XT=1.-OMXT
CCC      CT=(X*C+K*QK3)/XT
      OMCT=(2.*OMX+X*OMC-K*(1.+QK3))/XT
      CT=1.-OMCT
      IF(CT.LT.CMIN.OR.CT.GT.CMAX) GOTO 6
      WT(3)=WT(3)+1.D0
C-------------------------------------------- CALCULATE WEIGHT --------
      S =4.D0
      S1=4.D0*KM
      T =-2.D0*X *OMC
      T1=-2.D0*XT*OMCT
      U =-2.D0*XT*(1.D0+CT)
      U1=-2.D0*X *(1.D0+C )
      X1=K*(EM2-QK3)
      X2=K*(EM2+QK3)
      DY=.5D0*XM2*K/KM
      Y1=2.D0*OMXT+DY
      Y2=2.D0*OMX +DY
      W=(S*S1*(S*S+S1*S1)+T*T1*(T*T+T1*T1)+U*U1*(U*U+U1*U1))
     .  /(4.*S*S*S*S1)
     .  *(1.D0-(S*Y1*Y2+S1*X1*X2+U*X2*Y1+U1*X1*Y2)
     .         /(T*X2*Y2+T1*X1*Y1))
     .  *(1.D0-XM2*K/(1.D0+KM*KM)
     .        *(KM/X1+KM/X2+1.D0/Y1+1.D0/Y2))
      WT(4)=WT(4)+W
      WT(5)=WT(5)+W*W
      IF(W.LT.0.D0)   WT(11)=WT(11)+1.D0
      IF(W.GT.WMAX)   WT(12)=WT(12)+1.D0
      IF(W.LT.WT(13)) WT(13)=W
      IF(W.GT.WT(14)) WT(14)=W
C-------------------------------------------- REJECT W VALUES ---------
        IF(W.LE.WMAX) GOTO 312
                IF(NERR.LE.0) GOTO 312
                NERR=NERR-1
C*****          TYPE *,' ',('*',J=1,80)
C*****          TYPE *,' HARD WEIGHT IS TOO LARGE',W,WMAX
C*****          TYPE *,' K,OMC,OMCT=',K,OMC,OMCT
C*****          TYPE *,' OMU,VC,F1,CG=',OMU,VC,F1,CG
C*****          TYPE *,' OMX,OMXT=',OMX,OMXT
C*****          TYPE *,' ',('*',J=1,80)
                IF(NERR.NE.0) GOTO 312
C*****          TYPE *,' NO MORE MESSAGES WILL BE PRINTED'
312     R=WMAX*RANP(0)/W
        IF(R.GT.1.) GOTO 6
      WT(6)=WT(6)+1.D0
C-------------------------------------------- CONSTRUCT MOMENTA -------
  311 FI=RANP(0)*TWOPI
      CFI=DCOS(FI)
      SFI=DSIN(FI)
      QK(4)=K
      QK(3)=K*QK3
      QK(2)=K*(QK2*CFI-QK1*SFI)
      QK(1)=K*(QK2*SFI+QK1*CFI)
      QP(4)=X
      QP(3)=X*C
      QP(2)=-X*SC*SFI
      QP(1)=X*SC*CFI
      QM(1)=-QP(1)-QK(1)
      QM(2)=-QP(2)-QK(2)
      QM(3)=-QP(3)-QK(3)
      QM(4)=2.D0-K-X
C-------------------------------------------- REFLECTION POINT --------
      REFLCT=RANP(0)
      IF(REFLCT.LT.0.5D0) GOTO 10
      D O 9 I=1,3
      QK(I)=-QK(I)
      QPI=QP(I)
      QP(I)=-QM(I)
    9 QM(I)=-QPI
      QPI=QP(4)
      QP(4)=QM(4)
      QM(4)=QPI
   10 RETURN
      END
