*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:10  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  17:59:28  nk
* Consolidation
*
* Revision 1.1.1.1  1994/10/04 21:54:49  zfiles
* first version of clutil in CVS
*
*
*   Parameters defining error/message codes
*
* ddnmsp.inc
*
#if defined(CLEO_DOC)
#include "cleoks/cluseq/ddnmspdo.inc"
#endif
      INTEGER    NOERRS      , NOLNER      , LNTRER      , LNICER
      PARAMETER( NOERRS =   0, NOLNER =  -1, LNTRER =  -2, LNICER =  -3)
      INTEGER    VXFPER      , FNMSER      , FTMSER      , FNTRER
      PARAMETER( VXFPER =  -4, FNMSER =  -5, FTMSER =  -6, FNTRER =  -7)
      INTEGER    FTTRER      , FNICER      , FTICER      , NDCBER
      PARAMETER( FTTRER =  -8, FNICER =  -9, FTICER = -10, NDCBER = -11)
      INTEGER    ASSMSG      , ASSIER      , DEAMSG      , DEASER
      PARAMETER( ASSMSG = -12, ASSIER = -13, DEAMSG = -14, DEASER = -15)
      INTEGER    FTLMSG      , RETERR      , DDCERR      , LNAMSG
      PARAMETER( FTLMSG = -16, RETERR = -17, DDCERR = -18, LNAMSG = -19)
      INTEGER    LLSMSG      , NODDMS
      PARAMETER( LLSMSG = -20, NODDMS =  20                            )
* Message log levels
      INTEGER         ICLOGL, LOGLMS
      COMMON /DDLOGC/ ICLOGL, LOGLMS(NODDMS)
*
