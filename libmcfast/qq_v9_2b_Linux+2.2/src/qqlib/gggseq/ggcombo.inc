*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:37  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:36  zfiles
* first version of qqlib in CVS
*
*
*CMZ :  1.03/15 25/04/91  18.23.44  by  R.A.FULTON
*-- Author :    R.A.FULTON   14/12/90

      INTEGER    COMBS
      REAL       FRMODS, FRTYPE
      LOGICAL    EVTYPE

      COMMON/GGCOMB/FRMODS(3),COMBS(3),EVTYPE(3), FRTYPE(4,3)
      SAVE /GGCOMB/
C************************************************************

