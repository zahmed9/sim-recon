*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:23  eugenio
* Initial revision
*
* Revision 1.4  1995/11/29 18:24:05  zfiles
* Increased the size of GCBANK definition for CLEO_HUGM
*
* Revision 1.3  1994/10/17  16:37:58  lkg
* Changed include statements to use partial path names.
*
* Revision 1.2  1994/07/15  02:07:50  lkg
* Incorporated changes from Geant 3.15 94a correction patch
*
* Revision 1.1.1.1  1994/04/05  21:31:30  lkg
* Beta version of GEANT in CLEO CVS format
*
*
*
* gcbank.inc
*
#if defined(CLEO_TYPE)
#include "geant/gcdes/gtbank.inc"
#endif
#if defined(CLEO_HUGM)
      PARAMETER (KWBANK=69000,KWWORK=5200)
      PARAMETER (KDKLAR=3500000-KWBANK-24)
      COMMON/GCBANK/NZEBRA,GVERSN,ZVERSN,IXSTOR,IXDIV,IXCONS,FENDQ(16)
     +             ,LMAIN,LR1,WS(KWBANK),IDKLAR(KDKLAR)
      DIMENSION IQ(3499970),Q(3499970),LQ(3499978),IWS(KWBANK)
      EQUIVALENCE (Q(1),IQ(1),LQ(9)),(LQ(1),LMAIN),(IWS(1),WS(1))
      EQUIVALENCE (JCG,JGSTAT)
#elif defined(CLEO_BIGM)
      PARAMETER (KWBANK=69000,KWWORK=5200)
      PARAMETER (KDKLAR=1920000-KWBANK-24)
      COMMON/GCBANK/NZEBRA,GVERSN,ZVERSN,IXSTOR,IXDIV,IXCONS,FENDQ(16)
     +             ,LMAIN,LR1,WS(KWBANK),IDKLAR(KDKLAR)
      DIMENSION IQ(1919970),Q(1919970),LQ(1919978),IWS(KWBANK)
      EQUIVALENCE (Q(1),IQ(1),LQ(9)),(LQ(1),LMAIN),(IWS(1),WS(1))
      EQUIVALENCE (JCG,JGSTAT)
#else
      PARAMETER (KWBANK=69000,KWWORK=5200)
      COMMON/GCBANK/NZEBRA,GVERSN,ZVERSN,IXSTOR,IXDIV,IXCONS,FENDQ(16)
     +             ,LMAIN,LR1,WS(KWBANK)
      DIMENSION IQ(2),Q(2),LQ(8000),IWS(2)
      EQUIVALENCE (Q(1),IQ(1),LQ(9)),(LQ(1),LMAIN),(IWS(1),WS(1))
      EQUIVALENCE (JCG,JGSTAT)
#endif
#include "geant/gcdes/gclink.inc"
