*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:21  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  18:00:24  nk
* Consolidation
*
* Revision 1.1  1995/07/31 19:42:43  nk
* Added typscn
*
* Revision 1.1.1.1  1994/10/05  13:45:41  zfiles
* first version of typscn in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/12 11/11/91  20.18.58  by  Unknown
*CMZ :  1.00/10 31/05/91  13.41.36  by  Jon Urheim
*-- flags for ibm rs6000.
*CMZ :  1.00/08 14/08/90  17.46.28  by  CLEO II Librarian
*CMZ :  1.00/07 14/08/90  11.55.23  by  J. D. Lewis
*CMZ :  1.00/09 15/05/90  11.16.00  by  Ian C. Brock
*CMZ :  1.00/06 26/01/90  17.51.04  by  Ian C. Brock
*CMZ :  1.00/03 11/12/89  10.59.31  by  Ian C. Brock
*CMZ :  1.00/01 24/05/89  12.19.25  by  Ian C. Brock
*CMZ :  1.00/00 12/05/89  16.55.34  by  Ian C. Brock
*-- Author :
C
C*****************************************************************************
C
      SUBROUTINE TYPINI
      SAVE
C
#include "cleoks/typscn/typcde/typpar.inc"
#include "cleoks/typscn/typcde/typchr.inc"
#include "cleoks/typscn/typcde/typscn.inc"
#include "cleoks/typscn/typcde/typstr.inc"
#include "cleoks/typscn/typcde/typctl.inc"
#if (defined(CLEO_VAX))&&(!defined(CLEO_VAXF77))
#include "cleoks/typscn/typcde/kcvax.inc"
#endif
C
      INTEGER  I, ISTAT
      CHARACTER*3 TYPCPU
      LOGICAL LDONE
      DATA LDONE/.FALSE./
C
C     IF (ICHAR(CONES).NE.0) GO TO 99
      IF (LDONE) GO TO 99
      LDONE=.TRUE.
C
      IPOINT = 0
      NCHARS = -1
      CTYDAT = ' '
C
      CCBUF = ' '
      DO 1 I=1,DIMCLI
          ICLIST(I) = 0
1     CONTINUE
      NMATCH = 0
      NCHUSE = 0
      NWTYPE = 6
      CWTYPE = '.TRUE.'
      CTYPNM = 'COMMAND'
      LASYNC = .FALSE.
      IEVFLG = 0
      LASYIN = .TRUE.
C
C Special characters
      CNULL = CHAR(0)
      I = 255
      CONES = CHAR(I)
C
C Set machine dependent characters - TAB and ^Z and default terminal unit #'s
      IF (ICHAR('A').EQ.65) THEN
C     ASCII
          CCTLZ = CHAR(26)
          CTAB = CHAR(9)
          IF (ICHAR(CONES).EQ.127) THEN
C             seven bit ASCII - KL
              IUNACC = 5
              IUNTYP = 5
          ELSE
C             eight bit ASCII - VAX
#if defined(CLEO_VAX)||defined(CLEO_APOLLO)||defined(CLEO_UNIX)
              IUNACC = 5
              IUNTYP = 6
#endif
#if defined(CLEO_MAC)
              IUNACC = 9
              IUNTYP = 9
#endif
          END IF
      ELSE
C     EBCDIC
          CCTLZ = CHAR(63)
          CTAB = CHAR(5)
          IUNACC = 5
          IUNTYP = 6
      END IF
C
      CTABSP = ' '//CTAB
C
C Default valid symbols
      NSYMBL = 62
      CSYMBL = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     1                //'abcdefghijklmnopqrstuvwxyz'
     1                //'0123456789'
C
C Default delimiters
      NDELIM = 3
      CDELIM = ' '//CTAB//','
C
99    CONTINUE
*
* VAX/SMG code for line editing (last 20 commands entered)
*
#if (defined(CLEO_VAX))&&(!defined(CLEO_VAXF77))
      ISTAT = SMG$CREATE_VIRTUAL_KEYBOARD(KEYB)
      IF (.NOT.ISTAT) CALL LIB$SIGNAL(%VAL(ISTAT))

      ISTAT = SMG$CREATE_KEY_TABLE(KEYT)
      IF (.NOT.ISTAT) CALL LIB$SIGNAL(%VAL(ISTAT))
#endif
C
      RETURN
      END
