*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:39  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:37  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 04/10/94  23.00.01  by  Paul Avery
*CMZ :          19/05/90  14.51.01  by  Jorge L. Rodriguez
*>> Author :

      SUBROUTINE JETDEC(IPD,CMAS,LAST,MATRX,NDAU,IER)
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "qqlib/seq/mcgen.inc"

C     Calling arguments
      INTEGER IPD, LAST, MATRX, NDAU, IER
      REAL CMAS
*
C     Local variables
      INTEGER NCOLD, J, I1, I
      REAL PCSAV(4,4)
      REAL BETAX, BETAY, BETAZ
C ---------------------------------------------------------------------------

C   MATRX < 0 .... jet decays

C   Save momentum of quarks, gluons
      IER = 0
      NCOLD = NC
      DO 1600 I=1,4
        DO 1590 J=1,NCOLD
          PCSAV(J,I) = PC(J,I)
1590    CONTINUE
1600  CONTINUE
      GOTO (1610,1620,1630,1640),-MATRX

C  MATRX = -1 .... gg decay  (NDAU = 1,2 ==> 1/3, 2/3 charge)
1610  LASTN = LAST
      IST=0
      CALL GGGJET(CMAS,1.,1.)
      CALL ANGGEN(CMAS,0.)
      GOTO 2500

C   MATRX = -2 .... ggg decay (NDAU = 1,2 ==> 1/3, 2/3 charge)
1620  CALL EVTGEN(0,CMAS,NDAU,LAST,IER)
      GOTO 2500

C   MATRX = -3 .... qq decay  (NDAU = 1-10 ==> quark flavor)
1630  CALL EVTGEN(NDAU,CMAS,0,LAST,IER)
      GOTO 2500

C   MATRX = -4 .... qqg decay (NDAU = 1-10 ==> quark flavor)
1640  CALL EVTGEN(NDAU,CMAS,1,LAST,IER)
      GOTO 2500

C   boost daughter particles into lab
2500  IF(IER .NE. 0)RETURN
      IST=0
      BETAX = P(IPD,1)/P(IPD,4)
      BETAY = P(IPD,2)/P(IPD,4)
      BETAZ = P(IPD,3)/P(IPD,4)
      CALL ROTBST(0.,0.,BETAX,BETAY,BETAZ)

C   restore momentum of quarks, gluons
      NC=NCOLD
      DO 2560 I=1,4
        DO 2550 J=1,NCOLD
          PC(J,I)= PCSAV(J,I)
2550    CONTINUE
2560  CONTINUE

C   set parent code
      DO 2580 I1=LAST+1,N
        K(I1,1)=-IPD
2580  CONTINUE
      LAST=N
      RETURN
      END
