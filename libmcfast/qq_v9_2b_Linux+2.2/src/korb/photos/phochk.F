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
      SUBROUTINE PHOCHK(JFIRST)
C.----------------------------------------------------------------------
C.
C.    PHOCHK:   checking branch.
C.
C.    Purpose:  checks whether particles in the common block /PHOEVT/
C.              can be served by PHOMAK.
C.              JFIRST is the position in /HEPEVT/ (!) of the first daughter
C.              of sub-branch under action.
C.
C.
C.    Author(s):  Z. Was                           Created at: 22/10/92
C.                                                Last Update: 16/10/93
C.
C.----------------------------------------------------------------------
C     ********************
C--   IMPLICIT NONE
      INTEGER NMXPHO
#if defined(NONCLEO_DOUBLE)
      PARAMETER (NMXPHO=4000)
      INTEGER IDPHO,ISTPHO,JDAPHO,JMOPHO,NEVPHO,NPHO
      double precision PPHO,VPHO
#else
      PARAMETER (NMXPHO=2000)
      INTEGER IDPHO,ISTPHO,JDAPHO,JMOPHO,NEVPHO,NPHO
      REAL PPHO,VPHO
#endif
      COMMON/PHOEVT/NEVPHO,NPHO,ISTPHO(NMXPHO),IDPHO(NMXPHO),
     &JMOPHO(2,NMXPHO),JDAPHO(2,NMXPHO),PPHO(5,NMXPHO),VPHO(4,NMXPHO)
      LOGICAL CHKIF
      COMMON/PHOIF/CHKIF(NMXPHO)
      INTEGER NMXHEP
#if defined(NONCLEO_DOUBLE)
      PARAMETER (NMXHEP=4000)
#else
      PARAMETER (NMXHEP=2000)
#endif
      LOGICAL QEDRAD
      COMMON/PHOQED/QEDRAD(NMXHEP)
      INTEGER JFIRST
      LOGICAL F
      INTEGER IDABS,NLAST,I,IPPAR
      LOGICAL INTERF,ISEC,IFTOP
      REAL FINT,FSEC
      COMMON /PHOKEY/ INTERF,FINT,ISEC,FSEC,IFTOP
      LOGICAL IFRAD
      INTEGER IDENT,K
C these are OK .... if you do not like somebody else, add here.
      F(IDABS)=
     &     ( ((IDABS.GT.9).AND.(IDABS.LE.40)) .OR. (IDABS.GT.100) )
     & .AND.(IDABS.NE.21)
     $ .AND.(IDABS.NE.2101).AND.(IDABS.NE.3101).AND.(IDABS.NE.3201)
     & .AND.(IDABS.NE.1103).AND.(IDABS.NE.2103).AND.(IDABS.NE.2203)
     & .AND.(IDABS.NE.3103).AND.(IDABS.NE.3203).AND.(IDABS.NE.3303)
C
      NLAST = NPHO
C
      IPPAR=1
C checking for good particles
      DO 10 I=IPPAR,NLAST
      IDABS    = ABS(IDPHO(I))
C possibly call on PHZODE is a dead (to be omitted) code.
      CHKIF(I)= F(IDABS)       .AND.F(ABS(IDPHO(1)))
     &  .AND.   (IDPHO(2).EQ.0)
      IF(I.GT.2) CHKIF(I)=CHKIF(I).AND.QEDRAD(JFIRST+I-IPPAR-2)
 10   CONTINUE
C--
C now we go to special cases, where CHKIF(I) will be overwritten
C--
      IF(IFTOP) THEN
C special case of top pair production
        DO  K=JDAPHO(2,1),JDAPHO(1,1),-1
           IF(IDPHO(K).NE.22) THEN
             IDENT=K
             GOTO 15
           ENDIF
        ENDDO
 15     CONTINUE
        IFRAD=((IDPHO(1).EQ.21).AND.(IDPHO(2).EQ.21))
     &  .OR. ((ABS(IDPHO(1)).LE.6).AND.((IDPHO(2)).EQ.(-IDPHO(1))))
        IFRAD=IFRAD
     &        .AND.(ABS(IDPHO(3)).EQ.6).AND.((IDPHO(4)).EQ.(-IDPHO(3)))
     &        .AND.(IDENT.EQ.4)
        IF(IFRAD) THEN
           DO 20 I=IPPAR,NLAST
           CHKIF(I)= .TRUE.
           IF(I.GT.2) CHKIF(I)=CHKIF(I).AND.QEDRAD(JFIRST+I-IPPAR-2)
 20        CONTINUE
        ENDIF
      ENDIF
C--
C--
      IF(IFTOP) THEN
C special case of top decay
        DO  K=JDAPHO(2,1),JDAPHO(1,1),-1
           IF(IDPHO(K).NE.22) THEN
             IDENT=K
             GOTO 25
           ENDIF
        ENDDO
 25     CONTINUE
        IFRAD=((ABS(IDPHO(1)).EQ.6).AND.(IDPHO(2).EQ.0))
        IFRAD=IFRAD
     &        .AND.((ABS(IDPHO(3)).EQ.24).AND.(ABS(IDPHO(4)).EQ.5)
     &        .OR.(ABS(IDPHO(3)).EQ.5).AND.(ABS(IDPHO(4)).EQ.24))
     &        .AND.(IDENT.EQ.4)
        IF(IFRAD) THEN
           DO 30 I=IPPAR,NLAST
           CHKIF(I)= .TRUE.
           IF(I.GT.2) CHKIF(I)=CHKIF(I).AND.QEDRAD(JFIRST+I-IPPAR-2)
 30        CONTINUE
        ENDIF
      ENDIF
C--
C--
      END
