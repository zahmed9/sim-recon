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
*CMZ :  1.03/31 22/11/91  13.35.07  by  B. Heltsley
************
      DOUBLE PRECISION  P1BH,P2BH,Q1BH,Q2BH,PHOTBH
      INTEGER                                             NPHOBH
      COMMON / MOMSET / P1BH(4),Q1BH(4),P2BH(4),Q2BH(4),
     *                                      PHOTBH(100,4),NPHOBH
      SAVE   / MOMSET /

      INTEGER           NINPBH, NOUTBH, NOU2BH
      COMMON / INOUT  / NINPBH, NOUTBH, NOU2BH
      SAVE   / INOUT  /

      INTEGER           NPARBH
      DOUBLE PRECISION                 XPARBH
      COMMON / BHLUSQ / NPARBH( 100 ), XPARBH( 100 )
      SAVE   / BHLUSQ /
************
