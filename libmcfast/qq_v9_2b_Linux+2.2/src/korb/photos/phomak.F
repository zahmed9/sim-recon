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
*CMZ :  2.00/05 17/11/94  10.28.13  by  Alan J. Weinstein
*CMZ :  2.00/05 21/10/93  17.43.04  by  Alan Weinstein
*-- Author :
      SUBROUTINE PHOMAK(IPPAR,NHEP0)
C.----------------------------------------------------------------------
C.
C.    PHOMAK:   PHOtos MAKe
C.
C.    Purpose:  Single or double bremstrahlung radiative corrections
C.              are generated in  the decay of the IPPAR-th particle in
C.              the  HEP common /HEPEVT/. Example of the use of
C.              general tools.
C.
C.    Input Parameter:    IPPAR:  Pointer   to   decaying  particle  in
C.                                /HEPEVT/ and the common itself
C.
C.    Output Parameters:  Common  /HEPEVT/, either  with  or  without a
C.                                particles added.
C.
C.    Author(s):  Z. Was,                         Created at:  26/05/93
C.                                                Last Update:
C.
C.----------------------------------------------------------------------
C--   IMPLICIT NONE
      DOUBLE PRECISION DATA
      REAL PHORAN
      INTEGER IP,IPPAR,NCHARG
      INTEGER WTDUM,IDUM,NHEP0
      INTEGER NCHARB,NEUDAU
      REAL RN,WT,PHINT
      LOGICAL BOOST
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
C--
      IP=IPPAR
      IDUM=1
      NCHARG=0
C--
        CALL PHOIN(IP,BOOST,NHEP0)
        CALL PHOCHK(JDAHEP(1,IP))
        WT=0.0
        CALL PHOPRE(1,WT,NEUDAU,NCHARB)
        IF (WT.EQ.0.0) RETURN
        RN=PHORAN(WTDUM)
C PHODO is calling PHORAN, thus change of series if it is moved before if.
        CALL PHODO(1,NCHARB,NEUDAU)
        IF (INTERF) WT=WT*PHINT(IDUM)/FINT
        DATA=WT
        IF (WT.GT.1.0) CALL PHOERR(3,'WT_INT',DATA)
      IF (RN.LE.WT) THEN
        CALL PHOOUT(IP,BOOST,NHEP0)
      ENDIF
      RETURN
      END
