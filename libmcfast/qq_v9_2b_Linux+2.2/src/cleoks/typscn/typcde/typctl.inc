*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:17  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  18:00:04  nk
* Consolidation
*
* Revision 1.1  1995/07/31 19:38:28  nk
* Added typscn
*
* Revision 1.1.1.1  1994/10/05  13:45:40  zfiles
* first version of typscn in CVS
*
*
*CMZ :  1.00/06 26/02/90  22.33.07  by  Ian C. Brock
*CMZ :  1.00/00 12/05/89  16.46.57  by  Ian C. Brock
*-- Author :
      LOGICAL LASYNC
      LOGICAL LASYIN
      INTEGER NSYMBL
      INTEGER NDELIM
      INTEGER NWTYPE
      INTEGER NCHUSE
      INTEGER ICLIST
      INTEGER NMATCH
      INTEGER IUNACC
      INTEGER IUNTYP
      INTEGER IEVFLG
      INTEGER ICHAN
      INTEGER NDEVBF
C
      COMMON /TYPCTL/ NSYMBL, NDELIM, NWTYPE, NCHUSE,
     1        ICLIST(DIMCLI), NMATCH,
     1        IUNACC, IUNTYP, LASYNC, IEVFLG, ICHAN(10),
     1        LASYIN, NDEVBF
