      subroutine trk_init

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Initialize tracking variables
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "trace_params.inc"

      save

c     Local variables
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      step_max_distance = 1.e10
      step_max_angle = 1.e10
      step_max_dedx = 1.e10
      step_max_mscat = 1.e10

      trk_max_turns = 0.5
      trk_min_kinetic = 1.e6 * unit_ev
      trk_min_brem = 1.e6 * unit_ev

      trk_ldecays = .TRUE.   !  make decays in flight
      trk_lpair = .TRUE.     !  make conversions
      trk_lint  = .FALSE.    !  make secondary interactions -- off
      trk_lhits = .TRUE.     !  make hits 
      trk_lscat = .FALSE.    !  scattering during trace -- off
      trk_ldedx = .FALSE.    !  energy loss during trace -- off

      trk_lintegrated = .TRUE. ! use integrated tracing algorithm (C++)

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:36  eugenio
c Initial revision
c
c Revision 1.7  1998/06/29 21:28:30  yarba_j
c added switch for integrated tracing algorithm
c
c Revision 1.6  1998/02/13  19:24:15  mcbride
c add init for secondary interaction switch
c
c Revision 1.5  1997/04/04  20:30:26  garren
c add rcs log line
c
