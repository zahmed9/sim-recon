#include "McfMainMenu.hh"
#include <string.h>
main(int argc, char **argv)
{  
char *filename = NULL;
   if(argc>1)
   {
     filename = argv[1];
   }
   McfMainMenu::McfGetStarted(filename);
}
