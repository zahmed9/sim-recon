/*======================================================================

Checks if there is a completed type-in entry in the standard input
device. If something has been typed in (*bytes > 0) then a Fortran
read can be done on unit 5.

======================================================================*/

#include <sgtty.h>

int cmd_asynck_(bytes)
     int *bytes;
{
  int res;

  /* check standard input device byte count */
  res = ioctl(0,FIONREAD,bytes);
  if (*bytes <= 0) *bytes = -1;

  return res;
}

