*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:22  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/04/05  21:38:31  lkg
* Beta version of GEANT using CLEO CVS system
*
*
*
* cgcfac.inc
*
      PARAMETER (LABC=1500)
      COMMON /CGCFAC/ F1(LABC),F2(LABC),F3(LABC),RFMIN(3),RFMAX(3),
     +                AABCD(4),DRFACE(5)
