*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:41  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:29  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 22/09/94  00.13.02  by  Paul Avery
*CMZ :  1.03/71 01/12/93  11.28.10  by  Lynn Garren
*CMZ :  1.03/70 08/10/93  17.05.25  by  Paul Avery
*CMZ :  1.01/00 22/09/90  10.30.37  by  Paul Avery
*CMZ :  1.00/00 14/06/90  14.26.26  by  Paul Avery
*CMZ :          19/05/90  14.51.02  by  Jorge L. Rodriguez
*>> Author :
* 16/10/96 Lynn Garren: Add double precision conditionals.
      SUBROUTINE BRYLEP(NP,NQ,KID,XM,KQ,ID,CMAS,T,IT,ND,PQ,MATRX,IER)
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C  ---------------------------------------------------------------------------
C  THIS ROUTINE HANDLES SEMILEPTONIC DECAYS OF CHARMED BARYONS
C  OF THE TYPE
C     (C+SPECTATORS) >>> LEPTON+ NU (QUARK SOUP) (S+SPECTATORS)
C  CHARGED LEPTON FIRST YIELDS V-A MATRIX ELEMENT.
C  ASSUMES 100 PERCENT C -> S.
C  CALLED BY SUBROUTINE DECAY WHEN MATRX .EQ. 4
C  C. ROSENFELD AND G. RUCINSKI, 3/26/82.
C  ---------------------------------------------------------------------------

#include "qqlib/seq/mcjet.inc"
#include "qqlib/seq/qqcntl.inc"
#include "qqlib/seq/qqspcm.inc"

C     Calling arguments
      INTEGER NP, NQ, ID, IT, ND, MATRX, IER
      INTEGER KID(30), KQ(2,5)
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION CMAS
      DOUBLE PRECISION T(4), XM(30), PQ(4,30)
#else
      REAL CMAS
      REAL T(4), XM(30), PQ(4,30)
#endif
C     Local variables
      INTEGER J, IABS, I, IDBY, IDDK, IERR, ND1, ITRY, NTRYMX
      INTEGER KQL(2,5)
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION SUBMS2, RMAS, XMBY, PSQ
      DOUBLE PRECISION CNDE, CMEAN, WID
      DOUBLE PRECISION CURMAS(6)
#else
      REAL SUBMS2, RMAS, XMBY, PSQ
      REAL CNDE, CMEAN, WID
      REAL CURMAS(6)
#endif

C     External declarations
      INTEGER KBPART, MLTGEN
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION GETMAS
#else
      REAL GETMAS
#endif
      EXTERNAL KBPART, MLTGEN, GETMAS

      DATA CURMAS/.01, .01, .15, 1.5, 4.9, 20./
      DATA NTRYMX/50000/
C  ---------------------------------------------------------------------------

C  tell spectr to do V-A
      DATA IDDK/ 1 /
C  ---------------------------------------------------------------------------

      IER = 0

C  SET UP MASSES FOR SPECTR

C   current quark mass => always C
      EMBQ = CURMAS(4)

C   4-momenta of decaying particle
      DO 1000 J=1,4
        P2QRK(J,1) = T(J)
1000  CONTINUE

C  always decay to s quark
      EMCQ = CURMAS(3)

C   Get lepton content of decay
C   Assume first two daughters in list are lepton and neutrino

C   antiparticle (relative to parent)
      EMNU = XM(1)

C   particle
      EMCL = XM(2)

C   get quark content of baryon
      CALL KBQRK(ID,KQL)
      J = 1

C   find c quark
1200  IF( IABS(KQL(1,J)) .NE. 4 )THEN
        J = J + 1
        GOTO 1200
      ENDIF

C   make s quark with same sign as c
      KQL(1,J) = ISIGN(3,KQL(1,J))

C  Make baryon consistent with mass of decaying particle

C  Mass of decaying particle
      SUBMS2 = CMAS
      DO 1700 I=1,2

C   subtract lepton masses
        SUBMS2=SUBMS2 - XM(I)
1700  CONTINUE
      RMAS = 2 * SUBMS2

C   Get id of new baryon
2000  IF( RMAS .GT. SUBMS2 )THEN

C   get new baryon
        IDBY = KBPART(KQL)

C   minimum hadron mass
        RMAS = GETMAS(IDBY)

C   save baryon mass
        XMBY = RMAS
        GOTO 2000
      ENDIF

C   Minimum hadronic rest mass should include masses of at least
C   two hadrons implying ability to make arbitrary mass
      RMAS = ( RMAS + .140 ) ** 2

C     do the decay
      CALL SPECTR(IDDK)
      PSQ = P2QRK(1,4) ** 2 + P2QRK(2,4) ** 2 + P2QRK(3,4) ** 2

C  mass sq'd of blob
      SUBMS2 = P2QRK(4,4) ** 2 - PSQ
#if defined(NONCLEO_DOUBLE)
      IF( P2QRK(4,4) .LT. 0. ) SUBMS2 = SIGN(SUBMS2,-1.D0)
#else
      IF( P2QRK(4,4) .LT. 0. ) SUBMS2 = SIGN(SUBMS2,-1.)
#endif
      IF( SUBMS2 .LT. RMAS )THEN

C  Spectr did not make enough hadronic mass
C  do three body semileptonic decay
        ND=3

C  Use previously created baryon
        KID(ND) = IDBY
        XM(ND) = XMBY
        IF( LPHASE ) CALL PHSP(T,CMAS,1,ND,XM,PQ)

      ELSE
        SUBMS2 = SQRT( SUBMS2 )
        IERR = 1
        ITRY = 0
2300    IF(IERR .NE. 0)THEN
          IF(ITRY.GT.NTRYMX) GO TO 9000
          ITRY = ITRY + 1

C  Generate multiplicity
#if defined(NONCLEO_DOUBLE)
          CNDE = CMLT1(IT) * DLOG( (SUBMS2 - XMBY) / CMLT2(IT) )
          CMEAN = CNDE
          WID = SQRT( DMAX1( CNDE * WIDTH(IT), .00001D0 ))
#else
          CNDE = CMLT1(IT) * ALOG( (SUBMS2 - XMBY) / CMLT2(IT) )
          CMEAN = CNDE
          WID = SQRT( AMAX1( CNDE * WIDTH(IT), .00001 ))
#endif
          ND1 = MLTGEN( CMEAN, WID, 1, 10) + 1

C   Pop quarks and hadronize
C   Final number of daughters
          CALL BARYDK( ND1, 0, 3, SUBMS2, KID(3), XM(3), KQL, 10, IERR)
          ND = ND1 + 2
          GOTO 2300
        ENDIF

C  SET UP PQ ARRAY
        DO 2500 J=1,4

C  antiparticle
          PQ(J,1) = P2QRK(J,2)

C   particle
          PQ(J,2) = P2QRK(J,3)

C   hadronic blob
          PQ(J,3) = P2QRK(J,4)
2500    CONTINUE
      IF( LPHASE ) CALL PHSP( PQ(1,3), SUBMS2, 0, ND1, XM(3), PQ(1,3))

      ENDIF
      RETURN
9000  IER = 1
      RETURN
      END
