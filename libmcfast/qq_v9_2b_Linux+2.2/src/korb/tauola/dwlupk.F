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
      SUBROUTINE DWLUPK(KTO,ISGN,PNU,PAA,PIM1,PIM2,PIPL,JAA)
C ----------------------------------------------------------------------
C Lorentz transformation to CMsystem and
C Updating of HEPEVT record
C
C ISGN = 1/-1 for tau-/tau+
C JAA  = 1 (2) FOR A_1- DECAY TO PI+ 2PI- (PI- 2PI0)
C
C     called by : DEXAY,(DEKAY1,DEKAY2)
C ----------------------------------------------------------------------
C
      REAL  PNU(4),PAA(4),PIM1(4),PIM2(4),PIPL(4)
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
CC
C W boson (W+ is 24)
      CALL TRALO4(KTO,PAA,PAA,AM)
      CALL FILHEP(0,1,-24*ISGN,NPS,NPS,0,0,PAA,AM,.TRUE.)
C first decay product
        IDEF=IPKDEF(1,JAA,ISGN)
        CALL TRALO4(KTO,PIM1,PIM1,AM)
        CALL FILHEP(0,1,IDEF,-1,-1,0,0,PIM1,AM,.TRUE.)
C second decay product
        IDEF=IPKDEF(2,JAA,ISGN)
        CALL TRALO4(KTO,PIM2,PIM2,AM)
        CALL FILHEP(0,1,IDEF,-2,-2,0,0,PIM2,AM,.TRUE.)
C third decay product
        IDEF=IPKDEF(3,JAA,ISGN)
        CALL TRALO4(KTO,PIPL,PIPL,AM)
        CALL FILHEP(0,1,IDEF,-3,-3,0,0,PIPL,AM,.TRUE.)
C
      RETURN
      END
