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
*CMZ :  1.04/00 16/09/94  02.28.12  by  Paul Avery
*CMZ :  1.03/71 06/12/93  13.55.25  by  Lynn Garren
*-- Author :    Lynn Garren   06/12/93
      SUBROUTINE QBBFLD
C.......................................................................
C.
C. QBBFLD - Initilization of variables.
C.
C. Inputs    : NONE
C. Outputs   : NONE
C.
C. COMMON    : QQEVNT,QQBFLD.
C.
C. Called    : QBINIT
C. Author    : Lynn Garren  06/12/93
C.
C. Detailed description
C.
C.    Magnetic field unit and sign changed.
C.                                             27/04/92
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
#include "seq/clinc/qqbfld.inc"

C---------------------------------------------------------------------

C=== QQBFLD /QQBFL1/
C                    BFLDQQ is used only in DECADD/DECADL for swimming of
C                    shrot-lived particle before decay.
C                    CLEOG has its own magnetic field parameter and does not
C                    use BFLDQQ.
CC     BFLDQQ = 1.5
C                         Magnetic field unit changed to KGauss.
C                                                    27/04/92  PCK

      BFLDQQ = -15.0

      RETURN
      END
