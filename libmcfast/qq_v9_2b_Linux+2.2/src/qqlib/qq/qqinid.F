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
*CMZ :  1.04/00 16/09/94  02.30.21  by  Paul Avery
*CMZ :          02/12/93  13.04.16  by  Lynn Garren
      SUBROUTINE QQINID

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C   Initialize QQ
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "seq/clinc/qqevnt.inc"
#include "seq/clinc/qqbmst.inc"
#include "qqlib/seq/qqcntl.inc"

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C-- Machine width of cm energy. If positron energy not set then assume
C   symmetric beams with beam energy = Ecm/2. EWIDQQ is the Ecm width but
C   only the beam widths are used in event generation.
      IF(BMPSQQ .GT. 0.) THEN
        ECM = 2. * SQRT(BMPSQQ * BMNGQQ)
        ENERQQ = ECM
        EWIDQQ = 0.5 * ECM * (BWPSQQ/BMPSQQ + BWNGQQ/BMNGQQ)
      ELSE
        ENERQQ = ECM
        BMPSQQ = ECM * 0.5
        BMNGQQ = ECM * 0.5
        EWIDQQ = SPREAD*(ECM/10.)**2
        BWPSQQ = EWIDQQ * SQRT(0.5)
        BWNGQQ = EWIDQQ * SQRT(0.5)
      ENDIF
      BEAMQQ = ENERQQ/2.

      RETURN
      END
