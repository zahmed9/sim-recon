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
*CMZ :  1.00/00 07/12/88  16.52.12  by  R. Namjoshi
*-- Author : R. Namjoshi
      SUBROUTINE LOKLUN( ILUN, CRNAME )
C.......................................................................
C.
C. LOKLUN - Permanent allocation of a unit, cannot be unlocked!
C.
C. Inputs    : ILUN   - Unit number to lock
C.           : CRNAME - CHARACTER name of owner of lock
C. Outputs   : ILUN   - Set to -1 if locking fails
C.
C. COMMON    : LUNMCC LUNMCI
C. Banks D   : None
C. Banks L   : None
C. Banks M   : None
C. Banks U   : None
C.
C. Calls     : CLTOU  ERRLUN INILUN
C. Called    : CHKLUN <USER>
C.
C. Detailed description
C.  This routine locks unit ILUN removing it permanently from the list
C.  of available unit numbers. This routine is provided to mark certain
C.  units (such as 5, 6) as being unallocatable since the list of such
C.  units may be installation/application dependent.
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
      INTEGER JLUN
      LOGICAL LFIRST
* -------------------- SAVE     declarations ---------------
      SAVE RCSINI
      SAVE LFIRST
* -------------------- DATA  initializations ---------------
      DATA RCSINI/.TRUE./
      DATA LFIRST /.TRUE./
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
C== Check validity of ILUN
C
      JLUN = -1
      IF( ILUN.LT.LUNMIN .OR. ILUN.GT.LUNMAX ) THEN
C
C== Error if ILUN is out of range
C
         CALL ERRLUN( 'LOKLUN', ILUN, LRNGER, ' ' )

      ELSEIF( LUNTBL(ILUN).EQ.LISLOK ) THEN
C
C== Error if ILUN is already locked
C
         CALL ERRLUN( 'LOKLUN', ILUN, LLOKER, ' ' )

      ELSEIF( LUNTBL(ILUN).EQ.LISUSE ) THEN
C
C== Error if ILUN is already allocated
C
         CALL ERRLUN( 'LOKLUN', ILUN, LUSEER, ' ' )

      ELSEIF( LUNTBL(ILUN).EQ.LISFRE ) THEN
C
C== Allocate it if it is free
C
         LUNTBL(ILUN) = LISLOK
         JLUN         = ILUN
         IF( CRNAME.EQ.' ' ) THEN
            CALL ERRLUN( 'LOKLUN', ILUN, LNONAM, ' ' )
         ENDIF
         LUNOWN(ILUN) = CRNAME
         CALL CLTOU( LUNOWN(ILUN) )

      ELSE
C
C== If none of the above, table must be corrupted
C
         CALL ERRLUN( 'LOKLUN', ILUN, LTABER, ' ' )

      ENDIF
C
   10 ILUN = JLUN
C
      RETURN
      END
