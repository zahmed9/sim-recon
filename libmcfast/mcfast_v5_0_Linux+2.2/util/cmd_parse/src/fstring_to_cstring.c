/*======================================================================

Converts a Fortran type string to a C string

======================================================================*/

#include <stdlib.h>
#include <stdio.h>

void fstring_to_cstring_(char *fstring, char *cstring, int len)
{
  int i;

  cstring = (char *) malloc(len+1);
  for (i=0; i<len; i++) cstring[i] = fstring[i];
  cstring[len] = NULL;
}
