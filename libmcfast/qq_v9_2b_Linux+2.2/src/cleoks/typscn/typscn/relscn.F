*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:19  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  18:00:11  nk
* Consolidation
*
* Revision 1.1  1995/07/31 19:39:40  nk
* Added typscn
*
* Revision 1.1.1.1  1994/10/05  13:45:39  zfiles
* first version of typscn in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/06 26/07/90  16.49.32  by  J. D. Lewis
*CMZ :  1.00/00 12/05/89  16.52.49  by  Ian C. Brock
*-- Author :
C
C----------------------------------------------------------------------
C Extracts a real
C
      REAL FUNCTION RELSCN(JPOINT,JCHARS,IDELIM)
      SAVE
C
      INTEGER  ID
      INTEGER  IDELIM
      INTEGER  IDOT
      INTEGER  IEND
      INTEGER  IERR
      INTEGER  IEXPON
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
      CHARACTER*15 VALID
      CHARACTER*8 FORM
      LOGICAL STRIP
C
      NCHUSE = 0
      RELSCN = 0.
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
CJDL  IF (INDEX('+-.eE0123456789',CCH).EQ.0) THEN ! Don't "E" to start real #
      IF (INDEX(  '+-.0123456789',CCH).EQ.0) THEN
C             foreign char termination
      IDELIM = ICHAR(CCH)
      RETURN
      END IF
C
C     Extract characters until next delimiter or end of line
      ISTART = JPOINT
      VALID = CNULL//CNULL//'.eE0123456789'
      IDOT = 0
      IEXPON = 0
      STRIP = .TRUE.
20    CONTINUE
      IF (STRIP) THEN
      CCH = CCHSCN(JPOINT,JCHARS)
      IF (CCH.EQ.CONES) THEN
              STRIP = .FALSE.
C                     end of line
              IDELIM = -1
      ELSE IF (INDEX(VALID,CCH).NE.0) THEN
              IF (CCH .EQ. '.') THEN
C                     no more "." allowed
                      VALID(3:3) = CNULL
                      IDOT = JPOINT
              ELSE IF (CCH .EQ. 'E' .OR. CCH .EQ. 'e') THEN
                      VALID(1:5) = '+-'//CNULL//CNULL//CNULL
C                     no more ".","E",or "e" allowed. "+-" ok
                      IEXPON = JPOINT
              END IF
      ELSE IF (INDEX(CDELIM(1:NDELIM),CCH).NE.0) THEN
              STRIP = .FALSE.
              IF (JCHARS.LE.0) THEN
C                     nothing after delimiter
                      IDELIM = -1
                      JCHARS = -1
              ELSE
C                     more on line
                      IDELIM = 0
              END IF
      ELSE
              STRIP = .FALSE.
C             foreign char termination
              IDELIM = ICHAR(CCH)
      END IF
      GO TO 20
      END IF
      IEND = MAX(1,JPOINT - 1)
C
      NCHUSE = IEND - ISTART + 1
      IF (IDOT.EQ.0) THEN
      ID = 0
      ELSE IF (IEXPON.EQ.0) THEN
      ID = IEND - IDOT
      ELSE
      ID = MAX(0,IEXPON - IDOT - 1)
      END IF
      WRITE(FORM,100) NCHUSE,ID
100   FORMAT('(G',I2,'.',I2,')')
      READ (CTYDAT(ISTART:IEND),FMT=FORM,IOSTAT=IERR) RELSCN
C
      RETURN
      END
