*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:50  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:33  zfiles
* first version of qqlib in CVS
*
*
*CMZ :  1.04/00 05/10/94  02.27.49  by  Peter C Kim
*CMZ :          05/10/94  02.18.26  by  Peter C Kim
*>> Author :
*
*  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
*                      QQMISC.INC
*
*              Some variables left behind
*  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
*
#if defined(CLEO_CDGDOC)
*  NEWDEC        Name of user-defined decay file (*.dec)
*  FTAPQQ        Name of ROAR output file (*.rp)
#endif

      CHARACTER NEWDEC*80, FTAPQQ*80
      COMMON /QQMIS1/
     *                 NEWDEC, FTAPQQ
