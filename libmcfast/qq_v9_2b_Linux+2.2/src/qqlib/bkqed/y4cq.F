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
*CMZ :  1.03/74 07/01/94  15.41.00  by  Brian Heltsley
* fix awful angle bug of unknown origin
*CMZ :  1.00/00 04/06/90  18.55.46  by  Jorge L. Rodriguez
*-- Author :

      FUNCTION Y4CQ(CCC)
C  ---------------------------------------------------------------------------
C...CUMULATIVE INTEGRAL OVER "ORIGINAL" SCATTERING ANGLE
C...ONLY FOR HARD PART; FOR SOFT PART "GENCOS" IS USED
C...THERE IS AN OVERALL FACTOR 2.D0*ALFA**3/S*LOG(S/M**2)
C...WHICH IS LEFT OUT
C  ---------------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION(A-Z)

      COMMON / CON1 / PI,M,ALFA,PI2,LE,E,DL,MU,S,DUMMY(8)
      COMMON / OUT13 / K,C,Z,FI,FG
C MODIFY.....Y4C IS SYMMETRIC....Y4C(-C) = - Y4C(+C)
C
C THUS POPULATE ONLY C=0....1, THEN THROW RANDOM SIGN CHOICE
C USE CCC=-LOG(1-C/ETA), ETA=1+MU
C
      C=(1.+MU)*(1.-DEXP(-CCC))
C      B1=CCC
      B1=DLOG(((1.+C)+MU)/((1.-C)+MU))
      B2=DLOG((2.D0-K*(1.D0-C))/(2.D0-K*(1.D0+C)))
      Y4CQ=(1.D0-K)/K*B1+1.D0/(2.D0+MU*K)*(B1+B2)
      RETURN
      END
