*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:15  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  17:59:57  nk
* Consolidation
*
* Revision 1.2  1994/10/06 16:46:25  zfiles
* Do not use CALL MESLOG. (RCS keywords will not be printed out.)
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/40 27/08/91  13.27.11  by  C Ray Ng
*CMZ :  1.00/30 07/11/90  13.06.52  by  B. Heltsley
*CMZ :          07/11/90  13.03.30  by  B. Heltsley
* get luns from DRIVER for driver version
*CMZ :          02/11/90  09.16.03  by  B. Heltsley
* make non-clever version
*CMZ :          20/12/89  21.13.46  by  B. Heltsley
* include unit for DECStations (Ray Ng)
*CMZ :          24/07/89  16.05.38  by  B. Heltsley
* break off part that checks for stat div
*CMZ :          21/07/89  16.20.15  by  B. Heltsley
* minimize dependence on bank sequences
*CMZ :          04/04/89  12.07.28  by  R. Namjoshi
*-- Author :    R. Namjoshi   18/07/88
      SUBROUTINE MESINI
C.......................................................................
C.
C. MESINI - Initialize the message logger
C.
C. Inputs    : None
C. Outputs   : None
C.
C. COMMON    :  MESCOM MESLUN
C. Banks D   : None
C. Banks L   : None
C. Banks M   : None
C. Banks U   : CLST
C.
C. Calls     : MESBNK
C. Called    : <USER>
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
* -------------------- Argument declarations ---------------
* None
* -------------------- EXTERNAL declarations ---------------
* None
* -------------------- SEQUENCE declarations ---------------
#include "cleoks/cluseq/mesbuf.inc"
#include "cleoks/cluseq/mescom.inc"
#include "cleoks/cluseq/meslun.inc"
* -------------------- Local    declarations ---------------
      CHARACTER*(*) CMNAME
      PARAMETER(    CMNAME = 'MESINI' )

      INTEGER M1,M2,M3,M4,M5,M6
* -------------------- SAVE     declarations ---------------
* None
* -------------------- DATA  initializations ---------------
* None
* ----------------- Executable code starts here ------------
*
      MSINIT = MSFLAG
C
C== Initialize units
C
      MESLEC = 0

#if defined(CLEO_APOLLO)
      MESLIN = 5
      MESLOU = 7
#endif

#if !defined(CLEO_APOLLO)
      MESLIN = 5
      MESLOU = 6
#endif
#if defined(CLEO_CLEVER)
      CALL MESBNK
#endif
#if !defined(CLEO_CLEVER)
      CALL DVLUNS( M1, M2, M3, M4,M5,M6 )
      IF( M1 .GT. 0 ) MESLIN = M1
      IF( M2 .GT. 0 ) MESLOU = M2
      IF( M3 .GT. 0 ) MESLPT = M3
#endif

      RETURN
      END
