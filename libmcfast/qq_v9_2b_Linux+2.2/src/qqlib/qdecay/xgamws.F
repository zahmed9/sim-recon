*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:42  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:30  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.03/68 30/08/93  14.42.24  by  Peter C Kim
*CMZ :  1.03/50 19/10/92  21.13.01  by  Peter C Kim
*CMZ :  1.03/46 05/06/92  15.25.18  by  Unknown
*CMZ :  1.03/46 04/06/92  10.48.21  by  Peter C Kim
*CMZ :  1.03/34 05/12/91  14.46.43  by  Peter C Kim
*CMZ :  1.03/33 05/12/91  12.03.50  by  Peter C Kim
*-- Author :    Daniela Bortoletto  14/10/91
      DOUBLE PRECISION FUNCTION XGAMWS(XHE3,XT)
C.......................................................................
C
C              FUNCTION XGAMWS(XHE3,XT) IS THE SEMILEPTONIC
C              DECAY DISTRIBUTION
C                       D2SIGMA/DQ**2/DE3
C              FOR THE TRANSITION OF BOTTOM MESON TO
C              CHARM MESON, WHERE XT=Q**2, XHE3=LEPTON ENERGY.
C
C. Calls     : None
C. Called    : DCSWSB
C. Author    : Daniela Bortoletto  14/10/91
C. Modified to correct previous modifications for b->u  M. Witherell 26.5.91
C.
C.......................................................................

      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'XGAMWS' )

      DOUBLE PRECISION XT, XHE3, T, HE3, X, YMAX , COST
      DOUBLE PRECISION MP, QPLUS, QMINS, PC, XH1, PI, VORF, CTH
      DOUBLE PRECISION BM, XM, MFF2,MFF3,VM,VM2,VM3,HELP,PX
      DOUBLE PRECISION AM(4),HMIN,HPLUS,H0,H00,HT,Q2
      COMMON /MASDB/ XM,BM,X,YMAX,COST
      COMMON /MODPAR/OVER,MFF
      DOUBLE PRECISION OVER,MFF
      COMMON/SELE3/IDECC,IDECAY,ICHAN
      INTEGER IDECC,IDECAY,ICHAN
      INTEGER IQ,NEV,IHEL
      REAL AMP(4,2),PMAS(4,2)
      REAL F0,V,A1,A2,A3,SM0P,SM0M,SM1M,SM1P,AMIQ,AMXQ,AMIXQ
      DATA NEV/0/
C***********************************************************************
C     IN WSB ONLY:   FOR V-A USE IHEL=+1, FOR V+A: IHEL=-1
C               IHEL>=0 --> IHEL := +1; IHEL<0 --> IHEL := -1
C***********************************************************************

      NEV = NEV + 1
      IF(NEV.EQ.1) THEN
C
C    The amplitudes and pole masses are put in here, following WSB paper
C    amp(i,j), pmas(i,j)  i=1,3 for V,A1,A2 for D*(rho), F for D(pi)
C    j= 1 for B -> D(D*), 2 for pi(rho)
C
        AMP(1,1) = 0.710
        AMP(2,1) = 0.650
        AMP(3,1) = 0.690
        AMP(4,1) = 0.690
        AMP(1,2) = 0.330
        AMP(2,2) = 0.280
        AMP(3,2) = 0.280
        AMP(4,2) = 0.330
        PMAS(1,1) = 6.34
        PMAS(4,1) = PMAS(1,1)
        PMAS(2,1) = 6.73
        PMAS(3,1) = PMAS(2,1)
        PMAS(1,2) = 5.33
        PMAS(4,2) = PMAS(1,2)
        PMAS(2,2) = 5.71
        PMAS(3,2) = PMAS(2,2)
      ENDIF
      T = XT
      HE3 = XHE3
      Q2=T

C                       Initialize XGAMWS
      XGAMWS = 0.0

C
C--- form factor at every q2. V,A1,A2 are three form factors for vector
C    meson in final state. F0 is the form factor for pseudoscalar.
C
        IQ = 1
        IF(ICHAN.GE.3) IQ = 2
        V  = AMP(1,IQ)/(1. - Q2/(PMAS(1,IQ))**2)
        A1 = AMP(2,IQ)/(1. - Q2/(PMAS(2,IQ))**2)
        A2 = AMP(3,IQ)/(1. - Q2/(PMAS(3,IQ))**2)
        F0 = AMP(4,IQ)/(1. - Q2/(PMAS(4,IQ))**2)
