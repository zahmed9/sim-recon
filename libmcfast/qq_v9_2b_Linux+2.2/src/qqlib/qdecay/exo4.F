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
*CMZ :  1.04/00 06/12/93  16.47.58  by  Lynn Garren
*CMZ :  1.03/71 01/12/93  11.32.09  by  Lynn Garren
*CMZ :  1.03/70 08/10/93  17.05.25  by  Paul Avery
*CMZ :  1.00/00 26/07/90  20.34.05  by  Paul Avery
*CMZ :          19/05/90  14.51.03  by  Jorge L. Rodriguez
*>> Author :
* 16/10/96 Lynn Garren:  Add double precision conditionals.
      SUBROUTINE EXO4(NP,NQ,KID,XM,KQ,ID,CMAS,T,IT,ND,PQ,MATRX,IER)
C.......................................................................
C.
C. EXO4 -
C.
C. Inputs    :
C. Outputs   :
C. COMMON    : MCJET QQCNTL QQLUNS QQSPCM /BLOB/
C.
C. Calls     : KQUARK SPECTR
C. Called    :
C.
C. THIS SUBROUTINE HANDLES EXOTIC B DECAYS OF THE TYPE
C.    B QUARK (+SPECTATOR) ==> LEPTON ANTIQUARK ANTIQUARK (+SPECTATOR)
C. IT IS CALLED BY SUBROUTINE DECAY WHEN MATRX .EQ. 14
C.
C. C. ROSENFELD AND G. RUCINSKI, 2/26/82.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

*- Argument declarations
      INTEGER KID(30), KQ(2,5), NP, NQ, ID, IT, ND, MATRX, IER
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION    T(4), XM(30), PQ(4,30), CMAS
#else
      REAL    T(4), XM(30), PQ(4,30), CMAS
#endif
*
*- External declarations
      INTEGER  KBPART, MLTGEN
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION GETMAS
#else
      REAL GETMAS
#endif
      EXTERNAL KBPART, MLTGEN, GETMAS
*
*- Sequence declarations
#include "qqlib/seq/mcjet.inc"
#include "qqlib/seq/qqcntl.inc"
#include "qqlib/seq/qqluns.inc"
#include "qqlib/seq/qqspcm.inc"

      INTEGER ND1, ND2
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION    SUBMS1, SUBMS2
#else
      REAL    SUBMS1, SUBMS2
#endif
      COMMON/BLOB1/ND1,ND2,SUBMS1,SUBMS2

*- Local declarations
*
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'EXO4' )
*
      INTEGER IQRK, I, J, ISGN, IDBRY, IERR
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION    RMAS, XMBY, PSQ, CNDE, CMEAN, WID
#else
      REAL    RMAS, XMBY, PSQ, CNDE, CMEAN, WID
#endif
*
      INTEGER IQ(2), KQL(2,3)
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION    CURMAS(6)
#else
      REAL    CURMAS(6)
#endif
      INTEGER IDDK

      DATA CURMAS/.01, .01, .15, 1.5, 4.9, 20./

C-- Tells SPECTR to do phase space decay
      DATA IDDK/0/
*
*
*- Executable code starts here
*
      IER = 0

C-- Determine quark and particle content of decay
C-- Initial quark id number
      IQRK = IT + 2
C-- Current quark masses
      EMBQ = CURMAS(IQRK)
C-- 4-momenta of decaying particle
      DO 101 J=1,4
         P2QRK(J,1) = T(J)
  101 CONTINUE

C-- Assume first daughter in list is lepton

C-- Lepton mass
      EMNU = XM(1)

C-- What quarks are we decaying to?
C-- Determine if quark or anti-quark is decaying

C-- ODD ID # => QUARK
      ISGN = MOD(ID,2)

C-- ISGN > 0 => QUARK
      ISGN = 2 * ISGN - 1

C-- Both quarks are "anti" to decaying
      KQL(1,1) = ISIGN(KQ(1,1),-ISGN)

