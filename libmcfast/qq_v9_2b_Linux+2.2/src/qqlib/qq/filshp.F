*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:43  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:26  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 16/09/94  02.25.42  by  Paul Avery
*CMZ :  1.00/00 21/08/90  21.08.22  by  Paul Avery
*CMZ :          21/05/90  18.02.52  by  Jon Urheim
*-- declare variables, adapt to CLEO2 software standards
*CMZ :          20/05/90  13.38.51  by  Jorge L. Rodriguez
*CMZ :          19/05/90  15.07.54  by  Jorge L. Rodriguez
*>> Author :
* 15/10/96 Lynn Garren: Add double precision conditionals.
      SUBROUTINE FILSHP

C ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C     FILL SHAPE COMMONS USE OLD COMMON HISUS FOR NOW
C ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqtrak.inc"
#include "seq/clinc/qqprop.inc"
*
C-- Additional internal common
      INTEGER   NPT, JCH, JB
#if defined(NONCLEO_DOUBLE)
      double precision PCC, PCH
      REAL      CRAP, WW
#else
      REAL      CRAP, PCC, PCH, WW
#endif
      COMMON/HISUS/CRAP(120),PCC(4,100),PCH(4,100),WW(400),NPT,JCH,JB

C-- Local variables
      INTEGER I, L, KK, IT
C
      JCH = 0
      L   = 0
      DO 10 I=1,NTRKQQ
        IT = ITYPEV(I,2)
        IF (IT.LT.0) GOTO 10
        L = L + 1
        DO 31 KK = 1,4
31        PCC(KK,L)=P4QQ(KK,I)
        IF (IT.LT.2 .OR. IT.GT.9) GOTO 10
        JCH = JCH + 1
        DO 32 KK = 1,4
32        PCH(KK,JCH) = P4QQ(KK,I)
10    CONTINUE
      NPT = L
C
      RETURN
      END
