*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:50  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:32  zfiles
* first version of qqlib in CVS
*
*
*CMZ :  1.02/00 12/03/91  11.00.37  by  Peter C Kim
*-- Author :    Peter C Kim   25/02/91
#if defined(CLEO_CDGDOC)
C---------------------------------------------------------------
C   Variables for the KORALB
C
C---------------------------------------------------------------
#endif
      INTEGER KSPIN,ITFIN,KEYGSW,KEYRAD,ITDKRC
      REAL KORBE1,KORBE2,SINW2,KORBGV,KORBGA,KORXK0

      COMMON/KORPAR/ KSPIN,ITFIN,KEYGSW,KEYRAD,ITDKRC,
     *               KORBE1(3),KORBE2(3),SINW2,KORBGV,KORBGA,KORXK0
      SAVE /KORPAR/
