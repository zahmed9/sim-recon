* AJW, 4/9/96: Add 3,4,5pi phase space, and 2-body P-wave, in ME81.
* AJW, 3/3/95: now correctly handles resonances in tau -> R nutau
*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:42  eugenio
* Initial revision
*
* Revision 1.3  1996/04/26 17:53:41  zfiles
* Add 3,4,5pi phase space and 2-body P-wave (AJW)
*
* Revision 1.2  1995/03/07  00:53:23  zfiles
* Correctly handles tau --> R nu tau from AJW
*
* Revision 1.1.1.1  1994/10/08  02:21:30  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.03/46 23/06/92  08.42.42  by  Unknown
*-- Author :
* Fix DGAMMX for MATRX=81 to improve efficiency.
*CMZ :  1.03/45 19/05/92  08.27.51  by  Unknown
*-- Author :
* Fix a nasty little bug, to get all the 4-vectors right.
*CMZ :          16/05/92  16.11.54  by  Alan J. Weinstein
*-- Author :
* New routine to implement V-A matrix element in hadronic tau decays.
*-- Author :    Alan Weinstein, 5/7/92
* 16/10/96 Lynn Garren: Add double precision conditionals.
      SUBROUTINE TAUMAT(NP,NQ,KID,XM,KQ,KPAR,CMAS,T,IT,ND,PQ,MATRX,IER)
C.......................................................................
C
C  Generate Tau -> nu hadrons
C    with weak matrix element and phase-space hadronic decays.
C    At the moment, works only with particles, not QQ states (NQ=0).
C  **The last particle on the list MUST be a tau neutrino (or anti-)!
C
C Inputs:
C  NP            number of daughters
C  NQ            number of QQ daughters (must be 0!)
C  KID           flavour of daughters
C  XM            masses of daughters
C  CMAS          mass of parent (tau mass)
C  T             boost 4-vector
C  MATRX         matrix element (81-85)
C  ** MATRX=81: V-A matrix element with flat phase space for M_had.
C           82: V-A plus spectral function for 2pi-  pi+ pi0
C           83: V-A plus spectral function for  pi- 3pi0
C           84: V-A plus spectral function for 3pi- 2pi+
C           85: V-A plus spectral function for 3pi- 2pi+ pi0
C
C Outputs:
C  ND            number of daughters
C  PQ            momentum of daughters
C  IER           Error flag (see code)
C
C. Calls     : PHSP,ROTAT,BOOSTF, SIGEE(in KoralB)
C. Called    : DECAY
C. Author    : Alan Weinstein, 5/7/92
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'TAUMAT' )

C--- Calling arguments

      INTEGER NP,NQ,KID(30),KQ(2,5),KPAR,IT,ND,MATRX,IER
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION XM(30),CMAS,T(4),PQ(4,30)
#else
      REAL XM(30),CMAS,T(4),PQ(4,30)
#endif

C--- External declarations

#if defined(NONCLEO_DOUBLE)
      REAL RANP
      DOUBLE PRECISION DSIGEE,GETMAS
      EXTERNAL RANP,DSIGEE,GETMAS
#else
      REAL RANP,SIGEE,GETMAS
      EXTERNAL RANP,SIGEE,GETMAS
#endif

C--- Local declarations

      INTEGER I,ITER,ND1,IDP
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION PS,AMS1,AMS2,AMX2,AMX,AMTAU,AMNTAU
      DOUBLE PRECISION DGAMMX,DGAMT,PXQ,PXN,QXN,P2,PS2B,DAMX
      DOUBLE PRECISION COSTH,PHI,THETA
      DOUBLE PRECISION PCM(4,8),TO(4)
#else
      REAL PS,AMS1,AMS2,AMX2,AMX,AMTAU,AMNTAU
      REAL DGAMMX,DGAMT,PXQ,PXN,QXN,P2,PS2B,DAMX
      REAL COSTH,PHI,THETA
      REAL PCM(4,8),TO(4)
#endif

C------------------------------------------------------------------

      IER = 0
C
C Check calling arguments for errors
      IF (NQ.GT.0) THEN
