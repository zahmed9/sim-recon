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
      SUBROUTINE DWLUAA(KTO,ISGN,PNU,PAA,PIM1,PIM2,PIPL,JAA)
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
C
C charged a_1 meson (a_1+ is 20213)
      CALL TRALO4(KTO,PAA,PAA,AM)
      CALL FILHEP(0,1,-20213*ISGN,NPS,NPS,0,0,PAA,AM,.TRUE.)
C
C two possible decays of the charged a1 meson
      IF(JAA.EQ.1) THEN
C
C A1  --> PI+ PI-  PI- (or charged conjugate)
C
C pi minus (or c.c.) (pi+ is 211)
        CALL TRALO4(KTO,PIM2,PIM2,AM)
        CALL FILHEP(0,1,-211*ISGN,-1,-1,0,0,PIM2,AM,.TRUE.)
C
C pi minus (or c.c.) (pi+ is 211)
        CALL TRALO4(KTO,PIM1,PIM1,AM)
        CALL FILHEP(0,1,-211*ISGN,-2,-2,0,0,PIM1,AM,.TRUE.)
C
C pi plus (or c.c.) (pi+ is 211)
        CALL TRALO4(KTO,PIPL,PIPL,AM)
        CALL FILHEP(0,1, 211*ISGN,-3,-3,0,0,PIPL,AM,.TRUE.)
C
      ELSE IF (JAA.EQ.2) THEN
C
C A1  --> PI- PI0  PI0 (or charged conjugate)
C
C pi zero (pi0 is 111)
        CALL TRALO4(KTO,PIM2,PIM2,AM)
        CALL FILHEP(0,1,111,-1,-1,0,0,PIM2,AM,.TRUE.)
C
C pi zero (pi0 is 111)
        CALL TRALO4(KTO,PIM1,PIM1,AM)
        CALL FILHEP(0,1,111,-2,-2,0,0,PIM1,AM,.TRUE.)
C
C pi minus (or c.c.) (pi+ is 211)
        CALL TRALO4(KTO,PIPL,PIPL,AM)
        CALL FILHEP(0,1,-211*ISGN,-3,-3,0,0,PIPL,AM,.TRUE.)
C
      ENDIF
C
      RETURN
      END
