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
*CMZ :  1.04/00 04/10/94  22.14.48  by  Paul Avery
*CMZ :  1.03/57 15/02/93  21.20.30  by  Peter C Kim
*-- Author :    D. Coffman   15/02/93
      DOUBLE PRECISION FUNCTION DKPSIH(P4PSI, MPSI, LAMBDA,
     *                                  KLOW,  ML,   P4LP,
     *                                  P4LM,  P4G)
C.......................................................................
C.
C. DKPSIH - Generate 4-momenta for the decay J/psi --> l+ l- photon
C.
C. Inputs    :
C.      P4PSI   Four momentum of J/psi
C.      MPSI    Mass of J/psi
C.      LAMBDA  Helicity of J/psi
C.      KLOW    Low energy cut-off
C.      ML      Mass of lepton
C.
C. Outputs   :
C.      P4LP    Four momentum of positive lepton
C.      P4LM    Four momentum of negative lepton
C.      P4G     Four momentum of photon
C.
C. Value     :
C.      Differential decay rate for this event, including phase space,
C       and matrix element
C.
C. Calls     : PSIHEL, DK3BOD, DOT4
C. Called    : PSIGEN
C.
C... This routine decays a polarized J/psi to a lepton pair and a photon.
C...
C...        D. Coffman 1/29/93
C.
C-----------------------------------------------------------------------
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
C
C Declare the arguments
C
      DOUBLE PRECISION P4PSI(4)
      DOUBLE PRECISION MPSI
      INTEGER          LAMBDA
      DOUBLE PRECISION KLOW
      DOUBLE PRECISION ML
      DOUBLE PRECISION P4LP(4)
      DOUBLE PRECISION P4LM(4)
      DOUBLE PRECISION P4G(4)

      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'DKPSIH' )

C
C Declare the random number generator
C

      INTEGER   ISEED
      COMMON/RANDM/ISEED
      REAL      RANP
      EXTERNAL  RANP

C
C If a random number is needed more than once, it is stored in rho
C

      DOUBLE PRECISION RHO

C
C The event weight will be "constructed" in the variable weight
C

      DOUBLE PRECISION WEIGHT

C
C The following terms enter into the matrix elements.
C

      DOUBLE PRECISION P12, P1K, P2K, KK, P1P1, P2P2

C
C These are various stages of the matrix element.
C   FB is the lowest order matrix element.

      DOUBLE PRECISION FB

C
C Beta is approximate velocity of the leptons in the rest-frame of the J/psi
C

      DOUBLE PRECISION BETA

C
C Khigh is the maximum photon energy
C

      DOUBLE PRECISION KHIGH

C
C The fine structure constant has its usual definition.
C

      DOUBLE PRECISION ALPHA
      PARAMETER(ALPHA=7.2974D-03)

C
C Mysterious transcendental number:  ratio of a circle's circumference
C to its diameter.
C

      DOUBLE PRECISION PI
      PARAMETER(PI=3.141592653D0)

C
C These are the five independent phase-space variables in the J/psi rest-frame
C     costht   cosine of polar angle of photon's direction
C     phi      azimuthal angle of photon's direction
C     ksi      azimuthal angle of positive lepton with respect to photon
C     omega    photon energy
C     coszet   cosine of angle between postive lepton's and photon's directions
C

      DOUBLE PRECISION COSTHT, PHI, KSI, OMEGA, COSZET

C
C The variable R is used to construct coszet.
C

      DOUBLE PRECISION R

C
C These are derived kinematic quantities:
C     Elp     total energy of positive lepton
C     Plp     3-momentum of positive lepton
C     Discr   discriminant from quadratic equation for determining Elp
C

      DOUBLE PRECISION ELP
      DOUBLE PRECISION PLP
      DOUBLE PRECISION DISCR

C
C These are inner products of various 4-momenta
C

      DOUBLE PRECISION X1, X2, Y1, Y2, S

C
C The mass of the photon is zero!
C

      DOUBLE PRECISION MG
      PARAMETER(MG=0.0D0)

C
C This function calculates inner products
C

      DOUBLE PRECISION DOT4

C
C This is the derivative of the energy delta function
C

      DOUBLE PRECISION FPRI

C
C     INFINITE LOOP TRAP.
C 
      INTEGER NTRY, NTRYMX
      PARAMETER ( NTRYMX = 100 )

C
C Sundry variables.
C

      INTEGER I

C
C This common is testing, debugging,  purposes
C

      DOUBLE PRECISION PSVOL, SUMPS
      DOUBLE PRECISION GAM0,  GAMS,  GAMH
      DOUBLE PRECISION SUM0,  SUMS,  SUMH
      DOUBLE PRECISION SUM20, SUM2S, SUM2H
      INTEGER          NUMW,  NUMS,  NUMH
      COMMON /TESTIT/ GAM0,   GAMS,  GAMH,
     *                SUM0,   SUMS,  SUMH,
     *                SUM20,  SUM2S, SUM2H,
     *                PSVOL,  SUMPS,
     *                NUMW,   NUMS,  NUMH

