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
*CMZ :  1.04/00 16/09/94  02.28.02  by  Paul Avery
*-- Author :    Lynn Garren   06/12/93
      SUBROUTINE QBSPCM
C.......................................................................
C.
C. QBSPCM - Initilization of variables.
C.
C. Inputs    : NONE
C. Outputs   : NONE
C.
C. COMMON    : QQSPCM.
C.
C. Called    : QBINIT
C. Author    : Lynn Garren  06/12/93
C.
C. Detailed description
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "qqlib/seq/qqspcm.inc"

C---------------------------------------------------------------------

C=== /SPECOM/  for Subroutine SPECTR

      PBAR   = 0.3

      RETURN
      END
