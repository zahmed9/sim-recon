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
*CMZ :  1.00/00 14/06/90  14.26.28  by  Paul Avery
*CMZ :          19/05/90  14.51.03  by  Jorge L. Rodriguez
*>> Author :
* 16/10/96 Lynn Garren: Add double precision conditionals.
      SUBROUTINE ETADEC(NP,NQ,KID,XM,KQ,ID,CMAS,T,IT,ND,PQ,MATRX,IER)
C.......................................................................
C.
C. ETADEC -
C.
C. Inputs    :
C. Outputs   :
C.
C. Calls     : ETADLZ
C. Called    :
C.
C... This routine handles the decays of the eta to two charged pions
C... plus a neutral. It is specifically constructed for eta >>> pi+ pi- pi0
C... (MATRX=17) and the pi+ pi- gamma decay (MATRX=18)
C... Notify Phil Baringer of problems. 4/21/87
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

*- Argument declarations
      INTEGER KID(30),KQ(2,5)
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION    T(4),XM(30),PQ(4,30)
      INTEGER NP, NQ, ID, IT, ND, MATRX, IER
      DOUBLE PRECISION    CMAS
#else
      REAL    T(4),XM(30),PQ(4,30)
      INTEGER NP, NQ, ID, IT, ND, MATRX, IER
      REAL    CMAS
#endif
*
*- Local declarations
*
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'ETADEC' )
*
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION    PDAUTS(4,3)
#else
      REAL    PDAUTS(4,3)
#endif
*
      INTEGER I, J
*
*- Executable code starts here
*
C... check to make sure particle is really an eta and mode is correct

      IER = 1
      IF (ID .NE. 52 .AND. ID .NE. 213) RETURN
      IF (NP .NE. 3 .OR. NQ .NE. 0)     RETURN
      CALL ETADLZ(T,PDAUTS,MATRX)
      ND = 3

C... store four-momenta
      DO 100 I=1,3

C... store pi+
         IF (KID(I) .EQ. 21) THEN
            DO 90 J=1,4
               PQ(J,I) = PDAUTS(J,1)
   90       CONTINUE
         ENDIF

C... store pi-
         IF (KID(I) .EQ. 22) THEN
            DO 91 J=1,4
               PQ(J,I) = PDAUTS(J,2)
   91       CONTINUE
         ENDIF

C... store pi0 (gamma)
         IF (KID(I) .EQ. 51 .OR. KID(I) .EQ. 1) THEN
            DO 92 J=1,4
               PQ(J,I) = PDAUTS(J,3)
   92       CONTINUE
         ENDIF

  100 CONTINUE

      IF(PQ(4,1).LE.0.0 .OR. PQ(4,2).LE.0.0 .OR. PQ(4,3).LE.0.0)RETURN
      IER = 0

      RETURN
      END
