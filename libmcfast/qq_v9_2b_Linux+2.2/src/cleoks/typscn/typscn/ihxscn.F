*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:18  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  18:00:08  nk
* Consolidation
*
* Revision 1.1  1995/07/31 19:39:25  nk
* Added typscn
*
* Revision 1.1.1.1  1994/10/05  13:45:39  zfiles
* first version of typscn in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/03 28/11/89  14.54.01  by  J. D. Lewis
*CMZ :  1.00/00 12/05/89  16.52.48  by  Ian C. Brock
*-- Author :
C
C----------------------------------------------------------------------
C Extracts a hexidecimal number
C
      INTEGER FUNCTION IHXSCN(JPOINT,JCHARS,IDELIM)
      SAVE
C
      INTEGER  I
      INTEGER  IDELIM
      INTEGER  IDIGIT
      INTEGER  IEND
      INTEGER  IPOS
      INTEGER  ISTART
      INTEGER  JCHARS
      INTEGER  JPOINT
      INTEGER  JBYTOR
      INTEGER  MSBYT
C
#include "cleoks/typscn/typcde/typpar.inc"
#include "cleoks/typscn/typcde/typchr.inc"
#include "cleoks/typscn/typcde/typscn.inc"
#include "cleoks/typscn/typcde/typstr.inc"
#include "cleoks/typscn/typcde/typctl.inc"
C
      CHARACTER*1 CCH
      CHARACTER*1 CCHSCN
      LOGICAL STRIP
C
      NCHUSE = 0
      IHXSCN = 0
C
      IF (JCHARS .LE. 0) THEN
C             nothing left on line
      JCHARS = -1
      IDELIM = -1
      RETURN
      END IF
C
C     Strip leading blanks and tabs
10    CONTINUE
      CCH = CCHSCN(JPOINT,JCHARS)
      IF (INDEX(CTABSP,CCH).NE.0) GO TO 10
C
C     If end of line, terminate
      IF (CCH.EQ.CONES) THEN
      IDELIM = -1
      RETURN
      END IF
C
C     If standard delimiter, terminate
      IF (INDEX(CDELIM(1:NDELIM),CCH).NE.0) THEN
      IF (JCHARS.LE.0) THEN
C             nothing after delimiter
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
      IF (INDEX('0123456789ABCDEFabcdef',CCH).EQ.0) THEN
C     foreign char termination
      IDELIM = ICHAR(CCH)
      RETURN
      END IF
C
C     Extract characters until next delimiter or end of line
      ISTART = JPOINT
      STRIP = .TRUE.
30    CONTINUE
      IF (STRIP) THEN
      CCH = CCHSCN(JPOINT,JCHARS)
      IF (CCH.EQ.CONES) THEN
              STRIP = .FALSE.
C                     end of line
              IDELIM = -1
      ELSE IF (INDEX(CDELIM(1:NDELIM),CCH).NE.0) THEN
              STRIP = .FALSE.
              IF (JCHARS.LE.0) THEN
C                             nothing after delimiter
                      IDELIM = -1
                      JCHARS = -1
              ELSE
C                             more on line
                      IDELIM = 0
              END IF
      ELSE IF (INDEX('0123456789ABCDEFabcdef',CCH).EQ.0) THEN
              STRIP = .FALSE.
C                     foreign char termination
              IDELIM = ICHAR(CCH)
      END IF
      GO TO 30
      END IF
      IEND = MAX(1,JPOINT - 1)
C
      NCHUSE = IEND - ISTART + 1
      IPOS = 0
      IHXSCN = 0
      DO 40 I=IEND,ISTART,-1
      CCH = CTYDAT(I:I)
      IF (CCH.GE.'a' .AND. CCH.LE.'f') THEN
              IDIGIT = ICHAR(CCH) - ICHAR('a') + 10
      ELSE IF (CCH.GE.'A' .AND. CCH.LE.'F') THEN
              IDIGIT = ICHAR(CCH) - ICHAR('A') + 10
      ELSE
              IDIGIT = ICHAR(CCH) - ICHAR('0')
      END IF
CCC   IHXSCN =    IOR(IHXSCN,ISHFT(IDIGIT,  IPOS     )     )
      IHXSCN = JBYTOR(IHXSCN,MSBYT(IDIGIT,0,IPOS+1,32),1,32)
      IPOS = IPOS + 4
40    CONTINUE
C
      RETURN
      END
