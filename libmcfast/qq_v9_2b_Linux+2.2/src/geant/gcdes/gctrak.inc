*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:24  eugenio
* Initial revision
*
* Revision 1.2  1994/10/17  16:38:53  lkg
* Changed include statements to use partial path names.
*
* Revision 1.1.1.1  1994/04/05  21:31:34  lkg
* Beta version of GEANT in CLEO CVS format
*
*
*
* gctrak.inc
*
#if defined(CLEO_TYPE)
#include "geant/gcdes/gttrak.inc"
#endif
      PARAMETER (MAXMEC=30)
      COMMON/GCTRAK/VECT(7),GETOT,GEKIN,VOUT(7),NMEC,LMEC(MAXMEC)
     + ,NAMEC(MAXMEC),NSTEP ,MAXNST,DESTEP,DESTEL,SAFETY,SLENG
     + ,STEP  ,SNEXT ,SFIELD,TOFG  ,GEKRAT,UPWGHT,IGNEXT,INWVOL
     + ,ISTOP ,IGAUTO,IEKBIN, ILOSL, IMULL,INGOTO,NLDOWN,NLEVIN
     + ,NLVSAV,ISTORY
C
