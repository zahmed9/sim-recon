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
*CMZ :  2.00/05 21/10/93  17.43.03  by  Alan Weinstein
*-- Author :
* 15/10/96 Lynn Garren: Add double precision conditionals.
      SUBROUTINE PHOTWO(MODE)
C.----------------------------------------------------------------------
C.
C.    PHOTWO:   PHOtos but TWO mothers allowed
C.
C.    Purpose:  Combines two mothers into one in /PHOEVT/
C.              necessary eg in case of g g (q qbar) --> t tbar
C.
C.    Input Parameters: Common /PHOEVT/ (/PHOCMS/)
C.
C.    Output Parameters:  Common /PHOEVT/, (stored mothers)
C.
C.    Author(s):  Z. Was                          Created at:  5/08/93
C.                                                Last Update:10/08/93
C.
C.----------------------------------------------------------------------
C--   IMPLICIT NONE
      INTEGER NMXPHO
#if defined(NONCLEO_DOUBLE)
      PARAMETER (NMXPHO=4000)
      INTEGER IDPHO,ISTPHO,JDAPHO,JMOPHO,NEVPHO,NPHO
      DOUBLE PRECISION PPHO,VPHO
#else
      PARAMETER (NMXPHO=2000)
      INTEGER IDPHO,ISTPHO,JDAPHO,JMOPHO,NEVPHO,NPHO
      REAL PPHO,VPHO
#endif
      COMMON/PHOEVT/NEVPHO,NPHO,ISTPHO(NMXPHO),IDPHO(NMXPHO),
     &JMOPHO(2,NMXPHO),JDAPHO(2,NMXPHO),PPHO(5,NMXPHO),VPHO(4,NMXPHO)
      DOUBLE PRECISION BET(3),GAM
      COMMON /PHOCMS/ BET,GAM
      INTEGER I,MODE
      REAL MPASQR
      LOGICAL IFRAD
C logical IFRAD is used to tag cases when two mothers may be
C merged to the sole one.
C So far used in case:
C                      1) of t tbar production
C
C t tbar case
      IF(MODE.EQ.0) THEN
       IFRAD=(IDPHO(1).EQ.21).AND.(IDPHO(2).EQ.21)
       IFRAD=IFRAD.OR.(IDPHO(1).EQ.-IDPHO(2).AND.ABS(IDPHO(1)).LE.6)
       IFRAD=IFRAD
     &       .AND.(ABS(IDPHO(3)).EQ.6).AND.(ABS(IDPHO(4)).EQ.6)
        MPASQR= (PPHO(4,1)+PPHO(4,2))**2-(PPHO(3,1)+PPHO(3,2))**2
     &          -(PPHO(2,1)+PPHO(2,2))**2-(PPHO(1,1)+PPHO(1,2))**2
       IFRAD=IFRAD.AND.(MPASQR.GT.0.0)
       IF(IFRAD) THEN
c.....combining first and second mother
            DO I=1,4
            PPHO(I,1)=PPHO(I,1)+PPHO(I,2)
            ENDDO
            PPHO(5,1)=SQRT(MPASQR)
c.....removing second mother,
            DO I=1,5
              PPHO(I,2)=0.0
            ENDDO
       ENDIF
      ELSE
C boosting of the mothers to the reaction frame not implemented yet.
C to do it in mode 0 original mothers have to be stored in new common (?)
C and in mode 1 boosted to cms.
      ENDIF
      END
