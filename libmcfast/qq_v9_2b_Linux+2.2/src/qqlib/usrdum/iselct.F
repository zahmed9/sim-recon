*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:51  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:31  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.03/35 06/12/91  15.27.26  by  Peter C Kim
*CMZ :  1.01/00 22/09/90  10.19.26  by  Paul Avery
*CMZ :  1.00/00 08/08/90  11.01.55  by  Paul Avery
*CMZ :          19/05/90  14.41.36  by  Jorge L. Rodriguez
*>> Author :
      LOGICAL FUNCTION ISELCT(I)

#include "qqlib/seq/qqluns.inc"

      INTEGER I
      ISELCT=.TRUE.

C   Tell the user that even though you set LSELCT = .TRUE.,
C   you forgot to provide the ISELCT function.

      WRITE(LTTOQQ,101)
      WRITE(LTTOQQ,102)
 101  FORMAT(/,'  *** You did not provide ISELCT funciton! ***')
 102  FORMAT(/,'  *** All events are accepted by default.  ***')

      RETURN
      END
