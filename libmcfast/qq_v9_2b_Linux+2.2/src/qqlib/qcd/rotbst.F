*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:40  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:31  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.02/00 05/06/90  15.41.34  by  Jorge L. Rodriguez
*-- Author :
* 15/10/96 Lynn Garren:  Add double precision conditionals.
      SUBROUTINE ROTBST(THETA,PHI,BETAX,BETAY,BETAZ)
C.......................................................................
C.
C. ROTBST -
C.
C. Inputs    :
C. Outputs   :
C.
C. COMMON    : MCGEN
C.
C. Calls     :
C. Called    : GGGJET GGGGEN
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
*- Argument declarations
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION THETA, PHI, BETAX, BETAY, BETAZ
#else
      REAL THETA, PHI, BETAX, BETAY, BETAZ
#endif
*
*- Sequence declarations
#include "qqlib/seq/mcgen.inc"
*
*- Local declarations
*
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'ROTBST' )
*
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION ROT(3,3), PR(3)

      INTEGER I0, NTOT, J, I, IC
      DOUBLE PRECISION    GA, BEP, GABEP
#else
      REAL ROT(3,3), PR(3)

      INTEGER I0, NTOT, J, I, IC
      REAL    GA, BEP, GABEP
#endif
*
*- Executable code starts here
*
C-- Find lower I limit. store jets after particles
      I0=LASTN+1
      IF(IST.GE.1) I0=1+K(250,2)
      NTOT=N+NC
      DO 100 IC=1,NC
         DO 100 J=1,4
  100       P(N+IC,J)=PC(IC,J)

C-- Rotate jet (typically from Z axis to direction THETA, PHI)
      IF(THETA**2+PHI**2.LT.1E-8) GOTO 130
      ROT(1,1)=COS(THETA)*COS(PHI)
      ROT(1,2)=-SIN(PHI)
      ROT(1,3)=SIN(THETA)*COS(PHI)
      ROT(2,1)=COS(THETA)*SIN(PHI)
      ROT(2,2)=COS(PHI)
      ROT(2,3)=SIN(THETA)*SIN(PHI)
      ROT(3,1)=-SIN(THETA)
      ROT(3,2)=0.
      ROT(3,3)=COS(THETA)
      DO 120 I=I0,NTOT
         DO 110 J=1,3
  110       PR(J)=P(I,J)
         DO 120 J=1,3
  120       P(I,J)=ROT(J,1)*PR(1)+ROT(J,2)*PR(2)+ROT(J,3)*PR(3)

C-- Lorentz boost jet (typically from rest to momentum/energy=beta)

  130 IF(BETAX**2+BETAY**2+BETAZ**2.LT.1E-8) GOTO 150
      GA=1./SQRT(1.-BETAX**2-BETAY**2-BETAZ**2)
      DO 140 I=I0,NTOT
         BEP=BETAX*P(I,1)+BETAY*P(I,2)+BETAZ*P(I,3)
         GABEP=GA*(GA*BEP/(1.+GA)+P(I,4))
         P(I,1)=P(I,1)+GABEP*BETAX
         P(I,2)=P(I,2)+GABEP*BETAY
         P(I,3)=P(I,3)+GABEP*BETAZ
  140    P(I,4)=GA*(P(I,4)+BEP)

C-- Jets are transformed (in most cases)
  150 IF(NC.EQ.0.OR.IST.GT.0) RETURN

      DO 160 IC=1,NC
         DO 160 J=1,4
  160       PC(IC,J)=P(N+IC,J)

      RETURN
      END
