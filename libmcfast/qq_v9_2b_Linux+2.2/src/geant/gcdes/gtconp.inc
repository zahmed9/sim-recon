*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:24  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/04/05  21:31:32  lkg
* Beta version of GEANT in CLEO CVS format
*
*
*
* gtconp.inc
*
#if defined(CLEO_SINGLE)
      REAL          PI,TWOPI,PIBY2,DEGRAD,RADDEG,CLIGHT,BIG,EMASS
      REAL          EMMU,PMASS,AVO
C
#endif
#if !defined(CLEO_SINGLE)
      DOUBLE PRECISION PI,TWOPI,PIBY2,DEGRAD,RADDEG,CLIGHT,BIG,EMASS
      DOUBLE PRECISION EMMU,PMASS,AVO
C
#endif