C       IF(NEV.LE.9.AND.IDECAY .eq. 1) TYPE *,'V,A1,A2', V,A1,A2

      AM(1)=0.
      AM(2)=0.
      AM(3)=XM
      AM(4)=BM

      AMIQ = AM(4)**2
      AMXQ = AM(3)**2
      AMIXQ = (AM(4) + AM(3))**2
C      IF(NEV.LE.10) TYPE *,'AM',AM(1),AM(2),AM(3),AM(4)


        QPLUS =  (BM+XM)**2 - Q2
        QMINS =  (BM-XM)**2 - Q2

C RETURN WITH ZERO IF OUT OF BOUNDS

      IF (QPLUS.LE.0.D0 .OR. QMINS.LE.0.D0) RETURN

C     WRITE(6,*) '1'

      PC = DSQRT( QPLUS * QMINS ) / ( 2.D0*BM)

      PX = DSQRT((AMIQ - AMXQ -Q2)**2 - 4.D0 * AMXQ * Q2)
     *     / (2.D0 * AM(4))

      PC = DSQRT( QPLUS * QMINS ) / ( 2.D0*BM)
C      IF(IFALL.EQ.1) THEN
C         CTH = HE3
C         HE3 = (BM**2-XM**2+T-2.D0*BM*PC*CTH)/(4.D0*BM)
C      ELSE
         CTH = -(4.D0*BM*HE3 - BM**2 - T+XM**2)/( 2.D0*BM*PC)
C.. RETURN IF COS(THETA)**2 >= 1
         IF (CTH**2 .GT. 1.D0) RETURN
C      ENDIF
      IHEL=-1
      IF (HE3.LE.0.D0 .OR. HE3.GT.(BM**2-XM**2)/(2.D0*BM) ) RETURN

      HMIN  = DSQRT(Q2)*((AM(4) + AM(3)) * A1
     *    + 2.D0 * AM(4) * PX / (AM(4) + AM(3)) * V )
      HPLUS = DSQRT(Q2)*((AM(4) + AM(3)) * A1
     *    - 2.D0 * AM(4) * PX / (AM(4) + AM(3)) * V )
      H0 = ((AMIQ - AMXQ - Q2) * A1 * (AM(4) + AM(3))
     *      - 4.D0 * AMIQ * PX**2 * A2 / (AM(4) + AM(3)))
     *   / (2.D0 * AM(3) )


      IF (IDECAY .EQ. 1) GOTO 101
      IF (IDECAY .EQ. 2) GOTO 102
      IF (IDECAY .EQ. 3) GOTO 103
      IF (IDECAY .EQ. 4) GOTO 104


C.. GAMMA- CONTRIBUTION
101   CONTINUE
      XH1 =  (HMIN**2)*(1.D0-CTH)**2
      GO TO 200
C.. GAMMA+ CONTRIBUTION
102   CONTINUE
      XH1 = (HPLUS**2)*(1.D0+CTH)**2
      GOTO 200
C.. Gamma0* DECAY
103   CONTINUE
      H00 = H0**2
      XH1=2.D0*H0**2*(1.D0-CTH**2)
      GO TO 200
C.. Pseudoscalar DECAY
104   CONTINUE
      H0 = PX*2*AM(4)*F0
      XH1=2.D0*H0**2*(1.D0-CTH**2)


      GO TO 200

200    CONTINUE
       PI = 3.141592654
       MP = 0.939D0
       VORF = (1.02D0/MP**2)**2 * 151.9D0 / ( 2.D0*PI )**3
       VORF = VORF/(BM**2)
       HT = (HMIN**2+HPLUS**2)
       XGAMWS= (VORF/16.D0 ) * XH1

C        if(nev.lt.10)type *,'px,pc',px,pc
C        if(nev.lt.10)type *,'hplus,hmin,h0',hplus,hmin,h0
C        if(nev.lt.10)type *,'ht,h00',ht,h00
C        if(nev.lt.10) type*,'vorf',vorf
C        if(nev.lt.10)type *,'xgamWS',xgamWS

      RETURN
      END
