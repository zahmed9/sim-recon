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
#if defined(CLEO_CDGDOC)
C********************************************************
C GAMMA-GAMMA CMS VARIABLES PRODUCED IN GGGEN,EPALUM
C          T1,T2   = ELECTRON ANGLES
C          EPS       = FACTION :LT/TT
C          ANGUNT    = MAXIMUM UNTAGGED ANGLE
C          TMNLAB    = ORIGINAL LAB MINIMUM TAGGING ANGLE
C          EPAUPS    = MAX GG WEIGHT SO FAR
C          T1MIN     = MIN ACCEPTED TAG ANGLE SO FAR
C          T2MAX     = MAX ACCEPTED UNTAGGED ANGLE SO FAR
C          WGTCOR    = CORRECTION OF MASS GEN.
C************************************************************
#endif
      INTEGER    IQRK,NUMQRK
      REAL       T1,T2,EPS1,EPS2,EPS3,EPS4,EPS5,EPS6,EPS7,
     +            TTSUM,LTSUM,TLSUM,SSSUM,ANGUNT,
     +            EPAUPS,T1MIN,T2MAX,T3MIN,T3MAX,
     +            WGTCOR,STBEGN,DTAG1,
     +            SSQMN,SSQMX,
     +            QRKM,LMSBSQ,XSMIN,XSMAX

      COMMON/SINTAG/T1,T2,EPS1,EPS2,EPS3,EPS4,EPS5,EPS6,EPS7,
     +                TTSUM,LTSUM,TLSUM,SSSUM,ANGUNT,
     +                EPAUPS,T1MIN,T2MAX,T3MIN,T3MAX,
     +                WGTCOR,STBEGN,DTAG1,
     +                SSQMN,SSQMX,
     +                QRKM,IQRK,NUMQRK,LMSBSQ,XSMIN,XSMAX
      SAVE /SINTAG/

