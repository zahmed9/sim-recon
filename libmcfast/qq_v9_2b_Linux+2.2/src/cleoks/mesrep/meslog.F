*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:15  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  17:59:58  nk
* Consolidation
*
* Revision 1.2  1994/10/06 16:46:30  zfiles
* Do not use CALL MESLOG. (RCS keywords will not be printed out.)
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/30 07/11/90  10.21.37  by  B. Heltsley
* elim namec8 call; put in select flag
*CMZ :          25/07/89  09.34.10  by  B. Heltsley
* add call to check if stat div exists yet
*CMZ :          07/04/89  09.36.50  by  R. Namjoshi
*-- Author :    R. Namjoshi   18/07/88
      SUBROUTINE MESLOG( CRNAME, IMES, CSEVER )
C.......................................................................
C.
C. MESLOG - Log a message
C.
C. Inputs    : CRNAME - Name of calling routine
C.           : IERR   - Message number
C.           : CSEVER - Severity
C. Outputs   : None
C.
C. COMMON    : MESBUF MESREP
C. Calls     : LENOCC MESCKS MESPRO SPACES CLTOU MESBNK
C. Called    : <USER>
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
* -------------------- Argument declarations ---------------
      CHARACTER*(*) CRNAME, CSEVER
      INTEGER IMES
* -------------------- EXTERNAL declarations ---------------
      CHARACTER*8 SPACES
      EXTERNAL    SPACES
      INTEGER  LENOCC, MESCKS
      EXTERNAL LENOCC, MESCKS
* -------------------- SEQUENCE declarations ---------------
#include "cleoks/cluseq/mescom.inc"
#include "seq/clutil/mesrep.inc"
#include "cleoks/cluseq/mesbuf.inc"
#include "seq/zfiles/quest.inc"
* -------------------- Local    declarations ---------------
      CHARACTER*(*) MRNAME
      PARAMETER(    MRNAME = 'MESLOG' )
      CHARACTER*132 CMSAVE
      CHARACTER*8   FRNAME
      INTEGER       ISEVER
* -------------------- SAVE     declarations ---------------
* None
* -------------------- DATA  initializations ---------------
* None
* ----------------- Executable code starts here ------------
C
C== Initialize if not already done
C
      IF( MSINIT.NE.MSFLAG ) CALL MESINI

#if defined(CLEO_CLEVER)
      IF( .NOT. MSCLOG ) CALL MESBNK
#endif
C
C== Format name
C
      FRNAME = SPACES( CRNAME, 0 )
      CALL CLTOU( FRNAME )
C
C== Check valid severity, Call MESPRO to do the work
C
      ISEVER = MESCKS( CSEVER )
      IF( ISEVER.LT.1 ) THEN
C
C== Unknown severity messages are changed to MSINFO
C
         CMSAVE = CHMESS
         WRITE(CHMESS,10000) FRNAME(1:LENOCC(FRNAME)), MSINFO
         CALL MESPRO( MRNAME, 1, MESCKS(MSERRO) )

         CHMESS = CMSAVE
         CALL MESPRO( FRNAME, IMES, MESCKS(MSINFO) )

      ELSE

         CALL MESPRO( FRNAME, IMES, ISEVER )

      ENDIF
C
C== Explicitly clear IQUEST
C
      IQUEST(1) = 0
C
      RETURN
*
10000 FORMAT(' Unknown severity message issued by ', A,
     +       ' changed to severity ', A )
      END
