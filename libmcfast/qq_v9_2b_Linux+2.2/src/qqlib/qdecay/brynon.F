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
*CMZ :  1.04/00 22/09/94  00.13.51  by  Paul Avery
*CMZ :  1.03/70 08/10/93  17.05.25  by  Paul Avery
*CMZ :  1.00/00 14/06/90  14.26.26  by  Paul Avery
*CMZ :          19/05/90  14.51.02  by  Jorge L. Rodriguez
*>> Author :
* 16/10/96 Lynn Garren: Add double precision conditionals.
      SUBROUTINE BRYNON(NP,NQ,KID,XM,KQ,ID,CMAS,T,IT,ND,PQ,MATRX,IER)
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C  ---------------------------------------------------------------------------
C  THIS ROUTINE HANDLES DECAYS OF CHARMED BARYONS TO QUARK SOUP.
C  ASSUMES 100 PERCENT C -> S.
C  CALLED FROM SUBROUTINE DECAY WHEN MATRX .EQ. 9
C  C. ROSENFELD AND G. RUCINSKI, 3/26/82.
C  ---------------------------------------------------------------------------

#include "qqlib/seq/mcjet.inc"
#include "qqlib/seq/qqcntl.inc"

C     Calling variable
      INTEGER NP, NQ, ID, IT, ND, MATRX, IER
      INTEGER KID(30), KQ(2,5)
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION CMAS
      DOUBLE PRECISION T(4), XM(30), PQ(4,30)
#else
      REAL CMAS
      REAL T(4), XM(30), PQ(4,30)
#endif
*
C     Local variables
      INTEGER IDBY, IERR, ND1, J, IDME, KODE, IDUM, ITRY, NTRYMX
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION XME, SUBMS, RMAS, CNDE, CMEAN, WID
#else
      REAL XME, SUBMS, RMAS, CNDE, CMEAN, WID
#endif
*
C     External declarations
      INTEGER KBPART, MLTGEN, KPART
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION GETMAS
#else
      REAL GETMAS
#endif
      EXTERNAL KBPART, MLTGEN, GETMAS, KPART

C     Data statements
      DATA NTRYMX/50000/
C  ---------------------------------------------------------------------------

C     decode quarks and particles to obtain baryon quark soup

      IER = 0

C   Get quark content of baryon
      CALL KBQRK(ID,KQ(1,2))
      NQ = 4
      J = 2

C   Find c quark
200   IF( IABS(KQ(1,J)) .NE. 4 )THEN
        J = J + 1
        GOTO 200
      ENDIF
C   make s quark with same sign as c
      KQ(1,J) = ISIGN(3,KQ(1,J))

C     make meson out of quark pair

      KODE = 6 * MAX0(KQ(1,1),KQ(2,1)) - MIN0(KQ(1,1),KQ(2,1)) - 6

C   come back here if not enough energy
500   IDME = KPART(KODE,IDUM)
      XME=GETMAS(IDME)

C  mass of decaying particle
      SUBMS = CMAS

C  subtract meson mass
      SUBMS = SUBMS - XME

      RMAS = 2 * SUBMS

C     make baryon consistent with mass of decaying particle and
C     mass of meson from qq-bar pair

C  get new baryon
      IDBY = KBPART(KQ(1,2))

C   baryon mass
      RMAS = GETMAS(IDBY)

C   check if mass fits inside submass
      IF(RMAS.GT.SUBMS)GOTO 500

C     generate multiplicity
      IERR = 1
      ITRY = 0
800   IF( IERR .NE. 0 )THEN
        IF(ITRY.GT.NTRYMX) GO TO 9000
        ITRY = ITRY + 1
#if defined(NONCLEO_DOUBLE)
        CNDE = CMLT1(IT) * DLOG( (CMAS-RMAS) / CMLT2(IT) )
        CMEAN = .5 + CNDE
        WID = SQRT( DMAX1( CNDE * WIDTH(IT), .00001D0 ))
#else
        CNDE = CMLT1(IT) * ALOG( (CMAS-RMAS) / CMLT2(IT) )
        CMEAN = .5 + CNDE
        WID = SQRT( AMAX1( CNDE * WIDTH(IT), .00001 ))
#endif
        ND1 = MLTGEN( CMEAN, WID, 1, 10) + 1

C   decay baryon quark soup
        CALL BARYDK( ND1, 0, NQ, CMAS, KID, XM, KQ, 10, IERR)
        GOTO 800
      ENDIF
      ND = ND1
      IF( LPHASE ) CALL PHSP( T, CMAS, 0, ND1, XM, PQ)
      RETURN
9000  IER = 1
      RETURN
      END
