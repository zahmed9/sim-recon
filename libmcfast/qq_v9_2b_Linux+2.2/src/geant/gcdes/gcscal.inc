*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:23  eugenio
* Initial revision
*
* Revision 1.2  1994/10/17  16:38:42  lkg
* Changed include statements to use partial path names.
*
* Revision 1.1.1.1  1994/04/05  21:31:35  lkg
* Beta version of GEANT in CLEO CVS format
*
*
*
* gcscal.inc
*
#if defined(CLEO_TYPE)
#include "geant/gcdes/gtscal.inc"
#endif
      PARAMETER(MXSLNK=100)
      COMMON/GCSCAL/ ISLINK(MXSLNK)
      EQUIVALENCE (LSLAST,ISLINK(MXSLNK))
      EQUIVALENCE (LSCAN ,ISLINK(1)),(LSTEMP,ISLINK(2))
      EQUIVALENCE (LSPARA,ISLINK(3)),(LSERAY,ISLINK(4))
*
