*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:41  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:30  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/00 14/06/90  14.26.27  by  Paul Avery
*CMZ :          19/05/90  14.51.03  by  Jorge L. Rodriguez
*>> Author :
      INTEGER FUNCTION KBPART(JBFL)
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C  GIVEN THE QUARK CONTENT OF A BARYON IN JBFL, KBPART RETURNS THE
C  PARTICLE CODE OF A CORRESPONDING BARYON.
C  ELEMENTS OF THE VECTOR BSPIN SPECIFY THE PROPORTION OF SPIN 1/2
C  FOR THE CASES XXX, SXX, SSX, CYY, AND CCY WHERE X IS U OR D AND
C  Y IS U, D, OR S.
C  ELEMENTS OF THE VECTOR BSYMM SPECIFY THE PROPORTION OF THE
C  LAMBDA-LIKE STATE FOR THE SPIN 1/2 COMBINATIONS SUD, CUD, AND CSX.
C  C. ROSENFELD AND G. RUCINSKI, 3/26/82.

#include "qqlib/seq/mcgen.inc"
      INTEGER ISEED
      COMMON/RANDM/ISEED

*- External declarations
      REAL     RANP
      EXTERNAL RANP
*
C-- Local variables
      INTEGER JBFL(2,3)

      INTEGER JFL1, JFL2, JFL3, JDX, J1, J2, JSPIN, KLAS

      INTEGER JBARY
      INTEGER JA10, JA11, JB1, JA3, JB3, JC3
*
      DATA JBARY/121/
      DATA JA10,JA11,JB1,JA3,JB3,JC3/0,8,16,40,48,72/
*
C-- Executable code starts here ---------------------------------------------

      JFL1 = IABS(JBFL(1,1))
      JFL2 = IABS(JBFL(1,2))
      JFL3 = IABS(JBFL(1,3))

C-- CONDITIONAL
      IF     (JFL1.EQ.JFL2 .AND. JFL2.EQ.JFL3) THEN
         JDX = JC3+2*(JFL1-1)

      ELSEIF (JFL1.EQ.JFL2) THEN
         J2 = JFL1
         J1 = JFL3
         CALL JDXCS2(J2, J1, JB1, JB3, JDX, KLAS, JSPIN)

      ELSEIF (JFL1.EQ.JFL3) THEN
         J2 = JFL1
         J1 = JFL2
         CALL JDXCS2(J2, J1, JB1, JB3, JDX, KLAS, JSPIN)

      ELSEIF (JFL2.EQ.JFL3) THEN
         J2 = JFL2
         J1 = JFL1
         CALL JDXCS2(J2, J1, JB1, JB3, JDX, KLAS, JSPIN)

C     (OTHERWISE)
      ELSE
         J1 = JFL1+JFL2+JFL3-5
         KLAS = 4
         IF (J1.EQ.1) KLAS = 2
         JSPIN = JA3

         IF (RANP(ISEED).LT.BSPIN(KLAS)) THEN
            JSPIN = JA10
            IF (RANP(ISEED).GT.BSYMM(MIN0(J1,3))) JSPIN = JA11
         ENDIF

         JDX = JSPIN+2*(J1-1)

      ENDIF

      IF (JBFL(1,1).LT.0) JDX = JDX+1
      KBPART = JBARY+JDX

      RETURN
      END
