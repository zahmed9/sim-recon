*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:24  eugenio
* Initial revision
*
* Revision 1.2  1994/10/17  16:38:55  lkg
* Changed include statements to use partial path names.
*
* Revision 1.1.1.1  1994/04/05  21:31:30  lkg
* Beta version of GEANT in CLEO CVS format
*
*
*
* gcursb.inc
*
      COMMON/GCURSB/NUMNDS,IADDI,NUMND2,NNPAR,IISELT
      COMMON/GCURSC/MOMO
      CHARACTER*4 MOMO
*
#if defined(CLEO_TYPE)
#include "geant/gcdes/gtursb.inc"
#endif
