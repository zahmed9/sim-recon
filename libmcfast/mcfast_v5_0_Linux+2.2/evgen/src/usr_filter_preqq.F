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
#include "stdlun.inc"

c     Argument list
      integer keep

c     Local variables
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      keep = 1

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:58:35  eugenio
c Initial revision
c
c Revision 1.3  1998/06/25 15:49:05  bphyslib
c add all necessary changes from v3_3
c
