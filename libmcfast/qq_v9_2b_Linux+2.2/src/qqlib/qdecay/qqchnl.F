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
*CMZ :  1.04/00 22/09/94  00.17.02  by  Paul Avery
*CMZ :          17/03/94  21.42.58  by  Paul Avery
* 28/10/96  L. Garren:  Add double precision conditionals.
      SUBROUTINE QQCHNL(TYPE, IPD, ICHAN, NDAU, LIST, MATRX, NMATRX,
     *                  XMATRX, IDC, IHEL, HEL)

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C   Chooose decay channel and return information about the decay, including
C   the list of daughters, polarizations, etc.
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
C
#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqprop.inc"
#include "seq/clinc/qqtrak.inc"
#include "qqlib/seq/qqbrat.inc"
#include "qqlib/seq/mcgen.inc"
#include "qqlib/seq/qqmxcp.inc"
*
C     External declarations
      REAL RANP
      EXTERNAL RANP

C     Calling arguments
      INTEGER TYPE, IPD, ICHAN, NDAU, LIST(*), MATRX, NMATRX, IHEL, IDC
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION XMATRX(7)
      REAL HEL
#else
      REAL XMATRX(7), HEL
#endif

C     Local variables
      INTEGER I, IDCSAV, IPOL, NPOL, NHEL, JPPAR, INDX
      REAL TBR, R
*
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C  choose decay channel ==> decay products (particles and quark jets)
      TBR = RANP(0)
      IDC = IPLIST(1,TYPE) - 1
      IDCSAV = IDC

C     If decay channel already decided in mixing/CP routine, use it.
C     Otherwise find one.
      IF(IPD .GT. 0) THEN
        IF(ILDECA(IPD) .GT. 0) THEN
          IDC = ILDECA(IPD)
        ELSE
90        IDC = IDC + 1
          IF(TBR .GT. BRLIST(IDC)) GOTO 90
        ENDIF
      ELSE
100     IDC = IDC + 1
        IF(TBR .GT. BRLIST(IDC)) GOTO 100
      ENDIF

C    Return decay channel
      ICHAN = IDC - IDCSAV

C   Get daughters stored in IDLIST
C   MATRX = Matrix element type (0 for pure phase space)
C   NDAU  = # daughters
C   JPPAR = Position in IDLIST of first daughter
C   IPOL  = pointer to helicity angular distribution database (if parent is
C           polarized)
C   NPOL  = # of defined helicity angular distributions for this decay
C   IHEL  = pointer to final state helicity probability list (0 if none)
C   NHEL  = # of helicity decay states (each with its own probability)
      NDAU  = MLLIST(1,IDC)
      JPPAR = MLLIST(2,IDC)
      MATRX = MLLIST(3,IDC)
      NHEL  = MLLIST(4,IDC)
      NPOL  = MLLIST(5,IDC)
      IHEL  = MLLIST(6,IDC)
      IPOL  = MLLIST(7,IDC)

C     Get daughters
      DO 140 I=1,NDAU
        LIST(I) = IDLIST(JPPAR+I-1)
140   CONTINUE

C     HELCQQ is helicity picked up from parent decay

C     Get angular distribution from helicity given to us by parent decay
      NMATRX = 0
#if defined(NONCLEO_DOUBLE)
      DO I=1,7
        XMATRX(I)=0.D0
      ENDDO
#else
      CALL VZERO(XMATRX, 7)
#endif
      IF(IPD .GT. 0) THEN
        HEL = HELCQQ(IPD)
      ELSE
        HEL = -999.
      ENDIF
      IF (IPOL.GT.0 .AND. ABS(HEL).LT.100) THEN
        DO 150 I=1,NPOL
          INDX = IPOL + I - 1
          IF(HEL .EQ. HELANG(INDX)) THEN
            NMATRX = 7
            XMATRX(1) = COFANG(1,INDX)
            XMATRX(2) = COFANG(2,INDX)
            XMATRX(3) = COFANG(3,INDX)
            XMATRX(4) = COFANG(4,INDX)
            XMATRX(5) = COFANG(5,INDX)
            XMATRX(6) = COFANG(6,INDX)
            XMATRX(7) = COFANG(7,INDX)
            GOTO 151
          ENDIF
150     CONTINUE
151     CONTINUE

C     Otherwise get it from stored distribution
      ELSE
        NMATRX = 7
        XMATRX(1) = AGLIST(1,IDC)
        XMATRX(2) = AGLIST(2,IDC)
        XMATRX(3) = AGLIST(3,IDC)
        XMATRX(4) = AGLIST(4,IDC)
        XMATRX(5) = AGLIST(5,IDC)
        XMATRX(6) = AGLIST(6,IDC)
        XMATRX(7) = AGLIST(7,IDC)
      ENDIF

      RETURN
      END
