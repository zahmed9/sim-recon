*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:14  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  17:59:54  nk
* Consolidation
*
* Revision 1.1.1.1  1994/10/04 21:54:51  zfiles
* first version of clutil in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/41 10/12/91  14.35.16  by  B. Heltsley
* give out fresh unit numbers only 10 and above
*CMZ :          17/11/88  15.21.09  by  R. Namjoshi
*-- Author : R. Namjoshi
      SUBROUTINE GETLUN( ILUN, CRNAME )
C.......................................................................
C.
C. GETLUN - Allocate ILUN or next available LUN
C.
C. Inputs    : ILUN   - Unit number to allocate
C.           : CRNAME - CHARACTER name of owner of the allocation
C. Outputs   : ILUN   - Allocated unit number, -1 if unable to allocate
C.
C. COMMON    : LUNMCC LUNMCI
C. Banks D   : None
C. Banks L   : None
C. Banks M   : None
C. Banks U   : None
C.
C. Calls     : CHKLUN CLTOU  ERRLUN INILUN
C. Called    : <USER>
C.
C. Detailed description
C.  This routine attempts to allocate unit number ILUN. If ILUN is
C.  invalid or unavailable (locked or already allocated), the first
C.  available unit number is returned in ILUN. If there are no free
C.  slots in the unit allocation table, ILUN is set to -1 and a message
C.  is logged. The name of the owner of the allocation is saved in the
C.  owner table. Case is ignored and only the first eight characters
C.  are significant.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
* -------------------- Argument declarations ---------------
      CHARACTER*(*) CRNAME
      INTEGER ILUN
* -------------------- EXTERNAL declarations ---------------
* None
* -------------------- SEQUENCE declarations ---------------
#include "cleoks/cluseq/lunmcde.inc"
* -------------------- Local    declarations ---------------
      LOGICAL RCSINI
      CHARACTER*(*) CHRCSS, CHRCSR, CHRCST, CHRCSD, CHRCSA
      PARAMETER(CHRCSS='$RCSfile$')
      PARAMETER(CHRCSR='$Revision$')
      PARAMETER(CHRCST='$State$')
      PARAMETER(CHRCSD='$Date$')
      PARAMETER(CHRCSA='$Author$')
      INTEGER I
      LOGICAL LFIRST
* -------------------- SAVE     declarations ---------------
      SAVE RCSINI
      SAVE LFIRST
* -------------------- DATA  initializations ---------------
      DATA RCSINI/.TRUE./
      DATA LFIRST / .TRUE. /
* ----------------- Executable code starts here ------------
#if WRITE_RCS_INFO
      IF(RCSINI)THEN
        RCSINI = .FALSE.
        WRITE(6,*)'-------- CVSinfo --------'
        WRITE(6,*)CHRCSS
        WRITE(6,*)CHRCSR//' '//CHRCST
        WRITE(6,*)CHRCSD//' '//CHRCSA
      ENDIF
#endif

      IF( LFIRST ) THEN
         LFIRST = .FALSE.
         CALL INILUN
      ENDIF
C
C== Check integrity of allocation table
C
      CALL CHKLUN( 'GETLUN' )
      IF( ILUN.GE.LUNMIN .AND. ILUN.LE.LUNMAX ) THEN
C
C== If ILUN is in range and free, allocate it
C
         IF( LUNTBL(ILUN).EQ.LISFRE ) THEN
            LUNTBL(ILUN) = LISUSE
            IF( CRNAME.EQ.' ' ) THEN
               CALL ERRLUN( 'GETLUN', ILUN, LNONAM, ' ' )
            ENDIF
            LUNOWN(ILUN) = CRNAME
            CALL CLTOU( LUNOWN(ILUN) )
            GOTO 999
         ENDIF
      ENDIF
C
C== Else, look for first free unit and allocate it
C
      DO 10 I = 10, LUNMAX
         ILUN = I
         IF( LUNTBL(ILUN).EQ.LISFRE ) THEN
            LUNTBL(ILUN) = LISUSE
            IF( CRNAME.EQ.' ' ) THEN
               CALL ERRLUN( 'GETLUN', ILUN, LNONAM, ' ' )
            ENDIF
            LUNOWN(ILUN) = CRNAME
            CALL CLTOU( LUNOWN(ILUN) )
            GO TO 999
         ENDIF
   10 CONTINUE
C
C== If we get here, the table is full
C
      CALL ERRLUN( 'GETLUN', ILUN, LFULER, ' ' )
      ILUN = -1
C
      RETURN
  999 END
