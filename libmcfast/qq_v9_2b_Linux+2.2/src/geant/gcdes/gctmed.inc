*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:24  eugenio
* Initial revision
*
* Revision 1.2  1994/10/17  16:38:51  lkg
* Changed include statements to use partial path names.
*
* Revision 1.1.1.1  1994/04/05  21:31:34  lkg
* Beta version of GEANT in CLEO CVS format
*
*
*
* gctmed.inc
*
      COMMON/GCTMED/NUMED,NATMED(5),ISVOL,IFIELD,FIELDM,TMAXFD,STEMAX
     +      ,DEEMAX,EPSIL,STMIN,CFIELD,PREC,IUPD,ISTPAR,NUMOLD
C
#if defined(CLEO_TYPE)
#include "geant/gcdes/gttmed.inc"
#endif
