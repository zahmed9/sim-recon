*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:40  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:37  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 04/10/94  22.13.21  by  Paul Avery
*CMZ :  1.03/57 15/02/93  16.08.05  by  Peter C Kim
*-- Author :    D. Coffman   15/02/93
      SUBROUTINE PSIHEL(P1,  P2,  K,   LAMBDA,
     *                  P12, P1K, P2K, KK, P1P1, P2P2)
C
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

      DOUBLE PRECISION    P1(4), P2(4), K(4)
      INTEGER LAMBDA
      DOUBLE PRECISION    P12, P1K, P2K, KK, P1P1, P2P2

      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'PSIHEL' )

      COMPLEX*16 P1L, P2L, KL

      IF(LAMBDA .EQ. +1)      THEN
        P1L = DCMPLX(P1(1), P1(2))/DSQRT(2.0D0)
        P2L = DCMPLX(P2(1), P2(2))/DSQRT(2.0D0)
        KL  = DCMPLX(K(1),  K(2)) /DSQRT(2.0D0)

      ELSE IF(LAMBDA .EQ. 0)  THEN
        P1L = -DCMPLX(P1(3), 0.0D0)
        P2L = -DCMPLX(P2(3), 0.0D0)
        KL  = -DCMPLX(K(3),  0.0D0)

      ELSE IF(LAMBDA .EQ. -1) THEN
        P1L = -DCMPLX(P1(1), -P1(2))/DSQRT(2.0D0)
        P2L = -DCMPLX(P2(1), -P2(2))/DSQRT(2.0D0)
        KL  = -DCMPLX(K(1),  -K(2)) /DSQRT(2.0D0)

      ENDIF

      P12  = DREAL(P1L*DCONJG(P2L))
      P1K  = DREAL(P1L*DCONJG(KL))
      P2K  = DREAL(P2L*DCONJG(KL))

      KK   = DREAL(DCONJG(Kl)*KL)
      P1P1 = DREAL(DCONJG(P1L)*P1L)
      P2P2 = DREAL(DCONJG(P2L)*P2L)

      RETURN
      END
