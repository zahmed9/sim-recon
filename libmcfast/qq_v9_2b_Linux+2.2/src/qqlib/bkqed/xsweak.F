*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:34  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:29  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.03/22 18/09/91  17.19.15  by  Peter C Kim
*CMZ :  1.00/00 04/06/90  18.55.46  by  Jorge L. Rodriguez
*-- Author :

      FUNCTION XSWEAK(EB,XMZ0,SIN2,OMX)

C-------------------------------------------- REMARKS -----------------
C BHABHA CROSS SECTION DUE TO INTERFERENCE OF THE PHOTON AND Z0 GRAPHS.
C EB  = BEAM ENERGY (GEV)
C XMZ0= Z0 MASS (GEV)
C SIN2= SIN(WEAK MIXING ANGLE)**2
C X   = COSINE OF POLAR SCATTERING ANGLE OF POSITRON
C OMX = 1. - X
C THE COUPLING CONSTANTS OF THE ELECTRONS TO THE Z0 ARE CALCULATED
C ACCORDING TO THE STANDARD SU(2)*U(1) MODEL, USING SIN2. THE MASS
C XMZ0 IS TREATED AS AN ADDITIONAL, INDEPENDENT PARAMETER.
C NEITHER THE PURE Z0 CHANNEL, NOR THE EFFECTS OF A NONZERO Z0 WIDTH
C ARE TAKEN INTO ACCOUNT ---> THIS ROUTINE IS NOT GOOD FOR LEP/SLC.
C----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION(A-H,O-Z)

      DATA INIT /0/
      IF(INIT.NE.0) GOTO 1
      INIT=1
C-------------------------------------------- INITIALIZATION ----------
      A2=1./(16.*SIN2*(1.-SIN2))
      VP=((1.-4.*SIN2)**2+1.)*A2
      VM=VP-2.*A2
      CHIQ=(XMZ0/EB)**2/2.
      XS=1./(1.-CHIQ/2.)
      FACT=5.183833D0/EB**2
C----------------------------------------------------------------------
    1 XM=OMX
      X =1.D0-OMX
      XP=(1.+X)**2
      XT=1./(1.+CHIQ/XM)
C      XSWEAK=FACT*( XS*( VP*XP + VM*XM**2 )/4.
C     .            + XT*( VP*XP + VM*4.    )/(XM*XM)
C     .        -(XS+XT)*( VP*XP            )/(2.*XM) )

      XSWEAK =          FACT*XS*(VP*XP+VM*XM**2)/4.
      XSWEAK = XSWEAK + FACT*XT*(VP*XP+VM*4.)/(XM*XM)
      XSWEAK = XSWEAK + FACT*(-1.0)*(XS+XT)*(VP*XP)/(2.*XM)

      RETURN
      END
