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
      SUBROUTINE DWLURO(KTO,ISGN,PNU,PRHO,PIC,PIZ)
C ----------------------------------------------------------------------
C Lorentz transformation to CMsystem and
C Updating of HEPEVT record
C
C ISGN = 1/-1 for tau-/tau+
C
C     called by : DEXAY,(DEKAY1,DEKAY2)
C ----------------------------------------------------------------------
C
      REAL  PNU(4),PRHO(4),PIC(4),PIZ(4)
C
C position of decaying particle:
      IF(KTO.EQ. 1) THEN
        NPS=3
      ELSE
        NPS=4
      ENDIF
C
C tau neutrino (nu_tau is 16)
      CALL TRALO4(KTO,PNU,PNU,AM)
      CALL FILHEP(0,1,16*ISGN,NPS,NPS,0,0,PNU,AM,.TRUE.)
C
C charged rho meson (rho+ is 213)
      CALL TRALO4(KTO,PRHO,PRHO,AM)
      CALL FILHEP(0,2,-213*ISGN,NPS,NPS,0,0,PRHO,AM,.TRUE.)
C
C charged pi meson (pi+ is 211)
      CALL TRALO4(KTO,PIC,PIC,AM)
      CALL FILHEP(0,1,-211*ISGN,-1,-1,0,0,PIC,AM,.TRUE.)
C
C pi0 meson (pi0 is 111)
      CALL TRALO4(KTO,PIZ,PIZ,AM)
      CALL FILHEP(0,1,111,-2,-2,0,0,PIZ,AM,.TRUE.)
C
      RETURN
      END
