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
      SUBROUTINE DWLNPI(KTO,ISGN,PNU,PWB,PNPI,JNPI)
C ----------------------------------------------------------------------
C Lorentz transformation to CMsystem and
C Updating of HEPEVT record
C
C ISGN = 1/-1 for tau-/tau+
C
C     called by : DEXAY,(DEKAY1,DEKAY2)
C ----------------------------------------------------------------------
C
      PARAMETER (NMODE=4)
      COMMON / TAUNPI / CBRNPI       ,AMAS
     &                 ,KPI(6,NMODE) ,MULT(NMODE)
      REAL*4            CBRNPI(NMODE),AMAS(6,NMODE)
      REAL  PNU(4),PWB(4),PNPI(4,6)
      REAL  PPI(4)
C
C position of decaying particle
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
C W boson (W+ is 24)
      CALL TRALO4(KTO,PWB,PWB,AM)
      CALL FILHEP(0,1,-24*ISGN,NPS,NPS,0,0,PWB,AM,.TRUE.)
C
C multi pi mode JNPI
C
C get multiplicity of mode JNPI
      ND=MULT(JNPI)
      DO I=1,ND
        KFPI=KPI(I,JNPI)
C for charged conjugate case, change charged pions only
        IF(KFPI.NE.111)KFPI=KFPI*ISGN
        DO J=1,4
          PPI(J)=PNPI(J,I)
        END DO
        CALL TRALO4(KTO,PPI,PPI,AM)
        CALL FILHEP(0,1,KFPI,-I,-I,0,0,PPI,AM,.TRUE.)
      END DO
C
      RETURN
      END
