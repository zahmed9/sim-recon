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
*-- Author :    R.A.FULTON   11/12/90
* 17/10/96 Lynn Garren: Add double precision conditionals.

#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION  XINT, FRACQ, XLWR, ARG1, ARG2, ARGM
      DOUBLE PRECISION  BETAQ, BETAPT
      DOUBLE PRECISION  WXCHK, XCHKV, QQ1LB, QQ2LB
#else
      REAL  XINT, FRACQ, XLWR, ARG1, ARG2, ARGM, BETAQ, BETAPT
      REAL  WXCHK, XCHKV, QQ1LB, QQ2LB
#endif

        COMMON/GGJWGT/XINT(100,4),FRACQ(4),XLWR(4),ARG1,ARG2,ARGM,
     +  BETAQ,BETAPT,WXCHK(100,4),XCHKV(100,4),QQ1LB,QQ2LB
        SAVE /GGJWGT/
