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
* Revision 1.1  1995/07/31 19:39:26  nk
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
C Extracts an integer
C
      INTEGER FUNCTION INTSCN(JPOINT,JCHARS,IDELIM)
      SAVE
C
      INTEGER  IDELIM
      INTEGER  IEND
      INTEGER  IERR
      INTEGER  ISTART
      INTEGER  JCHARS
      INTEGER  JPOINT
C
#include "cleoks/typscn/typcde/typpar.inc"
#include "cleoks/typscn/typcde/typchr.inc"
#include "cleoks/typscn/typcde/typscn.inc"
#include "cleoks/typscn/typcde/typstr.inc"
#include "cleoks/typscn/typcde/typctl.inc"
C
      CHARACTER*1 CCH
      CHARACTER*1 CCHSCN
      CHARACTER*8 FORM
      LOGICAL STRIP
C
      NCHUSE = 0
      INTSCN = 0
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
C                     nothing after delimiter
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
      IF (INDEX('+-0123456789',CCH).EQ.0) THEN
C             foreign char termination
      IDELIM = ICHAR(CCH)
      RETURN
      END IF
C
C     Extract characters until next delimiter or end of line
      ISTART = JPOINT
      STRIP = .TRUE.
20    CONTINUE
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
      ELSE IF (INDEX('0123456789',CCH).EQ.0) THEN
              STRIP = .FALSE.
C                     foreign char termination
              IDELIM = ICHAR(CCH)
      END IF
      GO TO 20
      END IF
      IEND = MAX(1,JPOINT - 1)
C
      NCHUSE = IEND - ISTART + 1
      WRITE(FORM,100) NCHUSE
100   FORMAT('(I',I2,')')
      READ (CTYDAT(ISTART:IEND),FMT=FORM,IOSTAT=IERR) INTSCN
C
      RETURN
      END