C can't handle QQ states
        IER = 1
        PRINT *,' In TAUMAT: Cant handle decays to QQ states. Exiting'
        RETURN
      ELSEIF (NP.LT.2.OR.NP.GT.8) THEN
C need at least 2, at most 8, daughters
        IER = 2
        PRINT *,' In TAUMAT: Need at least 2 daughters. Exiting'
        RETURN
      ELSEIF (KID(NP).NE.17.AND.KID(NP).NE.18) THEN
C last particle MUST be tau (anti-)neutrino
        IER = 3
        PRINT *,' In TAUMAT: Last particle in list must be NUT. Exiting'
        RETURN
      ELSEIF (MATRX.LT.81.OR.MATRX.GT.85) THEN
C Unrecognized matrix element
        IER = 4
        PRINT *,' In TAUMAT: Unrecognized matrix element. Exiting'
        RETURN
      END IF
C
C final number of daughters
      ND = NP
      ND1 = ND-1
C
C If only 2 daughters, the 1st must be a resonance!
      IF (ND1.EQ.1) THEN
        IDP = KID(1)
        AMX = GETMAS(IDP)
        AMX2 = GETMAS(IDP)
        IF (AMX.EQ.AMX2) THEN
          IER = 5
          PRINT *,' In TAUMAT: Cant decay to stable particle!',
     1            ' Use MATRIX=0. Exiting.'
          RETURN
        END IF
      END IF
C
C Masses of tau and tau neutrino
      AMTAU = CMAS
      AMNTAU = XM(NP)

      IF (ND1.GT.1) THEN
C Minimum hadronic system mass
        PS = 0.
        DO 4 I=1,ND1
4       PS  = PS+XM(I)
        AMS1 = PS**2
C Maximum hadronic system mass
        AMS2 = (AMTAU-AMNTAU)**2
      ELSEIF (ND1.EQ.1) THEN
C For resonance, get min, max mass:
        AMS1=AMTAU-AMNTAU
        AMS2 = 0.
        DO 5 I=1,100
          AMX = GETMAS(IDP)
          AMS1 = MIN(AMX,AMS2)
          AMS2 = MAX(AMX,AMS1)
   5    CONTINUE
        AMS1 = AMS1**2
        AMS2 = AMS2**2
      END IF

      DGAMMX = 0.
      IF (MATRX.EQ.81.AND.ND1.EQ.1) THEN
C For resonance, get max weight (from minimum mass)
        PXQ = 0.5*(AMTAU**2+AMS1-AMNTAU**2)
        QXN = 0.5*(AMTAU**2-AMS1-AMNTAU**2)
        PXN = 0.5*(AMTAU**2-AMS1+AMNTAU**2)
        DGAMMX=(2*PXQ*QXN+AMS1*PXN)*PXN
      END IF
C
C Begin iteration to get maximum weight, accept/reject
      ITER = 0
 100  ITER=ITER+1
C
      IF (ND1.GT.1) THEN
C FLAT PHASE SPACE  !!!
        AMX2=AMS1+(AMS2-AMS1)*RANP(0)
        AMX =SQRT(AMX2)
      ELSE
C Breit Wigner for resonance
        AMX = GETMAS(IDP)
        AMX2 = AMX*AMX
      END IF
C
      PXQ = 0.5*(AMTAU**2+AMX2-AMNTAU**2)
      QXN = 0.5*(AMTAU**2-AMX2-AMNTAU**2)
      PXN = 0.5*(AMTAU**2-AMX2+AMNTAU**2)
      DGAMT=(2*PXQ*QXN+AMX2*PXN)*PXN
C
C "phase-space" spectral function for N-body hadronic system:
      IF (MATRX.EQ.81.AND.ND1.GT.1) THEN
        IF (ND1.EQ.2) THEN
C here's 2-body p-wave phase space, guaranteed to be > 0:
          P2 = (AMX2-(XM(1)+XM(2))**2)*(AMX2-(XM(1)-XM(2))**2)
          PS2B = SQRT(P2)/AMX2
          DGAMT = DGAMT*PS2B**3
        ELSEIF (ND1.EQ.3) THEN
