#include "string.h"
#include <strstream.h>
#include "ctype.h"
#include "stringMax.hh"
#include "McfUtilities.hh"
void addNull(char *string)
{
    //getting the name from the FORTRAN routine is such a joy!
    for(int i=0; i<MAXSTRING; i++)
    {
      if(isspace(string[i]))
      {
        string[i] = '\0';
        break;
      }
    }
  
}
