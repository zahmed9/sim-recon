*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:21  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  18:00:25  nk
* Consolidation
*
* Revision 1.1  1995/07/31 19:42:47  nk
* Added typscn
*
* Revision 1.1.1.1  1994/10/05  13:45:40  zfiles
* first version of typscn in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/00 12/05/89  16.55.34  by  Ian C. Brock
*-- Author :
C
C*****************************************************************************
C
C Routines that do not reference SCNSUB routines
C
C*****************************************************************************
C Resets pointer to beginning of buffer (after error).
C
      SUBROUTINE ZERTYP(CQUOTE)
      SAVE
C
C     If CQUOTE = '.FALSE.', no output error message is made.
C     If CQUOTE = '.TRUE.', a standard error message is typed.
C     Otherwise CQUOTE is the error message, and is typed.
C
#include "cleoks/typscn/typcde/typpar.inc"
#include "cleoks/typscn/typcde/typchr.inc"
#include "cleoks/typscn/typcde/typscn.inc"
#include "cleoks/typscn/typcde/typstr.inc"
#include "cleoks/typscn/typcde/typctl.inc"
C
      INTEGER  M
      INTEGER  N
      INTEGER  NCHS
      CHARACTER*(*) CQUOTE
      CHARACTER*20 FORM
C
      IF (NCHACC.GT.0) THEN
C
C
      IF (IUNTYP.NE.0 .AND. CQUOTE.NE.'.FALSE.') THEN
      IF (CQUOTE.EQ.'.TRUE.') THEN
              WRITE (UNIT=IUNTYP,FMT=5100) CTYPNM,CTYDAT(1:NCHACC)
5100          FORMAT (' ? Error in ',A,': ',A)
              NCHS = 21
      ELSE
              WRITE (UNIT=IUNTYP,FMT=5200) CQUOTE,CTYDAT(1:NCHACC)
5200          FORMAT (1X,A,A)
              NCHS = LEN(CQUOTE)
      END IF
C
C             Output another line underlining the offending parts:
      N = NCHS+KPOINT
      M = MAX(1,NCHUSE)
C             form underline
      WRITE (UNIT=FORM,FMT=5300) N,M
5300  FORMAT ('(1X,',I3,'X,',I3,'(''=''))')
      WRITE (UNIT=IUNTYP,FMT=FORM)
      END IF
      END IF
C
      IPOINT = NCHACC
      NCHARS = -1
      RETURN
      END
