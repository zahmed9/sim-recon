*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:10  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  17:59:29  nk
* Consolidation
*
* Revision 1.1.1.1  1994/10/04 21:54:49  zfiles
* first version of clutil in CVS
*
*
*CMZ :  1.00/00 17/11/88  13.59.36  by  T. Bowcock
*-- Author :    R. Namjoshi   15/07/88
C
* LUNMIN - Smallest allowed LUN number
* LUNMAX - Largest  allowed LUN number
* MAXLUN - Length of the    LUN number allocation table
*
      INTEGER    LUNMIN,     LUNMAX
      PARAMETER( LUNMIN = 1, LUNMAX = 99 )
*
      INTEGER    MAXLUN
      PARAMETER( MAXLUN = LUNMAX - LUNMIN + 1 )
*
* LISUSE - Flag for LUN is in use  - arbitrary number
* LISFRE - Flag for LUN is free    - arbitrary number
* LISLOK - Flag for LUN is locked  - arbitrary number
*
      INTEGER    LISUSE,     LISFRE,     LISLOK
      PARAMETER( LISUSE = 12131, LISFRE = 14151, LISLOK = 16171 )
*
* LUSEER - Error, LUN in use
* LRNGER - Error, LUN number out of range
* LTABER - Error, LUN allocation table corrupted
* LFULER - Error, LUN allocation table full
* LLOKER - Error, LUN is already locked
* LFLKER - Error, LUN is locked, cannot be freed
* LINIER - Error, in initialization
* LUALER - Error, found unalloacted unit connected to file
* LNONAM - Warning, Allocator name is blank
* LDIFER - Warning, Allocator and deallocator are different
*
      INTEGER    LUSEER,     LRNGER,     LTABER,     LFULER
      PARAMETER( LUSEER = 1, LRNGER = 2, LTABER = 3, LFULER = 4 )
      INTEGER    LLOKER,     LFLKER,     LINIER,     LUALER
      PARAMETER( LLOKER = 5, LFLKER = 6, LINIER = 7, LUALER = 8 )
      INTEGER    LNONAM,     LDIFER
      PARAMETER( LNONAM = 9, LDIFER =10                         )
*
* LUNTBL - The LUN allocation table
* LUNOWN - The LUN allocation owner table
*
      INTEGER         LUNTBL
      COMMON /LUNMCI/ LUNTBL(LUNMIN:LUNMAX)
      CHARACTER*8     LUNOWN
      COMMON /LUNMCC/ LUNOWN(LUNMIN:LUNMAX)
