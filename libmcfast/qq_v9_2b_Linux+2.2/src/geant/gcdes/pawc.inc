*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:24  eugenio
* Initial revision
*
* Revision 1.2  1994/10/17  16:38:59  lkg
* Changed include statements to use partial path names.
*
* Revision 1.1.1.1  1994/04/05  21:31:37  lkg
* Beta version of GEANT in CLEO CVS format
*
*
*
* pawc.inc
*
#if defined(CLEO_TYPE)
#include "geant/gcdes/pawct.inc"
#endif
      COMMON /PAWC/ NWPAW,IXPAWC,IHBOOK,IXHIGZ,IXKUIP,IFENCE(5),
     +              LLMAIN, WWS(9989)
      DIMENSION IQQ(2),QQ(2),LQQ(8000)
      EQUIVALENCE (QQ(1),IQQ(1),LQQ(9)),(LQQ(1),LLMAIN)
C
