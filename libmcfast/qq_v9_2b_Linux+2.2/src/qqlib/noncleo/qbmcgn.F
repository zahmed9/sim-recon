*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:39  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:38  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 23/02/94  22.05.03  by  Paul Avery
*CMZ :  1.03/71 06/12/93  14.20.24  by  Lynn Garren
*-- Author :    Lynn Garren   04/11/93
      SUBROUTINE QBMCGN
C.......................................................................
C.
C. QBMCGN - Initilization of variables in MCGEN.
C.
C. Inputs    : NONE
C. Outputs   : NONE
C.
C. COMMON    : MCGEN
C.
C. Calls     : none
C. Called    : QBINIT
C. Author    : Lynn Garren  04/11/93
C.
C. Detailed description
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
#include "qqlib/seq/mcgen.inc"

C=== LOCAL VARIABLES USED FOR DATA INPUT

      INTEGER I, J, XQFLV(2,6)
      REAL XQMAS(15), XPAR(25), XCZF(15), XMESO(36), XCMIX(6,2)
      REAL XBRFLV(6,4)

C=== MCGEN

      DATA XQMAS/.3, .3, .5, 1.6, 5., 20., .275, 2*0., 3*.6, .8, .8, 1./
      DATA XPAR / 0.1, 0.0, 1.0, 0.0, 0.0073, 4.0, 0.121, 0.0, 0.3,
     *            0.9, 1.0, 0.7, 0.39, 0.27, -0.8839, 0.2250, 2.355,
     *            8*0. /

      DATA XCZF  / 2*0.77,0.77,0.,0.,0.,3*0.,6*0./
      DATA XMESO / 31, 1, 3, 8,14,22, 2,32, 5,10,
     *             16,24, 4, 6,33,12,18,26, 7, 9,
     *             11,34,20,28,13,15,17,19,35,30,
     *             21,23,25,27,29,36 /
      DATA XCMIX / 2*0.5,1.,   2*0.5,1.,   2*0.25,0.5,   2*0.,1./
      DATA XBRFLV/ 40,41,42,43,44,46,
     *             41,42,48,44,45,47,
     *             43,44,45,46,47,49,
     *             50,51,52,53,54,55 /
      DATA XQFLV/ 1,1,1,2,2,2,1,3,2,3,3,3 /

C---------------------------------------------------------------------

C=== MCGEN /DATA1/

      IST = 0
      IFR = 1
      PUD = 0.48
      PS1 = 0.5
      SIGMA = 0.35

      DO 10 I=1,15
 10   QMAS(I) = XQMAS(I)

      DO 11 I=1,25
 11   PAR(I) = XPAR(I)

      PAR(8) = 0.


C=== MCGEN /DATA2/

      DO 20 I=1,15
 20   CZF(I) = XCZF(I)

      DO 21 I=1,36
 21   MESO(I) = XMESO(I)

      DO 22 I=1,6
       DO 23 J=1,2
                     CMIX(I,J) = XCMIX(I,J)
 23    CONTINUE
 22   CONTINUE


C=== MCGEN /DATA3/

      CND(1) = 1.8
      CND(2) = 0.9
      CND(3) = 2.0


C=== MCGEN /DATA5/

      BSPIN(1) = 1.0
      BSPIN(2) = 1.0
      BSPIN(3) = 1.0
      BSPIN(4) = 1.0
      BSPIN(5) = 1.0

      BSYMM(1) = 1.0
      BSYMM(2) = 1.0
      BSYMM(3) = 1.0


C=== MCGEN /BARYON/

      PBFL(1) =  9.
      PBFL(2) = 18.
      PBFL(3) = 27.
      PBFL(4) = 28.
      PBFL(5) = 29.
      PBFL(6) = 29.

      FLIP = 0.
      WBAR = 2.

      DO 31 I=1,6
       DO 32 J=1,4
                     KBRFLV(I,J) = XBRFLV(I,J)
 32    CONTINUE
 31   CONTINUE

      DO 33 I=1,2
       DO 34 J=1,6
                     IQFLV(I,J) = XQFLV(I,J)
 34    CONTINUE
 33   CONTINUE

      RETURN
      END
