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
*CMZ :  1.00/00 04/06/90  18.55.55  by  Jorge L. Rodriguez
*-- Author :
C  ---------------------------------------------------------------------
C     CLMCX:MCJET.INC
C  ---------------------------------------------------------------------
#if defined(CLEO_CDGDOC)
C  ICLASS(36)          qqbar class (1-10)
C  PSPIN(10)           Pseudoscalar fraction per cless
C  CMIX1(3,6)          SU(3) mixing for uu, dd, etc
C  CMLT1(5)            1st coefficient in mult. formula
C  CMLT2(5)            2nd coefficient in mult. formula
C  WIDTH(5)            3rd coefficient in mult. formula
#endif

      INTEGER ICLASS
      REAL PSPIN, CMIX1, CMLT1, CMLT2, WIDTH

      COMMON/JET3PA/
     *  ICLASS(36),
     *  PSPIN(10),
     *  CMIX1(3,6),
     *  CMLT1(5),
     *  CMLT2(5),
     *  WIDTH(5)

