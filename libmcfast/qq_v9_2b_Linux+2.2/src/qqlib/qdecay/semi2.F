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
*CMZ :  1.04/00 06/12/93  16.49.09  by  Lynn Garren
*CMZ :  1.03/70 08/10/93  17.05.25  by  Paul Avery
*CMZ :  1.01/00 22/09/90  10.30.36  by  Paul Avery
*CMZ :  1.00/00 26/07/90  21.03.09  by  Paul Avery
*CMZ :          19/05/90  14.51.02  by  Jorge L. Rodriguez
*>> Author :
* 16/10/96 Lynn Garren: Add double precision conditionals.
      SUBROUTINE SEMI2(NP,NQ,KID,XM,KQ,ID,CMAS,T,IT,ND,PQ,MATRX,IER)
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C  ---------------------------------------------------------------------------
C  THIS SUBROUTINE DOES SEMILEPTONIC DECAYS OF MESONS:
C     MESON ==> ANTILEPTON LEPTON (K HADRONS) [QUARK SOUP]
C  K .GE. 0 WITH SOUP, K .GE. 1 WITH NO SOUP.
C  IF DECAYING FERMION IS A QUARK (ANTIQUARK), THEN ANTILEPTON (LEPTON)
C  FIRST YIELDS V-A MATRIX ELEMENT.  (LEPTON FIRST YIELDS V+A.)
C  CALLED FROM SUBROUTINE DECAY WHEN MATRX .EQ. 3
C  C. ROSENFELD AND G. RUCINSKI, 3/26/82.
C  ---------------------------------------------------------------------------

#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqprop.inc"
#include "qqlib/seq/mcjet.inc"
#include "qqlib/seq/mcgen.inc"
#include "qqlib/seq/qqcntl.inc"
#include "qqlib/seq/qqluns.inc"
#include "qqlib/seq/qqspcm.inc"

C     Calling arguments
      INTEGER NP, NQ, ID, IT, ND, MATRX, IER
      INTEGER KID(*), KQ(2,*)
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION T(4), XM(*), PQ(4,*)
      DOUBLE PRECISION CMAS
#else
      REAL T(4), XM(*), PQ(4,*)
      REAL CMAS
#endif
*
C     Local variables
      INTEGER J, IERR, IQRK, ISGN, IHDTOT, I, IDP, JQRK, ND1, ND2
      INTEGER IDDK
      INTEGER IQ(2)
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION P5MAX, RMAS, PSQ, SUBMS2
      DOUBLE PRECISION PSUM, CNDE, CMEAN, WID, SUBMS1
      DOUBLE PRECISION CURMAS(6)
#else
      REAL P5MAX, RMAS, PSQ, SUBMS2
      REAL PSUM, CNDE, CMEAN, WID, SUBMS1
      REAL CURMAS(6)
#endif

      COMMON/BLOB1/ND1,ND2,SUBMS1,SUBMS2

C     External declarations
      INTEGER MLTGEN
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION GETMAS
#else
      REAL GETMAS
#endif
      EXTERNAL MLTGEN, GETMAS
      DATA CURMAS/.01, .01, .15, 1.5, 4.9, 20./
      DATA IDDK/1/
C  ---------------------------------------------------------------------------

      IER = 0
      IERR = 1

C     Do old semileptonic decays for 3 particle final states

      IF( NP .EQ. 3 .AND. NQ .EQ. 0 )THEN
C  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C   DO-THREE-BODY-SEMILEP
C   TO DO-THREE-BODY-SEMILEP
C     Old semileptonic decay - treat as 3 body semileptonic
        ND=3
        IF(LPHASE) CALL PHSP(T,CMAS,1,ND,XM,PQ)
        IERR = 0
C  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      ELSE

C  New semileptonic decay - treat hadronic blob as particle
C  determine quark and particle content of decay

C   Initial quark id number
        IQRK = IT + 2

C   Current quark masses
        EMBQ = CURMAS(IQRK)

