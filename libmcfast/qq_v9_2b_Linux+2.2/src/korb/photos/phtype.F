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
*CMZ :  2.00/05 17/11/94  10.27.55  by  Alan J. Weinstein
*CMZ :  2.00/05 21/10/93  17.43.04  by  Alan Weinstein
*-- Author :
      SUBROUTINE PHTYPE(ID)
C.----------------------------------------------------------------------
C.
C.    PHTYPE:   Central manadgement routine.
C.
C.    Purpose:   defines what kind of the
C.              actions will be performed at point ID.
C.
C.    Input Parameters:       ID:  pointer of particle starting branch
C.                                 in /HEPEVT/ to be treated.
C.
C.    Output Parameters:  Common /HEPEVT/.
C.
C.    Author(s):  Z. Was                          Created at:  24/05/93
C.                                                Last Update: 01/10/93
C.
C.----------------------------------------------------------------------
C--   IMPLICIT NONE
#include "seq/clinc/qqpars.inc"
#include "qqlib/seq/hepevt.inc"
C     INTEGER NMXHEP
C     PARAMETER (NMXHEP=2000)
C     INTEGER IDHEP,ISTHEP,JDAHEP,JMOHEP,NEVHEP,NHEP
C     REAL PHEP,VHEP
C     COMMON/HEPEVT/NEVHEP,NHEP,ISTHEP(NMXHEP),IDHEP(NMXHEP),
C    &JMOHEP(2,NMXHEP),JDAHEP(2,NMXHEP),PHEP(5,NMXHEP),VHEP(4,NMXHEP)
      LOGICAL INTERF,ISEC,IFTOP
      REAL FINT,FSEC
      COMMON /PHOKEY/ INTERF,FINT,ISEC,FSEC,IFTOP
      INTEGER ID,NHEP0
      LOGICAL IPAIR
      REAL RN,PHORAN
      INTEGER WTDUM
C--
      IPAIR=.TRUE.
C--   Check decay multiplicity..
      IF (JDAHEP(1,ID).EQ.0) RETURN
C--
      NHEP0=NHEP
C--
      IF(ISEC) THEN
C-- double photon emission
        FSEC=1.0
        RN=PHORAN(WTDUM)
        IF (RN.GE.0.5) THEN
          CALL PHOMAK(ID,NHEP0)
          CALL PHOMAK(ID,NHEP0)
        ENDIF
      ELSE
C-- single photon emission
        FSEC=1.0
        CALL PHOMAK(ID,NHEP0)
      ENDIF
C--
C-- electron positron pair (coomented out for a while
C      IF (IPAIR) CALL PHOPAR(ID,NHEP0)
      END
