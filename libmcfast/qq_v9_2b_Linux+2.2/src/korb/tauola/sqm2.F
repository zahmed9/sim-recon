*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:32  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:03  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/00 21/01/93  15.42.30  by  Alan Weinstein
*-- Author :
      FUNCTION SQM2(ITDKRC,QP,XN,XA,XK,AK0,HV)
C
C **********************************************************************
C     REAL PHOTON MATRIX ELEMENT SQUARED                               *
C     PARAMETERS:                                                      *
C     HV- POLARIMETRIC FOUR-VECTOR OF TAU                              *
C     QP,XN,XA,XK - 4-momenta of electron (muon), NU, NUBAR and PHOTON *
C                   All four-vectors in TAU rest frame (in GeV)        *
C     AK0 - INFRARED CUTOFF, MINIMAL ENERGY OF HARD PHOTONS (GEV)      *
C     SQM2 - value for S=0                                             *
C     see Eqs. (2.9)-(2.10) from CJK ( Nucl.Phys.B(1991) )             *
C **********************************************************************
C
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON / PARMAS / AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
C
      REAL*4            AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
      COMMON / DECPAR / GFERMI,GV,GA,CCABIB,SCABIB,GAMEL
      REAL*4            GFERMI,GV,GA,CCABIB,SCABIB,GAMEL
      COMMON / QEDPRM /ALFINV,ALFPI,XK0
      REAL*8           ALFINV,ALFPI,XK0
      REAL*8    QP(4),XN(4),XA(4),XK(4)
      REAL*8    R(4)
      REAL*8   HV(4)
      REAL*8 S0(3),RXA(3),RXK(3),RQP(3)
      DATA PI /3.141592653589793238462643D0/
C
      TMASS=AMTAU
      GF=GFERMI
      ALPHAI=ALFINV
      TMASS2=TMASS**2
      EMASS2=QP(4)**2-QP(1)**2-QP(2)**2-QP(3)**2
      R(4)=TMASS
C     SCALAR PRODUCTS OF FOUR-MOMENTA
      DO 7 I=1,3
        R(1)=0.D0
        R(2)=0.D0
        R(3)=0.D0
        R(I)=TMASS
        RXA(I)=R(4)*XA(4)-R(1)*XA(1)-R(2)*XA(2)-R(3)*XA(3)
C       RXN(I)=R(4)*XN(4)-R(1)*XN(1)-R(2)*XN(2)-R(3)*XN(3)
        RXK(I)=R(4)*XK(4)-R(1)*XK(1)-R(2)*XK(2)-R(3)*XK(3)
        RQP(I)=R(4)*QP(4)-R(1)*QP(1)-R(2)*QP(2)-R(3)*QP(3)
  7   CONTINUE
      QPXN=QP(4)*XN(4)-QP(1)*XN(1)-QP(2)*XN(2)-QP(3)*XN(3)
      QPXA=QP(4)*XA(4)-QP(1)*XA(1)-QP(2)*XA(2)-QP(3)*XA(3)
      QPXK=QP(4)*XK(4)-QP(1)*XK(1)-QP(2)*XK(2)-QP(3)*XK(3)
c     XNXA=XN(4)*XA(4)-XN(1)*XA(1)-XN(2)*XA(2)-XN(3)*XA(3)
      XNXK=XN(4)*XK(4)-XN(1)*XK(1)-XN(2)*XK(2)-XN(3)*XK(3)
      XAXK=XA(4)*XK(4)-XA(1)*XK(1)-XA(2)*XK(2)-XA(3)*XK(3)
      TXN=TMASS*XN(4)
      TXA=TMASS*XA(4)
      TQP=TMASS*QP(4)
      TXK=TMASS*XK(4)
C
      X= XNXK/QPXN
      Z= TXK/TQP
      A= 1+X
      B= 1+ X*(1+Z)/2+Z/2
      S1= QPXN*TXA*( -EMASS2/QPXK**2*A + 2*TQP/(QPXK*TXK)*B-
     $TMASS2/TXK**2)  +
     $QPXN/TXK**2* ( TMASS2*XAXK - TXA*TXK+ XAXK*TXK) -
     $TXA*TXN/TXK - QPXN/(QPXK*TXK)* (TQP*XAXK-TXK*QPXA)
      CONST4=256*PI/ALPHAI*GF**2
      IF (ITDKRC.EQ.0) CONST4=0D0
      SQM2=S1*CONST4
      DO 5 I=1,3
        S0(I) = QPXN*RXA(I)*(-EMASS2/QPXK**2*A + 2*TQP/(QPXK*TXK)*B-
     $  TMASS2/TXK**2) +
     $  QPXN/TXK**2* (TMASS2*XAXK - TXA*RXK(I)+ XAXK*RXK(I))-
     $  RXA(I)*TXN/TXK - QPXN/(QPXK*TXK)*(RQP(I)*XAXK- RXK(I)*QPXA)
  5     HV(I)=S0(I)/S1-1.D0
      RETURN
      END
