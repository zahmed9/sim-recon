*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:41  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:30  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 06/12/93  16.45.18  by  Lynn Garren
*CMZ :  1.03/70 08/10/93  17.05.25  by  Paul Avery
*CMZ :  1.00/00 26/07/90  21.03.09  by  Paul Avery
*CMZ :          19/05/90  14.51.02  by  Jorge L. Rodriguez
*>> Author :
* 16/10/96 Lynn Garren: Add double precision conditionals.
      SUBROUTINE EXO3(NP,NQ,KID,XM,KQ,ID,CMAS,T,IT,ND,PQ,MATRX,IER)
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C  --------------------------------------------------------------------------
C  THIS SUBROUTINE HANDLES EXOTIC B DECAYS OF THE TYPE
C     B QUARK (+SPECTATOR)  ==>  LEPTON LEPTON QUARK (+SPECTATOR)
C  IT IS CALLED BY SUBROUTINE DECAY WHEN MATRX .EQ. 13
C C. ROSENFELD AND G. RUCINSKI, 3/26/82.
C  --------------------------------------------------------------------------

#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqprop.inc"
#include "qqlib/seq/mcjet.inc"
#include "qqlib/seq/mcgen.inc"
#include "qqlib/seq/qqcntl.inc"
#include "qqlib/seq/qqluns.inc"
#include "qqlib/seq/qqspcm.inc"

C     Calling variables
      INTEGER NP, NQ, ID, IT, ND, MATRX, IER
      INTEGER KID(30), KQ(2,5)
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION T(4), XM(30), PQ(4,30)
      DOUBLE PRECISION CMAS
#else
      REAL T(4), XM(30), PQ(4,30)
      REAL CMAS
#endif
*
C     Local variables
      INTEGER IERR, IQRK, J, ISGN, IHDTOT, I, IDP, JQRK, IDDK
      INTEGER ND1, ND2
      INTEGER IQ(2)
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION P5MAX, RMAS, SUBMS2, PSUM
      DOUBLE PRECISION PSQ, CNDE, CMEAN, WID, SUBMS1
      DOUBLE PRECISION CURMAS(6)
#else
      REAL P5MAX, RMAS, SUBMS2, PSUM
      REAL PSQ, CNDE, CMEAN, WID, SUBMS1
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
      DATA IDDK/0/
C  --------------------------------------------------------------------------

      IER = 0
      IERR = 1

C     DO 3 BODY PHASE SPACE DECAY

      IF( NP .EQ. 3 .AND. NQ .EQ. 0 )THEN
C  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C  DO-THREE-BODY-PHASE-SPACE
C  TO DO-THREE-BODY-PHASE-SPACE
C  Treat as 3 body phase space
      ND=3
      IF( LPHASE ) CALL PHSP(T,CMAS,0,ND,XM,PQ)
      IERR = 0
C  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      ELSE

C   EXOTIC DECAY => TREAT HADRONIC BLOB AS PARTICLE
C   DETERMINE QUARK AND PARTICLE CONTENT OF DECAY

C   initial quark id number
        IQRK = IT + 2

C   current quark masses
        EMBQ = CURMAS(IQRK)
        DO 1000 J=1,4

C   4-momenta of decaying particle
          P2QRK(J,1) = T(J)
1000    CONTINUE

C   Assume first two daughters in list are lepton and neutrino

C   antiparticle (relative to parent)
        EMNU = XM(1)

C  particle
        EMCL = XM(2)

C     WHAT QUARK ARE WE DECAYING TO?
C     DETERMINE IF QUARK OR ANTI-QUARK IS DECAYING

C   odd id # => quark
        ISGN = MOD(ID,2)

C   isgn > 0 => quark
        ISGN = 2 * ISGN - 1

C   initialize
        P5MAX = 0.

C   minimum rest mass of hadronic system
        RMAS  = 0.

C   total number of hadrons generated
        IHDTOT = 0

C   Look for heavy quark in first hadron
        IF( NP .GT. 2 )THEN

C   Only look for heavy quark in first particle

C   get quark content of particle
          CALL KQUARK(KID(3),IQ)
          DO 1300 I=1,2

C   Quarks decay to quarks
            IF( ISGN .EQ. ISIGN(1,IQ(I)) )THEN
              IQRK = ABS(IQ(I))
              P5MAX = CURMAS(IQRK)
            ENDIF
1300      CONTINUE
          DO 1500 J=3,NP

C    particle id number
            IDP = KID(J)
            RMAS = RMAS + XM(J)
            IHDTOT = IHDTOT + 1
1500      CONTINUE
        ENDIF

C   Now do quark pairs
        IF( NQ .GT. 0 )THEN
          IF( P5MAX .EQ. 0 )THEN
            DO 2000 I=1,2
              IF(ISGN .EQ. ISIGN(1,KQ(I,1)))THEN
                IQRK = ABS( KQ(I,1) )
                P5MAX = CURMAS(IQRK)
              ENDIF
2000        CONTINUE
          ENDIF
          DO 2300 J=1,NQ
            DO 2100 I=1,2
              IQ(I) = KQ(I,J)
2100        CONTINUE
C  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C           MAKE-A-PARTICLE
C  TO MAKE-A-PARTICLE
            IDP = 6 * MAX0(IQ(1),IQ(2)) - MIN0(IQ(1),IQ(2)) - 6
            JQRK = MESO(IDP)

C  make lowest mass particle consistent with quark flavor
            IDP = JQRK + 20

C  uu,dd ==> pi0
            IF(JQRK.EQ.31 .OR. JQRK.EQ.32) IDP=51

