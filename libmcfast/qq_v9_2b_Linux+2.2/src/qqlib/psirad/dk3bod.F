*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:40  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:37  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 04/10/94  22.13.14  by  Paul Avery
*CMZ :  1.03/57 15/02/93  16.05.05  by  Peter C Kim
*-- Author :    D. Coffman  15/02/93
      SUBROUTINE DK3BOD(MASSA, MASSB,  MASSC, MASSD,
     *                  CZETA, CTHETA, PHI,   KSI,
     *                  PCMOM, PDMOM,
     *                  P4A,   P4B,    P4C,   P4D,
     *                  BOOST)
C--------------------------------------------------------------------+
C      DK3BOD calculates the 4-momenta for the 3 body decay          |
C                                                                    |
C                     A -> B + C + D                                 |
C                                                                    |
C      The 4-momenta are first calculated in A's center-of-mass      |
C  frame, then boosted to the lab frame.                             |
C                                                                    |
C  Arguments:                                                        |
C                                                                    |
C     Massa, Massb,         the masses of A, B, C and D              |
C     Massc, Massd:         respectively.                            |
C                                                                    |
C     Coszet:               angle between C and D in the rest        |
C                              frame of A                            |
C
C     Costht, Phi:          direction of C in the rest               |
C                           frame of A, with respect to the          |
C                           direction of A.                          |
C                                                                    |
C     Ksi:                  azimuthal angle of D in the rest         |
C                           frame of A, with respect to the          |
C                           direction of C.                          |
C                                                                    |
C     Pcmom, Pdmom:         magnitude of the momenta of C and D,     |
C                           respectively, in A's rest frame.         |
C                                                                    |
C     P4a, P4b, P4c, P4d:   4-momenta of A, B, D and D respectively. |
C                                                                    |
C     Boost:                if .TRUE. pb, pc, and pd will be         |
C                           boosted to the lab frame.                |
C                                                                    |
C  Required Subroutines:  Eboost                                     |
C                                                                    |
C  Fixes:  4/6/84  "No-boost" feature fixed.        DXC              |
C          5/10/84  Rotation to lab frame fixed.    DXC              |
C--------------------------------------------------------------------+
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
C
C Define the arguments.
C

      DOUBLE PRECISION MASSA,  MASSB,  MASSC,  MASSD
      DOUBLE PRECISION CZETA,  CTHETA, PHI,    KSI
      DOUBLE PRECISION PCMOM,  PDMOM
      DOUBLE PRECISION P4A(4), P4B(4), P4C(4), P4D(4)
      LOGICAL BOOST
C
C Define the remaining angles
C
      DOUBLE PRECISION STHETA, CPHI, SPHI
      DOUBLE PRECISION SZETA,  CKSI, SKSI
      DOUBLE PRECISION COSTHA, SINTHA
      DOUBLE PRECISION COSPHA, SINPHA

C
C Define the momentum components.
C

      DOUBLE PRECISION PCX,  PCY, PCZ
      DOUBLE PRECISION PDX,  PDY, PDZ
      DOUBLE PRECISION PAMAG

C
C Calculate P4c in the center-of-mass of A, in a coordinate system
C with the lab direction of P4a along the z-axis.
C

      STHETA = DMAX1(-1.0D0, DMIN1(1.0D0, DSQRT(1.0D0 - CTHETA**2)))
      CPHI   = DCOS(PHI)
      SPHI   = DSIN(PHI)

      IF(MASSC .NE. 0.0D0) THEN
        P4C(4) = SQRT(PCMOM**2 + MASSC**2)
      ELSE
        P4C(4) = PCMOM
      ENDIF

      PCX = PCMOM * STHETA * CPHI
      PCY = PCMOM * STHETA * SPHI
      PCZ = PCMOM * CTHETA

C
C Calculate D's 4-momentum in A's rest-frame.
C

      SZETA = DMAX1(-1.0D0, DMIN1(1.0D0, DSQRT(1.0D0 - CZETA**2)))
      CKSI  = DCOS(KSI)
      SKSI  = DSIN(KSI)

      IF(MASSD .NE. 0.0D0) THEN
        P4D(4) = SQRT(PDMOM**2 + MASSD**2)
      ELSE
        P4D(4) = PDMOM
      ENDIF


      PDX = PDMOM * (CZETA * CPHI * STHETA
     *               - SZETA * (SPHI * SKSI - CPHI * CTHETA * CKSI))

      PDY = PDMOM * (CZETA * SPHI * STHETA
     *               + SZETA * (CPHI * SKSI + SPHI * CTHETA * CKSI))

      PDZ = PDMOM * (CZETA * CTHETA - SZETA * STHETA * CKSI)

C
C Calculate the magnitude of Pa, and if it is not zero, rotate
C Pc and Pd to the lab frame.
C

      PAMAG = DSQRT(P4A(1)**2 + P4A(2)**2 + P4A(3)**2)
      IF(PAMAG .NE. 0.0D0) THEN

        COSTHA = P4A(3)/PAMAG
        SINTHA = DMAX1(-1.0D0, DMIN1(1.0D0, DSQRT(1.0D0 - COSTHA**2)))
        COSPHA = P4A(1)/(PAMAG*SINTHA)
        SINPHA = P4A(2)/(PAMAG*SINTHA)

        P4C(1) =  PCX*COSTHA*COSPHA - PCY*SINPHA + PCZ*SINTHA*COSPHA
        P4C(2) =  PCX*COSTHA*SINPHA + PCY*COSPHA + PCZ*SINTHA*SINPHA
        P4C(3) = -PCX*SINTHA                     + PCZ*COSTHA

        P4D(1) =  PDX*COSTHA*COSPHA - PDY*SINPHA + PDZ*SINTHA*COSPHA
        P4D(2) =  PDX*COSTHA*SINPHA + PDY*COSPHA + PDZ*SINTHA*SINPHA
        P4D(3) = -PDX*SINTHA                     + PDZ*COSTHA

      ELSE

        P4C(1) = PCX
        P4C(2) = PCY
        P4C(3) = PCZ

        P4D(1) = PDX
        P4D(2) = PDY
        P4D(3) = PDZ

      ENDIF

C
C Calculate Pb from 4-momentum conservation.
C

      P4B(1) = 0.0   - P4C(1) - P4D(1)
      P4B(2) = 0.0   - P4C(2) - P4D(2)
      P4B(3) = 0.0   - P4C(3) - P4D(3)
      P4B(4) = MASSA - P4C(4) - P4D(4)

C
C Finally, boost P4c and P4d to the lab frame, with the direction
C given by P4a.
C

      IF(BOOST) CALL EBOOST(MASSA, P4A, P4B)
      IF(BOOST) CALL EBOOST(MASSA, P4A, P4C)
      IF(BOOST) CALL EBOOST(MASSA, P4A, P4D)

      RETURN
      END
