      function proper_decay_time ( p, d )

c     Compute the proper decay time, tau, for a particle with lab
c     frame 4-momentum p and lab frame decay length d.

c     Try to do something sensible in the impossible case that beta*gamma
c     is zero but d is non-zero.

      implicit none

#include "const.inc"

      DFLOAT proper_decay_time

      DFLOAT p(4), d, tau

      DFLOAT bg

      ! Functions.
      DFLOAT beta_gamma_d

      bg = beta_gamma_d(p)
      if ( bg .ne. 0. ) then
         tau = d/bg/clight
      else
         if ( d .eq. 0. ) then
            tau = 0.
         else
            tau = 1.e36
         endif
      endif

      proper_decay_time = tau
      end
c
c $Id$
c
c $Log$
c Revision 1.1  2000/06/19 19:59:46  eugenio
c Initial revision
c
c Revision 1.2  1998/04/27 02:17:02  kutschke
c New file.
c
c
