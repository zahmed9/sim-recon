*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:31  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:03  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/00 21/01/93  15.42.32  by  Alan Weinstein
*-- Author :
      SUBROUTINE DEXNPI(MODE,ISGN,PNU,PWB,PNPI,JNPI)
C ----------------------------------------------------------------------
C
C     called by : DEXAY,DEXAY1
C ----------------------------------------------------------------------
      PARAMETER (NMODE=4)
      COMMON / TAUNPI / CBRNPI       ,AMAS
     &                 ,KPI(6,NMODE) ,MULT(NMODE)
      REAL*4            CBRNPI(NMODE),AMAS(6,NMODE)
      REAL*4  PNU(4),PWB(4),PNPI(4,6)
C
      IF(MODE.EQ.-1) THEN
C     ===================
        DO 1 JNPI=1,NMODE
C         CALL HBOOK1(1070+10*JNPI+1,
C    &    'NEUTRINO ENERGY FROM MULTIPI$', 100,.0,50.,.0)
C         CALL HBOOK1(1070+10*JNPI+2,
C    &    'VIRTUAL W MASS  FROM MULTIPI$', 100,.0,2.0,0.)
1       CONTINUE
        CALL DADNPI(-1,ISGN,PNU,PWB,PNPI,JNPI)
C
      ELSEIF(MODE.EQ. 0) THEN
C     =======================
        CALL DADNPI(0,ISGN,PNU,PWB,PNPI,JNPI)
C
      ELSEIF(MODE.EQ. 1) THEN
C     =======================
        CALL DADNPI(1,ISGN,PNU,PWB,PNPI,JNPI)
C
      ENDIF
C     =====
      RETURN
      END
