*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:23  eugenio
* Initial revision
*
* Revision 1.2  1994/10/17  16:38:28  lkg
* Changed include statements to use partial path names.
*
* Revision 1.1.1.1  1994/04/05  21:31:32  lkg
* Beta version of GEANT in CLEO CVS format
*
*
*
* gcnum.inc
*
      COMMON/GCNUM/NMATE ,NVOLUM,NROTM,NTMED,NTMULT,NTRACK,NPART
     +            ,NSTMAX,NVERTX,NHEAD,NBIT
      COMMON /GCNUMX/ NALIVE,NTMSTO
C
#if defined(CLEO_TYPE)
#include "geant/gcdes/gtnum.inc"
#endif
