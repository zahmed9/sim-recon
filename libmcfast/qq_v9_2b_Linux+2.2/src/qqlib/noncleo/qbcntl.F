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
*CMZ :  1.04/00 20/05/94  08.54.26  by  Lynn Garren
*CMZ :          07/01/94  13.31.40  by  Brian Heltsley
* add new variable bhemin
*CMZ :  1.03/71 06/12/93  14.14.53  by  Lynn Garren
*-- Author :    Lynn Garren   04/11/93
      SUBROUTINE QBCNTL
C.......................................................................
C.
C. QBCNTL - Initilization of variables in qqcntl.
C.
C. Inputs    : NONE
C. Outputs   : NONE
C.
C. COMMON    : QQCNTL
C.
C. Calls     : none
C. Called    : QBINIT
C. Author    : Lynn Garren 04/11/93
C.
C. Detailed description
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
#include "qqlib/seq/qqcntl.inc"

C---------------------------------------------------------------------

C=== QQCNTL /QQCNT1/

      NDO   = 1000
      NDUMP = 5
      IRAN  = 0
      IDQQ = 0


C=== QQCNTL /QQCNT2/

      MODEL  = 1
      SPREAD = 0.0
      ENRGMN = 10.52
      ENRGMX = 10.60
      KEMIN  = 0.0
      KEMAX  = 1.0
      BHEMIN = 0.01

C=== QQCNTL /QQCNT3/

      LPRDEC = .FALSE.
      LPHASE = .TRUE.
      LWIDE  = .TRUE.
      LSHAPE = .FALSE.
      LTAPE  = .FALSE.
      TRACE  = .FALSE.
      BMRAD  = .FALSE.
      LRESPR = .FALSE.
C... LONGLF needs to be true for non-CLEO applications
      LONGLF = .TRUE.
      LTRKSM = .FALSE.
      ADDPQQ = .FALSE.
      LPROMP = .FALSE.

C=== QQCNTL /QQCNT4/

      ANGMIN =   5.0
      ANGMAX = 175.0

      CQMAS(1) = 0.1
      CQMAS(2) = 0.1
      CQMAS(3) = 0.5
      CQMAS(4) = 1.7
      CQMAS(5) = 5.0
      CQMAS(6) = 20.0
      CQMAS(7) = 0.0

      CEN(1)  = 1.87
      CEN(2)  = 1.87
      FWID(1) = 1.0
      FWID(2) = 1.0

      C1B(1) = 2.5
      C1B(2) = 2.5
      C1B(3) = 2.5
      C2B(1) = 8.0
      C2B(2) = 8.0
      C2B(3) = 8.0

      RESPRO(1) = 10.578
      RESPRO(2) = 0.024

      RETURN
      END
