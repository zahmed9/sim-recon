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
*CMZ :  1.03/20 11/08/91  15.17.01  by  R.A.FULTON
*-- Author :    R.A.FULTON   06/12/90
#if defined(CLEO_CDGDOC)
#endif
C
      LOGICAL WGTSET
      INTEGER ITERS
      DOUBLE PRECISION  WSUM, WSUMSQ, WGTVAL
C
      COMMON/WGTSUM/WSUM,WSUMSQ,WGTVAL,ITERS,WGTSET
      SAVE /WGTSUM/
