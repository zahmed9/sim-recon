*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:43  eugenio
* Initial revision
*
* Revision 1.3  1996/05/21 16:26:43  clib
* Z smearing with Gaussian shape.  BSIZQQ(3) changed to 0.0127.
*
* Revision 1.2  1995/02/18  02:54:23  zfiles
* New beam size from JGS
*
* Revision 1.1.1.1  1994/10/08  02:21:27  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 05/10/94  12.39.16  by  Peter C Kim
*-- Author :    Lynn Garren   04/11/93
      SUBROUTINE QBBMST
C.......................................................................
C.
C. QBBMST - Initilization of variables in QQBMST.
C.
C. Inputs    : NONE
C. Outputs   : NONE
C.
C. COMMON    : QQBMST
C.
C. Calls     : none
C. Called    : QBINIT
C. Author    : Lynn Garren  04/11/93
C.
C. Detailed description
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
#include "seq/clinc/qqbmst.inc"

C=== LOCAL VARIABLES USED FOR DATA INPUT

      INTEGER I, J

C---------------------------------------------------------------------

C=== QQBMST /QQBMS1/

      BMPSQQ = 0.
      BMNGQQ = 0.
      BWPSQQ = 0.
      BWNGQQ = 0.

C--  If BPOSQQ is left untouched, CLEOG will generate run-dependent IP
C    If the USER changes the values, CLEOG will use the QQ-defined IP.
C
      BPOSQQ(1) = 0.0
      BPOSQQ(2) = 0.0
      BPOSQQ(3) = 0.0

C     BSIZQQ(1) = 0.0005
C                                   from JGS (10/94)
      BSIZQQ(1) = 0.000325

C     BSIZQQ(2) = 0.000030
C                                   from JGS (2/95)
      BSIZQQ(2) = 0.000006
C
CXX      BSIZQQ(3) = 0.03
C                             Z smearing using Gaussian sigmas
C                                                   PCK (5.96)
      BSIZQQ(3) = 0.01273
C
      RETURN
      END
