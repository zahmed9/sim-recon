*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:14  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  17:59:53  nk
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
      SUBROUTINE CHKLUN( CRNAME )
C.......................................................................
C.
C. CHKLUN - Check integrity of LUN allocation table
C.
C. Inputs    : CRNAME - Character name of owner of lock (GETLUN/FRELUN)
C. Outputs   : None
C.
C. COMMON    : LUNMCI LUNMCI
C. Banks D   : None
C. Banks L   : None
C. Banks M   : None
C. Banks U   : None
C.
C. Calls     : ERRLUN
C. Called    : FRELUN GETLUN
C.
C. Detailed description
C.  This routine checks the integrity of the LUN allocation table. For
C.  each allowed unit number, an INQUIRE is performed to find out if
C.  an OPEN file is connected to the unit. If that is the case but the
C.  allocation table indicates that the unit is free, then the unit
C.  is locked by calling LOKLUN and an error message is logged.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
* -------------------- Argument declarations ---------------
      CHARACTER*(*) CRNAME
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
      LOGICAL LOPEN
* -------------------- SAVE     declarations ---------------
      SAVE RCSINI
* None
* -------------------- DATA  initializations ---------------
      DATA RCSINI/.TRUE./
* None
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
C
C== If a unit is OPEN but table indicates it is free then complain
C
      DO 10 I = LUNMIN, LUNMAX
         INQUIRE( UNIT=I, OPENED=LOPEN )
         IF( LOPEN .AND. LUNTBL(I).EQ.LISFRE ) THEN
            CALL LOKLUN( I, 'LUNMGR' )
            CALL ERRLUN( CRNAME, I, LUALER, ' ' )
         ENDIF
   10 CONTINUE
C
      RETURN
      END
