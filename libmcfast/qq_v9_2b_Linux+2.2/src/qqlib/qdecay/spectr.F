*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:42  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:30  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 22/09/94  00.17.25  by  Paul Avery
*CMZ :  1.03/70 08/10/93  17.05.25  by  Paul Avery
*CMZ :  1.03/69 04/10/93  18.29.56  by  Peter C Kim
*CMZ :  1.00/01 06/09/90  11.42.14  by  Paul Avery
*CMZ :  1.00/00 26/07/90  20.28.37  by  Paul Avery
*CMZ :          19/05/90  14.51.02  by  Jorge L. Rodriguez
*>> Author :
* 16/10/96 Lynn Garren:  Add double precision conditionals.
      SUBROUTINE SPECTR(IDDK)
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C  --------------------------------------------------------------------------
C  APPLIES A SPECTATOR MODEL, INCLUDING FERMI MOMENTUM, TO CALCULATE
C  THE LEPTONIC PART OF THE SEMILEPTONIC DECAYS OF HEAVY FLAVORED
C  PARTICLES, E.G.
C        B >>> NU + MU + (D+HADRONS)
C  USES V-A MATRIX ELEMENT IF IDDK .EQ. 1, PHASE SPACE IF IDDK .EQ. 0.
C  C. ROSENFELD AND G. RUCINSKI, 3/26/82.

C     EMB=B MESON MASS (NOT USED IN THIS VERSION)
C     EMBQ=MASS OF B QUARK (CURRENT)
C     EMNU=MASS OF ANTILEPTON (NEUTRINO)
C     EMCL=MASS OF LEPTON (MUON)
C     EMCQ=MASS OF C QUARK (CURRENT)
C     PBAR=RMS OF EACH MOMENTUM COMPONENT OF QUARKS IN B MESON
C     EBEAM=BEAM ENERGY IN LAB FRAME (NOT USED IN THIS VERSION)

C     INPUT IS P2QRK(1:4,1), THE FOUR MOMENTUM OF THE PARENT PARTICLE
C     (THE B) AND EMBQ...EMCQ.
C     RETURNS P2QRK, THE LAB FRAME FOUR-MOMENTA (T COMPONENT LAST) OF
C     THE B, NEUTRINO, MU, AND D+HADRONS INDEXED BY SECOND SUBSCRIPT.
C  --------------------------------------------------------------------------

#include "qqlib/seq/qqcntl.inc"
#include "qqlib/seq/qqluns.inc"
#include "qqlib/seq/qqspcm.inc"

C     Calling arguments
      INTEGER IDDK
*
C     Local variables
      INTEGER IER, I, ISEED, IXYZ, IEVENT, J
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION PMAX, R2, RX, RY, PSPSQ, RZ
      DOUBLE PRECISION PQRK(4,4),PSPEC(4),PQRL(4,2),PCONS(4),XM(3)
#else
      REAL PMAX, R2, RX, RY, PSPSQ, RZ
      REAL PQRK(4,4),PSPEC(4),PQRL(4,2),PCONS(4),XM(3)
#endif
*
C     External declarations
      REAL RANP
      EXTERNAL RANP

C     define both in main program
      COMMON/RANDM/ISEED

      EQUIVALENCE (XM,EMNU)
      LOGICAL IOK
      DATA PMAX/-1./
      DATA IEVENT/0/
C  --------------------------------------------------------------------------
      IER = 0
      IF(PMAX .LT. 0. ) PMAX  = SQRT(5.) * PBAR

C  Get 4-vectors of decay products from phsp
      DO 1000 I=1,3
        PQRK(I,1) = 0.
1000  CONTINUE
      PQRK(4,1) = EMBQ
      CALL PHSP(PQRK(1,1),EMBQ,IDDK,3,XM,PQRK(1,2))

C     CALCULATE BETA OF B MESON REST FRAME AS SEEN FROM B QUARK REST FRAME
C GJR PSPEC(1)=PBAR*GRAN(ISEED)
C GJR PSPEC(2)=PBAR*GRAN(ISEED)
C GJR PSPEC(3)=PBAR*GRAN(ISEED)

C  IN THIS MODEL THE FERMI MOMENTUM UNIFORMLY POPULATES A SPHERE.
C  THE RMS VALUE OF EACH COMPONENT IS PBAR.

      R2 = 2.
1100  IF(R2.GE.1.)THEN

C   GJR
        RX= 2.*RANP(ISEED)-1
        RY= 2.*RANP(ISEED)-1
        RZ= 2.*RANP(ISEED)-1.
        R2= RX*RX+RY*RY+RZ*RZ
        GOTO 1100
      ENDIF
      PSPEC(1)= PMAX*RX
      PSPEC(2)= PMAX*RY
      PSPEC(3)= PMAX*RZ
      PSPSQ=PSPEC(1)**2+PSPEC(2)**2+PSPEC(3)**2
      PSPEC(4)= SQRT( EMBQ*EMBQ + PSPSQ )

C  Transform to b meson rest frame from b quark rest frame
#if defined(NONCLEO_DOUBLE)
      CALL DBOOSF(PSPEC,2,PQRK(1,2),PQRL)
#else
      CALL RBOOSF(PSPEC,2,PQRK(1,2),PQRL)
#endif

C  Transform to lab frame from b meson rest frame
#if defined(NONCLEO_DOUBLE)
      CALL DBOOSF(P2QRK,2,PQRL,P2QRK(1,2))
#else
      CALL RBOOSF(P2QRK,2,PQRL,P2QRK(1,2))
#endif
      DO 2200 I=1,4
        P2QRK(I,4)=P2QRK(I,1)-P2QRK(I,2)-P2QRK(I,3)
2200  CONTINUE
C     4-momentum conservation test in b quark rest frame
      IOK=.TRUE.
      DO 3150 IXYZ=1,4
        PCONS(IXYZ)=PQRK(IXYZ,1)-PQRK(IXYZ,2)-PQRK(IXYZ,3)-PQRK(IXYZ,4)
CPCK    IF(ABS(PCONS(IXYZ)).GT.1.0E-6) IOK=.FALSE.
C less precision for error messages
        IF(ABS(PCONS(IXYZ)).GT.1.0E-4) IOK=.FALSE.
3150  CONTINUE
      IF(.NOT.IOK) WRITE(LTTOQQ,10) IEVENT,((PQRK(I,J),I=1,4),J=1,4)
10    FORMAT(1H0,5X,'Event',I5,' fails 4-momentum conservation test',
     *  /,15X,'PX',13X,'PY',13X,'PZ',13X,'E',/,4(10X,4F15.10,/))
      RETURN
      END
