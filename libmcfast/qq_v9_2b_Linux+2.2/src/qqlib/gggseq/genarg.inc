*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:37  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:35  zfiles
* first version of qqlib in CVS
*
*
*CMZ :  1.03/15 25/04/91  18.23.45  by  R.A.FULTON
*-- Author :    R.A.FULTON   30/03/91
* 16/10/96 Lynn Garren:  Add double precision conditionals.
#if defined(CLEO_CDGDOC)
C..............subroutine arguements
C..E14V    - 4-vector of 1st scattered electron
C..E24V    - 4-vector of 2nd scattered electron
C..G14V    - 4-vector of 1st initial photon
C..G24V    - 4-vector of 2nd initial photon
C..IC1     - charge of E14V
C..IC2     - charge of E24V
C..THPNT   - THPNT give the direction of the positive-charge particle
C            w.r.t. the gamma1 direction in the gamma-gamma CM system
C..PHIPNT  - THPNT give the direction of the positive-charge particle
C            w.r.t. the gamma1 direction in the gamma-gamma CM system
#endif
      INTEGER   IC1, IC2
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION E14V, E24V, G14V, G24V
      REAL      THPNT, PHIPNT
#else
      REAL      E14V, E24V, G14V, G24V, THPNT, PHIPNT
#endif
      COMMON/GENARG/IC1, IC2, E14V(4), E24V(4), G14V(4),
     +              G24V(4), THPNT, PHIPNT
      SAVE /GENARG/
