#include <stdio.h>
#include "alarm.h"

void main(int argc,char **argv)
{
  int msg = 0, limit = 10, i;
  
  eregister("esay","");
  esend_setmode(1);
  if(argc > 1)
    for(i=1; i<argc; i++) {
      sscanf(argv[i],"%i",&msg);
      esay(msg,limit);
    }
}
