*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:20  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  18:00:19  nk
* Consolidation
*
* Revision 1.1  1995/07/31 19:42:24  nk
* Added typscn
*
* Revision 1.1.1.1  1994/10/05  13:45:41  zfiles
* first version of typscn in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/10 31/05/91  13.40.09  by  Jon Urheim
*-- add flag for IBM RS6000.
*CMZ :  1.00/03 11/12/89  10.59.31  by  Ian C. Brock
*CMZ :  1.00/01 24/05/89  12.19.08  by  Ian C. Brock
*CMZ :  1.00/00 12/05/89  16.55.34  by  Ian C. Brock
*-- Author :
C
C----------------------------------------------------------------------------
C Input a string into work array if availble
C
      SUBROUTINE GETLIN(LWAIT)
      SAVE
C
#include "cleoks/typscn/typcde/typpar.inc"
#include "cleoks/typscn/typcde/typchr.inc"
#include "cleoks/typscn/typcde/typscn.inc"
#include "cleoks/typscn/typcde/typstr.inc"
#include "cleoks/typscn/typcde/typctl.inc"
C
      LOGICAL LWAIT
C
C
      IF (ICHAR(CONES).EQ.0) THEN
      STOP 'TYPSCN not initialized.  Add CALL TYPINI to main routine'
      END IF
C
      IF (NCHARS.LT.0) THEN
#if defined(CLEO_VAX)||defined(CLEO_IBM)||defined(CLEO_APOLLO)||defined(CLEO_DECS)||defined(CLEO_SGI)||defined(CLEO_RS6000)||defined(CLEO_UNIX)
      IF (LWAIT .OR. IUNACC.NE.5) THEN
#endif
#if defined(CLEO_MAC)
      IF (LWAIT .OR. IUNACC.NE.9) THEN
#endif
C     Synchronous read request - cancel outstanding async (if any)
      IF (IUNACC.EQ.5) CALL ASYNCN
      CALL SYNRD
      ELSE
C     Asynchronous request
      CALL ASYNRD
      CALL ASYNCK
      END IF
      END IF
C
      KPOINT = IPOINT
      KCHARS = NCHARS
      RETURN
      END
