*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:31  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:04  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/00 21/01/93  15.42.37  by  Alan Weinstein
*-- Author :
      SUBROUTINE DWLUKK (KTO,ISGN,PKK,PNU)
C ----------------------------------------------------------------------
C Lorentz transformation to CMsystem and
C Updating of HEPEVT record
C
C ISGN = 1/-1 for tau-/tau+
C
C ----------------------------------------------------------------------
C
      REAL PKK(4),PNU(4)
C
C position of decaying particle
      IF (KTO.EQ.1) THEN
        NPS=3
      ELSE
        NPS=4
      ENDIF
C
C tau neutrino (nu_tau is 16)
      CALL TRALO4 (KTO,PNU,PNU,AM)
      CALL FILHEP(0,1,16*ISGN,NPS,NPS,0,0,PNU,AM,.TRUE.)
C
C K meson (K+ is 321)
      CALL TRALO4 (KTO,PKK,PKK,AM)
      CALL FILHEP(0,1,-321*ISGN,NPS,NPS,0,0,PKK,AM,.TRUE.)
C
      RETURN
      END
