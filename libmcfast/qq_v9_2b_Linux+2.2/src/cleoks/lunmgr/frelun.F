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
*CMZ :  1.00/00 17/11/88  15.21.08  by  R. Namjoshi
*-- Author : R. Namjoshi
      SUBROUTINE FRELUN( ILUN, CRNAME )
C.......................................................................
C.
C. FRELUN - Deallocate ILUN
C.
C. Inputs    : ILUN   - Unit number to deallocate
C.           : CRNAME - CHARACTER name of owner of allocation
C. Outputs   : None
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
C.  This routine deallocates unit ILUN and marks it as being free in
C.  the unit allocation table. If the owner of the allocation is
C.  different from the value supplied in CRNAME, a message is logged
C.  before deallocating the unit.
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
      CHARACTER*8 COWNER
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
      CALL CHKLUN( 'FRELUN' )
      IF( ILUN.LT.LUNMIN .OR. ILUN.GT.LUNMAX ) THEN
C
C== Error if ILUN is out of range
C
         CALL ERRLUN( 'FRELUN', ILUN, LRNGER, ' ' )

      ELSEIF( LUNTBL(ILUN).EQ.LISLOK ) THEN
C
C== Error if ILUN is locked
C
         CALL ERRLUN( 'FRELUN', ILUN, LFLKER, ' ' )

      ELSEIF( LUNTBL(ILUN).EQ.LISUSE ) THEN
C
C== Deallocate it if it is allocated
C
         LUNTBL(ILUN) = LISFRE
         COWNER = CRNAME
         CALL CLTOU( COWNER )
         IF( LUNOWN(ILUN).NE.COWNER )
     +      CALL ERRLUN( 'FRELUN', ILUN, LDIFER, COWNER )
         LUNOWN(ILUN) = ' '

      ELSEIF( LUNTBL(ILUN).EQ.LISFRE ) THEN
C
C== Do nothing if it is already free
C

      ELSE
C
C== Else table must be corrupted
C
         CALL ERRLUN( 'FRELUN', ILUN, LTABER, ' ' )
      ENDIF
C
      RETURN
      END
