*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:43  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:27  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 16/09/94  02.26.44  by  Paul Avery
*CMZ :  1.03/29 18/10/91  15.22.26  by  B. Heltsley
* fix 3 gamma bugs
*CMZ :          22/09/90  10.25.50  by  Paul Avery
*CMZ :  1.00/00 21/08/90  21.08.22  by  Paul Avery
*CMZ :          21/05/90  18.57.23  by  Jon Urheim
*-- declare local variables, deflexify, adapt to Cleo 2 conventions
*CMZ :          20/05/90  13.38.52  by  Jorge L. Rodriguez
*CMZ :          19/05/90  15.07.55  by  Jorge L. Rodriguez
*>> Author :
      SUBROUTINE QED999
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C  ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C     Generate QED processes e+e-,mu+mu-,tau+tau-,3gam
C     Always create 2-or-3-body final state. If 3gamma, then
C     'radiative' gamma declared as the softest of the 3.
C     2-body ==> Store in positions 1+2
C     3-body ==> Store soft gamma in pos. 1, followed by other particles.
C  ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqtrak.inc"
#include "seq/clinc/qqprop.inc"
#include "seq/clinc/qqbmst.inc"
#include "qqlib/seq/mcgen.inc"

*-- Additional internal common blocks.
      INTEGER   IMODDD, IOUT
      COMMON/QED000/IMODDD,IOUT
*
C-- External declarations

C-- Local variables
      INTEGER IP, IJ, IPW, IV
      INTEGER KKK(4,2)
      DOUBLE PRECISION ABEAM,QP(4),QM(4),QK(4), XSAVE, QG(4,3)
      EQUIVALENCE
     *            (QG(1,1),QP(1)),
     *            (QG(1,2),QM(1)),
     *            (QG(1,3),QK(1))

*-- Data statement initializations
      DATA KKK/7,11,15,1,   8,12,16,1/

*-- Beginning of executable code

      IF     (IMODDD.EQ.1) THEN
         CALL QED012(QP,QM,QK)

      ELSEIF (IMODDD.EQ.2) THEN
         CALL QED022(QP,QM,QK)

      ELSEIF (IMODDD.EQ.3) THEN
         CALL QED032(QP,QM,QK)

      ELSEIF (IMODDD.EQ.4) THEN
         CALL QED042(QP,QM,QK)

C-- For 3 gamma case define qk as the weakest photon
         IP=1
         IF(QP(4).GT.QM(4)) IP=2
         IF(DMIN1(QP(4),QM(4)).GT.QK(4)) IP=3

         IF( IP .NE. 3 ) THEN
            DO 10 IJ=1,4
               XSAVE    = QG(IJ,3)
               QG(IJ, 3)= QG(IJ,IP)
               QG(IJ,IP)= XSAVE
   10       CONTINUE
         ENDIF

      ENDIF

C->>store tentative photon>>>>
      IPW=0
      IF(QK(4).NE.0.) THEN
         IPW=1
         K(1,1) = 0
         K(1,2)=1
         DO 20 IV=1,4
            P(1,IV)=QK(IV)*BEAMQQ
   20    CONTINUE
         P(1,5)=0.
      ENDIF

C->>Now the other 2 guys>>>>
      K(IPW+1,1) = 0
      K(IPW+2,1) = 0
      K(IPW+1,2) = KKK(IMODDD,1)
      K(IPW+2,2) = KKK(IMODDD,2)

      DO 30 IV=1,4
         P(IPW+1,IV) = QM(IV)*BEAMQQ
         P(IPW+2,IV) = QP(IV)*BEAMQQ
   30 CONTINUE

      P(IPW+1,5) = AMASS(K(IPW+1,2))
      P(IPW+2,5) = AMASS(K(IPW+2,2))
      N=IPW+2

      RETURN
      END
