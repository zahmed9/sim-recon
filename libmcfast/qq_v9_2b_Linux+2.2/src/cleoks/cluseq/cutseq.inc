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
* Revision 1.1.1.1  1994/10/04 21:54:48  zfiles
* first version of clutil in CVS
*
*
*CMZ :  1.00/05 26/05/89  12.17.37  by  B. Heltsley
* remove TIMEON and TIMEOFF sequences; put in SEQ.CMZ/CLUTIL
*-- Author :    R. Namjoshi   07/02/89
* Offset definitions for the STTI and CUTI banks
*
* STTI bank
*
* OSINTR - Offset to resort interval
* OCSINS - Offset to number of calls since last resort
*
      INTEGER    OSINTR,      OCSINS
      PARAMETER( OSINTR =  1, OCSINS =  2                          )
*
* CUTI Bank
*
* OHNAM1 - Offset to first  part of Hollerith name
* OHNAM2 - Offset to second part of Hollerith name
* ONCALL - Offset to number of calls
* ONIGNO - Offset to number of ignored calls
* OONBIT - Offset to flag marking start/end 1 = started, 0 = ended
* OCMIN  - Offset to CPU min
* OCMAX  - Offset to CPU max
* OCAVG  - Offset to CPU average
* OCTOT  - Offset to CPU total
* OEMIN  - Offset to Elapsed min
* OEMAX  - Offset to Elapsed max
* OEAVG  - Offset to Elapsed average
* OETOT  - Offset to Elapsed total
* OCSTAR - Offset to CPU start time
* OESTAR - Offset to Elapsed start time
*
      INTEGER    OHNAM1,      OHNAM2,      ONCALL,      ONIGNO
      PARAMETER( OHNAM1 =  1, OHNAM2 =  2, ONCALL =  3, ONIGNO =  4 )
      INTEGER    OONBIT
      PARAMETER( OONBIT =  5                                        )
      INTEGER    OCMIN ,      OCMAX ,      OCAVG ,      OCTOT
      PARAMETER( OCMIN  =  6, OCMAX  =  7, OCAVG  =  8, OCTOT  =  9 )
      INTEGER    OEMIN ,      OEMAX ,      OEAVG ,      OETOT
      PARAMETER( OEMIN  = 10, OEMAX  = 11, OEAVG  = 12, OETOT  = 13 )
      INTEGER    OCSTAR,      OESTAR
      PARAMETER( OCSTAR = 14, OESTAR = 15                           )
*
