
      subroutine calor_consolidate

c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c     7-24-96 Julia Yarba
c     This routine consolidates energy deposition that may come 
c     from different different particles/tracks into every particular
c     cell of every calorimeter 
c
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
      
      implicit none
      
#include "trace_params.inc"
#include "emcal.inc"
#include "control_shower.inc"

c     Calling arguments : none

c     Local variables
      integer ical

c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if (trk_lintegrated) return  ! using C++ code...
      if (emcal_num .le. 0 .or. emcal_num .gt. max_emcal) return
      if (.not.(hit_generation)) return
      
      do ical = 0,emcal_num-1
       if (emcal_par(ical+1).type .le. 100) then ! "sensitive" Calorimeters 
        call Consolidate_cal_hits(%val(ical))
       end if
      end do
      
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:27  eugenio
c Initial revision
c
c Revision 1.5  1999/01/15 18:08:28  yarba_j
c no more need of hit consolidation if using integrated tracing (C++ part)
c
c Revision 1.4  1997/04/04  20:30:06  garren
c add rcs log line
c
