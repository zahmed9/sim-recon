*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:23  eugenio
* Initial revision
*
* Revision 1.2  1994/10/17  16:38:15  lkg
* Changed include statements to use partial path names.
*
* Revision 1.1.1.1  1994/04/05  21:31:35  lkg
* Beta version of GEANT in CLEO CVS format
*
*
*
* gcjump.inc
*
#if defined(CLEO_TYPE)
#include "geant/gcdes/gtjump.inc"
#endif
      PARAMETER    (MAXJMP=30)
      COMMON/GCJUMP/JUDCAY, JUDIGI, JUDTIM, JUFLD , JUHADR, JUIGET,
     +              JUINME, JUINTI, JUKINE, JUNEAR, JUOUT , JUPHAD,
     +              JUSKIP, JUSTEP, JUSWIM, JUTRAK, JUTREV, JUVIEW,
     +              JUPARA
      DIMENSION     JMPADR(MAXJMP)
      EQUIVALENCE  (JMPADR(1), JUDCAY)
*