C-- QUARK => GIVE OPPOSITE SIGN
      KQL(1,2) = ISIGN(KQ(2,1),-ISGN)

C-- Get flavor of spectator
      CALL KQUARK(ID,IQ)

C-- If IQ(1) is the decaying quark, we want the other one.
      KQL(1,3) = IQ(1)
      IF( ISIGN(1,KQL(1,3)) .EQ. ISGN ) KQL(1,3) = IQ(2)

C-- Make baryon
      IDBRY = KBPART(KQL)

C-- Get quasi minimum rest mass of hadronic blob
      RMAS  = GETMAS(IDBRY)

C-- Save baryon mass
      XMBY = RMAS

C-- Fill quark masses for SPECTR
      EMCL = CURMAS( ABS(KQ(2,1)) )
      EMCQ = CURMAS( ABS(KQ(1,1)) )

C-- Do the decay

C-- Fills P2QRK(4,4)
      CALL SPECTR(IDDK)

C-- sum 4-momenta of two quarks to obtain total 4-momentum of blob
      DO 102 I=1,4
         P2QRK(I,3) = P2QRK(I,3) + P2QRK(I,4)
  102 CONTINUE

      PSQ = 0.
      DO 103 I=1,3
         PSQ = PSQ + P2QRK(I,3) ** 2
  103 CONTINUE

C-- mass sq'd of blob
      SUBMS2 =  P2QRK(4,3) ** 2 - PSQ

      IF ( SUBMS2 .LT. (RMAS + .140) ** 2 ) THEN

C-- Not enough energy to make arbitrary mass => use previously
C--    created baryon and do two body phase space decay.

         NP = 2
         ND = 2
         KID(2) = IDBRY
         XM(2) = RMAS
         IF( LPHASE ) CALL PHSP(T,CMAS,0,ND,XM,PQ)

      ELSE

         SUBMS2 = SQRT( SUBMS2 )

         IERR = 1

C--  UNTIL( IERR .EQ. 0 )

  200    IF (IERR .EQ. 0) GOTO 201

C-- Generate multiplicity

#if defined(NONCLEO_DOUBLE)
           CNDE = CMLT1(1) * DLOG( (SUBMS2 - RMAS) / CMLT2(1) )
           CMEAN = CNDE
           WID = SQRT( DMAX1( CNDE * WIDTH(1), .00001D0 ))
#else
           CNDE = CMLT1(1) * ALOG( (SUBMS2 - RMAS) / CMLT2(1) )
           CMEAN = CNDE
           WID = SQRT( AMAX1( CNDE * WIDTH(1), .00001 ))
#endif

           ND1 = MLTGEN( CMEAN, WID, 1, 10) + 1

C-- Hadronize
C     WRITE(LUNTTO,2020)ND1,NQ
2020  FORMAT(1X,'CALL TO BARYDK : ND1=',I3,' ,NQ=',I2)

      CALL BARYDK( ND1, 0, 3, SUBMS2, KID(2), XM(2), KQL, 10, IERR)

           GOTO 200

  201    CONTINUE

C-- Final number of daughters
         ND = ND1 + 1

C-- Set up PQ array
         DO 301 J=1,4

C-- LEPTON
            PQ(J,1) = P2QRK(J,2)
C-- HADRONIC BLOB
            PQ(J,2) = P2QRK(J,3)

  301    CONTINUE

      IF( LPHASE ) CALL PHSP( PQ(1,2), SUBMS2, 0, ND1, XM(2), PQ(1,2))

C     E = 0
C     DO (I=1,ND) E = E + PQ(4,I)
C     E = E / T(4)
C     WRITE(LUNTTO,2030)E
2030  FORMAT(1X,'(E OF DAUGHTERS)/(E OF PARENT)=',F10.5)

      ENDIF

1000  FORMAT(/,1X,' EXO4: COULD NOT FIND MASSIVE QUARK IN :',5A6)
1001  FORMAT(  1X,'       OR                               ',6I6)

      RETURN
      END
