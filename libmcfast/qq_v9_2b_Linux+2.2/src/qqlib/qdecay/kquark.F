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
      SUBROUTINE KQUARK(ID,IQ)
C.......................................................................
C.
C. KQUARK -  Given the ID of a meson, this routine returns the quark
C.                 content in IQ
C. Inputs    : ID
C. Outputs   : IQ
C. COMMON    : MCJET MCGEN
C. Called    :
C.
C  Authors   : C. ROSENFELD AND G. RUCINSKI, 3/26/82.
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

*- Argument declarations
      INTEGER ID, IQ(2)
*
*- External declarations
      REAL     RANP
      EXTERNAL RANP
*
*- Sequence declarations
#include "qqlib/seq/mcjet.inc"
#include "qqlib/seq/mcgen.inc"

      INTEGER ISEED
      COMMON/RANDM/ISEED
*
*- Local declarations
*
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'KQUARK' )
*
      REAL    CINV(2,6)
      REAL    TMIX
      INTEGER I, KK, ICL, ISPIN, KM, KIM1, KPART
      LOGICAL LFIRST
*
      DATA LFIRST/ .TRUE. /
*
*- Executable code starts here
*
      IF( LFIRST ) THEN
         LFIRST = .FALSE.

         DO 100 I=1,2
            KK = 1 + 3 * ( I - 1 )
            CINV(1,KK)   = CMIX1(1,KK)
            CINV(2,KK)   = CMIX1(1,KK+1) + CINV(1,KK)
            CINV(1,KK+1) = CMIX1(2,KK)   - CMIX1(1,KK)
            CINV(2,KK+1) = CMIX1(2,KK+1) - CMIX1(1,KK+1)
     +                                   + CINV(1,KK+1)
            CINV(1,KK+2) = 1 - CMIX1(2,KK)
            CINV(2,KK+2) = 1 - CMIX1(2,KK+1) + CINV(1,KK+2)
  100    CONTINUE
      ENDIF

      I=0
      ICL=0
      KPART=0

      ISPIN = 0
      IF( ID .GT. 60 ) ISPIN = 1

  101 IF ( I .EQ. 36 .OR. KPART .EQ. ID ) GOTO 201

         I = I + 1
         KK = I
         KIM1 = MESO(KK)

         IF ( KIM1 .LT. 31 .OR. KIM1 .GT. 33 ) THEN
            KPART = 20 + 40 * ISPIN + KIM1

         ELSE

C-- ONLY DO PI0'S... PHI'S ONCE
            IF( KIM1 .EQ. 31 ) THEN

C-- SELECT( ICL )
               IF     (ICL .EQ. 0) THEN
                  KPART = 51 + 40 * ISPIN
                  I = I - 1
                  ICL = 1
                  GOTO 150

               ELSEIF (ICL .EQ. 1) THEN
                  KPART = KPART + 1
                  I = I - 1
                  ICL = 2
                  GOTO 150

               ELSEIF (ICL .EQ. 2) THEN
                  KPART = KPART + 1
                  ICL = 0
               ENDIF

  150          CONTINUE

            KM = KPART - 50 - 37 * ISPIN
            TMIX = RANP(ISEED)
C-- U UBAR
            KK = 1
C-- D DBAR
            IF( TMIX .GT. CINV(1,KM) ) KK = 8
C-- S SBAR
            IF( TMIX .GT. CINV(2,KM) ) KK = 15

         ENDIF
      ENDIF
      GOTO 101

  201 CONTINUE

      IF ( KPART .EQ. ID ) THEN
         IQ(1) = ( 5 + KK ) / 6
         IQ(2) = 6 * ( IQ(1) - 1 ) - KK
      ELSE
         IQ(1) = 0
         IQ(2) = 0
      ENDIF

      RETURN
      END
