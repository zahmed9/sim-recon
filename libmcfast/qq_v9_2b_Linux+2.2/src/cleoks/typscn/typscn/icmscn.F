*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:18  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  18:00:06  nk
* Consolidation
*
* Revision 1.1  1995/07/31 19:39:20  nk
* Added typscn
*
* Revision 1.1.1.1  1994/10/05  13:45:39  zfiles
* first version of typscn in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/00 12/05/89  16.52.48  by  Ian C. Brock
*-- Author :
C
C----------------------------------------------------------------------
C Extracts a command
C
      INTEGER FUNCTION ICMSCN(JPOINT,JCHARS,IDELIM,CCMD)
      SAVE
C
      INTEGER  I
      INTEGER  IDELIM
      INTEGER  JCHARS
      INTEGER  JCMD
      INTEGER  JPOINT
      INTEGER  L
      INTEGER  NM
C
#include "cleoks/typscn/typcde/typpar.inc"
#include "cleoks/typscn/typcde/typchr.inc"
#include "cleoks/typscn/typcde/typscn.inc"
#include "cleoks/typscn/typcde/typstr.inc"
#include "cleoks/typscn/typcde/typctl.inc"
C
      CHARACTER*1 CCH
      CHARACTER*1 CCHSCN
      CHARACTER*(*) CCMD(*)
      LOGICAL STRIP
      CHARACTER CTEMP*(DIMCBF)
C
      CCBUF = ' '
      NCHUSE = 0
      NMATCH = 0
      DO 10 I=1,DIMCLI
      ICLIST(I) = 0
10    CONTINUE
C
C is anything left on line
      IF (JCHARS .LE. 0) THEN
      JCHARS = -1
      ICMSCN = -1
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
      ICMSCN = -1
      IDELIM = -1
      RETURN
      END IF
C
C     If standard  delimiter, terminate
      IF (INDEX(CDELIM(1:NDELIM),CCH).NE.0) THEN
C             nothing
      ICMSCN = -1
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
C     Foreign character, terminate
      IF (INDEX(CSYMBL(1:NSYMBL),CCH).EQ.0) THEN
C             nothing
      ICMSCN = -1
C             foreign char termination
      IDELIM = ICHAR(CCH)
      RETURN
      END IF
C
C     Make it upper case
      IF (CCH.GE.'a' .AND. CCH.LE.'z') THEN
      CCH = CHAR(ICHAR('A') + ICHAR(CCH) - ICHAR('a'))
      END IF
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
      ELSE IF (INDEX(CSYMBL(1:NSYMBL),CCH).EQ.0) THEN
              STRIP = .FALSE.
C                     foreign char termination
              IDELIM = ICHAR(CCH)
      ELSE
              IF (CCH.GE.'a' .AND. CCH.LE.'z') THEN
                      CCH = CHAR(ICHAR('A') + ICHAR(CCH) - ICHAR('a'))
              END IF
              NCHUSE = NCHUSE + 1
              CCBUF(NCHUSE:NCHUSE) = CCH
      END IF
      GO TO 30
      END IF
C
      JCMD = 1
40    CONTINUE
      IF (CCMD(JCMD) .NE. ' ') THEN
      L = INDEX(CCMD(JCMD),' ')
      IF (L.EQ.0) THEN
              L = LEN(CCMD(JCMD))
      ELSE
              L = MAX(1,L-1)
      END IF
      CTEMP = CCMD(JCMD)
        DO 41 I=1,L
        IF (CTEMP(I:I).GE.'a' .AND. CTEMP(I:I).LE.'z') THEN
          CTEMP(I:I)=CHAR(ICHAR('A')+ICHAR(CTEMP(I:I))-ICHAR('a'))
        END IF
41    CONTINUE
      IF (INDEX(CCBUF(1:NCHUSE),CTEMP(1:L)) .EQ. 1) THEN
              NMATCH = NMATCH + 1
              NM = MIN(NMATCH,DIMCLI)
              ICLIST(NM) = JCMD
      ELSE IF (INDEX(CTEMP(1:L),CCBUF(1:NCHUSE)) .EQ. 1) THEN
              NMATCH = NMATCH + 1
              NM = MIN(NMATCH,DIMCLI)
              ICLIST(NM) = JCMD
      END IF
      JCMD = JCMD + 1
      GO TO 40
      END IF
C
      IF (NMATCH.EQ.1) THEN
C             unique match
      ICMSCN = ICLIST(1)
      ELSE
C             no mtach or multi match
      ICMSCN = 0
      END IF
C
      RETURN
      END
