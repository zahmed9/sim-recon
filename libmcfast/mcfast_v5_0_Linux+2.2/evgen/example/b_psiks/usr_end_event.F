      subroutine usr_end_event

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Check event for conservation of energy and charge.
c   Also histogram  multiplicities of various final state particles.
c
c   Notes:
c   1) isajet does not conserve charge.
c   2) isajet+qq sometimes does a poor job at conservation of 4-momentum
c   3) pythia+qq often does a really bad job of conservation of 4-momentum
c   4) Some generators decay hyperons and some do not.  So we must remember
c      to count undecayed hyperons when checking for charge balance.
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "stdhep.inc"
#include "stdcm1.inc"

      ! 4-momentum sum of stable particles.
      ! Charge sum of stable particles.
      real*8 psum(4), qtot

      ! Count types of particles in each event.
      ! Notes:
      ! 1) n_emupikp - if hyperons are not decayed, then n_emupikp need
      !                not be divisible by 2 in order to have a charge
      !                conserving event.
      integer n_emupikp
      integer n_neutrino
      integer n_gamma
      integer n_hadshow
      integer n_hyperon
      integer n_unknown

      ! Statement functions.
      logical e_mu_pi_k_p, neutrino, hadshow, hyperon, k0_meson

      ! Indexology.
      integer j, kk

      ! Functions
      real*4 stdchg
!      real*8 eta_d, pt_d, v3mag_d

      ! pi, k, p, e, mu
      e_mu_pi_k_p(kk) = iabs(idhep(kk)) .eq.  211 .or.
     +                  iabs(idhep(kk)) .eq.  321 .or.
     +                  iabs(idhep(kk)) .eq. 2212 .or.
     +                  iabs(idhep(kk)) .eq.   11 .or.
     +                  iabs(idhep(kk)) .eq.   13 

      ! neutrinos
      neutrino(kk) = iabs(idhep(kk)) .eq. 12 .or.
     +               iabs(idhep(kk)) .eq. 14 .or.
     +               iabs(idhep(kk)) .eq. 16

      ! Stable hyperons.
      hyperon(kk)  = iabs(idhep(kk)) .eq. 3122 .or.
     +               iabs(idhep(kk)) .eq. 3222 .or.
     +               iabs(idhep(kk)) .eq. 3212 .or.
     +               iabs(idhep(kk)) .eq. 3112 .or.
     +               iabs(idhep(kk)) .eq. 3322 .or.
     +               iabs(idhep(kk)) .eq. 3312 .or.
     +               iabs(idhep(kk)) .eq. 3332


      ! Hadronically showering neutrals.  K0L and n0.
      hadshow(kk)  = iabs(idhep(kk)) .eq.  130 .or.
     +               iabs(idhep(kk)) .eq. 2112

      ! Remaing K0; both K0S and strangeness eigenstates.
      k0_meson(kk) = iabs(idhep(kk)) .eq.  310 .or.
     +               iabs(idhep(kk)) .eq.  311

      psum(1)      = 0.
      psum(2)      = 0.
      psum(3)      = 0.
      psum(4)      = 0.
      n_emupikp    = 0
      n_neutrino   = 0
      n_gamma      = 0
      n_hadshow    = 0
      n_hyperon    = 0
      n_unknown    = 0
      qtot         = 0

      do j = 1, nhep

         ! For all stable particles.
         if ( isthep(j) .eq. 1 ) then

            ! charge and energy conservation
            psum(1) = psum(1) + phep(1,j)
            psum(2) = psum(2) + phep(2,j)
            psum(3) = psum(3) + phep(3,j)
            psum(4) = psum(4) + phep(4,j)
            qtot    = qtot + stdchg(idhep(j))
 
            ! Multiplicities
            if ( e_mu_pi_k_p(j) ) then
               n_emupikp = n_emupikp+1
            else if ( idhep(j) .eq.  22 )  then
               n_gamma = n_gamma + 1
            else if ( idhep(j) .eq. 111 )  then
               n_gamma = n_gamma + 2
            else if ( neutrino(j) ) then
               n_neutrino = n_neutrino + 1
            else if ( hadshow(j)  ) then
               n_hadshow = n_hadshow + 1
            else if ( hyperon(j) .or. k0_meson(j) ) then
               n_hyperon = n_hyperon + 1
            else
               n_unknown = n_unknown + 1
            endif

         endif

         ! Some inclusive properties of B and B_s mesons.
!         if ( abs(idhep(j)) .eq. 511 .or. abs(idhep(j)) .eq. 521 ) then
!            call hf1 ( 21, sngl(eta_d  (phep(1,j))), 1. )
!            call hf1 ( 22, sngl(pt_d   (phep(1,j))), 1. )
!            call hf1 ( 23, sngl(v3mag_d(phep(1,j))), 1. )
!         else if ( abs(idhep(j)) .eq. 531 ) then
!            call hf1 ( 24, sngl(eta_d  (phep(1,j))), 1. )
!            call hf1 ( 25, sngl(pt_d   (phep(1,j))), 1. )
!       call hf1 ( 26, sngl(v3mag_d(phep(1,j))), 1. )
!         endif

      enddo

      ! Fill conservation histograms.
      call hf1 ( 10, sngl(qtot),            1. )
      call hf1 ( 11, sngl(psum(1)),         1. )
      call hf1 ( 12, sngl(psum(2)),         1. )
      call hf1 ( 13, sngl(psum(3)),         1. )
      call hf1 ( 14, sngl(psum(4)-stdecom), 1. )


      ! Fill multiplicity histograms.
      call hf1 ( 15, float(n_emupikp),      1. )
      call hf1 ( 16, float(n_neutrino),     1. )
      call hf1 ( 17, float(n_gamma),        1. )
      call hf1 ( 18, float(n_hadshow),      1. )
      call hf1 ( 19, float(n_hyperon),      1. )
      call hf1 ( 20, float(n_unknown),      1. )

      end
c
c $Id$
c
c $Log$
c Revision 1.1  2000/06/19 19:58:31  eugenio
c Initial revision
c
c Revision 1.5  1998/11/20 22:48:34  procario
c Linux port Added Linux section makefiles Small Linux modes to code.
c
c Revision 1.4  1998/05/19  01:21:10  kutschke
c Include B production histograms.
c
c