C---------------------------------------------------------------------------
C Executable code begins here
C---------------------------------------------------------------------------

      NTRY = 0
 1    NTRY = NTRY + 1

C
C Calculate the velocity of the leptons
C

      BETA = DSQRT(1.0D0 - 4.0D0*ML**2/MPSI**2)

C
C Now calculate the maximum photon energy
C

      KHIGH = 0.5D0 * MPSI * BETA**2

C
C Construct the kinematic variables according to the approximate
C distributions.
C

      RHO    = DBLE(RANP(ISEED))
      COSTHT = 2.0D0*RHO - 1.0D0

      RHO    = DBLE(RANP(ISEED))
      PHI    = 2.0D0*PI*RHO

      RHO    = DBLE(RANP(ISEED))
      KSI    = 2.0D0*PI*RHO

      RHO    = DBLE(RANP(ISEED))
      OMEGA  = KLOW * ((KHIGH/KLOW)**RHO)

      RHO    = DBLE(RANP(ISEED))
      R      = ( (1.0D0 + BETA)/(1.0D0 - BETA) )**(2.0D0*RHO - 1.0D0)
      COSZET = (R - 1.0D0) / (R + 1.0D0) / BETA

C
C Protect coszet from round-off error
C

      COSZET = DMAX1(-1.0D0, DMIN1(1.0D0, COSZET))

C
C Now calculate the energy of the positive lepton using the exact
C relationships.
C

      DISCR = DMAX1(0.0D0,
     *        (MPSI**2 - 2.0D0*MPSI*OMEGA)**2
     *      + 4.0D0* OMEGA**2 * ML**2 * COSZET**2
     *      - 4.0D0* (MPSI - OMEGA)**2 * ML**2)

      ELP = ( (MPSI - OMEGA) * (MPSI**2 - 2.0D0*MPSI*OMEGA)
     *        - OMEGA * COSZET * DSQRT(DISCR) )
     *    / ( 2.0D0 * ( (MPSI - OMEGA)**2 - OMEGA**2*COSZET**2) )

      PLP = DSQRT(DMAX1(0.0D0, ELP**2 - ML**2))

C
C Generate the 4-momenta.
C

      CALL DK3BOD(MPSI,   ML,     MG,  ML,
     *            COSZET, COSTHT, PHI, KSI,
     *            OMEGA,  PLP,
     *            P4PSI,  P4LM,   P4G, P4LP,
     *            .FALSE.)

C
C Trap cases of bad kinematics and rethrow the event.
C
      IF ( ABS(P4LM(4)**2-P4LM(1)**2-P4LM(2)**2-P4LM(3)**2-ML**2) .GT.
     *     ML*0.001 ) THEN
           IF ( NTRY .LE. NTRYMX ) GOTO 1
      ENDIF

C
C Calculate the helicity factors
C

      CALL PSIHEL(P4LP, P4LM, P4G,  LAMBDA,
     *            P12,  P1K,  P2K,  KK,
     *            P1P1, P2P2)

C
C Calculate the inner products
C

      X1 = DOT4(P4PSI, P4LP)
      X2 = DOT4(P4PSI, P4LM)

      Y1 = DOT4(P4LP,  P4G)
      Y2 = DOT4(P4LM,  P4G)

      S  = DOT4(P4LP,  P4LM)

C
C Calculate the lowest order matrix element.
C

      FB = -64.0D0 * PI**2 * ALPHA**2 * (
     *   ( ML**2 * (2.0D0*P12 + X1)
     *   + (ML**2 - Y1)*(2.0D0*P2K + Y2) ) / Y1**2
     * - ( S * (4.0D0*P12 - 2.0D0*KK + MPSI**2 - 2.0D0*ML**2)
     *   + 2.0D0*ML**2 * (S - KK)
     *   + 2.0D0*Y1*(P12 - P2P2)
     *   + 2.0D0*Y2*(P12 - P1P1) ) / (Y1*Y2)
     * + ( ML**2 * (2.0D0*P12 + X2)
     *   + (ML**2 - Y2) * (2.0D0*P1K + Y1) ) / Y2**2
     *                                  )

C
C Calculate the approximate integral
C

      WEIGHT = 1.0D0/(16.0D0 * PI**3 * MPSI**2)
     *       * DLOG(KHIGH / KLOW)
     *       * DLOG( (1.0D0 + BETA) / (1.0D0 - BETA) ) / BETA

C
C Calculate the differential decay rate using Fermi's Golden Rule
C Protect the calculation from division by zero!
C (A zero value of plp IS allowed by phase-space:
C  the matrix element is however, zero.)
C

      FPRI    = DABS( -2.0D0*MPSI*PLP
     *        + 2.0D0*OMEGA*(PLP - ELP*COSZET) )

      WEIGHT  = WEIGHT * MPSI**2 * PLP * OMEGA**2
     *        * PLP / FPRI
     *        * (1.0D0 - BETA*COSZET)*(1.0D0 + BETA*COSZET)

      GAMH = WEIGHT * FB/(2.0D0*MPSI)

C
C Save the value of the diffenetial decay rate and return.
C

      DKPSIH = GAMH
      RETURN
      END
