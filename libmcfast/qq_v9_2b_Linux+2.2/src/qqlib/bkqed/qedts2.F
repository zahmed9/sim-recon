*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:34  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:29  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.03/10 12/06/91  11.32.45  by  Peter C Kim
*CMZ :  1.00/00 04/06/90  18.55.47  by  Jorge L. Rodriguez
*-- Author :

      FUNCTION QEDTS2(DUMMY)
C  ---------------------------------------------------------------------------
C...TEST EVENT FOR ACCEPTANCE BY COMPARING COLINEAR APPROXIMATION
C...WITH THE EXACT DISTRIBUTION IN BOTH REGIMES
C  ---------------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION(A-H,K,O-Z)

      COMMON / CONSTQ / E,AE,AM,ALE,ALM,ALL,PI,PI2,ALFA,BETA
      COMMON /CONST1/ CMAX,K0,KMIN,KMAX,SIG0,SOFT1,TRSHLD,CHI,GV2,DELW
      COMMON / OUTPAR / K,C,CG,FIG,FI
      COMMON / OUTPA2 / S,SG,CFIG,SFIG,CFI,SFI
      COMMON/QED000/IMODDD,LOUT
      CP=1.D0+C
      CM=1.D0-C
      CS=1.D0+C*C
      IF(K.EQ.0.D0)GO TO 2
C...HARD EVENT
      Y=2.D0-K+K*CG
      Y2=Y*Y
      KM=1.D0-K
      KM2=1.D0+KM*KM
      AM2=AM*AM
      AE2=AE*AE
      AE3=0.5D0*AE2
      DEL=.25D0*AM2*K/KM
      X=2.D0*KM/Y
      TK=2.D0*(X-KM+DEL)
      UK=2.D0*(1.D0-X+DEL)
      AKA=C*CG+S*SG*CFIG
      KA1=((1.D0+AKA)+AE3)*K
      KA =((1.D0-AKA)+AE3)*K
      T =X*CM
      T1=X*CP
      U =2.D0-T-KA
      U1=2.D0-T1-KA1
      T2 =T*T
      T12=T1*T1
      U2 =U*U
      U12=U1*U1
      ACOLL=(-AE2*((U12+T12)/KA/KA+(U2+T2)/KA1/KA1)/KM/KM
     Z       -AM2*((U2+U12)/TK/TK+(T2+T12)/UK/UK)
     Z  +(T2+T12+U2+U12)/KM*(2.D0/KA/KA1+2.D0*KM/TK/UK
     Z  +T/TK/KA-T1/TK/KA1-U/UK/KA+U1/UK/KA1))*K*KM/Y/Y
      AKC =(CP*CP+KM*KM*CM*CM)/(CP+KM*CM)**4
      AKCM=(CM*CM+KM*KM*CP*CP)/(CM+KM*CP)**4
      COLL=4.D0*( AKC*(-AE2*K*KM/KA+KM2)/KA
     Z          +AKCM*(-AE2*K*KM/KA1+KM2)/KA1)
     Z +2.D0*CS*KM*(   (-AM2*K/TK+KM2)/TK
     Z             +(-AM2*K/UK+KM2)/UK  )/Y2
      QEDTS2=ACOLL/COLL
      IF(QEDTS2.LT.0.D0) WRITE (LOUT,10) ACOLL,COLL,K,C,CG,CFIG
C*****IF(QEDTS2.LT.0.D0) TYPE      10,ACOLL,COLL,K,C,CG,CFIG
   10 FORMAT(/,20X,'TEST NEGATIVE',/,20X,6D15.7)
      RETURN
C
C...SOFT EVENT
C
    2 CP=0.5D0*CP
      CM=0.5D0*CM
      ALCP=DLOG(CP)
      ALCM=DLOG(CM)
      DARC=2.D0*ALFA/PI*(
     Z -0.5D0/CS*(C*(ALCP*ALCP+ALCM*ALCM)+2.D0*(CM*ALCP-CP*ALCM))
     Z +0.5D0*(ALCM*ALCM-ALCP*ALCP)  +DILOG(CP)-DILOG(CM) )
      DARC=DARC+4.D0*ALFA/PI*(ALCM-ALCP)*DLOG(K0)
      DWC=2.D0*CHI*(GV2+2.D0*C/CS)
      QEDTS2=(SOFT1 + DARC + DWC)/(SOFT1+DELW)
      IF(QEDTS2.LT.0.D0) WRITE (LOUT,10) K,C,SOFT1,DARC,DWC,DELW
C*****IF(QEDTS2.LT.0.D0) TYPE      10,K,C,SOFT1,DARC,DWC,DELW
      RETURN
      END
