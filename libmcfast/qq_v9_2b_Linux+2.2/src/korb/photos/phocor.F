*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:29  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:06  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/07 30/01/94  16.25.01  by  Alan J. Weinstein
* Protect BETA=SQRT.
*CMZ :  2.00/05 21/10/93  17.43.05  by  Alan Weinstein
*-- Author :
* 15/10/96 Lynn Garren: Add double precision conditionals.
      FUNCTION PHOCOR(MPASQR,MCHREN,ME)
C.----------------------------------------------------------------------
C.
C.    PHOTOS:   PHOton radiation in decays CORrection weight from
C.              matrix elements
C.
C.    Purpose:  Calculate  photon  angle.  The reshaping functions  will
C.              have  to  depend  on the spin S of the charged particle.
C.              We define:  ME = 2 * S + 1 !
C.
C.    Input Parameters:  MPASQR:  Parent mass squared,
C.                       MCHREN:  Renormalised mass of charged system,
C.                       ME:      2 * spin + 1 determines matrix element
C.
C.    Output Parameter:  Function value.
C.
C.    Author(s):  Z. Was, B. van Eijk             Created at:  26/11/89
C.                                                Last Update: 21/03/93
C.
C.----------------------------------------------------------------------
C--   IMPLICIT NONE
      DOUBLE PRECISION MPASQR,MCHREN,BETA,XX,YY,DATA
      INTEGER ME
      REAL PHOCOR,PHOFAC,WT1,WT2,WT3
      DOUBLE PRECISION MCHSQR,MNESQR
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION PNEUTR
#else
      REAL PNEUTR
#endif
      COMMON/PHOMOM/MCHSQR,MNESQR,PNEUTR(5)
      DOUBLE PRECISION COSTHG,SINTHG
      REAL XPHMAX,XPHOTO
      COMMON/PHOPHS/XPHMAX,XPHOTO,COSTHG,SINTHG
      INTEGER IREP
      REAL PROBH,CORWT,XF
      COMMON/PHOPRO/IREP,PROBH,CORWT,XF
C--
C--   Shaping (modified by ZW)...
      XX=4.*MCHSQR/MPASQR*(1.-XPHOTO)/(1.-XPHOTO+(MCHSQR-MNESQR)/
     &MPASQR)**2
      IF (ME.EQ.1) THEN
        YY=1.
        WT3=(1.-XPHOTO/XPHMAX)/((1.+(1.-XPHOTO/XPHMAX)**2)/2.)
      ELSEIF (ME.EQ.2) THEN
        YY=0.5*(1.-XPHOTO/XPHMAX+1./(1.-XPHOTO/XPHMAX))
        WT3=1.
      ELSEIF ((ME.EQ.3).OR.(ME.EQ.4).OR.(ME.EQ.5)) THEN
        YY=1.
        WT3=(1.+(1.-XPHOTO/XPHMAX)**2-(XPHOTO/XPHMAX)**3)/(1.+(1.
     &  -XPHOTO/XPHMAX)** 2)
      ELSE
        DATA=(ME-1.)/2.
        CALL PHOERR(6,'PHOCOR',DATA)
        YY=1.
        WT3=1.
      ENDIF
CAJWMOD:      BETA=SQRT(1.-XX)
      BETA=SQRT(MAX(1.-XX,0.D0))
      WT1=(1.-COSTHG*SQRT(1.-MCHREN))/(1.-COSTHG*BETA)
      WT2=(1.-XX/YY/(1.-BETA**2*COSTHG**2))*(1.+COSTHG*BETA)/2.
      WT2=WT2*PHOFAC(1)
      PHOCOR=WT1*WT2*WT3
      CORWT=PHOCOR
      IF (PHOCOR.GT.1.) THEN
        DATA=PHOCOR
        CALL PHOERR(3,'PHOCOR',DATA)
      ENDIF
      RETURN
      END
