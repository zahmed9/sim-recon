*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:33  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:35  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 22/09/94  00.22.42  by  Paul Avery
*CMZ :  1.03/20 24/07/91  09.47.12  by  R.A.FULTON
*-- Author :   R.A.FULTON
      SUBROUTINE ELONLY
C*******************************************************************
C...Loads scattered electrons ONLY into MC common blocks.
#include "qqlib/gggseq/ggmodl.inc"
#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqprop.inc"
#include "qqlib/seq/mcgen.inc"
#include "qqlib/gggseq/genarg.inc"
C.................LOCALS
       INTEGER   J2, LQPMAT
C
C..EXTERNAL::
       EXTERNAL  LQPMAT
C
C.    Reset particle counters
      N  = 0
C
C     scattered electron stored
      DO 14 J2=1,2
        N = N + 1
  14  P(N,5) = AMASS(7)
C
      DO 15 J2=1,4
        P(N - 1,J2) = E14V(J2)
  15  P(N,J2) = E24V(J2)
C
      K(N - 1,2)   = LQPMAT(-11*IC1,1)
      K(N,2)       = LQPMAT(-11*IC2,1)
C
C     Decay all particles
      CALL DECADD
C
      RETURN
      END