C   4-momenta of decaying particle
        DO 1010 J=1,4
          P2QRK(J,1) = T(J)
1010    CONTINUE

C     V-A matrix element is calculated correctly when antiparticle
C     (relative to parent) comes first in list of daughters

C   Antiparticle
        EMNU = XM(1)

C   Particle
        EMCL = XM(2)

C     what quark are we decaying to?
C     determine if quark or anti-quark is decaying

C   odd ID # => quark
        ISGN = MOD(ID,2)

C   ISGN > 0 => quark
        ISGN = 2 * ISGN - 1

C   initialize
        P5MAX = 0.

C   minimum rest mass of hadronic system
        RMAS  = 0.

C   total number of hadrons generated
        IHDTOT = 0

C    Look for heavy quark in first hadron
        IF( NP .GT. 2 )THEN

C    Only look for heavy quark in first particle

C   get quark content of particle
          CALL KQUARK(KID(3),IQ)
          DO 1500 I=1,2

C  quarks decay to quarks
            IF( ISGN .EQ. ISIGN(1,IQ(I)) )THEN
              IQRK = ABS(IQ(I))
              P5MAX = CURMAS(IQRK)
            ENDIF
1500      CONTINUE
          DO 1600 J=3,NP

C   particle id number
            IDP = KID(J)
            RMAS = RMAS + XM(J)
            IHDTOT = IHDTOT + 1
1600      CONTINUE
        ENDIF

C     Now do quark pairs
        IF( NQ .GT. 0 )THEN

          IF( P5MAX .EQ. 0 )THEN
            DO 1650 I=1,2
              IF(ISGN .EQ. ISIGN(1,KQ(I,1)))THEN
                IQRK = ABS( KQ(I,1) )
                P5MAX = CURMAS(IQRK)
              ENDIF
1650        CONTINUE
          ENDIF

          DO 1680 J=1,NQ
            DO 1670 I=1,2
              IQ(I) = KQ(I,J)
1670        CONTINUE
C  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C    MAKE-A-PARTICLE
C    TO MAKE-A-PARTICLE

            IDP = 6 * MAX0(IQ(1),IQ(2)) - MIN0(IQ(1),IQ(2)) - 6
            JQRK = MESO(IDP)

C   make lowest mass particle consistent with quark flavor
            IDP = JQRK + 20

C  uu,dd ==> pi0
            IF(JQRK.EQ.31 .OR. JQRK.EQ.32) IDP=51
C  ss ==> eta
            IF(JQRK.EQ.33) IDP=52
C  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            RMAS  = RMAS + GETMAS(IDP)
            IHDTOT = IHDTOT + 1
1680      CONTINUE

        ENDIF

        IF( P5MAX .EQ. 0 )THEN
          WRITE(LTTOQQ,1000) ( PNAME( KID(I) ),I=1,NP )
          IF( NQ .GT. 0 ) WRITE(LTTOQQ,1001)(( KQ(I,J),I=1,2),J=1,NQ)
          IERR = -1

        ELSE
          EMCQ = P5MAX

C     minimum hadronic rest mass should include masses of at least
C     two particles implying ablility to construct arbitrary mass.
          IF( IHDTOT .EQ. 1 ) RMAS = RMAS + .140
          RMAS = RMAS * RMAS

C     do the decay
1800      IF(IERR .NE. 0)THEN

C  Fills P2QRK(4,4)
            CALL SPECTR(IDDK)
            PSQ = 0.

C   mass sq'd of blob
            DO 1840 I=1,3
               PSQ = PSQ + P2QRK(I,4) ** 2
1840        CONTINUE
            SUBMS2 = P2QRK(4,4) ** 2 - PSQ
            IF( P2QRK(4,4) .LT. 0. ) SUBMS2 = SIGN(SUBMS2,-1.D0)
            IF( SUBMS2 .LT. RMAS )THEN
              IF( NP .EQ. 2 .AND. NQ .EQ. 1 )THEN

C   Quark pair is the only hadronic component => make a hadron and
C   Treat as three body semiletonic.
                NP = 3

