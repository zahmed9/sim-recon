*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:43  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:27  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 05/10/94  10.01.08  by  Paul Avery
*CMZ :          02/12/93  13.06.25  by  Lynn Garren
*>> Author :
* 15/10/96 Lynn Garren:  Add double precision conditionals.
*
      SUBROUTINE QQBST

*  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
*    Boost primary particles to lab frame.
*  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
*
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "seq/clinc/qqevnt.inc"
#include "qqlib/seq/mcgen.inc"

C-- Calling arguments

C-- Local variables
      INTEGER I, IT
#if defined(NONCLEO_DOUBLE)
      double precision P4(4)
#else
      REAL    P4(4)
#endif
*
C-- Executable code starts here-----------------------------------------------

C-- Boost all primary particles to lab frame
      DO 30 IT=1,N
        DO 20 I=1,4
          P4(I) = P(IT,I)
20      CONTINUE
#if defined(NONCLEO_DOUBLE)
        CALL DBOOSF(P4CMQQ, 1, P4, P4)
#else
        CALL RBOOSF(P4CMQQ, 1, P4, P4)
#endif
        DO 25 I=1,4
          P(IT,I) = P4(I)
25      CONTINUE
30    CONTINUE

      RETURN
      END
