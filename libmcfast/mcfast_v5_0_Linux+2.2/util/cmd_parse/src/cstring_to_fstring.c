/*======================================================================

Converts a C type string to a Fortran string. Blank fill the Fortran
string if the C string is shorter.

======================================================================*/

#include <stdlib.h>
#include <stdio.h>

void cstring_to_fstring_(char *cstring, char *fstring, int len)
{
  int i, j;

  for (i=0; i<len && cstring[i]; i++) fstring[i] = cstring[i];
  for (j=i; j<len; j++) fstring[j] = ' ';
}
