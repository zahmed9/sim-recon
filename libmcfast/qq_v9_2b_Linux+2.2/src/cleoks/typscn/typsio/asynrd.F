*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:20  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  18:00:15  nk
* Consolidation
*
* Revision 1.1  1995/07/31 19:40:37  nk
* Added typscn
*
* Revision 1.1.1.1  1994/10/05  13:45:41  zfiles
* first version of typscn in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/12 11/11/91  20.18.58  by  Unknown
*CMZ :  1.00/10 31/05/91  13.43.53  by  Jon Urheim
*-- add flag for ibm rs6000.
*CMZ :  1.00/08 14/08/90  14.40.40  by  J. D. Lewis
*CMZ :  1.00/08 16/02/90  16.19.56  by  Ian C. Brock
*-- Author :
      SUBROUTINE ASYNRD
C
C----------------------------------------------------------------------
C Asynchronous read routine
C
C
#if (defined(CLEO_VAX))&&(!defined(CLEO_VAXF77))
CJDL  IMPLICIT INTEGER (A-Z)
      INCLUDE '($SSDEF)/NOLIST'
      INCLUDE '($IODEF)/NOLIST'
#endif
C
#include "cleoks/typscn/typcde/typpar.inc"
#include "cleoks/typscn/typcde/typchr.inc"
#include "cleoks/typscn/typcde/typscn.inc"
#include "cleoks/typscn/typcde/typstr.inc"
#include "cleoks/typscn/typcde/typctl.inc"
C
      CHARACTER*80 TEXT
      LOGICAL LTTY
      INTEGER LUNSAV, MBYT
      INTEGER ISTAT, N, NN
#if (defined(CLEO_VAX))&&(!defined(CLEO_VAXF77))
      INTEGER*2 IOSB(4)
      INTEGER*2 INPUT_CHANNEL,LEN
      INTEGER LIB$GET_EF,SYS$QIO,SYS$CANCEL
      LOGICAL FIRST
      DATA    FIRST/.TRUE./
#endif
C
C
      IF (.NOT.LASYNC) THEN
C
#if (defined(CLEO_VAX))&&(!defined(CLEO_VAXF77))
      IF (FIRST) THEN
        FIRST = .FALSE.
        CALL ASYNI(LTTY,INPUT_CHANNEL)
        IF (IEVFLG.EQ.0) ISTAT = LIB$GET_EF(IEVFLG)
      END IF
C
      IF (LTTY) THEN
        CTYDAT=' '
        ISTAT = SYS$QIO(%VAL(IEVFLG),%VAL(INPUT_CHANNEL),
     1          %VAL(IO$_READVBLK),IOSB,,,%REF(CTYDAT),
     1          %VAL(NDEVBF),,,,)
        IF (ISTAT.NE.SS$_NORMAL) THEN
                CALL SYS$GETMSG(%VAL(ISTAT),LEN,TEXT,,)
                IF (IUNTYP.GT.0) WRITE(UNIT=IUNTYP,FMT=300) TEXT(:LEN)
300             FORMAT (' TYPSCN: async read ',A)
        END IF
      END IF
#endif
C
      IPOINT = 0
      LASYNC = .TRUE.
      END IF
C
      RETURN
C
C------------------------------------------------------------------------------
C Cancel asynchronous read request
C
      ENTRY ASYNCN
C
      IF (LASYNC) THEN
      LASYNC = .FALSE.
#if (defined(CLEO_VAX))&&(!defined(CLEO_VAXF77))
      IF (LTTY) THEN
        ISTAT = SYS$CANCEL(%VAL(INPUT_CHANNEL))
        IF (ISTAT.NE.SS$_NORMAL) THEN
                CALL SYS$GETMSG(%VAL(ISTAT),LEN,TEXT,,)
                IF (IUNTYP.GT.0) WRITE(UNIT=IUNTYP,FMT=400) TEXT(:LEN)
400             FORMAT (' CANCEL_QIO: ',A)
        END IF
      END IF
#endif
      END IF
C
      RETURN
C
C-----------------------------------------------------------------------------
C Check status of outstanding asynchronous read
C
      ENTRY ASYNCK
C
#if (defined(CLEO_VAX))&&(!defined(CLEO_VAXF77))
      IF (LTTY) THEN
      IF (IOSB(1).EQ.0) THEN
        CONTINUE
      ELSE IF (IOSB(1).EQ.SS$_ENDOFFILE) THEN
        LASYNC = .FALSE.
        CALL QUOTYP(CCTLZ)
      ELSE IF (IOSB(1).EQ.SS$_NORMAL) THEN
        LASYNC = .FALSE.
C       Strip trailing blanks and tabs
        DO NN=IOSB(2),1,-1
                N = NN
                IF (INDEX(CTABSP,CTYDAT(N:N)).EQ.0) GO TO 1
        END DO
        N = 0
1       CONTINUE
        NCHARS = N
        NCHACC = N
        IPOINT = 0
      ELSE
        LASYNC = .FALSE.
        CALL SYS$GETMSG(%VAL(IOSB(1)),LEN,TEXT,,)
        IF (IUNTYP.GT.0) WRITE(UNIT=IUNTYP,FMT=500) TEXT(:LEN)
500     FORMAT (' TYPSCN: async check ',A)
      END IF
      END IF
#endif
#if defined(CLEO_UNIX)
      CALL ASYNCK_C(MBYT)
      IF (MBYT.EQ.-1) THEN
        CONTINUE
      ELSE
        LASYNC = .FALSE.
        LUNSAV = IUNACC
        IUNACC = 5
        CWTYPE = '.FALSE.'
        NWTYPE = LEN('.FALSE.')
        CALL SYNRD
        IUNACC = LUNSAV
      END IF
#endif
C
      RETURN
      END
