      subroutine emcal_get_ical(w, ical)
c
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c    Finds calorimeter the point xyz belongs to.  
c
c
c  Inputs:
c
c  w          track/point current status in W-form 
c
c  Outputs:
c
c  ical       calorimeter number (w.x,w.y,w.z) belongs to (0 is none)
c
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "emcal.inc"
#include "wtrack_struct.inc"

c     Calling arguments  
      record /wtrack_struct/ w
      integer ical 

c     Local variables
      integer i
      logical lstrike

c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if (emcal_num .le. 0 .or. emcal_num .gt. max_emcal) return

      do i = 1,emcal_num
       call emcal_find_ical(w,i,lstrike)
       if (lstrike) then
c   The necessary CAL is found
        ical = i
        return
       end if
      end do

c    The point xyz does NOT belong to any calorimeter
      ical = 0

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:28  eugenio
c Initial revision
c
c Revision 1.4  1997/04/04 20:30:10  garren
c add rcs log line
c
