*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:19  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  18:00:09  nk
* Consolidation
*
* Revision 1.1  1995/07/31 19:39:30  nk
* Added typscn
*
* Revision 1.1.1.1  1994/10/05  13:45:40  zfiles
* first version of typscn in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/06 05/03/90  08.49.33  by  Ian C. Brock
*CMZ :  1.00/07 13/02/90  13.40.24  by  Ian C. Brock
*CMZ :  1.00/06 26/01/90  10.47.19  by  Ian C. Brock
*-- Author :
      INTEGER FUNCTION IQSSCN(JPOINT,JCHARS,IDELIM,ASTR)
C
C----------------------------------------------------------------------
C     Extracts a character string
C     The string should be enclosed in ' ' if the rest of the line
C     is not to be taken
C
      SAVE
C
      INTEGER  I
      INTEGER  IDELIM
      INTEGER  JCHARS
      INTEGER  JPOINT
      INTEGER  NCHR
C
#include "cleoks/typscn/typcde/typpar.inc"
#include "cleoks/typscn/typcde/typchr.inc"
#include "cleoks/typscn/typcde/typscn.inc"
#include "cleoks/typscn/typcde/typstr.inc"
#include "cleoks/typscn/typcde/typctl.inc"
C
      CHARACTER*(*) ASTR
C
      CHARACTER*1 CCH
      CHARACTER*1 CCHSCN
      LOGICAL STRIP,QUOTE
      CHARACTER CTEMP*(DIMCBF)
C
      CCBUF = ' '
      ASTR=' '
      NCHUSE = 0
      NMATCH = 0
      DO 10 I=1,DIMCLI
      ICLIST(I) = 0
10    CONTINUE
C
C is anything left on line
      IF (JCHARS .LE. 0) THEN
      JCHARS = -1
      IQSSCN = -1
      IDELIM = -1
      RETURN
      END IF
C
C     Strip leading blanks and tabs
20    CONTINUE
      CCH = CCHSCN(JPOINT,JCHARS)
      IF (INDEX(CTABSP,CCH).NE.0) GO TO 20
C
C     If end of line, terminate
      IF (CCH.EQ.CONES) THEN
C             nothing
          IQSSCN = -1
          IDELIM = -1
          RETURN
      END IF
C
C     If standard  delimiter, terminate
      IF (INDEX(CDELIM(1:NDELIM),CCH).NE.0) THEN
C         nothing
          IQSSCN = -1
          IF (JCHARS.LE.0) THEN
C             nothing useful after delimiter
              IDELIM = -1
              JCHARS = -1
          ELSE
C             more on line
              IDELIM = 0
          END IF
          RETURN
      END IF
C
C     See if the first character is a '
C
      IF(CCH.EQ.'''') THEN
          QUOTE = .TRUE.
C
C     If it is not a  quote take the rest of the line, also shifting the
C     pointers, not like ISTRNG
C
      ELSE
          QUOTE  = .FALSE.
C         Back up to get valid character
          JPOINT = JPOINT - 1
          JCHARS = JCHARS + 1
          NCHUSE = JCHARS
          DO 30 I=1,NCHUSE
              CCBUF(I:I) = CCHSCN(JPOINT,JCHARS)
30        CONTINUE
          IDELIM = -1
          JCHARS = -1
          GOTO 2000
      ENDIF
C
C     Extract characters until next delimiter, quote, or end of line
C
      STRIP = .TRUE.
40    CONTINUE
      IF (STRIP) THEN
          CCH = CCHSCN(JPOINT,JCHARS)
C
C         End of line
C
          IF (CCH.EQ.CONES) THEN
              STRIP = .FALSE.
              IDELIM = -1
C
C         Quote found - check if it is the end of the string
C
          ELSEIF(QUOTE .AND. CCH.EQ.'''') THEN
              STRIP = .FALSE.
C
C             Get the next character which should be the delimiter
C
              CCH = CCHSCN(JPOINT,JCHARS)
C             nothing after delimiter
              IF (JCHARS.LE.0) THEN
                  IDELIM = -1
                  JCHARS = -1
C
C             More on line
C             See if the next character is a quote also - if it is
C             add it to the string and keep going
C
              ELSEIF(CCH.EQ.'''') THEN
                  STRIP = .TRUE.
                  NCHUSE = NCHUSE + 1
                  CCBUF(NCHUSE:NCHUSE) = CCH
              ELSE
                  IF(INDEX(CDELIM(1:NDELIM),CCH).NE.0) THEN
                      IDELIM = 0
                  ELSE
                      IDELIM = ICHAR(CCH)
                  ENDIF
              ENDIF
C
C         standard delimter termination
C
          ELSEIF(.NOT.QUOTE .AND. INDEX(CDELIM(1:NDELIM),CCH).NE.0) THEN
              STRIP = .FALSE.
C             nothing after delimiter
              IF (JCHARS.LE.0) THEN
                  IDELIM = -1
                  JCHARS = -1
C             more on line
              ELSE
                  IDELIM = 0
              END IF
          ELSE
              NCHUSE = NCHUSE + 1
              CCBUF(NCHUSE:NCHUSE) = CCH
          END IF
          GO TO 40
      END IF
C
2000  CONTINUE
      NCHR = MIN(NCHUSE,LEN(ASTR))
      ASTR=CCBUF(1:NCHR)
      IQSSCN=NCHR
C
      RETURN
      END
