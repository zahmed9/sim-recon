*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:35  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:29  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.03/10 12/06/91  11.31.20  by  Peter C Kim
*CMZ :  1.00/00 04/06/90  18.55.47  by  Jorge L. Rodriguez
*-- Author :

      FUNCTION Y2K(K)
      IMPLICIT DOUBLE PRECISION(A-H,K,O-Z)
      COMMON / CONSTQ / E,AE,AM,ALE,ALM,ALL,PI,PI2,ALFA,BETA
      COMMON /CONST1/ CMAX,K0,KMIN,KMAX,SIG0,SOFT1,TRSHLD,CHI,GV2,DELW
      IF(K.GE.K0) GOTO 311
C...SOFT CASE ; CONSIDER SMEARED-OUT SPECTRUM BETEEN 0 AND K0
         Y2K=K/K0*SIG0*SOFT1
         RETURN
C...HARD CASE
311   Y2K=SIG0*(SOFT1+Y2KQ(DLOG(K/K0)) )
      RETURN
      END
