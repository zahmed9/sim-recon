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
*CMZ :  1.03/10 12/06/91  11.31.03  by  Peter C Kim
*CMZ :  1.00/00 04/06/90  18.55.47  by  Jorge L. Rodriguez
*-- Author :

      SUBROUTINE QED02A(QP,QM,PH)
C  ----------------------------------------------------------------------------
C...CONSTRUCT 4MOMENTA FROM EVENT PARAMETERS K,C,CG,FIG,FI
C...THE ENERGIES ARE NORMALIZED TO THE BEAM ENERGY ;
C...THE POSITRON DIRECTION IS THE POSITIVE Z-AXIS  ;
C...THE PARTICLE ENERGIES ARE THE FOURTH COMPONENTS.
C  ----------------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION(A-H,K,O-Z)

      DIMENSION QP(4),QM(4),PH(4)
      COMMON / CONSTQ / E,AE,AM,ALE,ALM,ALL,PI,PI2,ALFA,BETA
      COMMON / OUTPAR / K,C,CG,FIG,FI
      COMMON / OUTPA2 / S,SG,CF,SF,CI,SI
      LOGICAL LSFOT
      DATA LSFOT/.FALSE./
      GOTO 7777
C
      ENTRY QED027(IARG)
      LSFOT=IARG.NE.0
      RETURN
C
 7777 CONTINUE
C...QP=Q*ROTA*ROTB*(0,0,1)
C...PH=K*ROTA*ROTB*(SG*SF,SG*CF,CG)
C
C ROTA=(+CI,+SI,0 // +SI,-CI,0 // 0,0,1)
C ROTB=(1,0,0 // 0,-C,+S // 0,+S,+C)
C
      IF(K.NE.0.D0) GOTO 300
      IF(.NOT.LSFOT) GOTO 400
      CALL QED026
      CF=DCOS(FIG)
      SF=DSIN(FIG)
C...4MOMENTUM OF MU+
  300 Q=2.D0*(1.D0-K)/(2.-K+K*CG)
      QP(1)=Q*SI*S
      QP(2)=-Q*CI*S
      QP(3)=Q*C
      QP(4)=Q
C...4MOMENTUM OF THE PHOTON
      PH(1)=K*(CG*S*SI-C*SI*SG*CF+CI*SG*SF)
      PH(2)=K*(-CI*CG*S+CI*C*SG*CF+SI*SG*SF)
      PH(3)=K*(C*CG+S*SG*CF)
      PH(4)=K
      GOTO 500
C
C
  400 QP(1)=SI*S
      QP(2)=-CI*S
      QP(3)=C
      QP(4)=1.D0
      PH(1)=0.D0
      PH(2)=0.D0
      PH(3)=0.D0
      PH(4)=0.D0
C
C...4MOMENTUM OF THE MU- IS GIVEN BY MOMENTUM CONSERVATION
C
  500 QM(1)=-QP(1)-PH(1)
      QM(2)=-QP(2)-PH(2)
      QM(3)=-QP(3)-PH(3)
      QM(4)=-QP(4)-PH(4)+2.
      RETURN
      END
