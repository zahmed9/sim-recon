*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:37  eugenio
* Initial revision
*
* Revision 1.3  1995/08/24  16:51:27  zfiles
* Fix bugs in in event decay history for Upsilon decays,
* one is Jetset, the other in decadl.F
* Fix for boosting in case of asymetric beams.
*
* Revision 1.2  1994/11/01  15:04:50  lkg
*      Bug fix : K(*,4),K(*,5)  --> KJS(*,4), KJS(*,5)
*
* Revision 1.1.1.1  1994/10/08  02:21:34  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.03/76 15/08/94  23.16.18  by  Peter C Kim
*-- Author :    Peter C Kim   15/08/94
      SUBROUTINE NTONJS
C.......................................................................
C.
C. NTONJS:  Copy /LUJETS/ into /LUJETX/
C.
C. Called    : DECADL
C. Author    : Peter C Kim  15/08/94  15.10.37
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "geant/gcdes/lujets.inc"
#include "qqlib/seq/lujetx.inc"

      INTEGER I,J

      NJS = N
      DO 1 J=1,5
      DO 2 I=1,N
        KJS(I,J) = K(I,J)
        PJS(I,J) = P(I,J)
        VJS(I,J) = V(I,J)
 2    CONTINUE
 1    CONTINUE

      RETURN
      END
