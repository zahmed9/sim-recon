*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:23  eugenio
* Initial revision
*
* Revision 1.2  1994/10/17  16:38:34  lkg
* Changed include statements to use partial path names.
*
* Revision 1.1.1.1  1994/04/05  21:31:31  lkg
* Beta version of GEANT in CLEO CVS format
*
*
*
* gcopti.inc
*
      COMMON/GCOPTI/ IOPTIM
C
#if defined(CLEO_TYPE)
#include "geant/gcdes/gtopti.inc"
#endif
