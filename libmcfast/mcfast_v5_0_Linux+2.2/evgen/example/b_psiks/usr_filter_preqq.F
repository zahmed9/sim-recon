      subroutine usr_filter_preqq(keep)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Decide if event should be looked at.
c
c  Outputs:
c
c   keep     integer variable
c            0 ==> throw out event
c           >0 ==> keep event
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "stdhep.inc"

c     Argument list
      integer keep

c     Local variables
      integer i

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Look for events with a B0
      do i=1,nhep
        if(idhep(i) .eq. 511) then
          keep = 1
          return
        endif
      enddo
      keep = 0
      return
      end
