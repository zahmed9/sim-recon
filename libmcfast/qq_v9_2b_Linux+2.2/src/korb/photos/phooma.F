*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:29  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:06  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/05 21/10/93  17.43.04  by  Alan Weinstein
*-- Author :
* 15/10/96 Lynn Garren: Add double precision conditionals.
      SUBROUTINE PHOOMA(IFIRST,ILAST,POINTR)
C.----------------------------------------------------------------------
C.
C.    PHOTOS:   PHOton radiation in decays Order MAss vector
C.
C.    Purpose:  Order  the  contents  of array 'POINTR' according to the
C.              decreasing value in the array 'MASS'.
C.
C.    Input Parameters:  IFIRST, ILAST:  Pointers  to  the  vector loca-
C.                                       tion be sorted,
C.                       POINTR:         Unsorted array with pointers to
C.                                       /PHOEVT/.
C.
C.    Output Parameter:  POINTR:         Sorted arrays  with  respect to
C.                                       particle mass 'PPHO(5,*)'.
C.
C.    Author(s):  B. van Eijk                     Created at:  28/11/89
C.                                                Last Update: 27/05/93
C.
C.----------------------------------------------------------------------
C--   IMPLICIT NONE
      INTEGER NMXPHO
#if defined(NONCLEO_DOUBLE)
      PARAMETER (NMXPHO=4000)
      INTEGER IDPHO,ISTPHO,JDAPHO,JMOPHO,NEVPHO,NPHO
      DOUBLE PRECISION PPHO,VPHO
#else
      PARAMETER (NMXPHO=2000)
      INTEGER IDPHO,ISTPHO,JDAPHO,JMOPHO,NEVPHO,NPHO
      REAL PPHO,VPHO
#endif
      COMMON/PHOEVT/NEVPHO,NPHO,ISTPHO(NMXPHO),IDPHO(NMXPHO),
     &JMOPHO(2,NMXPHO),JDAPHO(2,NMXPHO),PPHO(5,NMXPHO),VPHO(4,NMXPHO)
      INTEGER IFIRST,ILAST,I,J,BUFPOI,POINTR(NMXPHO)
      REAL BUFMAS,MASS(NMXPHO)
      IF (IFIRST.EQ.ILAST) RETURN
C--
C--   Copy particle masses
      DO 10 I=IFIRST,ILAST
   10 MASS(I)=PPHO(5,POINTR(I))
C--
C--   Order the masses in a decreasing series
      DO 30 I=IFIRST,ILAST-1
        DO 20 J=I+1,ILAST
          IF (MASS(J).LE.MASS(I)) GOTO 20
          BUFPOI=POINTR(J)
          POINTR(J)=POINTR(I)
          POINTR(I)=BUFPOI
          BUFMAS=MASS(J)
          MASS(J)=MASS(I)
          MASS(I)=BUFMAS
   20   CONTINUE
   30 CONTINUE
      RETURN
      END
