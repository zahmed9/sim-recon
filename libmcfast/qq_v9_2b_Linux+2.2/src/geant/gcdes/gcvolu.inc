*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:24  eugenio
* Initial revision
*
* Revision 1.2  1994/10/17  16:38:57  lkg
* Changed include statements to use partial path names.
*
* Revision 1.1.1.1  1994/04/05  21:31:34  lkg
* Beta version of GEANT in CLEO CVS format
*
*
*
* gcvolu.inc
*
      COMMON/GCVOLU/NLEVEL,NAMES(15),NUMBER(15),
     +LVOLUM(15),LINDEX(15),INFROM,NLEVMX,NLDEV(15),LINMX(15),
     +GTRAN(3,15),GRMAT(10,15),GONLY(15),GLX(3)
C
#if defined(CLEO_TYPE)
#include "geant/gcdes/gtvolu.inc"
#endif
