*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:38  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:28  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.02/00 14/03/91  17.18.15  by  Peter C Kim
*-- Author :    Peter C Kim   14/03/91
* 16/10/96 Lynn Garren: Add double precision conditionals.
        SUBROUTINE ROTAT(A,B,G,N,PO,PN)

C  ------------------------------------------------------------------
C   ROTATE N 4-VECTORS BY EULER ANGLES A,B,G
C
C   copied from AVELIB      (used in SEMIL1)
C
C  ------------------------------------------------------------------

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#if defined(NONCLEO_DOUBLE)
        DOUBLE PRECISION A,B,G
        DOUBLE PRECISION PO(4,100),PN(4,100),R(3,3),P(4)
        INTEGER N,I,J
        DOUBLE PRECISION COSA,COSB,COSG,SINA,SINB,SING
#else
        REAL A,B,G
        REAL PO(4,100),PN(4,100),R(3,3),P(4)
        INTEGER N,I,J
        REAL COSA,COSB,COSG,SINA,SINB,SING
#endif

C    SAVE TIME BY CALCULATING AUXILIARY VARIABLES
        COSA=COS(A)
        COSB=COS(B)
        COSG=COS(G)
        SINA=SIN(A)
        SINB=SIN(B)
        SING=SIN(G)

C     COMPUTE ROTATION MATRIX
        R(1,1)=COSG*COSB*COSA-SING*SINA
        R(2,1)=-SING*COSB*COSA-COSG*SINA
        R(3,1)=SINB*COSA
        R(1,2)=COSG*COSB*SINA+SING*COSA
        R(2,2)=-SING*COSB*SINA+COSG*COSA
        R(3,2)=SINB*SINA
        R(1,3)=-COSG*SINB
        R(2,3)=SING*SINB
        R(3,3)=COSB

C     DO THE ROTATION

        DO 300 I=1,N
          DO 100 J=1,3
 100      P(J)=R(1,J)*PO(1,I)+R(2,J)*PO(2,I)+R(3,J)*PO(3,I)
          DO 200 J=1,3
 200      PN(J,I)=P(J)
          PN(4,I)=PO(4,I)
 300    CONTINUE
        RETURN
        END
