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
*CMZ :  1.03/10 12/06/91  11.32.27  by  Peter C Kim
*CMZ :  1.00/00 04/06/90  18.55.47  by  Jorge L. Rodriguez
*-- Author :

      SUBROUTINE QEDSY2(IERR)
      IMPLICIT DOUBLE PRECISION (A-H,K,O-Z)

      COMMON / CONSTQ / E,AE,AM,ALE,ALM,ALL,PI,PI2,ALFA,BETA
      COMMON /CONST1/ CMAX,K0,KMIN,KMAX,SIG0,SOFT1,TRSHLD,CHI,GV2,DELW
      COMMON/OUTPAR/K,C,CG,FIG,FI
      COMMON/OUTPA2/S,SG,CF,SFIG,CFI,SFI
      IERR = 0
      Y=2.D0-K+K*CG
      XP=2.D0*(1.D0-K)/Y
      XM=2.D0-K-XP
      XMZ=-K*(C*CG+S*SG*CF)-XP*C
      IF(DABS(XMZ/XM).GT.CMAX) GOTO 50
      RETURN

50    IERR = 1
      RETURN
      END
