*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:28  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:06  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/07 30/01/94  16.42.05  by  Alan J. Weinstein
* Improved interference term from Was: does, eg, K-pi+.
*CMZ :  2.00/05 21/10/93  17.43.04  by  Alan Weinstein
*-- Author :
* 15/10/96 Lynn Garren: Add double precision conditionals.
      FUNCTION PHINT(IDUM)
C.----------------------------------------------------------------------
C.
C.    PHINT:   PHotos INTerference
C.
C.    Purpose:  Calculates interference between emission of photons from
C.              different possible chaged daughters stored in
C.              the  HEP common /PHOEVT/.
C.
C.    Input Parameter:    commons /PHOEVT/ /PHOMOM/ /PHOPHS/
C.
C.
C.    Output Parameters:
C.
C.
C.    Author(s):  Z. Was,                         Created at:  10/08/93
C.                                                Last Update: 16/11/93
C.
C.----------------------------------------------------------------------
 
C--   IMPLICIT NONE
      REAL PHINT
      REAL PHOCHA
      INTEGER IDUM
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
      DOUBLE PRECISION MCHSQR,MNESQR
#if defined(NONCLEO_DOUBLE)
      double precision PNEUTR
#else
      REAL PNEUTR
#endif
      COMMON/PHOMOM/MCHSQR,MNESQR,PNEUTR(5)
      DOUBLE PRECISION COSTHG,SINTHG
      REAL XPHMAX,XPHOTO
      COMMON/PHOPHS/XPHMAX,XPHOTO,COSTHG,SINTHG
      REAL MPASQR,XX,BETA,E1,E2,PP,PP2,SS
      LOGICAL IFINT
      INTEGER K,IDENT
C
      DO  K=JDAPHO(2,1),JDAPHO(1,1),-1
         IF(IDPHO(K).NE.22) THEN
           IDENT=K
           GOTO 20
         ENDIF
      ENDDO
 20   CONTINUE
C check if there is a photon
      IFINT= NPHO.GT.IDENT
C check if it is two body + gammas reaction
      IFINT= IFINT.AND.(IDENT-JDAPHO(1,1)).EQ.1
C check if two body was particle antiparticle
C     IFINT= IFINT.AND.IDPHO(JDAPHO(1,1)).EQ.-IDPHO(IDENT)
C check if particles were charged
      IFINT= IFINT.AND.PHOCHA(IDENT).NE.0
C check if they have opposite charge
      IFINT= IFINT.AND.PHOCHA(IDENT)* PHOCHA(JDAPHO(1,1)).LT.0
C calculates interference weight contribution
      IF(IFINT) THEN
        MPASQR = PPHO(5,1)**2
C       XX=4.*MCHSQR/MPASQR*(1.-XPHOTO)/(1.-XPHOTO+(MCHSQR-MNESQR)/
C    &     MPASQR)**2
C        BETA=SQRT(1.-XX)
C        PHINT  = 2D0/(1D0+COSTHG**2*BETA**2)
         SS =MPASQR*(1.-XPHOTO)
         PP2=((SS-MCHSQR-MNESQR)**2-4.*MCHSQR*MNESQR)/SS/4.
         PP2 = MAX(0.,PP2)
         E1 =SQRT(PP2+MCHSQR)
         E2 =SQRT(PP2+MNESQR)
         PP =SQRT(PP2)
         PHINT= (E1+E2)**2/((E2+COSTHG*PP)**2+(E1-COSTHG*PP)**2)
      ELSE
         PHINT  = 1D0
      ENDIF
      END
