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
*CMZ :  1.04/00 16/09/94  02.29.35  by  Paul Avery
*-- Author :    Lynn Garren   04/11/93
      SUBROUTINE QBKRBC
C.......................................................................
C.
C. QBKRBC - Initilization of variables in KORBCM.
C.
C. Inputs    : NONE
C. Outputs   : NONE
C.
C. COMMON    : KORBCM
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
#include "qqlib/seq/korbcm.inc"

C---------------------------------------------------------------------

C
C=== KORALB variables :  KORBCM /KORPAR/

      KSPIN  = 1
      ITFIN  = 1
      KEYGSW = 1
      KEYRAD = 1
      ITDKRC = 0
      KORBE1(1) = 0.0
      KORBE1(2) = 0.0
      KORBE1(3) = 0.0
      KORBE2(1) = 0.0
      KORBE2(2) = 0.0
      KORBE2(3) = 0.0
      SINW2  = 0.226
      KORBGV =  1.0
      KORBGA = -1.0
      KORXK0 = 0.01

      RETURN
      END
