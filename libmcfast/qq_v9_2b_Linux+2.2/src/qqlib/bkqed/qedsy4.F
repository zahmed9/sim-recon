*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:34  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:29  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.03/74 07/01/94  15.41.00  by  Brian Heltsley
* fix awful bug of unknown origin
*CMZ :  1.00/00 04/06/90  18.55.46  by  Jorge L. Rodriguez
*-- Author :

      SUBROUTINE QEDSY4(IERR)
      IMPLICIT DOUBLE PRECISION(A-H,K-Z)

      COMMON / CON1 / PI,M,ALFA,PI2,LE,E,DL,MU,S,K0,CMAX,BETA,
     *                SIG0,SIGA,SIGCOL,THRSLD,LK0
      COMMON / OUT13 / K,C,Z,FI,FG
      COMMON / OUT12 / SC,SZ,CGAM,E2
      DIMENSION EE(3),EEZ(3)
      IERR = 0
      EE(1)=MAX(1.D-7,K)
      EE(2)=MAX(1.D-7,E2)
      EE(3)=MAX(1.D-7,2.D0*E-EE(1)-EE(2) )
      EEZ(1)=EE(1)*Z
      EEZ(2)=EE(2)*C
      EEZ(3)=-EEZ(1)-EEZ(2)
      IF(( DABS(EEZ(1)/EE(1)).GT.CMAX .OR. EE(1).LT.1.D-6 ) .AND.
     *   ( DABS(EEZ(2)/EE(2)).GT.CMAX .OR. EE(2).LT.1.D-6 ) .AND.
     *   ( DABS(EEZ(3)/EE(3)).GT.CMAX .OR. EE(3).LT.1.D-6 ) )
     * GOTO 50
      RETURN

50    IERR = 1
      RETURN
      END
