*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:34  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:29  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/00 04/06/90  18.55.45  by  Jorge L. Rodriguez
*-- Author :
C   06/04/83            MEMBER NAME  VIRSOF   (S)           FORTRAN

      SUBROUTINE VIRSOF(EB,XK0,OMX,BORN,CORR,CORR3)
C-------------------------------------------- REMARKS -----------------
C BHABHA SCATTERING DIFFERENTIAL CROSS SECTION WITH CORRECTIONS:
C 1) SELF-ENERGY DIAGRAMS FOR IN- AND OUTGOING LEPTONS;
C 2) VERTEX CORRECTION DIAGRAMS;
C 3) BOX DIAGRAMS (TWO-PHOTON EXCHANGE);
C 4) SOFT BREMSSTRAHLUNG (PHOTON ENERGY < XK0*EBEAM );
C 5) VACUUM POLARIZATION (PHOTON SELF-ENERGY DIAGRAMS);
C 6) INTERFERENCE BETWEEN PHOTON AND Z0 EXCHANGE GRAPHS.
C FORMULA AND CONVENTIONS TAKEN FROM:
C F.A.BERENDS ET AL, NUCL.PHYS.B68(1974)541.
C EB   = BEAM ENERGY IN GEV;
C XK0  = CUTOFF ON SOFT BREMSSTRAHLUNG ENERGY;
C X    = COSINE OF POLAR SCATTERING ANGLE OF POSITRON;
C OMX  = 1. - X
C BORN = LOWEST-ORDER DIFFERENTIAL CROSS SECTION IN NANOBARN;
C CORR = TOTAL OF CORRECTIONS GIVEN ABOVE.
C ASSUMED VALUES: 90 GEV FOR THE Z0 MASS, .23 FOR SIN**2(TH).
C----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION(A-H,O-Z)
C-------------------------------------------- LOWEST ORDER ------------
      X=1.D0-OMX
      OPX=1.D0+X
      X2=X*X
      X3=X2*X
      X4=X3*X
      XNUM=9.D0+6.D0*X2+X4
      BORN=1.295958D0/EB**2*XNUM/OMX**2
C-------------------------------------------- CORRECTIONS (NO VAC.POL.)
      U=2.D0*DLOG(3.9139D03*EB)
      V=U+DLOG(OPX)-0.6931472D0
      W=U+DLOG(OMX)-0.6931472D0
      CORR1=2.3228D-03*(
     .-4.D0*(1.D0-U+V-W)*DLOG(XK0) - 6.5797D0 + U*U - V*V + W*W
     .+ 2.*DILOG(OPX/2.D0) - 2.*DILOG(OMX/2.D0)
     .+ ( ( 1.-12.*X+12.*X2 -4.*X3 +3.*X4)*U
     .   -( 5. -7.*X +3.*X2    -X3       )*V
     .   +(31. +5.*X +9.*X2 +3.*X3       )*W
     .   +( 3. +7.*X -5.*X2 -3.*X3 -2.*X4)*U*U*.5
     .   +( 3. -3.*X    +X2    -X3       )*V*V
     .   -( 9. +7.*X+11.*X2 +5.*X3       )*W*W*.5
     .   -( 2.    -X           -X3       )*U*V*X*2.
     .   -(21. +3.*X +9.*X2 -3.*X3 +2.*X4)*U*W
     .   +( 6. +5.*X +4.*X2    +X3       )*V*W*2.
     .   -(36.      +24.*X2        +4.*X4)
     .   +(18.-15.*X+12.*X2 -3.*X3 +4.*X4)*3.2899)/XNUM)
C-------------------------------------------- VACUUM POLARIZATION -----
      CORR2=
     .(6.*X -6.*X2 +2.*X3 -2.*X4)*REPI(4.*EB*EB)/XNUM+
     .(-18.-6.*X-6.*X2-2.*X3)*REPI(-2.*EB*EB*OMX)/XNUM
C-------------------------------------------- INTERFERENCE WITH Z0 ----
      CORR3=XSWEAK(EB,9.D01,.23D0,OMX)/BORN
      CORR=CORR1+CORR2+CORR3
C*****IF(CORR.LT.-1.D0) TYPE 1, CORR1,CORR2,CORR3,EB,XK0,X
    1 FORMAT(10H0***VIRSOF,6D15.6)
      RETURN
      END
