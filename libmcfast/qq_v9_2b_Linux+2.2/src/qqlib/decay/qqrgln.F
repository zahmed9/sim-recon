*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:36  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:31  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 15/10/93  12.33.02  by  Paul Avery
*CMZ :  1.01/00 31/10/90  22.11.15  by  Paul Avery
*CMZ :  1.00/01 19/10/90  08.16.18  by  Paul Avery
*-- Author :    Paul Avery   21/08/89
      SUBROUTINE QQRGLN(NID, IDLIST, NREAD, LIST, CLIST, LERROR )
C.......................................................................
C.
C. QQRGLN - Read in a line of numbers and strings
C.
C. Inputs
C   NID      integer variable
C            Number of items to be read. Length of IDLIST
C
C   IDLIST   integer array
C            Specifies type of items to be read (length = NID)
C            1 = integer
C            2 = real
C            3 = string
C            4 = octal
C            5 = hex
C.
C. Outputs
C   NREAD    integer variable
C            Number of items actually read. Length of LIST.
C
C   LIST     mixed array (real and integer)
C            Returned list of items actually read (length = NREAD)
C            If the item was a string, LIST(I) points to the location
C            in CLIST where the string is located
C
C   CLIST    character array
C            Returned list of character items read. The length is the
C            total number of string items requested (specified in IDLIST).
C
C   LERROR   logical variable
C            TRUE if an error occurred during read
C.
C. Author    : Paul Avery  21/08/89  16.28.35
C.
C. Detailed description
C.  Uses TYPSCN to read in the line.
C.......................................................................

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C     External routines
      INTEGER INTTYP, IOCTYP, IHXTYP, ICMTYP
      REAL RELTYP
      EXTERNAL INTTYP, IOCTYP, IHXTYP, ICMTYP, RELTYP

C     Calling arguments
      INTEGER NID, IDLIST(*), NREAD, LIST(*)
      CHARACTER CLIST(*)*(*)
      LOGICAL LERROR
C
C     Local variables
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'QQRGLN' )
      CHARACTER*80 CMESSG
      INTEGER I, IX, NCHAR, DELIM, ICMD, LENG
      REAL X
      EQUIVALENCE (IX, X)
C >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C     Count the number of character items expected and clear CLIST/LIST
      NCHAR = 0
      DO 10 I=1,NID
        LIST(I) = 0
        IF(IDLIST(I) .EQ. 3) THEN
          NCHAR = NCHAR + 1
          CLIST(NCHAR) = ' '
        ENDIF
10    CONTINUE

C     Read the list
      DELIM = 0
      NREAD = 0
      NCHAR = 0
      DO 100 I=1,NID

C     Quit if end of line
        IF(DELIM .LT. 0) GOTO 1000

C     Integer
        IF(IDLIST(I) .EQ. 1) THEN
          IX = INTTYP(.FALSE., DELIM)

C     Real
        ELSE IF(IDLIST(I) .EQ. 2) THEN
          X = RELTYP(.FALSE., DELIM)

C     String
        ELSE IF(IDLIST(I) .EQ. 3) THEN
          ICMD = ICMTYP(.FALSE., DELIM, ' ')
          CALL ICMSTR(CMESSG)
          IF(DELIM .LE. 0) NCHAR = NCHAR + 1
          IX = NCHAR

C     Octal
        ELSE IF(IDLIST(I) .EQ. 4) THEN
          IX = IOCTYP(.FALSE., DELIM)

C     Hex
        ELSE IF(IDLIST(I) .EQ. 5) THEN
          IX = IHXTYP(.FALSE., DELIM)

C     Illegal
        ELSE
          GOTO 9999
        ENDIF

C     Everything OK, add to list
        IF(DELIM .LE. 0) THEN
          NREAD = NREAD + 1
          LIST(NREAD) = IX
          IF(IDLIST(I) .EQ. 3) CLIST(NCHAR) = CMESSG

C     Error reading, quit
        ELSE
          GOTO 9999
        ENDIF
100   CONTINUE

C     Normal exit
1000  LERROR = .FALSE.
      RETURN

C     Error exit
9999  LERROR = .TRUE.
      CALL ZERTYP('Illegal string: ')
      RETURN
      END
