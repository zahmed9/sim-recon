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
*CMZ :  1.04/00 04/10/94  23.00.21  by  Paul Avery
*-- Author :    Lynn Garren   04/11/93
      SUBROUTINE QBMCJT
C.......................................................................
C.
C. QBMCJT - Initilization of variables in MCJET.
C.
C. Inputs    : NONE
C. Outputs   : NONE
C.
C. COMMON    : MCJET
C.
C. Calls     : none
C. Called    : QBINIT
C. Author    : Lynn Garren 04/11/93
C.
C. Detailed description
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
#include "qqlib/seq/mcjet.inc"

C=== LOCAL VARIABLES USED FOR DATA INPUT

      INTEGER I, XCLASS(36)

C=== MCJET

      DATA XCLASS/2*1,4*2,6*3,8*4,10*5,2*1,6,7,8,9/

C---------------------------------------------------------------------

C=== MCJET /JET3PA/

      DO 5 I=1,36
 5    ICLASS(I) = XCLASS(I)

      DO 6 I=1,10
 6    PSPIN(I) = 0.50

      CMIX1(1,1) = 3.0
      CMIX1(2,1) = 4.0
      CMIX1(3,1) = 1.0
      CMIX1(1,2) = 3.0
      CMIX1(2,2) = 4.0
      CMIX1(3,2) = 1.0
      CMIX1(1,3) = 0.0
      CMIX1(2,3) = 1.0
      CMIX1(3,3) = 1.0
      CMIX1(1,4) = 1.0
      CMIX1(2,4) = 1.0
      CMIX1(3,4) = 0.0
      CMIX1(1,5) = 1.0
      CMIX1(2,5) = 1.0
      CMIX1(3,5) = 0.0
      CMIX1(1,6) = 0.0
      CMIX1(2,6) = 0.0
      CMIX1(3,6) = 1.0

      CMLT1(1) = 1.8
      CMLT2(1) = 0.8
      CMLT1(2) = 2.5
      CMLT2(2) = 0.8
      CMLT1(3) = 1.95
      CMLT2(3) = 0.8
      CMLT1(4) = 1.8
      CMLT2(4) = 0.9
      CMLT1(5) = 3.85
      CMLT2(5) = 0.8

      WIDTH(1) = 1.0
      WIDTH(2) = 1.0
      WIDTH(3) = 0.5
      WIDTH(4) = 1.0
      WIDTH(5) = 0.5

      RETURN
      END
