*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:33  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:35  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.03/15 11/03/91  11.40.13  by  R.A.FULTON
*-- Author :
      SUBROUTINE BREWIG(XM2,QR,JR,XMRS2G,WMRS2G,XMCH1,XMCH2,FGVAL,XNORM)
C**********************************************************************
C BREIT-WIGNER GENERATION...SEE GGINIT FOR DESCRIPTION
C**********************************************************************
      INTEGER   JR
      REAL      XM2, QR, XMRS2G, WMRS2G
      REAL      XMCH1, XMCH2, FGVAL, XNORM

      REAL      FGRES, XM, Z, DL, WIMVAR, XMRES2, XNORES
      REAL      QSTAR
      EXTERNAL  QSTAR

      FGRES  = FGVAL
      XM     = SQRT(XM2)
      QR     = QSTAR(XM,XMCH1,XMCH2)
      FGVAL  = 1.
      XNORM  = 1.

      IF(WMRS2G.LT.0.0001) RETURN
      Z      = (5.*QR)**2
      DL     = 1.

      IF(JR.EQ.1) DL=1.+Z
      IF(JR.EQ.2) DL=9.+3.*Z+Z**2

      FGVAL  = (QR**(2*JR+1))/(DL*(XM+XMRS2G))
      WIMVAR = WMRS2G*FGVAL/FGRES
      XMRES2 = XMRS2G**2
      XNORM  = WIMVAR/((XM2-XMRES2)**2+WIMVAR**2)
      XNORES = WMRS2G/((XM2-XMRES2)**2+WMRS2G**2)
      XNORM  = XNORM/XNORES

      RETURN
      END
