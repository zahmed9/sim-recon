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
*CMZ :  1.00/00 04/06/90  18.55.46  by  Jorge L. Rodriguez
*-- Author :

      SUBROUTINE QED04A(K1,K2,K3)

C  ---------------------------------------------------------------------------
C...CONSTRUCT 4VECTORS OUT OF GENERATED VARIABLES ;
C...THIS IS EXACT BECAUSE THE PARTICLES ARE MASSLES.
C...THE FOURTH COMPONENT IS THE ENERGY;THE THIRD COMPONENT
C...IS THE DIRECTION OF THE POSITRON BEAM
C  ---------------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION(A-Z)

      DIMENSION K1(4),K2(4),K3(4)
      COMMON / CON1 / PI,M,ALFA,PI2,LE,E,DL,MU,S,K0,CMAX,BETA,
     *                SIG0,SIGA,SIGCOL,THRSLD,LK0
      COMMON / OUT13 / E1,C,Z,FI,FG
      COMMON / OUT12 / SC,SZ,CGAM,E2
      K1(1)=E1*SZ*DCOS(FG)
      K1(2)=E1*SZ*DSIN(FG)
      K1(3)=E1*Z
      K1(4)=E1
      K2(1)=E2*SC*DCOS(FI)
      K2(2)=E2*SC*DSIN(FI)
      K2(3)=E2*C
      K2(4)=E2
      K3(1)=-K1(1)-K2(1)
      K3(2)=-K1(2)-K2(2)
      K3(3)=-K1(3)-K2(3)
      K3(4)=-K1(4)-K2(4)+2.D0*E
      RETURN
      END
