*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:43  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:27  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 16/09/94  02.26.56  by  Paul Avery
*CMZ :  1.03/40 10/02/92  10.14.29  by  Peter C Kim
*CMZ :  1.01/00 16/09/90  15.24.19  by  Paul Avery
*CMZ :  1.00/00 24/08/90  15.55.07  by  Paul Avery
*CMZ :          21/05/90  15.49.14  by  Jon Urheim
*-- declare local variables, deflexify, adapt to CLEO II software specs
*CMZ :          20/05/90  13.38.50  by  Jorge L. Rodriguez
*CMZ :          19/05/90  15.07.54  by  Jorge L. Rodriguez
      SUBROUTINE QQBGRN

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C   Monte Carlo Generator for begin run
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      CHARACTER*(*)  CRNAME
      PARAMETER( CRNAME = 'QQBGRN' )

C--- Initialize ROAR field flags.

      CALL CLRWPK(-1,0,0,0,.FALSE.,0,0,0,CRNAME,0)

C     Only exit
1000  CONTINUE
      RETURN
      END
