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
*CMZ :  1.00/00 04/06/90  18.55.46  by  Jorge L. Rodriguez
*-- Author :

      FUNCTION PROXIM(K,Z,X,C,X1,C1)

C --------------------------------------------------------------------------
C...CALCULATES ONE-SIXTH OF THE APPROXIMANT BY CHOOSING A DEFINITE
C...LABELING OF THE THREE PHOTONS ; ONE OF THEM REMAINS DUMMY (3RD)
C...THE TRIAL EVENTS ARE GENERATED WITH VARIABLES K AND X , WHICH
C...GIVE RISE TO A PHASE SPACE FACTOR  X**2*K/2/(1-K); TO
C...MAKE THE PHASE SPACE SYMMETRIC UNDER ANY PERMUTATION AS IN THE
C...EXACT EXPRESSION , WE HAVE TO DIVIDE BY THIS FACTOR.
C --------------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION(A-Z)

      COMMON / CON1 / PI,M,ALFA,PI2,LE,E,DL,MU,S,DUMMY(8)
      KM=E-K
      CP=E+C
      CM=E-C
      ZP=E+Z
      ZM=E-Z
      YP=2.D0*E-K*(1.D0-C)
      YM=2.D0*E-K*(1.D0+C)
C...APPROXIMANT
      PROXIM=4.D0/CM/ZM*(KM/K/CP+1.D0/YP)+4.D0/CP/ZP*(KM/K/CM+1.D0/YM)
      PROXIM=ALFA**3/8.D0/PI2/S*PROXIM
C...PHASE SPACE RENORMALIZATION
      PROXIM=PROXIM*2.D0*(E-K)/K/X**2
      RETURN
      END
