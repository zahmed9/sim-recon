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
*CMZ :  1.04/00 22/09/94  00.14.57  by  Paul Avery
*CMZ :  1.03/70 08/10/93  17.05.25  by  Paul Avery
*CMZ :  1.00/00 14/06/90  14.26.26  by  Paul Avery
*CMZ :          19/05/90  14.51.02  by  Jorge L. Rodriguez
*>> Author :
* 16/10/96 Lynn Garren: Add double precision conditionals.
      SUBROUTINE TAUHAD(NP,NQ,KID,XM,KQ,ID,CMAS,T,IT,ND,PQ,MATRX,IER)
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C  --------------------------------------------------------------------------
C     ROUTINE FOR DOING NON-EXCLUSIVE HADRONIC TAU DECAYS
C     CALLED FOR MATRX=15
C  --------------------------------------------------------------------------

#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqprop.inc"
#include "qqlib/seq/mcjet.inc"
#include "qqlib/seq/qqcntl.inc"

C     Calling variables
      INTEGER NP, NQ, ID, IT, ND, MATRX, IER
      INTEGER KID(30), KQ(2,5)
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION XM(30), PQ(4,30), T(4)
      DOUBLE PRECISION CMAS
#else
      REAL XM(30), PQ(4,30), T(4)
      REAL CMAS
#endif
*
C     Local variables
      INTEGER I, ISEED, IERR, ND1, NDMIN
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION EMHAD, WGHT, EMBIAS, EMSMER, CNDE, CMEAN, WID
#else
      REAL EMHAD, WGHT, EMBIAS, EMSMER, CNDE, CMEAN, WID
#endif
      LOGICAL LMASS

      COMMON/RANDM/ISEED
*
C     External declarations
      INTEGER MLTGEN
      REAL RANP
      EXTERNAL MLTGEN, RANP

      DATA EMBIAS/ 1.05 /, EMSMER/ 0.3 /
C  --------------------------------------------------------------------------

      IER = 0

C  electron-neutrino mass
      XM(1) = AMASS(9)

C  electron mass
      XM(2) = AMASS(7)

C  tau-neutrino mass
      XM(3) = AMASS(17)
      LMASS = .FALSE.
100   IF( LMASS )GOTO 600
      CALL PHSP(T,CMAS,1,3,XM,PQ)
      DO 300 I=1,4
        PQ(I,2) = PQ(I,1) + PQ(I,2)
        PQ(I,1) = PQ(I,3)
300   CONTINUE
      EMHAD = PQ(1,2) ** 2 + PQ(2,2) ** 2 + PQ(3,2) ** 2
      EMHAD = SQRT( PQ(4,2) ** 2 - EMHAD )
      WGHT = .5 * ( 1. + TANH( (EMHAD - EMBIAS ) / EMSMER ) )
      LMASS =.FALSE.
      IF( EMHAD .GT. .52 )THEN
        IF( RANP(ISEED) .LE. WGHT )LMASS=.TRUE.
      ENDIF

C  LMASS = EMHAD .GT. .52 .AND. RANP(ISEED) .LE. WGHT
      GOTO 100
600   CONTINUE
      IERR = 1.
700   IF( IERR .NE. 0 )THEN

C   Generate multiplicity
#if defined(NONCLEO_DOUBLE)
        CNDE = CMLT1(1) * DLOG( EMHAD / CMLT2(2) )
        CMEAN = CNDE
        WID = SQRT( DMAX1( CNDE * WIDTH(IT), .00001D0 ))
#else
        CNDE = CMLT1(1) * ALOG( EMHAD / CMLT2(2) )
        CMEAN = CNDE
        WID = SQRT( AMAX1( CNDE * WIDTH(IT), .00001 ))
#endif
        NDMIN = 2

C     IF (EMHAD .LT. .92) NDMIN = 3
        ND1 = MLTGEN( CMEAN, WID, NDMIN, 10)

C   Hadronize
        CALL DECQRK( ND1, 0, NQ, EMHAD, KID(2), XM(2), KQ, 10, IERR)

C   IF( ND1 .EQ. 2 )
C   IF( XM(2) .LT. .14 )
C   IF( XM(3) .LT. .14 ) IERR = 1
C   FIN
C   FIN
        GOTO 700
      ENDIF

C   final number of daughters
      ND = ND1 + 1
      IF( LPHASE ) CALL PHSP( PQ(1,2), EMHAD, 0, ND1, XM(2), PQ(1,2))
      RETURN
      END
