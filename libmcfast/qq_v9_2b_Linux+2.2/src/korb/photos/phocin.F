*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:29  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:05  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/05 21/10/93  17.43.02  by  Alan Weinstein
*-- Author :
* 15/10/96 Lynn Garren: Add double precision conditionals.
      SUBROUTINE PHOCIN
C.----------------------------------------------------------------------
C.
C.    PHOTOS:   PHOton Common INitialisation
C.
C.    Purpose:  Initialisation of parameters in common blocks.
C.
C.    Input Parameters:   None
C.
C.    Output Parameters:  Commons /PHOLUN/, /PHOPHO/, /PHOCOP/, /PHPICO/
C.                                and /PHSEED/.
C.
C.    Author(s):  B. van Eijk                     Created at:  26/11/89
C.                Z. Was                          Last Update: 10/08/93
C.
C.----------------------------------------------------------------------
C--   IMPLICIT NONE
      INTEGER NMXHEP
#if defined(NONCLEO_DOUBLE)
      PARAMETER (NMXHEP=4000)
#else
      PARAMETER (NMXHEP=2000)
#endif
      LOGICAL QEDRAD
      COMMON/PHOQED/QEDRAD(NMXHEP)
      INTEGER PHLUN
      COMMON/PHOLUN/PHLUN
      REAL ALPHA,XPHCUT
      COMMON/PHOCOP/ALPHA,XPHCUT
      REAL PI,TWOPI
      COMMON/PHPICO/PI,TWOPI
      INTEGER ISEED,I97,J97
      REAL URAN,CRAN,CDRAN,CMRAN
      COMMON/PHSEED/ISEED(2),I97,J97,URAN(97),CRAN,CDRAN,CMRAN
      INTEGER PHOMES
      PARAMETER (PHOMES=10)
      INTEGER STATUS
      COMMON/PHOSTA/STATUS(PHOMES)
      LOGICAL INTERF,ISEC,IFTOP
      REAL FINT,FSEC
      COMMON /PHOKEY/ INTERF,FINT,ISEC,FSEC,IFTOP
      INTEGER INIT,I
      SAVE INIT
      DATA INIT/ 0/
C--
C--   Return if already initialized...
      IF (INIT.NE.0) RETURN
      INIT=1
C--
C--   Preset switch  for  photon emission to 'TRUE' for each particle in
C--   /HEPEVT/, this interface is needed for KORALB and KORALZ...
      DO 10 I=1,NMXHEP
   10 QEDRAD(I)=.TRUE.
C--
C--   Logical output unit for printing of PHOTOS error messages
      PHLUN=6
C--
C--   Set cut parameter for photon radiation
CAJWMOD  XPHCUT=0.01
      XPHCUT=0.001
C--
C--   Define some constants
      ALPHA=0.00729735039
      PI=3.14159265358979324
      TWOPI=6.28318530717958648
C--
C--   Default seeds Marsaglia and Zaman random number generator
      ISEED(1)=1802
      ISEED(2)=9373
C--
C--   Iitialization for extra options
C--   (1)
C--   Interference weight for two body symmetric channels only.
      INTERF=.TRUE.
C--   (2)
C--   Second order - double photon switch
      ISEC=.TRUE.
C--   (3)
C--   Emision in the hard process g g (q qbar) --> t tbar
C--                                 t          --> W b
      IFTOP=.TRUE.
C--
C--   further initialization done automatically
      IF (INTERF) THEN
C--   best choice is if FINT=2**N where N+1 is maximal number of charged daughte
C--   see report on overweihted events
        FINT=2.0
      ELSE
        FINT=1.0
      ENDIF
C--   Initialise status counter for warning messages
      DO 20 I=1,PHOMES
   20 STATUS(I)=0
      RETURN
      END
