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
*CMZ :  1.03/68 30/08/93  14.01.52  by  Peter C Kim
*CMZ :  1.03/33 05/12/91  11.22.29  by  Peter C Kim
*-- Author :    Daniela Bortoletto   14/10/91
      DOUBLE PRECISION FUNCTION XGAMKS(XHE3,XT)
C******************************************************************
C.
C. Calls     : None
C. Called    : DCSKS2
C. Author    : Daniela Bortoletto   14/10/91
C.
C      FUNCTION XGAMKS(XHE3,XT) IS THE SEMILEPTONIC
C      DECAY DISTRIBUTION
C                             D2SIGMA/DQ**2/DE3
C      FOR THE TRANSITION OF BOTTOM MESON TO
C      CHARM MESON, WHERE XT=Q**2, XHE3=LEPTON ENERGY.
C
C******************************************************************

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'XGAMKS' )

      DOUBLE PRECISION XT, XHE3, T, HE3, X, YMAX , COST
      DOUBLE PRECISION MP, QPLUS, QMINS, PC, XH1, PI, VORF, CTH
      DOUBLE PRECISION BM, XM,  MFF2,MFF3,VM,VM2,VM3,HELP
      COMMON /MASDB/ XM,BM,X,YMAX,COST
      DOUBLE PRECISION OVER,MFF
      COMMON /MODPAR/OVER,MFF
      INTEGER IDECAY,IDECC
      COMMON/SELE/IDECC,IDECAY
      INTEGER IHEL
C***********************************************************************
C     IN KS ONLY:   FOR V-A USE IHEL=+1, FOR V+A: IHEL=-1
C               IHEL>=0 --> IHEL := +1; IHEL<0 --> IHEL := -1
C***********************************************************************
      T = XT
      HE3 = XHE3
C.. CHECK HELICITY
      IHEL=-1
C        MFF2 = 6.80D0
C        MFF3 = 6.34D0
C        MFF4 = 6.73D0
       VM  = MFF**2  / ( MFF**2  - T )
C      VM2 = MFF2**2 / ( MFF2**2 - T )
C      VM3 = MFF3**2 / ( MFF3**2 - T )
C      VM4 = MFF4**2 / ( MFF4**2 - T )

C                                  Initialize XGAMKS
      XGAMKS = 0.0


      PI = 3.141592654
      MP = 0.939D0
      QPLUS =  (BM+XM)**2 - T
      QMINS =  (BM-XM)**2 - T
C RETURN WITH ZERO IF OUT OF BOUNDS
      IF (QPLUS.LE.0.D0 .OR. QMINS.LE.0.D0) RETURN
C     WRITE(6,*) '1'

      PC = DSQRT( QPLUS * QMINS ) / ( 2.D0*BM)
C      IF(IFALL.EQ.1) THEN
C         CTH = HE3
C         HE3 = (BM**2-XM**2+T-2.D0*BM*PC*CTH)/(4.D0*BM)
C      ELSE
         CTH = -(4.D0*BM*HE3 - BM**2 - T+XM**2)/( 2.D0*BM*PC)
C.. RETURN IF COS(THETA)**2 >= 1
         IF (CTH**2 .GT. 1.D0) RETURN
C      ENDIF
      IF (HE3.LE.0.D0 .OR. HE3.GT.(BM**2-XM**2)/(2.D0*BM) ) RETURN
      IF (IDECAY .EQ. 1) GOTO 101
      IF (IDECAY .EQ. 2) GOTO 102
      IF (IDECAY .EQ. 3) GOTO 103
      IF (IDECAY .EQ. 4) GOTO 104

C.. GAMMAU CONTRIBUTION (TRANSVERSE UNPOLARIZED DECAY)
101        XH1 = T*OVER**2*VM**2*
     *           ((BM+XM)**2+4.*BM**2*PC**2/(BM+XM)**2*VM**2)
     *           /8.*(1+CTH**2)
C*3./4.*(1.-COST**2)
      GOTO 200

C.. GAMMAP CONTRIBUTION (PARITY-ODD)

102       XH1 =IHEL * T * VM**3* OVER**2*BM*PC*CTH
C*(1-COST**2)
      GOTO 200

C.. 0* DECAY
103       XH1 = VM * OVER / XM *  DSQRT(2.D0*(1-CTH**2)) *
     *    ( (BM**2 - XM**2 -T) * (BM + XM) /2. - 2. * BM**2 * PC**2
     *     * VM /(BM+XM))
        XH1=XH1**2/16.
C*3./2.COST**2
      GOTO 200

C.. 0 DECAY
104       XH1 = 2.D0 * BM * PC * VM * OVER
     *           * DSQRT( 2.D0* (1-CTH**2) )
          XH1=XH1**2/16.
200   VORF = (1.02D0/MP**2)**2 * 151.9D0 / ( 2.D0*PI )**3
      XGAMKS = VORF *  XH1
      RETURN
      END
