*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:19  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  18:00:13  nk
* Consolidation
*
* Revision 1.1  1995/07/31 19:39:43  nk
* Added typscn
*
* Revision 1.1.1.1  1994/10/05  13:45:40  zfiles
* first version of typscn in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/00 12/05/89  16.52.48  by  Ian C. Brock
*-- Author :
C
C******************************************************************************
C This section contains RELSCN, INTSCN, IOCSCN, ICMSCN, STRSCN, ISTSCN
C
C******************************************************************************
C Puts next NCHGET characters into array CARRAY
C
      SUBROUTINE STRSCN(JPOINT,JCHARS,NCHGET,CARRAY)
      SAVE
C
#include "cleoks/typscn/typcde/typpar.inc"
#include "cleoks/typscn/typcde/typchr.inc"
#include "cleoks/typscn/typcde/typscn.inc"
#include "cleoks/typscn/typcde/typstr.inc"
#include "cleoks/typscn/typcde/typctl.inc"
C
      INTEGER  I
      INTEGER  JCHARS
      INTEGER  JPOINT
      INTEGER  N
      INTEGER  NCHGET
      CHARACTER*(*) CARRAY
      CHARACTER*1 CCH
      CHARACTER*1 CCHSCN
C
      CARRAY = ' '
C
C     Strip leading blanks and tabs
10    CONTINUE
      CCH = CCHSCN(JPOINT,JCHARS)
      IF (CCH.EQ.CONES) RETURN
      IF (INDEX(CTABSP,CCH).NE.0) GO TO 10
C
C     If a delimiter, skip it
      IF (INDEX(CDELIM(1:NDELIM),CCH).EQ.0) THEN
C             There was no delimter, back up to get valid character
      JPOINT = JPOINT - 1
      JCHARS = JCHARS + 1
      END IF
C
C     Return what's left or required
      N = MIN(NCHGET,JCHARS)
      DO 20 I=1,N
      CARRAY(I:I) = CCHSCN(JPOINT,JCHARS)
20    CONTINUE
C
      RETURN
      END
