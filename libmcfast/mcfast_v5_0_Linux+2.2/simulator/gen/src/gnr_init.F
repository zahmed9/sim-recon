      subroutine gnr_init

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Initialize internal generation parameters
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "gnr_params.inc"

c     Local variables
      integer i
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      gnr_ntype = 0
      gnr_type_list(1) = 211
      gnr_type_probs(1) = 1.0
      gnr_type_masses(1) = .13956
      do i=2,gnr_maxtype
        gnr_type_list(i) = 0
        gnr_type_probs(i) = 0.
        gnr_type_masses(i) = 0.
      enddo

      gnr_avetrk = 1.
      gnr_fix_mult = .TRUE.

      gnr_ptmin = 1.
      gnr_ptmax = 1.
      gnr_etamin = 0.
      gnr_etamax = 0.
      gnr_phimin = 0.
      gnr_phimax = tpi

      gnr_slope = 0.

      do i=1,3
        gnr_vtx(i) = 0.
        gnr_dvtx(i) = 0.
      enddo

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:19  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 18:07:48  garren
c add hooks to initialize user trigger code
c
