*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:17  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  18:00:03  nk
* Consolidation
*
* Revision 1.1  1995/07/31 19:38:23  nk
* Added typscn
*
* Revision 1.1.1.1  1994/10/05  13:45:40  zfiles
* first version of typscn in CVS
*
*
*CMZ :  1.00/08 14/08/90  14.35.15  by  J. D. Lewis
*CMZ :  1.00/08 26/01/90  17.50.27  by  Ian C. Brock
*-- Author :    Ian C. Brock   26/01/90
      INTEGER SMG$CREATE_VIRTUAL_KEYBOARD
      INTEGER SMG$CREATE_KEY_TABLE
      INTEGER KEYB,KEYT
      COMMON /KCVAX/ KEYB,KEYT
      INTEGER SMG$READ_COMPOSED_LINE
      INTEGER SMG$_EOF
      PARAMETER (SMG$_EOF=1213442)
