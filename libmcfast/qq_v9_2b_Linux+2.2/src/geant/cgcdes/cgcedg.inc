*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:22  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/04/05  21:38:30  lkg
* Beta version of GEANT using CLEO CVS system
*
*
*
* cgcedg.inc
*
      PARAMETER (INPART = 30, NTTT = 50)
      COMMON /CGCEDG/ TDEL,NPART,TSTRT(INPART),TEND(INPART),
     +                KX,KY,KZ,NPART2,TSTRT2(INPART),TEND2(INPART),
     +                XA,YA,ZA,XB,YB,ZB,XDELT,YDELT,ZDELT,
     +                ABC(3,2),DEDGE(5),TTT(2,NTTT),ITTT(NTTT)
      REAL AA(3),BB(3),DELTA(3)
      EQUIVALENCE     (AA,XA),(BB,XB),(DELTA,XDELT)