C  ss ==> eta
            IF(JQRK.EQ.33) IDP=52
C  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            IHDTOT = IHDTOT + 1
            RMAS = RMAS + GETMAS(IDP)
2300      CONTINUE
        ENDIF
        IF( P5MAX .EQ. 0. )THEN
          WRITE(LTTOQQ,5000) ( PNAME( KID(I) ),I=1,NP )
          IF( NQ .GT. 0 ) WRITE(LTTOQQ,5001)
     *                (( KQ(I,J),I=1,2),J=1,NQ)
          IERR = -1

        ELSE
          EMCQ = P5MAX

C     Minimum hadronic rest mass should include masses of at least
C     two particles implying ablility to construct arbitrary mass.

C   add pi mass
          IF( IHDTOT .EQ. 1 ) RMAS = ( RMAS + .140 )
          RMAS = RMAS * RMAS

C    DO THE DECAY
2600      IF( IERR .NE. 0 )THEN

C    fills P2QRK(4,4)
            CALL SPECTR(IDDK)
            PSQ = 0.
            DO 2800 I=1,3
              PSQ = PSQ + P2QRK(I,4) ** 2
2800        CONTINUE

C    mass sq'd of blob
            SUBMS2 = P2QRK(4,4) ** 2 - PSQ
#if defined(NONCLEO_DOUBLE)
            IF( P2QRK(4,4) .LT. 0. ) SUBMS2 = SIGN(SUBMS2,-1.D0)
#else
            IF( P2QRK(4,4) .LT. 0. ) SUBMS2 = SIGN(SUBMS2,-1.)
#endif
            IF( SUBMS2 .LT. RMAS )THEN
              IF( NP .EQ. 2 .AND. NQ .EQ. 1 )THEN

C     Quark pair is the only hadronic component => make a hadron and
C     treat as three body phase space
                NP = 3

C   mass of decaying particle
                SUBMS2 = CMAS
                DO 3000 I=1,2

C   subtract lepton masses
                  SUBMS2=SUBMS2 - XM(I)
3000            CONTINUE
                PSUM = 2 * SUBMS2

C   make particle here ala DECQRK
3100            IF( PSUM .GT. SUBMS2 )THEN
                    DO 3200 I=1,2
                      IQ(I) = KQ(I,1)
3200                CONTINUE
C  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C                   MAKE-A-PARTICLE
C  TO MAKE-A-PARTICLE
                    IDP = 6 * MAX0(IQ(1),IQ(2)) - MIN0(IQ(1),
     *                                              IQ(2)) - 6
                    JQRK = MESO(IDP)

C  make lowest mass particle consistent with quark flavor
                    IDP = JQRK + 20

C ........... uu,dd ==> pi0
                    IF(JQRK.EQ.31 .OR. JQRK.EQ.32) IDP=51

C ............ ss ==> eta
                    IF(JQRK.EQ.33) IDP=52
C  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    KID(NP) = IDP
                    XM(NP)=GETMAS(IDP)
                    PSUM = XM(NP)
                    GOTO 3100
                  ENDIF
                  NQ = 0
C  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C  DO-THREE-BODY-PHASE-SPACE
C  TO DO-THREE-BODY-PHASE-SPACE
C  Treat as 3 body phase space
                  ND=3
                  IF( LPHASE ) CALL PHSP(T,CMAS,0,ND,XM,PQ)
                  IERR = 0
C  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                ENDIF

            ELSE
              SUBMS2 = SQRT( SUBMS2 )

C    Hadronize quark pairs
              IF( NQ .GT. 0 )THEN
3600            IF( IERR .NE. 0 )THEN

C    Generate multiplicity
#if defined(NONCLEO_DOUBLE)
                  CNDE = CMLT1(1) * DLOG( SUBMS2 / CMLT2(1) )
                  CMEAN = .5 * NQ + CNDE
                  WID = SQRT( DMAX1( CNDE * WIDTH(1), .00001D0 ))
#else
                  CNDE = CMLT1(1) * ALOG( SUBMS2 / CMLT2(1) )
                  CMEAN = .5 * NQ + CNDE
                  WID = SQRT( AMAX1( CNDE * WIDTH(1), .00001 ))
#endif
                  ND1 = MLTGEN( CMEAN, WID, MAX0(2,NP - 2 + NQ), 10)

C ............ .Hadronize
                  CALL DECQRK( ND1, NP-2, NQ, SUBMS2, KID(3),
     *                             XM(3), KQ, 10, IERR)


C    final number of daughters
                  ND = ND1 + 2
                  GOTO 3600
                ENDIF

              ELSE
                IERR = 0

C    no qq pairs => # of daughters is # of particles
                ND = NP
              ENDIF

C    number of particles still without momenta
              ND1 = ND - 2

C    set up pq array
              DO 4000 J=1,4

C  ........  antiparticle
                PQ(J,1) = P2QRK(J,2)

C  ........  particle
                PQ(J,2) = P2QRK(J,3)

C  ........  hadronic blob
                PQ(J,3) = P2QRK(J,4)
4000          CONTINUE
              IF( LPHASE ) CALL PHSP( PQ(1,3), SUBMS2,
     *                  0, ND1, XM(3), PQ(1,3))
            ENDIF
            GOTO 2600
          ENDIF
        ENDIF
      ENDIF
5000  FORMAT(/,1X,' EXO3: COULD NOT FIND MASSIVE QUARK IN :',5A6)
5001  FORMAT(  1X,'       OR                               ',6I6)
      RETURN
      END

