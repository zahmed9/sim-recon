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
*CMZ :  2.00/05 21/10/93  17.43.04  by  Alan Weinstein
*-- Author :
* 15/10/96 Lynn Garren: Add double precision conditionals.
      SUBROUTINE PHOENE(MPASQR,MCHREN,BETA,IDENT)
C.----------------------------------------------------------------------
C.
C.    PHOTOS:   PHOton radiation in decays calculation  of photon ENErgy
C.              fraction
C.
C.    Purpose:  Subroutine  returns  photon  energy fraction (in (parent
C.              mass)/2 units) for the decay bremsstrahlung.
C.
C.    Input Parameters:  MPASQR:  Mass of decaying system squared,
C.                       XPHCUT:  Minimum energy fraction of photon,
C.                       XPHMAX:  Maximum energy fraction of photon.
C.
C.    Output Parameter:  MCHREN:  Renormalised mass squared,
C.                       BETA:    Beta factor due to renormalisation,
C.                       XPHOTO:  Photon energy fraction,
C.                       XF:      Correction factor for PHOFAC.
C.
C.    Author(s):  S. Jadach, Z. Was               Created at:  01/01/89
C.                B. van Eijk                     Last Update: 26/03/93
C.
C.----------------------------------------------------------------------
C--   IMPLICIT NONE
      DOUBLE PRECISION MPASQR,MCHREN,BIGLOG,BETA,DATA
      INTEGER IWT1,IRN,IWT2
      REAL PRSOFT,PRHARD,PHORAN,PHOFAC
      DOUBLE PRECISION MCHSQR,MNESQR
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION PNEUTR
#else
      REAL PNEUTR
#endif
      INTEGER IDENT
      REAL PHOCHA
      COMMON/PHOMOM/MCHSQR,MNESQR,PNEUTR(5)
      DOUBLE PRECISION COSTHG,SINTHG
      REAL XPHMAX,XPHOTO
      COMMON/PHOPHS/XPHMAX,XPHOTO,COSTHG,SINTHG
      REAL ALPHA,XPHCUT
      COMMON/PHOCOP/ALPHA,XPHCUT
      REAL PI,TWOPI
      COMMON/PHPICO/PI,TWOPI
      INTEGER IREP
      REAL PROBH,CORWT,XF
      COMMON/PHOPRO/IREP,PROBH,CORWT,XF
      LOGICAL INTERF,ISEC,IFTOP
      REAL FINT,FSEC
      COMMON /PHOKEY/ INTERF,FINT,ISEC,FSEC,IFTOP
C--
      IF (XPHMAX.LE.XPHCUT) THEN
        XPHOTO=0.0
        RETURN
      ENDIF
C--   Probabilities for hard and soft bremstrahlung...
      MCHREN=4.*MCHSQR/MPASQR/(1.+MCHSQR/MPASQR)**2
      BETA=SQRT(1.-MCHREN)
      BIGLOG=LOG(MPASQR/MCHSQR*(1.+BETA)**2/4.*(1.+MCHSQR/MPASQR)**2)
      PRHARD=ALPHA/PI/BETA*BIGLOG*(LOG(XPHMAX/XPHCUT)-.75+XPHCUT/
     &XPHMAX-.25*XPHCUT**2/XPHMAX**2)
      PRHARD=PRHARD*PHOCHA(IDENT)**2*FINT*FSEC
      IF (IREP.EQ.0) PROBH=0.
      PRHARD=PRHARD*PHOFAC(0)
      PROBH=PRHARD
      PRSOFT=1.-PRHARD
C--
C--   Check on kinematical bounds
      IF (PRSOFT.LT.0.1) THEN
        DATA=PRSOFT
        CALL PHOERR(2,'PHOENE',DATA)
      ENDIF
      IF (PHORAN(IWT1).LT.PRSOFT) THEN
C--
C--   No photon... (ie. photon too soft)
        XPHOTO=0.
      ELSE
C--
C--   Hard  photon... (ie.  photon  hard enough).
C--   Calculate  Altarelli-Parisi Kernel
   10   XPHOTO=EXP(PHORAN(IRN)*LOG(XPHCUT/XPHMAX))
        XPHOTO=XPHOTO*XPHMAX
        IF (PHORAN(IWT2).GT.((1.+(1.-XPHOTO/XPHMAX)**2)/2.)) GOTO 10
      ENDIF
C--
C--   Calculate parameter for PHOFAC function
      XF=4.*MCHSQR*MPASQR/(MPASQR+MCHSQR-MNESQR)**2
      RETURN
      END
