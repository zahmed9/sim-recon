
      subroutine calor_init

      implicit none

#include "emcal.inc"
#include "control_shower.inc"

c     Calling arguments : None

c     Local Variables
      integer num_cal_sens  ! # of "sensitive" Calorimeters
      integer ical

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if (emcal_num .le. 0 .or. emcal_num .gt. max_emcal) return
      if (.not.(hit_generation)) return

c
c     This call should be done in Mcfast global initialization, 
c     after the geometry file is read in with the appropriate 
c     number of calorimeters defined.
c

      num_cal_sens = 0
      do ical = 1,emcal_num
       if (emcal_par(ical).type .le. 100) then
        num_cal_sens = num_cal_sens + 1
       end if
      end do

      call init_all_cal_hits(%val(num_cal_sens))
	
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:27  eugenio
c Initial revision
c
c Revision 1.4  1997/04/04 20:30:06  garren
c add rcs log line
c
