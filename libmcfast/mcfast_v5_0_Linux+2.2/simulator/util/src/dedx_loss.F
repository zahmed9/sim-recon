      function dedx_loss(p, xmas, dedxmn)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c    Returns momentum after encounter with dE/dx material (i.e., momentum
c    is subtracted). To get momentum gain, dedxmn should be negative.
c
c    The momentum loss is based on the Bethe-Bloch formula
c
c      dE/dx = -a/beta**2 * [log(beta**2*gamma**2*me*c**2/I0) - beta**2]
c
c    where me is the electron mass and i0 = the ionization potential.
c    We parametrize I0 by
c
c                           I0 = 16. * z**.9
c
c    in eV and use z = 9 as an approximate average for the materials
c    we encounter. The formula is very insensitive to the precise value
c    of z. The minimum for this function is 11.528 and occurs for the
c    value gamma*beta = 10.43. The formula for dp/dx = (dE/dx) / beta
c    then becomes
c
c     dp/dx = -dedxmn/11.528*[9.0872 + 2*log(gamma*beta) - beta**2]/beta**3
c
c    The Runge-Kutta method is used to integrate the momentum.
c
c  p     = DFLOAT variable
c          incoming momentum in GeV/c
c
c  xmas  = DFLOAT variable
c          mass in GeV/c^2
c
c  dedxmn= DFLOAT variable
c          dE/dx (min. ionizing) in GeV
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"

      DFLOAT dedx_loss

c     Calling arguments
      DFLOAT p, xmas, dedxmn

c     local variables
      DFLOAT dp, func1, func2, denorm
      DFLOAT tau, tau1, tau2, tau3, tau4, v1, v2, v3, v4
      DFLOAT beta1, beta2, beta3, beta4, x, y
      DFLOAT fac1, fac2, fac3, fac4

      DFLOAT taumax, frac
      save taumax, frac

      data taumax /100./        !Max value of p/m
      data frac/0.01/           !Do simple calculation if dp/p < frac
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Statement functions
      func1(x,y) = (9.0872 + 2.*log(x) - y**2) / y**3 / 11.528
      func2(x,y) = (9.0872 + 2.*log(x) - (x/y)**2) * y**3 / 11.528

      dedx_loss = p
      if(dedxmn.eq.0. .or. p.le.0.) goto 1000

      denorm = dedxmn / xmas

c     Use Runge-Kutta method to integrate
      tau1 = min (p/xmas , taumax)
      beta1 = tau1 / sqrt(1. + tau1**2)
      v1 = func1(tau1, beta1)

c     Skip Runge-Kutte for small changes
      if(abs(v1*denorm/tau1) .lt. frac) then
        dp = xmas*v1*denorm
        dedx_loss = p - dp

c     Otherwise, use full formula
      else if(tau1 .gt. 0.6) then
        tau2 = tau1 - 0.5*denorm*v1
        if(tau2 .le. 0.) goto 9999
        beta2 = tau2 / sqrt(1. + tau2**2)
        v2 = func1(tau2, beta2)

        tau3 = tau1 - 0.5*denorm*v2
        if(tau3 .le. 0.) goto 9999
        beta3 = tau3 / sqrt(1. + tau3**2)
        v3 = func1(tau3, beta3)

        tau4 = tau1 - denorm*v3
        if(tau4 .le. 0.) goto 9999
        beta4 = tau4 / sqrt(1. + tau4**2)
        v4 = func1(tau4, beta4)

        dp = xmas*denorm/6. * (v1 + 2.*v2 + 2.*v3 + v4)
        dedx_loss = p - dp

c     For low momentum, integrate dtau/dx = f()(1+tau**2)**1.5 / tau**3
c     using the independent variable tau' = tau^4 / 4 to eliminate the
c     1 / tau^3 term.
      else
        fac1 = sqrt(1. + tau1**2)
        v1 = func2(tau1, fac1)

        tau2 = tau1**4 - 2.*denorm*v1
        if(tau2 .le. 0.) goto 9999
        tau2 = sqrt(sqrt(tau2))
        fac2 = sqrt(1. + tau2**2)
        v2 = func2(tau2, fac2)

        tau3 = tau1**4 - 2.*denorm*v2
        if(tau3 .le. 0.) goto 9999
        tau3 = sqrt(sqrt(tau3))
        fac3 = sqrt(1. + tau3**2)
        v3 = func2(tau3, fac3)

        tau4 = tau1**4 - 4.*denorm*v3
        if(tau4 .le. 0.) goto 9999
        tau4 = sqrt(sqrt(tau4))
        fac4 = sqrt(1. + tau4**2)
        v4 = func2(tau4, fac4)

        tau = tau1**4 - 2./3.*denorm * (v1+2.*v2+2.*v3+v4)
        if(tau .le. 0.) goto 9999
        tau = sqrt(sqrt(tau))
        dedx_loss = xmas * tau
      endif

c     Normal exit
1000  if(dedx_loss .lt.0.) goto 9999
      return

c     Error exit
9999  dedx_loss = 0.0
      return

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:43  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:31:18  garren
c add rcs log line
c
