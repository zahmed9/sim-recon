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
*CMZ :  1.04/00 22/09/94  00.24.15  by  Paul Avery
*CMZ :  1.00/00 26/07/90  13.29.10  by  Paul Avery
*-- Author :
      SUBROUTINE QQDAUC(IP, NDAU, IDAU)

C  ---------------------------------------------------------------------
C  Find all charged, stable daughters of a particle
C
C  IP      integer (read)
C          Position in QQ list of particle whose daughters we want
C            IP > 0 Find all the charged, stable daughters of particle IP
C            IP = 0 Find all the charged, stable particles in event
C
C *NDAU    integer (read/write)
C          Input:  max number of charged, stable daughters to find
C          Output: number of charged, stable daughters found
C
C *IDAU    integer (write)
C          Positions of daughters in QQ list
C  ---------------------------------------------------------------------
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqtrak.inc"
#include "seq/clinc/qqprop.inc"
C
C     Calling arguments
      INTEGER IP, NDAU, IDAU(*)
C
C     Local variables
      INTEGER J, LL, IPARNT, NLIST
      LOGICAL LEVNT
C  ---------------------------------------------------------------------

C     LEVNT is TRUE when we want all the charged particles in the event
      LEVNT = IP .EQ. 0

C     For each stable particle, loop upward through parents until we find
C     the one we want or until the parent becomes 0 (primary particle).
      NLIST = 0
      DO 100 J=1,NFINAL
        LL = IFINSV(J)
        IF(CHARGE(ITYPEV(LL,1)) .EQ. 0.) GOTO 100
        IPARNT = LL

50      IPARNT = IPRNTV(IPARNT)
        IF(.NOT.LEVNT .AND. IPARNT.NE.0 .AND. IPARNT.NE.IP) GOTO 50

        IF(LEVNT .OR. IPARNT.EQ.IP) THEN
          IF(NLIST .GE. NDAU) GOTO 1000
          NLIST = NLIST + 1
          IDAU(NLIST) = LL
        ENDIF
100   CONTINUE

C     Only exit
1000  NDAU = NLIST

      RETURN
      END
