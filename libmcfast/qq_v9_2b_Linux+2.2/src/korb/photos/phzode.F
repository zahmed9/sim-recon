*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:29  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:06  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/00 17/11/94  10.25.44  by  Alan J. Weinstein
*CMZ :  2.00/00 21/01/93  15.43.09  by  Alan Weinstein
*-- Author :
CDECK  ID>, PHZODE.
      LOGICAL FUNCTION PHZODE(IPPAR,I)
C.----------------------------------------------------------------------
C.
C.    PHZODE:   checkin family relations
C.
C.    Purpose:  checks whether particle I originates from particle
C.              IPPAR
C.
C.    Input Parameters:  IPPAR  :  position of particle starting cascade
C.                       I      :  position to be checked
C.
C.    Output Parameter:  .true. :  particles are related
C.                       .false.: particles are not related
C.
C.    Author(s):  Z. Was                          Created at:  12/10/92
C.                                                Last Update:
C.
C.----------------------------------------------------------------------
 
      IMPLICIT NONE
#include "seq/clinc/qqpars.inc"
#include "qqlib/seq/hepevt.inc"
C     INTEGER NMXHEP
C     PARAMETER (NMXHEP=2000)
C     INTEGER IDHEP,ISTHEP,JDAHEP,JMOHEP,NEVHEP,NHEP
C     REAL PHEP,VHEP
C     COMMON/HEPEVT/NEVHEP,NHEP,ISTHEP(NMXHEP),IDHEP(NMXHEP),
C    &JMOHEP(2,NMXHEP),JDAHEP(2,NMXHEP),PHEP(5,NMXHEP),VHEP(4,NMXHEP)
      INTEGER IPPAR,I,POTOM
      PHZODE=.FALSE.
      POTOM=I
 10   CONTINUE
        POTOM=JMOHEP(1,POTOM)
        PHZODE=POTOM.EQ.IPPAR
      IF (POTOM.GT.IPPAR) GOTO 10
      END
