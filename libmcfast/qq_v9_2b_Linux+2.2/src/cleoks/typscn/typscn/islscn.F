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
* Revision 1.1  1995/07/31 19:39:31  nk
* Added typscn
*
* Revision 1.1.1.1  1994/10/05  13:45:40  zfiles
* first version of typscn in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/06 15/05/90  11.13.25  by  Ian C. Brock
*CMZ :  1.00/07 13/02/90  17.50.43  by  Ian C. Brock
*-- Author :
C
C----------------------------------------------------------------------
C Extracts a character string
C
      INTEGER FUNCTION ISLSCN(JPOINT,JCHARS,IDELIM,ASTR)
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
      LOGICAL STRIP
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
          ISLSCN = -1
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
      ISLSCN = -1
      IDELIM = -1
      RETURN
      END IF
C
C     If standard  delimiter, terminate
      IF (INDEX(CDELIM(1:NDELIM),CCH).NE.0) THEN
C             nothing
      ISLSCN = -1
      IF (JCHARS.LE.0) THEN
C                     nothing useful after delimiter
              IDELIM = -1
              JCHARS = -1
      ELSE
C                     more on line
              IDELIM = 0
      END IF
      RETURN
      END IF
C
C     Make it upper case
C     IF (CCH.GE.'a' .AND. CCH.LE.'z') THEN
C     CCH = CHAR(ICHAR('A') + ICHAR(CCH) - ICHAR('a'))
C     END IF
      NCHUSE = NCHUSE + 1
      CCBUF(NCHUSE:NCHUSE) = CCH
C
C     Extract characters until next delimiter or end of line
      STRIP = .TRUE.
30    CONTINUE
      IF (STRIP) THEN
      CCH = CCHSCN(JPOINT,JCHARS)
      IF (CCH.EQ.CONES) THEN
              STRIP = .FALSE.
C                     end of line
              IDELIM = -1
      ELSE IF (INDEX(CDELIM(1:NDELIM),CCH).NE.0) THEN
C                     standard delimter termination
              STRIP = .FALSE.
              IF (JCHARS.LE.0) THEN
C                             nothing after delimiter
                      IDELIM = -1
                      JCHARS = -1
              ELSE
C                             more on line
                      IDELIM = 0
              END IF
      ELSE
C             IF (CCH.GE.'a' .AND. CCH.LE.'z') THEN
C                     CCH = CHAR(ICHAR('A') + ICHAR(CCH) - ICHAR('a'))
C             END IF
              NCHUSE = NCHUSE + 1
              CCBUF(NCHUSE:NCHUSE) = CCH
      END IF
      GO TO 30
      END IF
C
      NCHR = MIN(NCHUSE,LEN(ASTR))
      ASTR=CCBUF(1:NCHR)
      ISLSCN=NCHR
C
      RETURN
      END
