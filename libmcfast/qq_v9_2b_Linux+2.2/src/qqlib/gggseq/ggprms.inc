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
*-- Author :    R.A.FULTON   04/12/90
C.
C.*************************************************************
#if defined(CLEO_CDGDOC)
C. GGPRMS::
C INTERNAL PARAMETERS FOR TWO-PHOTON GENERATOR GGDEPA.
C FILLED IN GGINIT.........   COMMON/GGPRMS/

C PHOTON SPECTRUM PARMS....     EPB1,EPB2,WMN2G,WMX2G,YLTH2G,D2GW
C                                  NSTPSD,XSINT(100)

C TAGGING AND EPA PARMS....     TAGMN,TAGMX,DTAG,D1GTH,D2GTH,DTCNST,
C                                  EPAMAX,NEPAUP,DBTGMN,DBTGMX,
C                                  DT1BGN,DT2BGN

C NORMALIZATION
C  AND EFFICIENCY PARMS.....   ,FACT2G,TRY2G,OK2G,GGAREA,

C GAMMA-GAMMA MASS**2 ......    W2G
C ************************************************************
#endif
      INTEGER NSTPSD,NEPAUP
      REAL    EPB1,EPB2,WMN2G,WMX2G,YLTH2G,D2GW,XSINT
      REAL    TAGMN,TAGMX,DTAG,D1GTH,D2GTH,DTCNST,EPAMAX
      REAL    DBTGMN,DBTGMX,DT1BGN,DT2BGN
      REAL    FACT2G,TRY2G,OK2G,GGAREA,W2G
      COMMON/GGPRMS/
     +     EPB1, EPB2, WMN2G, WMX2G, YLTH2G, D2GW,
     +     NSTPSD, XSINT(100), TAGMN, TAGMX, DTAG,
     +     D1GTH, D2GTH, DTCNST, EPAMAX, NEPAUP,
     +     DBTGMN, DBTGMX, DT1BGN, DT2BGN,
     +     FACT2G, TRY2G, OK2G, GGAREA, W2G
      SAVE /GGPRMS/
