*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:39  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:38  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 17/04/94  21.18.56  by  Lynn Garren
*-- Author :
      SUBROUTINE QBFILE

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C   Make sure file names start out empty
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqfile.inc"
#include "qqlib/seq/qqmisc.inc"


C-----------------------------------------------------------------------
      FDECQQ = ' '
      NEWDEC = ' '

      RETURN
      END
