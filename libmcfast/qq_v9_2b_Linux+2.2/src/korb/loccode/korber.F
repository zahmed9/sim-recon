*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:28  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:01  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.02/00 23/12/90  00.00.00  by  Alan Weinstein
*-- Author :    Alan Weinstein  23/12/90
      SUBROUTINE KORBER
C.......................................................................
C.
C. KORBER - call KORALB(1) to give final printout.
C.
C. Inputs    : None
C.           :
C. Outputs   : None
C.
C. COMMON    :
C.
C. Calls     : KORALB(1)
C. Called    : by ANAL5, at present.
C. Author    : Alan Weinstein 23/12/90
C.
C. Detailed description
C.   Call KORALB(1) to get final printout.
C.......................................................................
*SELF,IF=TYPECHEK.
      IMPLICIT NONE
*SELF.
* -------------------- Argument declarations ---------------
 
* -------------------- EXTERNAL declarations ---------------
*
* -------------------- SEQUENCE declarations ---------------
*
* -------------------- Local    declarations ---------------
*
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'KORBER' )
*
      REAL PB1(4),PB2(4),XPR(40),E1(3),E2(3)
      INTEGER NPR(40)
*
* -------------------- SAVE     declarations ---------------
*
* -------------------- DATA  initializations ---------------
*
* ----------------- Executable code starts here ------------
*
C POSTGENERATION, PRINTOUTS
      CALL KORALB( 1,0,PB1,E1,0,PB2,E2,XPR,NPR)
C     *****************************************
C
      RETURN
      END
