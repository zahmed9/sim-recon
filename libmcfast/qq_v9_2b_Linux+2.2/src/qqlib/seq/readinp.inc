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
*CMZ :  1.04/00 21/09/94  22.57.56  by  Paul Avery
*CMZ :  1.01/00 03/11/90  17.38.25  by  Paul Avery
*-- Author :
#if defined(CLEO_CDGDOC)
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C    Contains information needed to read in decay information from decay
C    files.
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#endif

      INTEGER MLUNS, MPRB, MHEL
      PARAMETER (MLUNS = 10, MPRB = 10, MHEL = 10)

      INTEGER DELIM, ICMD, ILUN, LUN, LUNS, NLIST, LIST, NREAD
      INTEGER NDECAY, IDECAY, NCHAN, NCHNCP, NPRB, NHEL
      LOGICAL LERROR, LCPEIG, LCPTG
      REAL ANGS, ANGH, PROBH, HEL, SINPHI
      CHARACTER STRING*100, CHR*1, CFILE*80, CMD*20, CLIST*10, CTEMP*10
      CHARACTER CNAME*10
C
      COMMON /QQRED1/ DELIM, ICMD, ILUN, LUN, LUNS(MLUNS),
     *    NLIST, LIST(20), NREAD, LERROR,
     *    NDECAY, IDECAY, NCHAN, NCHNCP, LCPEIG, LCPTG,
     *    ANGS(7), NHEL, ANGH(8,MHEL),
     *    NPRB, PROBH(MPRB), HEL(20,MPRB), SINPHI
      REAL XLIST(20)
      EQUIVALENCE (LIST, XLIST)

      COMMON /QQRED2/ STRING, CHR, CFILE, CMD, CLIST(20), CTEMP(20),
     *                CNAME
