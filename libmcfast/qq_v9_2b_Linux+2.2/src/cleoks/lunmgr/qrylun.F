* Urheim - rename char. strings interpreted as trigraphs by cpp on rs6000.
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
* Revision 1.2  1994/12/06 17:28:48  zfiles
* Change comments for AIX cpp (related trigraph, from J. Urheim)
*
* Revision 1.1.1.1  1994/10/04  21:54:51  zfiles
* first version of clutil in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/00 17/11/88  15.21.09  by  R. Namjoshi
*-- Author :    R. Namjoshi   24/08/88
      SUBROUTINE QRYLUN( ILUN, CUSTAT, COWNER )
C.......................................................................
C.
C. QRYLUN  - Query status of unit ILUN
C.
C. Inputs    : ILUN   - Unit number whose status is sought
C. Outputs   : CUSTAT - Text describing status of ILUN
C.           : COWNER - Owner of the unit if not free
C.
C. COMMON    : LUNMCC LUNMCI
C. Banks D   : None
C. Banks L   : None
C. Banks M   : None
C. Banks U   : None
C.
C. Calls     : INILUN
C. Called    : <USER>
C.
C. Detailed description
C.  This routine can be used to query the status of a particular unit.
C.  The value of CUSTAT is  'FREE' if ILUN is available
C.                          'ALLO' if ILUN is allocated
C.                          'LOCK' if ILUN is locked
#if defined(CLEO_RS6000)
C.                          '?xxx' if ILUN is out of range or the table
#else
C.                          '????' if ILUN is out of range or the table
#endif
C.                                 appears to be corrupted
C.
C.  The value of COWNER is the name of the owner of the allocation or
C.  lock as supplied to GETLUN/LOKLUN. It is blank otherwise.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
* -------------------- Argument declarations ---------------
      INTEGER ILUN
      CHARACTER*(*) CUSTAT, COWNER
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
      INTEGER ISTAT
      LOGICAL LFIRST
* -------------------- SAVE     declarations ---------------
      SAVE RCSINI
      SAVE    LFIRST
* -------------------- DATA  initializations ---------------
      DATA RCSINI/.TRUE./
      DATA    LFIRST /.TRUE./
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
*
      IF( LFIRST ) THEN
         LFIRST = .FALSE.
         CALL INILUN
      ENDIF

#if defined(CLEO_RS6000)
      CUSTAT = '?xxx'
#else
      CUSTAT = '????'
#endif
      COWNER = ' '

      IF( ILUN.LT.LUNMIN .OR. ILUN.GT.LUNMAX ) GOTO 999

      ISTAT = LUNTBL(ILUN)
      IF(     ISTAT.EQ.LISFRE ) THEN
         CUSTAT = 'FREE'
      ELSEIF( ISTAT.EQ.LISUSE ) THEN
         CUSTAT = 'ALLO'
         COWNER = LUNOWN(ILUN)
      ELSEIF( ISTAT.EQ.LISLOK ) THEN
         CUSTAT = 'LOCK'
         COWNER = LUNOWN(ILUN)
      ENDIF
*
      RETURN
  999 END
