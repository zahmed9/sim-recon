*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:19  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  18:00:14  nk
* Consolidation
*
* Revision 1.1  1995/07/31 19:40:35  nk
* Added typscn
*
* Revision 1.1.1.1  1994/10/05  13:45:41  zfiles
* first version of typscn in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
#if (defined(CLEO_VAX))&&(!defined(CLEO_VAXF77))
*CMZ :  1.00/08 14/08/90  14.40.57  by  J. D. Lewis
*CMZ :  1.00/08 26/02/90  22.35.15  by  Ian C. Brock
*CMZ :  1.00/03 28/11/89  14.49.48  by  J. D. Lewis
*CMZ :  1.00/00 12/05/89  17.29.21  by  Ian C. Brock
*-- Author :
C
C----------------------------------------------------------------------
C Init channel for asynchronous read
C
      SUBROUTINE ASYNI(LTTY,INPUT_CHANNEL)
C
CJDL  IMPLICIT INTEGER*4 (A-Z)
C
      INCLUDE '($SSDEF)/NOLIST'
      INCLUDE '($DCDEF)/NOLIST'
      INCLUDE '($DVIDEF)/NOLIST'
#include "cleoks/typscn/typcde/typpar.inc"
#include "cleoks/typscn/typcde/typchr.inc"
#include "cleoks/typscn/typcde/typscn.inc"
#include "cleoks/typscn/typcde/typstr.inc"
#include "cleoks/typscn/typcde/typctl.inc"
C
      INTEGER  DEVCLASS
      INTEGER*2  INPUT_CHANNEL
      INTEGER  ISTAT
      INTEGER*2  LEN
C
      INTEGER SYS$GETDVIW,SYS$ASSIGN
      STRUCTURE /DVILIST/
      UNION
      MAP
          INTEGER*2 LEN
          INTEGER*2 CODE
          INTEGER*4 ADDR
          INTEGER*4 RLEN
      END MAP
      MAP
          INTEGER*4 LAST
      END MAP
      END UNION
      END STRUCTURE
C
      CHARACTER*80 TEXT
      LOGICAL LTTY
      RECORD /DVILIST/LIST(3)
C
      LIST(1).LEN = 4
      LIST(1).CODE = DVI$_DEVCLASS
      LIST(1).ADDR = %LOC(DEVCLASS)
      LIST(2).LEN = 4
      LIST(2).CODE = DVI$_DEVBUFSIZ
      LIST(2).ADDR = %LOC(NDEVBF)
      LIST(3).LAST = 0
      ISTAT = SYS$GETDVIW(,,'SYS$COMMAND',LIST,,,,)
      IF (ISTAT.EQ.SS$_NORMAL .OR. ISTAT.EQ.SS$_BUFFEROVF) THEN
        IF (DEVCLASS .EQ. DC$_TERM) THEN
                LTTY = .TRUE.
        ELSE IF (DEVCLASS .EQ. DC$_MAILBOX) THEN
                LTTY = .TRUE.
        ELSE
                LTTY = .FALSE.
        END IF
      ELSE
        STOP 'TYPSCN: async init GETDEV error'
      END IF
C
      NDEVBF = MIN(DIMTYD,NDEVBF)
C
      IF (LTTY) THEN
        ISTAT = SYS$ASSIGN('SYS$COMMAND',INPUT_CHANNEL,,)
        IF (ISTAT.NE.SS$_NORMAL) THEN
                CALL SYS$GETMSG(%VAL(ISTAT),LEN,TEXT,,)
                IF (IUNTYP.GT.0) WRITE(UNIT=IUNTYP,FMT=200) TEXT(:LEN)
200             FORMAT (' TYPSCN: async init error ',A)
        END IF
      END IF
C
      RETURN
      END
#endif