C This is the max phase space term for 3pi
          DAMX = AMX-0.4188
          DGAMT=DGAMT*(0.0166*DAMX+0.9530*DAMX**2-0.2197*DAMX**3)
        ELSEIF (ND1.EQ.4) THEN
C This is the max phase space term for 4pi
          DAMX = AMX-0.5584
          DGAMT=DGAMT*(-0.0001*DAMX**2+0.0776*DAMX**3+0.1500*DAMX**4)
        ELSEIF (ND1.EQ.5) THEN
C This is the max phase space term for 5pi
          DAMX = AMX-0.698
          DGAMT=DGAMT*(0.038760*DAMX**5+0.003786*DAMX**6)
        ELSE
C This is extremely approximate:
          DGAMT=DGAMT*AMX2**(2*ND1-4)
        END IF
      ELSEIF (MATRX.GT.81) THEN
C apply hadronic spectral function from KoralB, which includes phase space:
#if defined(NONCLEO_DOUBLE)
        DGAMT=DGAMT*AMX2*DSIGEE(AMX2,MATRX-81)
#else
        DGAMT=DGAMT*AMX2*SIGEE(AMX2,MATRX-81)
#endif
      END IF
C
C If we wanted to get the normalization right, here are all the factors:
C     PHSPAC=(1./2.**5/PI**2)*(4.*PI* 2.*PXN/AMTAU**2)*(AMS2-AMS1)
C     BRAK=2*(GV**2+GA**2)*(2*PXQ*QXN+AMX2*PXN)
C    &    -6*(GV**2-GA**2)*AMTAU*AMNTAU*AMX2
C     BRAK=(2*PXQ*QXN+AMX2*PXN)
C     AMPLIT=CCABIB**2*GFERMI**2/2.*(4.*BRAK)*AMX2*SIGEE(AMX2,JNPI)
C     DGAMT=1./(2.*AMTAU)*AMPLIT*PHSPAC
C
C do this lots of times, to get max weight for this config.
C Finally, do acceptance/rejection.
      IF ((MATRX.GT.81.OR.ND1.GT.1).AND.ITER.LE.100) THEN
        DGAMMX = MAX(DGAMT,DGAMMX)
        GOTO 100
      ELSE IF (ITER.LE.150) THEN
        DGAMMX = MAX(DGAMT,DGAMMX)
        IF (DGAMT.LT.RANP(0)*DGAMMX) GOTO 100
      ELSE
C this is taking too long. Try again w/different daughter masses...
        IER = 6
        PRINT *,' In TAUMAT: too many iterations required. Exiting'
        RETURN
      END IF
C
C TAU-NEUTRINO MOMENTUM
      PCM(1,ND)=0.
      PCM(2,ND)=0.
      PCM(4,ND)=PXN/AMTAU
      PCM(3,ND)=-SQRT((PCM(4,ND)-AMNTAU)*(PCM(4,ND)+AMNTAU))
C W MOMENTUM
      PCM(1,1)=0.
      PCM(2,1)=0.
      PCM(4,1)=PXQ/AMTAU
      PCM(3,1)=-PCM(3,ND)

      IF (ND1.GT.1) THEN
C If more than one hadronic daughter, decay W to them via phase-space
        DO 101 I=1,4
          TO(I)=PCM(I,1)
101     CONTINUE
        CALL PHSP(TO,AMX,0,ND1,XM,PCM(1,1))
      ELSE
C modify mass of resonance
        XM(1) = AMX
      END IF
C
C rotation
      COSTH = 2*RANP(0)-1.
      PHI = 2.*3.141592654*RANP(0)
      THETA = ACOS(COSTH)
      CALL ROTAT(PHI,THETA,-PHI,ND,PCM,PCM)

C LORENTZ TRANSFORMATION TO LABORATORY SYSTEM
      DO 666 I=1,4
        TO(I)=T(I)
666   CONTINUE
      CALL BOOSTF(TO,ND,PCM,PQ)

      RETURN
      END