C   mass of decaying particle
                SUBMS2 = GETMAS( ID )

C   subtract lepton masses
                DO 1850 I=1,2
                  SUBMS2=SUBMS2 - XM(I)
1850            CONTINUE
                PSUM = 2 * SUBMS2

C    make particle here ala decqrk
1855            IF(PSUM .GT. SUBMS2 )THEN
                  DO 1860 I=1,2
                    IQ(I) = KQ(I,1)
1860              CONTINUE
C  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C    MAKE-A-PARTICLE
C    TO MAKE-A-PARTICLE

            IDP = 6 * MAX0(IQ(1),IQ(2)) - MIN0(IQ(1),IQ(2)) - 6
            JQRK = MESO(IDP)

C   make lowest mass particle consistent with quark flavor
            IDP = JQRK + 20

C  uu,dd ==> pi0
            IF(JQRK.EQ.31 .OR. JQRK.EQ.32) IDP=51
C  ss ==> eta
            IF(JQRK.EQ.33) IDP=52
C  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                  KID(NP) = IDP
                  XM(NP)=GETMAS(KID(NP))
                  PSUM = XM(NP)
                  GOTO 1855
                ENDIF
                NQ = 0
C  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C    DO-THREE-BODY-SEMILEP
C    TO DO-THREE-BODY-SEMILEP
C     Old semileptonic decay - treat as 3 body semileptonic
                ND=3
                IF(LPHASE) CALL PHSP(T,CMAS,1,ND,XM,PQ)
                IERR = 0
C  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
              ENDIF

            ELSE
              SUBMS2 = SQRT( SUBMS2 )

C   hadronize quark pairs
              IF( NQ .GT. 0 )THEN
1870            IF(IERR .NE. 0)THEN

C     generate multiplicity
#if defined(NONCLEO_DOUBLE)
                  CNDE = CMLT1(IT) * DLOG( SUBMS2 / CMLT2(IT) )
                  CMEAN = .5 * NQ + CNDE
                  WID = SQRT( DMAX1( CNDE * WIDTH(IT), .00001D0 ))
#else
                  CNDE = CMLT1(IT) * ALOG( SUBMS2 / CMLT2(IT) )
                  CMEAN = .5 * NQ + CNDE
                  WID = SQRT( AMAX1( CNDE * WIDTH(IT), .00001 ))
#endif
                  ND1 = MLTGEN( CMEAN, WID, MAX0(2,NP - 2 + NQ), 10)

C          hadronize
                  CALL DECQRK( ND1,NP-2,NQ,SUBMS2,KID(3)
     *                                 ,XM(3),KQ, 10, IERR)

C    Final number of daughters
                  ND = ND1 + 2
                  GOTO 1870
                ENDIF
              ELSE
                IERR = 0

C       no qq pairs => # of daughters is # of particles
                ND = NP
              ENDIF

C      Number of particles still without momenta
              ND1 = ND - 2

C      set up pq array
              DO 1890 J=1,4

C     Antiparticle
                PQ(J,1)   = P2QRK(J,2)
C     Particle
                PQ(J,2)   = P2QRK(J,3)
C     Hadronic blob
                PQ(J,3)   = P2QRK(J,4)
1890          CONTINUE
              IF( LPHASE ) CALL PHSP( PQ(1,3), SUBMS2, 0,
     *                ND1, XM(3), PQ(1,3))

C     E = 0
C     DO (I=1,ND) E = E + PQ(4,I)
C     E = E / T(4)
C     WRITE(LTTOQQ,2030)E

2030          FORMAT(1X,'(E OF DAUGHTERS)/(E OF PARENT)=',F10.5)
            ENDIF
            GOTO 1800
          ENDIF
        ENDIF
      ENDIF
1000  FORMAT(/,1X,' SEMI: COULD NOT FIND MASSIVE QUARK IN :',5A6)
1001  FORMAT(  1X,'       OR                               ',6I6)
      RETURN
      END

