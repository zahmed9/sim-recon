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
*CMZ :  1.04/00 04/10/94  22.13.30  by  Paul Avery
*CMZ :  1.03/57 15/02/93  16.13.23  by  Peter C Kim
*-- Author :    D. Coffman    15/02/93
      DOUBLE PRECISION FUNCTION DKPSIS(P4PSI, MPSI, LAMBDA,
     *                                  KLOW,  ML,   P4LP,   P4LM)
C.......................................................................
C.
C. DKPSIS - Generate 4-momenta for the decay J/psi --> l+ l-
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
C.
C. Value     :
C.      Differential decay rate dor this event, including phase space,
C       matrix element, and soft radiative corrections
C.
C. Calls     : TWOBOD, DDILOG, PSIHEL
C. Called    : PSIGEN
C.
C... This routine decays a polarized J/psi to a lepton pair.
C... O(alpha) radiative corrections are included.
C...
C... The dilog function is from CERNLIB.  There, the definition is
C... unusual:
C...                   ( x
C...                   |
C...      LI2(x) = -   | | log (1-x) | / x  dx
C...                   |
C...                   ) 0
C...                                               D. Coffman 1/29/93
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
C
C Declare the arguments

      DOUBLE PRECISION P4PSI(4)
      DOUBLE PRECISION MPSI
      INTEGER          LAMBDA
      DOUBLE PRECISION ML
      DOUBLE PRECISION P4LP(4)
      DOUBLE PRECISION P4LM(4)
      DOUBLE PRECISION KLOW

      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'DKPSIS' )

C
C Declare a dummy variable for the unobserved photon momentum.
C
      DOUBLE PRECISION P4G(4)
C
C Declare the random number generator
C
      INTEGER  ISEED
      COMMON/RANDM/ISEED
      REAL     RANP
      EXTERNAL RANP
C
C Declare the Spence function
C
      DOUBLE PRECISION DDILOG
C
C The event weight will be "constructed" in the variable weight
C
      DOUBLE PRECISION WEIGHT
C
C The function TwoBod decays a state into two particles according to
C Lorentz invariant phase space.  The value of the function is the
C phase space weight.
C
      DOUBLE PRECISION TWOBOD
C
C The variable delta is the soft radiative correction to the lowest
C order matrix element.  It is the sum of the soft Bremsstrahlung
C --- deltaS --- and virtual --- deltaV --- parts.
C
      DOUBLE PRECISION DELTAS, DELTAV, DELTA
C
C The following terms enter into the matrix elements.
C
      DOUBLE PRECISION P12, P1K, P2K, KK, P1P1, P2P2
C
C These are various stages of the matrix element.
C   F0 is the lowest order matrix element.
C   FM is the "magnetic" term induced by the vertex correction.
C   F1 is the matrix element corrected to first order

      DOUBLE PRECISION F0, FM, F1
C
C Beta is velocity of the leptons in the rest-frame of the J/psi
C
      DOUBLE PRECISION BETA
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
      INTEGER           NUMW,  NUMS,  NUMH
      COMMON /TESTIT/ GAM0,   GAMS,  GAMH,
     *                SUM0,   SUMS,  SUMH,
     *                SUM20,  SUM2S, SUM2H,
     *                PSVOL,  SUMPS,
     *                NUMW,   NUMS,  NUMH

C---------------------------------------------------------------------------
C Executable code begins here
C---------------------------------------------------------------------------


C
C Calculate the velocity of the leptons
C

      BETA = DSQRT(1.0D0 - 4.0D0*ML**2/MPSI**2)

C
C Calculate the virtual and soft corrections.  The cancellation of the
C ultraviolet divergence is taken care of in the virtual correction term.
C Note the change of sign for the DDILOG term! (See note in function header)
C

      DELTAV = ALPHA/PI*(
     *    2.0D0*(DLOG(ML/(2.0D0*KLOW)) - 1.0D0)
     *         *(1.0D0 - (1.0D0 + BETA**2)/(2.0D0*BETA)
     *           * DLOG((1.0D0 + BETA)/(1.0D0 - BETA)))
     *  - 1.0D0/(2.0D0*BETA)* DLOG((1.0D0 + BETA)/(1.0D0 - BETA))
     *  + 2.0D0*(1.0D0 + BETA**2)/BETA
     *         *( PI**2/6.0D0
     *          - 0.250D0*DLOG(4.0D0*BETA**2/(1.0D0 - BETA))
     *                   *DLOG((1.0D0 + BETA)/(1.0D0 - BETA))
     *          + 0.125D0*DLOG((1.0D0 + BETA)/(1.0D0 - BETA))**2
     *          + 0.500D0*DDILOG((1.0D0 - BETA)/(1.0D0 + BETA)) )
     *                  )

      DELTAS = ALPHA/PI*(
     *    1.0D0/BETA*DLOG((1.0D0 + BETA)/(1.0D0 - BETA))
     *  + (1.0D0 + BETA**2)/(4.0D0*BETA)
     *       *DLOG((1.0D0 - BETA**2)/4.0D0)
     *       *DLOG((1.0D0 + BETA)/(1.0D0 - BETA))
     *  + (1.0D0 + BETA**2)/(4.0D0*BETA)
     *       *( DDILOG(BETA) - DDILOG(-BETA)
     *          - 0.5D0*DDILOG(0.5D0*(1.0D0 + BETA))
     *          + 0.5D0*DDILOG(0.5D0*(1.0D0 - BETA)) )
     *                  )

C
C Generate the 4-momenta, according to two-body phase-space.
C

      WEIGHT = TWOBOD(P4PSI, P4LP, P4LM, MPSI, ML, ML)

C
C Calculate the lowest order matrix element.
C

      DO 100 I = 1,4
        P4G(I) = 0.0D0
 100  CONTINUE
      CALL PSIHEL(P4LP, P4LM, P4G, LAMBDA,
     *            P12, P1K, P2K, KK, P1P1, P2P2)

      F0 = 16.0D0*PI*ALPHA*(2.0D0*P12 + 0.5D0*MPSI**2)

C
C Calculate the "magnetic" term
C

      FM = 16.0D0*ALPHA**2*ML**2/BETA
     *           * DLOG((1.0D0 + BETA)/(1.0D0 - BETA))

C
C Now combine these corrections into the corrected matrix element
C

      F1 = F0*(1.0D0 + DELTAV + DELTAS) - FM

C
C Save the differential rates for testing
C

      GAM0 = WEIGHT * F0 /(2.0D0*MPSI)/(2.0D0*PI)**2
      GAMS = WEIGHT * F1 /(2.0D0*MPSI)/(2.0D0*PI)**2

C
C Calculate the differential decay rate using Fermi's Golden Rule
C

      DKPSIS = WEIGHT * F1 /(2.0D0*MPSI)/(2.0D0*PI)**2
      RETURN
      END
