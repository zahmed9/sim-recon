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
* Revision 1.1  1995/07/31 19:40:38  nk
* Added typscn
*
* Revision 1.1.1.1  1994/10/05  13:45:41  zfiles
* first version of typscn in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/12 11/11/91  20.18.58  by  Unknown
*CMZ :  1.00/10 31/05/91  13.48.44  by  Jon Urheim
*-- add select flag for ibm rs6000.
*CMZ :  1.00/08 14/08/90  14.38.15  by  J. D. Lewis
*CMZ :  1.00/08 26/01/90  18.08.16  by  Ian C. Brock
*CMZ :  1.00/03 11/12/89  10.59.34  by  Ian C. Brock
*CMZ :  1.00/02 18/08/89  12.52.39  by  Ian C. Brock
*CMZ :  1.00/00 12/05/89  17.51.28  by  Ian C. Brock
*-- Author :
C
C-------------------------------------------------------------------------
C Synchronous read routine
C
      SUBROUTINE SYNRD
C
#if (defined(CLEO_VAX))&&(!defined(CLEO_VAXF77))
CJDL  IMPLICIT INTEGER (A-Z)
      CHARACTER*80 TPRMPT
      INTEGER LPRMPT
#endif
      INTEGER  IERNO
      INTEGER  IIN
      INTEGER  N
      INTEGER  NN
C
#include "cleoks/typscn/typcde/typpar.inc"
#include "cleoks/typscn/typcde/typchr.inc"
#include "cleoks/typscn/typcde/typscn.inc"
#include "cleoks/typscn/typcde/typstr.inc"
#include "cleoks/typscn/typcde/typctl.inc"
#if (defined(CLEO_VAX))&&(!defined(CLEO_VAXF77))
#include "typscn/typcde/kcvax.inc"
#endif
C
#if defined(CLEO_VAX)||defined(CLEO_IBM)||defined(CLEO_APOLLO)||defined(CLEO_UNIX)
      IF (IUNTYP.GT.0 .AND. IUNACC.EQ.5) THEN
#endif
#if defined(CLEO_MAC)
      IF (IUNTYP.GT.0 .AND. IUNACC.EQ.9) THEN
#endif
          IF (CWTYPE(:NWTYPE).EQ.'.TRUE.') THEN
#if (defined(CLEO_VAX))&&(!defined(CLEO_VAXF77))
C             WRITE (UNIT=IUNTYP,FMT=5100) CTYPNM
C5100         FORMAT(' Waiting for ',A,': ',$)
              TPRMPT = 'Waiting for ' // CTYPNM // ':'
              LPRMPT = 13 + LEN(CTYPNM)
#endif
#if (defined(CLEO_DECS)||defined(CLEO_SGI))&&(!defined(CLEO_VAXF77))
              WRITE (UNIT=IUNTYP,FMT=5100) CTYPNM
5100          FORMAT(' Waiting for ',A,': ',$)
#endif
#if defined(CLEO_IBM)||defined(CLEO_APOLLO)||defined(CLEO_MAC)||defined(CLEO_VAXF77)||defined(CLEO_RS6000)||defined(CLEO_HPUX)||defined(CLEO_LINUX)
              WRITE (UNIT=IUNTYP,FMT=5100) CTYPNM
5100          FORMAT(' Waiting for ',A,': ')
#endif
C
          ELSE IF (CWTYPE(:NWTYPE).EQ.'.FALSE.') THEN
#if (defined(CLEO_VAX))&&(!defined(CLEO_VAXF77))
              TPRMPT = ' '
              LPRMPT = 1
#endif
              CONTINUE
C
          ELSE
#if (defined(CLEO_VAX))&&(!defined(CLEO_VAXF77))
C             WRITE (UNIT=IUNTYP,FMT=5200) CWTYPE(:NWTYPE)
C5200         FORMAT(1X,A,$)
              TPRMPT = CWTYPE(:NWTYPE)
              LPRMPT = NWTYPE
#endif
#if (defined(CLEO_DECS)||defined(CLEO_SGI))&&(!defined(CLEO_VAXF77))
              WRITE (UNIT=IUNTYP,FMT=5200) CWTYPE(:NWTYPE)
5200          FORMAT(1X,A,$)
#endif
#if defined(CLEO_IBM)||defined(CLEO_APOLLO)||defined(CLEO_MAC)||defined(CLEO_VAXF77)||defined(CLEO_RS6000)||defined(CLEO_HPUX)||defined(CLEO_LINUX)
              WRITE (UNIT=IUNTYP,FMT=5200) CWTYPE(:NWTYPE)
5200          FORMAT(1X,A)
#endif
C
          END IF
      END IF
C
C IBM, APOLLO and MACINTOSH returns EOF condition for empty lines.
C Worse yet, supsequent reads look for another file with increment sequence
C number.  For terminal I/O we will close 5 and reopen. This seems to work.
C N.B.
C IBM only happy reading 80 characters from TTY. Assume IUNACC=5 means TTY
C input.
C
      CTYDAT=' '
#if (defined(CLEO_VAX))&&(!defined(CLEO_VAXF77))
      IIN = DIMTYD
      IF(IUNACC.EQ.5) THEN
          IERNO = SMG$READ_COMPOSED_LINE(
     +     KEYB,KEYT,CTYDAT,TPRMPT(1:LPRMPT)//' ')
          IF(IERNO.EQ.SMG$_EOF) GOTO 100
      ELSE
          READ(UNIT=IUNACC,FMT=5000,END=100) CTYDAT
      ENDIF
#endif
#if defined(CLEO_VAXF77)||defined(CLEO_UNIX)
      IIN = DIMTYD
      READ(UNIT=IUNACC,FMT=5000,END=100) CTYDAT
#endif
#if defined(CLEO_APOLLO)
      IIN = DIMTYD
      READ(UNIT=IUNACC,FMT=5000,IOSTAT=IOERR,END=100) CTYDAT
#endif
#if defined(CLEO_IBM)
      IF (IUNACC.EQ.5) THEN
#endif
#if defined(CLEO_MAC)
      IF (IUNACC.EQ.9) THEN
#endif
#if defined(CLEO_IBM)||defined(CLEO_MAC)
          IIN = 80
      ELSE
          IIN = DIMTYD
      END IF
      READ(UNIT=IUNACC,FMT=5000,END=100) CTYDAT(1:IIN)
#endif
5000  FORMAT(A)
C
C       Strip trailing blanks and tabs
      DO 10 NN=IIN,1,-1
          N = NN
          IF (INDEX(CTABSP,CTYDAT(N:N)).EQ.0) GO TO 1
10    CONTINUE
      N = 0
C
#if defined(CLEO_IBM)
      GOTO 1
C
100   CONTINUE
      N = 0
      IF (IUNACC.EQ.5) THEN
          CLOSE (UNIT=5)
          OPEN (UNIT=5)
      END IF
#endif
#if defined(CLEO_MAC)
100   CONTINUE
      N = 0
#endif
1     CONTINUE
C
C       Initialize pointers
      IPOINT = 0
      KPOINT = IPOINT
      NCHACC = N
      NCHARS = N
      KCHARS = N
C
#if defined(CLEO_VAX)||defined(CLEO_APOLLO)||defined(CLEO_UNIX)
      GO TO 110
C
100   CONTINUE
      CALL QUOTYP(CCTLZ)
110   CONTINUE
#endif
C
      RETURN
      END
