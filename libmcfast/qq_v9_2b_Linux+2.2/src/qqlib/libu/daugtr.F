*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:38  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:27  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 22/09/94  00.23.53  by  Paul Avery
*CMZ :  1.03/44 24/02/92  13.51.13  by  Peter C Kim
*CMZ :  1.00/00 26/07/90  13.29.10  by  Paul Avery
*CMZ :          19/05/90  14.41.36  by  Jorge L. Rodriguez
*>> Author :
      SUBROUTINE DAUGTR(IP,NDAU,NCH,IDAU)
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C  ---------------------------------------------------------------------------
C     IP > 0 Find all the stable daughters of particle IP
C     IP = 0 Find all the stable daughters in event
C     NDAU = Number of stable daughters found
C     NCH = Number of charged stable daughters
C     IDAU = List of daughters
C
C  Loop over NSTBMC changed to NSTBQQ.        24/02/92  PCK
C  ---------------------------------------------------------------------------

#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqtrak.inc"
#include "seq/clinc/qqprop.inc"

C     CALLING ARGUMENTS
      INTEGER IP, NDAU, NCH
      INTEGER IDAU(*)
*
C     Local variables
      INTEGER J, IPARNT, LL
      LOGICAL LEVNT
C  ---------------------------------------------------------------------------

      NDAU = 0
      NCH = 0
      IF(NFINAL .EQ. 0)RETURN
      LEVNT = IP .EQ. 0

C     loop over stable particles
      DO 1010 J=1,NSTBQQ
        LL = IFINSV(J)
        IPARNT = LL

C  now loop upward through parents until we find the one we want
C  or until the parent becomes 0 (primary particle).
1020    IPARNT = IPRNTV(IPARNT)
        IF((LEVNT .OR. IPARNT.EQ.0) .OR. (IPARNT.EQ.IP))GOTO 1030
        GOTO 1020
1030    CONTINUE
        IF(LEVNT .OR. IPARNT.EQ.IP)THEN
          NDAU = NDAU + 1
          IDAU(NDAU) = J
          IF(CHARGE(ITYPEV(LL,1)) .NE. 0.)NCH = NCH + 1
        ENDIF

1010  CONTINUE
      RETURN
      END
