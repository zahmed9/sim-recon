*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:23  eugenio
* Initial revision
*
* Revision 1.2  1994/10/17  16:38:36  lkg
* Changed include statements to use partial path names.
*
* Revision 1.1.1.1  1994/04/05  21:31:35  lkg
* Beta version of GEANT in CLEO CVS format
*
*
*
* gcpara.inc
*
#include "geant/gcdes/gtpara.inc"
      PARAMETER (LSTACK = 5000)
C     BITPOT is for Phi.Or.Tet
C
C ---------------------------------------------------------
      COMMON    /GCPARA/
     +                   EPSIX0 (LSTACK)       ,
     +                   IDRPHI (LSTACK     )  , IDRTET (LSTACK     ),
     +                   IDROUT (LSTACK     )  , JPLOST (LSTACK     ),
     +                   IPHTMP (LSTACK     )  ,
     +                   BITPHI (LSTACK     )  , BITTET (LSTACK     ),
     +                   BITPOT (LSTACK     )  , JJLOST, JJFILL,
     +                                           JENTRY, JEMPTY,
     +                                           EPSMAX,
     +                   JJTEMP, JJWORK        , JJSTK1,
     +                   J1TEMP,                 J1STK1,
     +                   IFOUNP, IFOUNT        , IFNPOT,
     +                                           SYMPHI,
     +                   SYMTEU, SYMTED
C
