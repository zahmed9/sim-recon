*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:15  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  17:59:59  nk
* Consolidation
*
* Revision 1.2  1994/10/06 16:46:38  zfiles
* Do not use CALL MESLOG. (RCS keywords will not be printed out.)
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
#if defined(CLEO_CLEVER)
*CMZ :  1.00/30 02/11/90  09.26.53  by  B. Heltsley
* insert select flag
*CMZ :          22/11/89  19.25.42  by  B. Heltsley
* change ITYPE return value
*CMZ :          15/11/89  21.15.52  by  B. Heltsley
* repair behavior on non-event records, change calling sequence
*CMZ :          27/07/89  15.19.52  by  B. Heltsley
* fix to get numbers properly
*CMZ :          03/04/89  14.21.52  by  R. Namjoshi
*-- Author :    R. Namjoshi   18/07/88
      SUBROUTINE MESREV( IRUN, IEVENT, ITYPE )
C.......................................................................
C.
C. MESREV - Returns current run and event #
C.
C. Inputs    : None
C. Outputs   : IRUN   - Current run number
C. Outputs   : IEVENT - Current run number
C. Outputs   : ITYPE  - Current record type
C.
C. COMMON    : None
C. Banks D   : None
C. Banks L   : None
C. Banks M   : None
C. Banks U   : CLEV
C.
C. Calls     : ?
C. Called    : MESCON
C.
C. Version   : 1.00
C. Created   : 08-Nov-88
C.
C. Detailed description
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
* -------------------- Argument declarations ---------------
      INTEGER  IRUN, IEVENT, ITYPE
* -------------------- EXTERNAL declarations ---------------
* None
* -------------------- SEQUENCE declarations ---------------
* None
* -------------------- Local    declarations ---------------
* None
      CHARACTER*(*) CRNAME
      PARAMETER ( CRNAME = 'MESREV' )

      REAL RDUM

* -------------------- SAVE     declarations ---------------
* None
* -------------------- DATA  initializations ---------------
* None
* ----------------- Executable code starts here ------------
C
C== Return run and event number if present
C
*
      CALL CLGHED( 'RUNNUM', CRNAME, IRUN, RDUM )
      CALL CLGHED( 'EVTNUM', CRNAME, IEVENT, RDUM )
      CALL CLGHED( 'DATTYP', CRNAME, ITYPE, RDUM )

      IRUN = MAX ( 0, IRUN )
      IEVENT = MAX ( 0, IEVENT )
      ITYPE = MAX( 0, ITYPE )

      RETURN
      END
#endif
