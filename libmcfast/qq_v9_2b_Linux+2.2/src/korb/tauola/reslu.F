*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:32  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:04  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/00 17/11/94  10.23.37  by  Alan J. Weinstein
*CMZ :  2.00/00 21/01/93  15.42.36  by  Alan Weinstein
*-- Author :
      SUBROUTINE RESLU
C     ****************
C INITIALIZE LUND COMMON
#include "seq/clinc/qqpars.inc"
#include "qqlib/seq/hepevt.inc"
C     PARAMETER (NMXHEP=2000)
C     COMMON/HEPEVT/NEVHEP,NHEP,ISTHEP(NMXHEP),IDHEP(NMXHEP),
C    &JMOHEP(2,NMXHEP),JDAHEP(2,NMXHEP),PHEP(5,NMXHEP),VHEP(4,NMXHEP)
C     SAVE  /HEPEVT/
      NHEP=0
      END
