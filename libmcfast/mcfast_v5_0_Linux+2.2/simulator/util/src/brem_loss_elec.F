      function brem_loss_elec(p, radl, Kmin)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Returns electron momentum after encounter with material having a
c  specified radiation length.
c
c  The photon energy is between Kmin and the momentum p of the parent.
c  The energy distribution is derived from Y. S. Tsai, Rev. Mod. Phys., 46,
c  815(1974) Eqn. 3.83.  This is the differential brem photon energy
c  spectrum for complete atomic screening.  See Bob Wagner for details on
c  derivation of the generation function.  Actual generation is done by
c  rejection and is near 90% efficient.
c
c  Zcorr contains a Z(atomic #) dependent correction to the
c  photon energy formula.  This correction factor is between
c  0.02 and 0.03 for most materials and has been set to 0.03.
c  Treatment of the factor as a constant causes only a small
c  error.  The whole term could be ignored and cause only a
c  error of 2-3% in the differential energy spectrum.
c  -----------------------------------------------------------------------
c
c  p      DFLOAT variable (read)
c         incoming momentum in GeV/c
c
c  radl   DFLOAT variable (read)
c         Thickness of material in radiation lengths
c
c  Kmin   DFLOAT variable (read)
c         Minimum energy of photon to radiate
c
c  Output:
c         Momentum of electron after brem.
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"

      DFLOAT brem_loss_elec

c     Externals
      external rann
      real     rann

c     Calling arguments
      DFLOAT p, radl, Kmin

c     Local variables
      DFLOAT radl_brem, slope, r, x, xmax, hofx

      DFLOAT zcorr, bh, ccmns
      save zcorr, ccmns, bh

      data ccmns/29.979/
      data bh/1.364/
      data zcorr/0.03/
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Check that the particle energy is greater then the minimum value
c     of the photon that its going to produce.  Else no brem.
c
      if (p .gt. Kmin) then
	   Xmax = 1. - (Kmin / p)
      else
          goto 9999
      endif

c     Calculate the slope parameter in the exponential p.d.f.
c     This parameter is given by
c            Slope = Na * X0 * SigmaB / A, where
c                  Na = Avogadro's Number
c                  X0 = Radiation length of medium (g/cm**2)
c                SigmaB = Bremsstrahlung cross section (cm**2)
c                   A = Atomic weight of material (g/cm**2)
c
c     Since we are dealing in number of radiation lengths all the material
c     specific stuff drops out and only the Xmax = 1 - Kmin/E dependence in
c     SigmaB matters.  SigmaB is given by integrating d(SigmaB)/dx from
c     x = 0 -> Xmax. d(SigmaB)/dx is derived from d(SigmaB)/dk given as
c     Eq. 3.83 in Y. S. Tsai, Rev. Mod. Phys., 46, p.831(1974).
c     In putting this equation into a useful form you will find that the last
c     term ends up with a factor
c
c         (1/9) * (Z**2 + Z) * (X0 / (716.405*A))
c
c     This factor is very near 0.03 for most materials and that is what is
c     used here.  Neglect of this term leads to an error of about 2-3% in
c     the slope parameter.  This number is called Zcorr below.
c
      Slope = ( (4./3. + Zcorr) * log(1. - Xmax))
     *      + ( (1./3. + Zcorr) * Xmax) + (0.5 * Xmax**2)

c     Now generate the number of radiation lengths before bremsstrahlung
c     If # of radiation lengths before radiation is less than the number
c     actually present, then no bremm.
c
 50   r = rann(0)
      if(r .eq. 0.) goto 50
      radl_brem = log(r) / Slope
      if(radl_brem .gt. radl) goto 9999

c     Generate a value for x = 1 - k/E by rejection techniques.
c     The probability density function we wish to chose x values from is
c           f(x) = N * (1 - (2/3 - Zcorr)*x + x**2) / (1 - x), where
c           N = Normalization factor
c
c      The p.d.f. that we use to generate x is
c        g(x) = -1 / (Ln(1 - Xmax) * (1 - x))
c
c     We keep x if the quantity (f(x)/g(x)) / Bh is greater than a number
c     picked from a uniform 0-1 distribution.  The value Bh is the maximum
c     value of f(x)/g(x) with a small positive value added as a safety factor.
c     This generation technique is > 86% efficient for parent particles with
c     energy greater than 2 GeV and minimum photon energy of 30 MeV.
C
 100  r = rann(0)
      if(r .eq. 0.) goto 100
      x = 1.0 - (1.0 - xmax)**r
      hofx = (1.0 - ((2./3. - zcorr) * x) + x**2) / bh
      if (hofx .lt. rann(0)) go to 100

      brem_loss_elec = p * x

c     Normal exit
 1000 return

c     No brem radiation
9999  brem_loss_elec = p
      return

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:42  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:30:53  garren
c add rcs log line
c
