/* */
/* $Id$ */
/* */
/* $Log$
 * Revision 1.1  2000/06/19 20:00:20  eugenio
 * Initial revision
 *
 * Revision 1.1.1.1  1995/08/01  18:00:18  nk
 * Consolidation
 *
 * Revision 1.1  1995/07/31 19:41:27  nk
 * Added typscn
 *
 * Revision 1.1.1.1  1994/10/05  13:45:42  zfiles
 * first version of typscn in CVS
 * */
/* */
#include "sys/CLEO_machine_c.h"
#include "pilot_c.h"
/*CMZ :  1.00/10 27/08/91  19.53.12  by  Jon Urheim */
/*-- put in T=XCC. qualifier on +DECK card to facillitate compilation */
/*CMZ :  1.00/06 26/07/90  15.28.55  by  J. D. Lewis */
/*-- Author :    J. D. Lewis   26/07/90 */
/*======================================================================

TYPSCN routine to check if there is a completed type-in entry in the
standard input device.  Asynchronous read routine checks to decide
whether to do a FORTRAN read from unit 5.

======================================================================*/

#include <sgtty.h>

void asynck_c_(bytes)
     int *bytes;
{
  int res;

  /* check standard input device byte count */
  res = ioctl(0,FIONREAD,bytes);
  if (*bytes <= 0) *bytes = -1;

  return;
}
