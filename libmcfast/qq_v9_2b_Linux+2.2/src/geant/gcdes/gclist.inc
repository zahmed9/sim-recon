*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:23  eugenio
* Initial revision
*
* Revision 1.2  1994/10/17  16:38:23  lkg
* Changed include statements to use partial path names.
*
* Revision 1.1.1.1  1994/04/05  21:31:31  lkg
* Beta version of GEANT in CLEO CVS format
*
*
*
* gclist.inc
*
      COMMON/GCLIST/NHSTA,NGET ,NSAVE,NSETS,NPRIN,NGEOM,NVIEW,NPLOT
     +       ,NSTAT,LHSTA(20),LGET (20),LSAVE(20),LSETS(20),LPRIN(20)
     +             ,LGEOM(20),LVIEW(20),LPLOT(20),LSTAT(20)
C
#if defined(CLEO_TYPE)
#include "geant/gcdes/gtlist.inc"
#endif
