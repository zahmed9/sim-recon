c
      subroutine emcal_clear_hits
c
c     modified 05/25/96 ASB -- adapted to modified hit structure
      implicit none      
c
c
c       include 'emcal.inc'   
c  Since this include changed, I just included it in this file... 
c	Bad, but  I don't wantto screw around with cpp
c
#include "trace_params.inc"
#include "emcal_struct.inc"

c    Electromagnetic calorimeters

c    All variables have the prefix "emcal_"
c    7/22/94  A.Boehnlein, added common for hits structure

      integer max_emcal
      parameter (max_emcal = 40)

      integer emcal_num			!Number of emcal detectors

      common /emcal_comm1/
     *  emcal_num

      record /emcal_struct/ emcal_par	!Calorimeter parameters

      common /emcal_comm2/
     *  emcal_par(max_emcal)


c
c     Calling argumets : None
c
c     Local variables
c
      integer ical, icalm1, i
c
      if (trk_lintegrated) return ! no need for this stuff in c++ version
      
      if (emcal_num .le. 0 .or. emcal_num .gt. max_emcal) return
c
      do ical = 1,emcal_num
        icalm1 = ical -1
        call Init_cal_hits(%val(icalm1))
      end do
c
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:28  eugenio
c Initial revision
c
c Revision 1.7  1999/05/24 16:28:47  yarba_j
c no need for this routine in integrated (C++) tracing
c
c Revision 1.6  1997/04/04  20:30:08  garren
c add rcs log line
c
