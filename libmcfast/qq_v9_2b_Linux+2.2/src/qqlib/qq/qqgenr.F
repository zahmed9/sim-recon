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
*CMZ :  1.04/00 16/09/94  02.27.07  by  Paul Avery
*CMZ :  1.03/68 30/08/93  11.24.52  by  Peter C Kim
*CMZ :  1.03/24 26/09/91  13.05.28  by  Peter C Kim
*CMZ :  1.03/21 16/09/91  20.48.21  by  Peter C Kim
*CMZ :  1.01/00 04/10/90  09.32.12  by  Paul Avery
*CMZ :  1.00/00 24/08/90  15.55.07  by  Paul Avery
*CMZ :          21/05/90  15.49.14  by  Jon Urheim
*-- declare local variables, deflexify, adapt to CLEO II software specs
*CMZ :          20/05/90  13.38.50  by  Jorge L. Rodriguez
*CMZ :          19/05/90  15.07.54  by  Jorge L. Rodriguez
      SUBROUTINE QQGENR(IRUN, IEVT, ISTAT)

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C   Monte Carlo Generator. Used as input stage to MCARLO
C
C *IRUN      Integer variable (write)
C            Run number
C
C *IEVT      Integer variable (write)
C            Event number
C
C *ISTAT     Integer variable (write)
C             = 1 Begin run record
C             = 2 Event record
C             = 3 End run record
C             = 4 Header record
C             = 5 EOF
C             = 6 End of dataset
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqtrak.inc"
#include "seq/clinc/qqevnt.inc"
#include "qqlib/seq/qqcntl.inc"
#include "seq/clinc/qqipft.inc"
#include "seq/clinc/qqipcd.inc"
#include "qqlib/seq/mcgen.inc"
#include "qqlib/seq/qqluns.inc"
#include "qqlib/seq/qqbuffer.inc"

C-- External declarations
      LOGICAL  ISELCT
      REAL     RANP
      EXTERNAL ISELCT, RANP

C-- Calling arguments
      INTEGER IRUN, IEVT, ISTAT

C-- Local variables
      INTEGER I, L, IDUM, IERR
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C     Want to generate header, begin run, event, event, event, ...
C     Already in event mode, generate more events
      IF(IRCIQQ .EQ. 2) THEN
        IRCIQQ = 2
        ISTAT = 2

C     Just after start or EOF ... generate header
      ELSE IF(IRCIQQ.EQ.0 .OR. IRCIQQ.EQ.5 .OR. IRCIQQ.EQ.6) THEN
        IRCIQQ = 4
        ISTAT = 4
        GOTO 1000

C     Just generated header, generate begin run
      ELSE IF(IRCIQQ .EQ. 4) THEN
        IRCIQQ = 1
        ISTAT = 1
        GOTO 1000

C     Just generated begin run, generate event
      ELSE IF(IRCIQQ .EQ. 1) THEN
        IRCIQQ = 2
        ISTAT = 2

      ELSE
        GOTO 1000
      ENDIF

      IEVTQQ = IEVTQQ + 1
      IRUN = IRUNQQ
      IEVT = IEVTQQ

100   CONTINUE

C-- Get random seed at start of event
      CALL QQRNGT(IRANQQ(1), IRANQQ(2))

C-- Generate event and boost into lab frame if radiation
      CALL MODEVT(IERR)
      IF(IERR .NE. 0)GOTO 100
C
C-- Add decay radiation if desired  (AJW)
      IF(ADDPQQ) CALL ADDPHO

C     Zero pointers
      CALL VZERO(IPFTQQ, MCTRK)
      CALL VZERO(IPCDQQ, MCTRK)

C     Copy over 4-vectors to other format
      DO 60 I=1,NTRKQQ
        DO 50 L=1,4
          PSAV(I,L) = P4QQ(L,I)
50      CONTINUE
60    CONTINUE

C-- Check if event passes selection criteria
      IF(LSELCT) THEN
        IF(.NOT.ISELCT(IDUM)) GOTO 100
      ENDIF

C-- Dump saved particle info
      IF(IEVTQQ .LE. NDUMP) CALL DMPMCC(IEVTQQ, LOUTQQ)

C-- Fill up shape array
      IF (LSHAPE) CALL FILSHP

C     Only exit
1000  CONTINUE
      RETURN
      END
