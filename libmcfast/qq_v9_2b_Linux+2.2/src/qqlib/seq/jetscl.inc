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
*CMZ :  1.03/57 15/02/93  18.24.16  by  Peter C Kim
*CMZ :  1.03/49 21/09/92  14.01.23  by  Peter C Kim
*CMZ :  1.03/36 16/12/91  19.44.27  by  Peter C Kim
*CMZ :  1.03/00 02/04/91  10.06.22  by  Peter C Kim
*CMZ :  1.02/00 12/03/91  11.01.02  by  Peter C Kim
*-- Author :    Peter C Kim   30/01/91
#if defined(CLEO_CDGDOC)
C-------------------------------------------------
C   Control variables for generating LUND events.
C-------------------------------------------------
#endif
      INTEGER MCMODE,NFLAV,LFRAG,IQTYPE,QCDCOR
      INTEGER LUNDEC,ISTRAD,LXEDIT,LNDDMP
      REAL LUNDAA,LUNDBB
      REAL EPSC,EPSB,MSPIN,BSTECM,EMINFX
      CHARACTER LUDTAB*80,CRESON*10

      COMMON /CTLUND/ MCMODE,NFLAV,LFRAG,IQTYPE,QCDCOR,LUNDEC,
     *                LXEDIT,LNDDMP,ISTRAD,LUNDAA,LUNDBB,
     *                EPSC,EPSB,MSPIN(7),BSTECM(6),EMINFX
      COMMON /CTLUNC/ LUDTAB,CRESON
      SAVE /CTLUND/,/CTLUNC/
